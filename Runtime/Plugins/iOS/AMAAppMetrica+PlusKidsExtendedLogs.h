
#import <Foundation/Foundation.h>
#import <AppMetricaCore/AppMetricaCore.h>
#import "AMAUAppMetricaConfiguration.h"

@interface AMAAppMetrica (PlusKidsExtendedLogs)
+ (void)plusKidsActivateWithConfiguration:(AMAAppMetricaConfiguration*) configuration;
+ (void)plusKidsActivate;
+ (void)plusKidsReportEvent:(NSString *)name onFailure:(void (^)(NSError *error))onFailure;
+ (void)plusKidsReportEvent:(NSString *)name
         parameters:(NSDictionary *)params
                  onFailure:(void (^)(NSError *error))onFailure;
@end


