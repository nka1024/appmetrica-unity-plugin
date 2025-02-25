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
#import "AppMetricaStorageFixer.h"

@implementation AMAAppMetrica (PlusKidsExtendedLogs)

+ (void)load {
    NSLog(@"Swizzle start. activateWithConfiguration");
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^
  {
      @autoreleasepool
      {
          Method original = class_getClassMethod(self, @selector(activateWithConfiguration:));
          Method swizzled = class_getClassMethod(self, @selector(plusKidsActivateWithConfiguration:));
          method_exchangeImplementations(original, swizzled);
          NSLog(@"Swizzle success. activateWithConfiguration");
          
          original = class_getClassMethod(self, @selector(activate));
          swizzled = class_getClassMethod(self, @selector(plusKidsActivate));
          method_exchangeImplementations(original, swizzled);
          NSLog(@"Swizzle success. activate");
          
          original = class_getClassMethod(self, @selector(reportEvent:onFailure:));
          swizzled = class_getClassMethod(self, @selector(plusKidsReportEvent:onFailure:));
          method_exchangeImplementations(original, swizzled);
          NSLog(@"Swizzle success. reportEvent");
          
          original = class_getClassMethod(self, @selector(reportEvent:parameters:onFailure:));
          swizzled = class_getClassMethod(self, @selector(plusKidsReportEvent:parameters:onFailure:));
          method_exchangeImplementations(original, swizzled);
          NSLog(@"Swizzle success. reportEvent:parameters");
      };
  });
}

+(void)plusKidsActivateWithConfiguration:(AMAAppMetricaConfiguration*) configuration {
    NSLog(@"AMAAppMetrica activateWithConfiguration called with apiKey=%@. CallStack: %@", configuration.APIKey, NSThread.callStackSymbols);
    [AppMetricaStorageFixer fixDatabase];
    [self plusKidsActivateWithConfiguration:configuration];
}
+(void)plusKidsActivate {
    NSLog(@"AMAAppMetrica activate called. CallStack: %@", NSThread.callStackSymbols);
    [AppMetricaStorageFixer fixDatabase];
    [self plusKidsActivate];
}

+ (void)plusKidsReportEvent:(NSString *)name onFailure:(void (^)(NSError *error))onFailure {
    NSLog(@"AMAAppMetrica reportEvent: %@ called. CallStack: %@", name, NSThread.callStackSymbols);
    [self plusKidsReportEvent:name onFailure: onFailure];
}

+ (void)plusKidsReportEvent:(NSString *)name
         parameters:(NSDictionary *)params
          onFailure:(void (^)(NSError *error))onFailure
{
    NSLog(@"AMAAppMetrica reportEvent:parameters: %@ called. CallStack: %@", name, NSThread.callStackSymbols);
    [self plusKidsReportEvent:name parameters:params onFailure: onFailure];
}
@end
