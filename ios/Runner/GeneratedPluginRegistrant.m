//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_icmp_ping/FlutterIcmpPingPlugin.h>)
#import <flutter_icmp_ping/FlutterIcmpPingPlugin.h>
#else
@import flutter_icmp_ping;
#endif

#if __has_include(<network_info_plus/FPPNetworkInfoPlusPlugin.h>)
#import <network_info_plus/FPPNetworkInfoPlusPlugin.h>
#else
@import network_info_plus;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

#if __has_include(<thermal_printer/ThermalPrinterPlugin.h>)
#import <thermal_printer/ThermalPrinterPlugin.h>
#else
@import thermal_printer;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FlutterIcmpPingPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterIcmpPingPlugin"]];
  [FPPNetworkInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPNetworkInfoPlusPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [ThermalPrinterPlugin registerWithRegistrar:[registry registrarForPlugin:@"ThermalPrinterPlugin"]];
}

@end
