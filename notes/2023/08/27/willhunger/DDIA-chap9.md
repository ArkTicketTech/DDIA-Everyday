##### A system of promises
2PC 的过程：
1. 当应用想要启动一个分布式事务时，它向协调者请求一个事务 ID。此事务 ID 是全局唯一的。
2. 应用在每个参与者上启动单节点事务，并在单节点事务上捎带上这个全局事务 ID。所有的读写都是在这些单节点事务中各自完成的。如果在这个阶段出现任何问题（例如，节点崩溃或请求超时），则协调者或任何参与者都可以中止。
3. 当应用准备提交时，协调者向所有参与者发送一个 **准备** 请求，并打上全局事务 ID 的标记。如果任意一个请求失败或超时，则协调者向所有参与者发送针对该事务 ID 的中止请求。
4. 参与者收到准备请求时，需要确保在任意情况下都的确可以提交事务。这包括将所有事务数据写入磁盘（出现故障，电源故障，或硬盘空间不足都不能是稍后拒绝提交的理由）以及检查是否存在任何冲突或违反约束。通过向协调者回答 “是”，节点承诺，只要请求，这个事务一定可以不出差错地提交。换句话说，参与者放弃了中止事务的权利，但没有实际提交。
5. 当协调者收到所有准备请求的答复时，会就提交或中止事务作出明确的决定（只有在所有参与者投赞成票的情况下才会提交）。协调者必须把这个决定写到磁盘上的事务日志中，如果它随后就崩溃，恢复后也能知道自己所做的决定。这被称为 **提交点（commit point）**。
6. 一旦协调者的决定落盘，提交或放弃请求会发送给所有参与者。如果这个请求失败或超时，协调者必须永远保持重试，直到成功为止。没有回头路：如果已经做出决定，不管需要多少次重试它都必须被执行。如果参与者在此期间崩溃，事务将在其恢复后提交 —— 由于参与者投了赞成，因此恢复后它不能拒绝提交。

两个承诺：当参与者投票 “是” 时，它承诺它稍后肯定能够提交（尽管协调者可能仍然选择放弃）；以及一旦协调者做出决定，这一决定是不可撤销的。这些承诺保证了 2PC 的原子性（单节点原子提交将这两个事件合为了一体：将提交记录写入事务日志）。