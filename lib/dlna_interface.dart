import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract class DlnaService{
  Function searchCallback;

  @protected
  Future<void> init();

  void setSearchCallback(Function searchCallback) {
    this.searchCallback = searchCallback;
  }

  //搜索设备
  @protected
  Future<void> search();

  //设置视频地址和名称
  @protected
  Future<void> setVideoUrlAndName(String url,String name);

  //设置设备
  @protected
  Future<void> setDevice(String uuid);

  //启动和播放
  @protected
  Future<void> startAndPlay() ;

  //停止
  @protected
  Future<void> stop();

}