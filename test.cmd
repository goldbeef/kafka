kafka概述
	流平台，发布/订阅数据流
	类似消息系统，但完全不同于消息系统
		自由伸缩/存储数据/数据传递保证
	实时版的hadoop
		低延迟
	面向实时数据流的平台
kafka概念
	消息
		数据单元,包含元数据(键)
	批次
		一组消息，属于同一主题和分区．
		吞吐量和延迟的trade-off
	模式
		用于定义消息的内容,统一的格式解藕子系统
		常见模式
			json/xml
	主题
		消息的分类，类似数据库中的表
	分区
		发布者/写入者
	消费者
		订阅者/读者
	偏移量
		记录每个消费者在每个分区的状态，存储在zookeeper或者kafka
	消费者群组
		一组消费者
		群组保证每个分区只能被一个消费者使用．
	broker
		一台独立的kafka服务器称为broker
	集群
		多个broker组成一个集群
	集群控制器
		管理broker，把分区分配给broker(分区的首领)
	复制机制
		一个分区可能存储在多个broker 
	保留消息
		累计时间/消息大小达到某个阈值．
	紧凑型日志
		只有最后一个带有特定键的消息会保留下来
kafka多集群目的
	数据类型分离
	安全需求隔离
	多数数据中心
MirrorMaker
	处理集群间的消息复制
为什么选择kafka?
	多个生产者
	多个消费者
	基于磁盘的数据存储
		保留特性
	伸缩性
	高性能
		横向扩者　生成者/消费者/broker 
kafka使用场景
	活动跟踪
	消息传递
	度量指标/日志记录
	提交日志
	流处理　
kakfa安装
	安装jdk8
	安装zookeeper
		单机服务
		群组服务
	安装kafka-broker 
	配置　
		broker常规配置
			broker.id //标识broker
			port //监听端口
			zookeeper.connect //zookeeper环境
			log.dirs //日志保存目录
			num.recovery.threads.per.data.dir 
			auto.create.topics.enable 
		主题的默认配置
			num.partitions //分区数量
				一般主题吞吐量/消费者吞吐量，作为分区的数量
			log.retention.ms/hours/minutes
				保留时间，根据日志文件的最后修改时间
			log.retention.bytes
				保留数量
			log.segment.bytes	
				日志片段关闭的大小
			log.segment.ms 
				日志片段关闭的时间．可能会影响磁盘性能
			message.max.bytes 
				限制单个消息的大小(压缩后的)
				客户端的fetch.message.max.bytes必须和服务器进行协商
kafka硬件的选择
	磁盘吞吐量
		客户端的性能收到服务器磁盘吞吐量的影响
		ssd/机械键盘
	磁盘容量
		取决于保留的消息数量/复制策略
	内存
		kafka大量使用系统的页面缓存
	网络
		决定kafka能够处理的最大数据流量
		受消费者/集群复制/镜像影响
	cpu 
		要求较低，主要对客户端数据解压，重新压缩保存到磁盘
kafka集群
	优势
		负载均衡
		避免单点
	需要多少个broker?
		需要多小磁盘空间保留消息，单个broker有多少空间可用
		集群处理能力的要求
			网络接口
			磁盘吞吐量
			系统内存
kafka-操作系统调优
	虚拟内存
		vm.swappiness ＝１　//减少交换区
		vm.dirty_backgroud_radio －//将脏页写入磁盘，减少脏页的数量
		vm.dirty_ratio  ＋//内核刷新到磁盘之前的脏页数量
	磁盘	
		合适的磁盘设备以及raid
		文件系统
			ext4
			xfs
				noaime 
	网络
		socket读写缓冲区的内存大小
			net.core.wmem_default
			net.core.rmem_default
		tcp读写缓冲区的大小
			net.ipv.tcp_wmem
			net.ipv.tcp_rmem
		其它
			net.ipv.tcp_window_scaling设置为１,　启用tcp时间窗扩展
			net.ipv4.max_syn_backlog //并发连接数
			net.core.netdev_max_backlog //更多的数据包排队
kafka-生产环境注意事项
	垃圾回收器选项
		MaxGCPauseMillis //gc间隔
		InitiatingHeapOccupancyPercent　//gc触发
	数据中心布局
		broker放在不同的机架上
	共享zookeeper 
		kafka: broker, 主题，分区的元数据保存在zookeeper
		消费者的分区偏移量：可以选择放在 zookeeper or kafka 
	
		不要和其他系统共用zookeeper


