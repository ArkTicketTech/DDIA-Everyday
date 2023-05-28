#第三章 存储与检索
##散列索引
SSTables和LSM树
用SSTables制作LSM树
B 树将数据库分解成固定大小的 块（block） 或 分页（page），传统上大小为 4KB（有时会更大），并且一次只能读取或写入一个页面。
