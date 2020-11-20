# flutter_dlna

一款真正可以实现视频投屏的插件，基于DLNA。

## Getting Started

pubspec.yaml中引入依赖：

```
dependencies:
  flutter_dlna: <最新版本>
```

最新版本查看地址：

```
https://pub.dev/packages/flutter_dlna/install
```

创建管理器

```
 FlutterDlna manager = new FlutterDlna();
```

初始化管理器

```
manager.init();
```

设置设备搜索回调

```
 List deviceList = List();
 manager.setSearchCallback((devices){
      if (devices != null && devices.length > 0) {
        this.setState(() {
          this.deviceList = devices;
        });
      }
    });
```

搜索设备

```
  manager.search();
```


选择设备

```
  await this.manager.setDevice(e["id"]);
```

设置视频播放地址及名称（android系统会直接投屏）

```
await this.manager.setVideoUrlAndName("https://vod3.buycar5.cn/20201030/Fk3mpLH6/index.m3u8","不期而遇");
```

开始投屏

```
await this.manager.startAndPlay();
```

退出投屏

```
this.manager.stop();
```