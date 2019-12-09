#import "FlutterBluetoothPrintPlugin.h"
#import <flutter_bluetooth_print_plugin/flutter_bluetooth_print_plugin-Swift.h>

@implementation FlutterBluetoothPrintPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBluetoothPrintPlugin registerWithRegistrar:registrar];
}
@end
