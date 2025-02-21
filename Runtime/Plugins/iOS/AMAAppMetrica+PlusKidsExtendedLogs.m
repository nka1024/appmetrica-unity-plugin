#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCrashes/AppMetricaCrashes.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "AMAUAppMetricaProxy.h"
#import "AMAUAdRevenueInfo.h"
#import "AMAAppMetrica+PlusKidsExtendedLogs.h"
#import "AMAUAppMetricaConfiguration.h"
#import "AMAUAppMetricaCrashesConfiguration.h"
#import "AMAUECommerceEvent.h"
#import "AMAUException.h"
#import "AMAUExternalAttribution.h"
#import "AMAULocation.h"
#import "AMAUReporterConfiguration.h"
#import "AMAAppMetrica+PlusKidsExtendedLogs.h"
#import "AMAURevenueInfo.h"
#import "AMAUStartupParamsCallbackProxy.h"
#import "AMAUUserProfile.h"
#import "AMAUUtils.h"

@implementation AMAAppMetrica (PlusKidsExtendedLogs)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^
  {
      @autoreleasepool
      {
        Method original, swizzled;
        
        original = class_getInstanceMethod(self, @selector(activateWithConfiguration:));
        swizzled = class_getInstanceMethod(self, @selector(plusKidsActivateWithConfiguration:));
        method_exchangeImplementations(original, swizzled);
      };
  });
}

-(void)plusKidsActivateWithConfiguration:(AMAAppMetricaConfiguration*) configuration {

    NSLog(@"AMAAppMetrica activateWithConfiguration called. CallStack: %@", NSThread.callStackSymbols);
    // looks like it's just calling itself, but the implementations were swapped so we're actually 
    // calling the original once we're done 
    [self plusKidsActivateWithConfiguration:configuration];
}

@end
