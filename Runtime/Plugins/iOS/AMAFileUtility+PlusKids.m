#import <Foundation/Foundation.h>
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
#import "AMAFileUtility+PlusKids.h"

@implementation AMAFileUtility (PlusKids)

+ (void)load {
    NSLog(@"AMAFileUtility Swizzle start");
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^
  {
      @autoreleasepool
      {
          Method original = class_getClassMethod(self, @selector(createPathIfNeeded:));
          Method swizzled = class_getClassMethod(self, @selector(plusKidsCreatePathIfNeeded:));
          method_exchangeImplementations(original, swizzled);
          NSLog(@"Swizzle success. createPathIfNeeded");
      };
  });
}
    

  + (BOOL)plusKidsCreatePathIfNeeded:(NSString *)path
  {
      NSLog(@"Call plusKidsCreatePathIfNeeded CallStack: %@", NSThread.callStackSymbols);
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL result = YES;
    if ([fm fileExistsAtPath:path] == NO) {
        NSError * __autoreleasing error = nil;
        result = [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (result) {
            NSLog(@"Path created: %@", path);
        }
        else {
            NSLog(@"Error: Failed to create path %@ with error: %@", path, error);
        }
    }
    else
    {
        NSDictionary* attrs = [fm attributesOfItemAtPath:path error:nil];
        if (attrs != nil) {
            NSDate *creationDate = (NSDate*)[attrs objectForKey: NSFileCreationDate];
            NSLog(@"Date Created: %@", [creationDate description]);
            
            NSDateFormatter *mmddccyy = [[NSDateFormatter alloc] init];
            mmddccyy.timeStyle = NSDateFormatterNoStyle;
            mmddccyy.dateFormat = @"MM/dd/yyyy";
            NSDate *minData = [mmddccyy dateFromString:@"05/02/2025"];
            if([creationDate compare: minData] == NSOrderedDescending) // if start is later in time than end
            {
                NSLog(@"Date Created: %@ is later than %@", [creationDate description], [minData description]);
                
                BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                if(success)
                {
                    NSLog(@"io.appmetrica directory removed");
                    [self createPathIfNeeded:path];
                }
            }
            else
            {
                NSLog(@"Date Created: %@ is erliaer", [creationDate description]);
            }
        }
        else {
            NSLog(@"Not found");
        }
    }
    return result;
  }

@end
