
import 'package:flutter/material.dart';
import 'package:flutter_dlna/flutter_dlna.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterDlna manager = new FlutterDlna();
  List deviceList = List();
  //当前选择的设备
  String currentDeviceUUID = "";
  @override
  void initState() {
    super.initState();
    manager.init();
    manager.setSearchCallback((devices){
      if (devices != null && devices.length > 0) {
        this.setState(() {
          this.deviceList = devices;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(child:Text("搜索"),onPressed: (){
                    manager.search();
                  },),
                  TextButton(child:Text("退出投屏"),onPressed: (){
                    manager.stop();
                  },),
                ],
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Column(children: [
                  Column(
                      children: deviceList.map((e) {
                        return InkWell(
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  height: 55,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            e["name"],
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Color(0xFF111111),
                                                fontSize: 12),
                                          )),
                                    ],
                                  )),
                              Divider(
                                color: Color(0xFFEEEEEE),
                                height: 0.5,
                                endIndent: 2,
                                indent: 2,
                              )
                            ],
                          ),
                          onTap: () async {
                            if(this.currentDeviceUUID == e["id"]){
                              return;
                            }
                            await this.manager.setDevice(e["id"]);
                            await this.manager.setVideoUrlAndName("https://vod3.buycar5.cn/20201030/Fk3mpLH6/index.m3u8","不期而遇");
                            await this.manager.startAndPlay();
                          },
                        );
                      }).toList()),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
