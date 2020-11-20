import 'package:flutter/services.dart';
import 'package:flutter_dlna/dlna_interface.dart';

class DlnaIosService extends DlnaService{
  MethodChannel _channel = const MethodChannel('flutter_dlna');

  Function searchCallback;

  @override
  Future<void> init() async {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "search_callback" && searchCallback != null) {
        searchCallback(call.arguments);
      }
    });
    await _channel.invokeMethod('init');
  }

  //搜索设备
  @override
  Future<void> search() async {
    String result = await _channel.invokeMethod('search');
    print(result);
  }

  //设置视频地址/设置视频名称
  @override
  Future<void> setVideoUrlAndName(String url,String name) async {
    String result = await _channel.invokeMethod('setVideoUrl',url);
    print(result);
    result = await _channel.invokeMethod('setVideoName',name);
    print(result);
  }

  //设置设备
  @override
  Future<void> setDevice(String uuid) async {
    String result = await _channel.invokeMethod('setDevice',uuid);
    print(result);
  }

  //启动和播放
  @override
  Future<void> startAndPlay() async {
    String result = await _channel.invokeMethod('startAndPlay');
    print(result);
  }
  //停止
  @override
  Future<void> stop() async {
    String result = await _channel.invokeMethod('stop');
    print(result);
  }

}