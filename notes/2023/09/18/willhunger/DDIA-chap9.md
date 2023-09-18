### Batch Processing With Unix Tools
Unix command with pipe 进行批处理，例如：
```bash
cat /var/log/nginx/access.log | #1 awk '{print $7}' | #2 sort | #3 uniq -c | #4 sort -r -n | #5 head -n 5 #6
```

优势：GNU Coreutils（Linux）中的 `sort` 程序通过溢出至磁盘的方式来自动应对大于内存的数据集，并能同时使用多个 CPU 核进行并行排序。

#### The unix philosophy
unix 设计哲学：
1. 让每个程序都做好一件事。要做一件新的工作，写一个新程序，而不是通过添加 “功能” 让老程序复杂化。
2. 期待每个程序的输出成为另一个程序的输入。不要将无关信息混入输出。避免使用严格的列数据或二进制输入格式。不要坚持交互式输入。
3. 设计和构建软件时，即使是操作系统，也让它们能够尽早地被试用，最好在几周内完成。不要犹豫，扔掉笨拙的部分，重建它们。
4. 优先使用工具来减轻编程任务，即使必须曲线救国编写工具，且在用完后很可能要扔掉大部分。

##### A uniform interface
一切皆文件：文件系统上的真实文件，到另一个进程（Unix 套接字，stdin，stdout）的通信通道，设备驱动程序（比如 `/dev/audio` 或 `/dev/lp0`），表示 TCP 连接的套接字等等，均可共享一套接口。

##### Separation of logic and wiring
使用标准输入（`stdin`）和标准输出（`stdout`），达到了低耦合。

##### Transparency and experimentation
* Unix 命令的输入文件通常被视为不可变的。
* 可以在任何时候结束管道，将管道输出到 `less`，然后查看它是否具有预期的形式。这种检查能力对调试非常有用。
* 你可以将一个流水线阶段的输出写入文件，并将该文件用作下一阶段的输入。这使你可以重新启动后面的阶段，而无需重新运行整个管道。