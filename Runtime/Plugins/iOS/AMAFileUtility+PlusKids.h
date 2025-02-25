#import <Foundation/Foundation.h>
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCoreUtils/AMAFileUtility.h>
#import "AMAUAppMetricaConfiguration.h"

@interface AMAFileUtility (PlusKids)
+ (BOOL)plusKidsCreatePathIfNeeded:(NSString *)path;
@end
