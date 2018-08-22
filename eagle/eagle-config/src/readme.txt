http://localhost:8889/common/dev

{
  "name": "common",
  "profiles": [
    "dev"
  ],
  "label": null,
  "version": "5bf6af9b5c9f348ebb0a8845f243c2eada99db38",
  "state": null,
  "propertySources": [
    {
      "name": "https://github.com/xiexifeng/p2pManager.git/config/common-dev.properties",
      "source": {
        "eagle.username": "schelling",
        "eagle.pwd": "123456"
      }
    },
    {
      "name": "https://github.com/xiexifeng/p2pManager.git/common-dev.properties",
      "source": {
        "eagle.username": "schelling",
        "eagle.pwd": "123456"
      }
    }
  ]
}

仓库中的配置文件会被转换成web接口，访问可以参照以下的规则：

/{application}/{profile}[/{label}]
/{application}-{profile}.yml
/{label}/{application}-{profile}.yml
/{application}-{profile}.properties
/{label}/{application}-{profile}.properties
以neo-config-dev.properties为例子，它的application是neo-config，profile是dev。client会根据填写的参数来选择读取对应的配置。

client config

bootstrap.properties如下：
spring.cloud.config.name=neo-config
spring.cloud.config.profile=dev
spring.cloud.config.uri=http://localhost:8001/
spring.cloud.config.label=master
spring.application.name：对应{application}部分
spring.cloud.config.profile：对应{profile}部分
spring.cloud.config.label：对应git的分支。如果配置中心使用的是本地存储，则该参数无用
spring.cloud.config.uri：配置中心的具体地址
spring.cloud.config.discovery.service-id：指定配置中心的service-id，便于扩展为高可用配置集群。

特别注意：上面这些与spring-cloud相关的属性必须配置在bootstrap.properties中，config部分内容才能被正确加载。
因为config的相关配置会先于application.properties，而bootstrap.properties的加载也是先于application.properties。