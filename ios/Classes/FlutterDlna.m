#import "FlutterDlna.h"
#import "MRDLNA.h"

@interface FlutterDlna () <DLNADelegate>
// 投屏控制
@property(nonatomic,strong) MRDLNA *dlnaManager;
@property (nonatomic, strong) NSMutableArray *deviceList;
@end

static FlutterMethodChannel *methodChannel;

@implementation FlutterDlna
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    methodChannel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_dlna"
            binaryMessenger:[registrar messenger]];
  FlutterDlna* instance = [[FlutterDlna alloc] init];
  [registrar addMethodCallDelegate:instance channel:methodChannel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
      _dlnaManager = [MRDLNA sharedMRDLNAManager];
      self.dlnaManager.delegate = self;
      result(@"ios dlna init,use MRDLNA");
  }else if([@"search" isEqualToString:call.method]){
      [_dlnaManager startSearch];
      result(@"ios dlna start search");
  }else if([@"setVideoName" isEqualToString:call.method]){
      self.dlnaManager.videoName = call.arguments;
      result(@"ios dlna setVideoName");
  }else if([@"setVideoUrl" isEqualToString:call.method]){
      self.dlnaManager.playUrl = call.arguments;
      result(@"ios dlna setVideoUrl");
  }else if([@"setDevice" isEqualToString:call.method]){
      CLUPnPDevice *model = nil;
    
      for(CLUPnPDevice *device in self.deviceList){
          if([device.uuid isEqualToString:call.arguments]){
              model = device;
              NSLog(@"%@", device.uuid);
          }
      }
      self.dlnaManager.device = model;
      result(@"ios dlna setDevice");
  }else if([@"startAndPlay" isEqualToString:call.method]){
      [_dlnaManager startDLNAAfterStop];
      result(@"ios dlna startAndPlay");
  }else if([@"play" isEqualToString:call.method]){
      [_dlnaManager dlnaPlay];
      result(@"ios dlna play");
  }else if([@"pause" isEqualToString:call.method]){
      [_dlnaManager dlnaPause];
      result(@"ios dlna pause");
  }else if([@"stop" isEqualToString:call.method]){
      [_dlnaManager endDLNA];
      result(@"ios dlna end");
  }else if([@"seek" isEqualToString:call.method]){
      [_dlnaManager seekChanged:[call.arguments longValue]];
      result(@"ios dlna seek");
  }else if([@"volume" isEqualToString:call.method]){
      [_dlnaManager volumeChanged:call.arguments];
      result(@"ios dlna volume");
  }else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSMutableArray *)deviceList{
    if (!_deviceList){
        _deviceList = [NSMutableArray array];
    }
    return _deviceList;
}

- (void)searchDLNAResult:(NSArray *)devicesArray{
    if (devicesArray.count > 0) {
        NSLog(@"发现设备");
        [self.deviceList removeAllObjects];
        [self.deviceList addObjectsFromArray:devicesArray];
        
        NSMutableArray *resultDevices=[NSMutableArray array];
        for(CLUPnPDevice *device in devicesArray){
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [device uuid],@"id", [device friendlyName],@"name", nil];
            [resultDevices addObject:dic];
        }
        [methodChannel invokeMethod:@"search_callback" arguments:resultDevices];
    }
}

@end
