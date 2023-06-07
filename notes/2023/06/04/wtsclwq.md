#### AP建模

TP中有很多模型，关系型、文档型、网状模型等，而AP中的模型较少，通常用**星型**，也称为**维度建模**

> 模式的中心是一个所谓的事实表(在这个例子中, 它被称为fact sales) 。 事实表的每一行表示在特定时间发生的事件(这里,每一行代表客户购买的一个产品)。 如果我们正在分析网站流最而不是零售, 则每一行可能表示页面视图或用户的单击。

<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/image-20230604235825212.png" alt="image-20230604235825212" style="zoom:33%;" />

像苹果 、 沃尔玛或者 eBay 这样的大企业, 其数据仓库可能有数十PB的交易历史, 其中大部分都保存在事实表中

星状模型的一个变种是雪花模型，可以类比雪花（❄️）图案，其特点是在维度表中会进一步进行二次细分，讲一个维度分解为几个子维度。比如品牌和产品类别可能有单独的表格。星状模型更简单，雪花模型更精细，具体应用中会做不同取舍。

> 在典型的数仓中，事件表可能会非常宽，即有很多的列：一百到数百列。

### 列存

前一小节提到的**分维度表**和**事实表**，对于后者来说，有可能达到数十亿行和数 PB 大。虽然事实表可能通常有几十上百列，但是单次查询通常只关注其中几个维度（列）。

如查询**人们是否更倾向于在一周的某一天购买新鲜水果或糖果**：

```sql
SELECT
  dim_date.weekday,
  dim_product.category,
  SUM(fact_sales.quantity) AS quantity_sold
FROM fact_sales
  JOIN dim_date ON fact_sales.date_key = dim_date.date_key
  JOIN dim_product ON fact_sales.product_sk = dim_product.product_sk
WHERE
  dim_date.year = 2013 AND
  dim_product.category IN ('Fresh fruit', 'Candy')
GROUP BY
  dim_date.weekday, dim_product.category;
```

由于传统数据库通常是按行存储的，这意味着对于属性（列）很多的表，哪怕只查询一个属性，也必须从磁盘上取出很多属性，无疑浪费了 IO 带宽、增大了读放大。

于是一个很自然的想法呼之欲出：每一个列分开存储好不好？

<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/image-20230605000125204.png" alt="image-20230605000125204" style="zoom:33%;" />

就如图中所示，每一列保存在一个文件中，但是如何维护他们的映射关系呢？

不同列之间同一个行的字段可以通过下标来对应，比如查询第23行的data_key和net_price列，就从这两个文件中找第23个记录就可以了，然后组合起来。当然也可以内嵌主键来对应，每一个文件中保存的都是<主键，col_val>的数据对，但那样存储成本就太高了。

#### 列存储的压缩

因为同一列的数据通常都是相同类型的，相似度较高，所以比较容易进行压缩。

如果**每一列中不同值的数量相比行数要小的多**，可以用**位图编码（_[bitmap encoding](https://en.wikipedia.org/wiki/Bitmap_index)_）**。举个例子，零售商可能有数十亿的销售交易，但只有 100,000 个不同的产品。

<img src="https://wtsclwq.oss-cn-beijing.aliyuncs.com/image-20230605000436505.png" alt="image-20230605000436505" style="zoom:33%;" />

上图中，是一个列分片中的数据，可以看出只有 {29, 30, 31, 68, 69, 74} 六个离散值。针对每个值出现的位置，我们使用一个 bit array 来表示：

1. bit map 下标对应列的下标
2. 值为 0 则表示该下标没有出现该值
3. 值为 1 则表示该下标出现了该值

如果 bit array 是稀疏的，即大量的都是 0，只要少量的 1。其实还可以使用 **[游程编码](https://zh.wikipedia.org/zh/游程编码)（RLE，Run-length encoding）** 进一步压缩：

1. 将连续的 0 和 1，改写成 `数量+值`，比如 `product_sk = 29` 是 `9 个 0，1 个 1，8 个 0`。
2. 使用一个小技巧，将信息进一步压缩。比如将同值项合并后，肯定是 0 1 交错出现，固定第一个值为 0，则交错出现的 0 和 1 的值也不用写了。则 `product_sk = 29` 编码变成 `9，1，8`
3. 由于我们知道 bit array 长度，则最后一个数字也可以省掉，因为它可以通过 `array len - sum(other lens)` 得到，则 `product_sk = 29` 的编码最后变成：`9，1`

位图索引很适合应对查询中的逻辑运算条件，比如：

```sql
WHERE product_sk IN（30，68，69）
```

可以转换为 `product_sk = 30`、`product_sk = 68`和  `product_sk = 69`这三个 bit array 按位或（OR）。

```sql
WHERE product_sk = 31 AND store_sk = 3
```

可以转换为 `product_sk = 31`和  `store_sk = 3`的 bit array 的按位与，就可以得到所有需要的位置。
