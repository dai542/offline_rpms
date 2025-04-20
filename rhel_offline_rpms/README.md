1. ### **打包过程**

- 在有网络机器上配置相关仓库，见domestic_mirror，对于 RedHat 系统优先使用 Rocky 的镜像，若无 Rocky 镜像可用 CentOS8的镜像，参考tsinghua.

- 上传`download_offline.sh`和`package.list`到同一目录下，执行`download_offline.sh`.

- 复制`/root/offline_packages/offline_install.sh`和`/root/offline_packages/rpms/offline_packages.iso`到同一目录下.

现已提供了一个 **RHEL 8.6(4.18.0-372.9.1.el8.x86_64)** [`offline_packages.iso`]()，可直接下载使用。


2. ### **使用本地ISO源先安装一部分基础包**
- 将`centos_init.sh`和`centos_localiso.sh`放到同一目录下，修改`centos_localiso.sh`中本地 ISO 的位置以及挂载位置（`ISO_PATH`和`MOUNT_DIR`），运行`centos_localiso.sh`生成本地 ISO 源。
- 执行`centos_init.sh`.


3. ### **使用第三方源安装epel库相关包**

  将`offline_install.sh`和`offline_packages.iso`放到同一目录下，执行`offline_install.sh`.


------

> 内核检测
>

```
grubby --info=ALL
grubby --default-kernel
grubby --set-default 2
```

