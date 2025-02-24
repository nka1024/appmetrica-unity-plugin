#import <Foundation/Foundation.h>
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCoreUtils/AMAFileUtility.h>
#import "PlusKidsLocalStorageCleaner.h"

@implementation PlusKidsLocalStorageCleaner

+ (void)clean
{
  NSLog(@"starting PlusKidsLocalStorageCleaner...");
    NSString *key = @"AppMetrica.storage.removed.580";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL deleted = [defaults boolForKey:key];
    
    if (deleted) {
        NSLog(@"skip PlusKidsLocalStorageCleaner: already deleted. ");
        return;
    }

    [defaults setBool:YES forKey:key];
    [defaults synchronize];
    
    NSString *path = [AMAFileUtility persistentPath];
    [AMAFileUtility deleteFileAtPath:path];
    NSLog(@"PlusKidsLocalStorageCleaner: deleted %@", path);

}
@end