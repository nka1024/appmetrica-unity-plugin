#import "AppMetricaStorageFixer.h"
#import <AppMetricaCoreUtils/AMAFileUtility.h>

@implementation AppMetricaStorageFixer

+ (void)fixDatabase
{
    NSLog(@"AppMetricaStorageFixer.fixDatabase call");
    NSString *key = @"AppMetrica.storage.fix.database.580";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL deleted = [defaults boolForKey:key];
    
    if (deleted) {
        NSLog(@"AppMetricaStorageFixer.fixDatabase: already fixed");
        return;
    }

    [defaults setBool:YES forKey:key];
    [defaults synchronize];
    
    NSArray *critKeys = @[@"schema.version",
                          @"fallback-keychain-AMAMetricaPersistentConfigurationDeviceIDStorageKey",
                          @"fallback-keychain-AMAMetricaPersistentConfigurationDeviceIDHashStorageKey",
                          @"5.0.0.migration.applied",
                          @"5.8.0.migration.applied",
                          @"recent.main.api.key"];
    
    [self removeAllExceptKeys:critKeys];
}

+ (BOOL)removeAllExceptKeys:(NSArray<NSString *> *)criticalKeys
{
    NSLog(@"AppMetricaStorageFixer.fixDatabase: removeAllExceptKeys start");
    AMAFMDatabase *db = [AMAFMDatabase databaseWithPath:[self databasePath]];
    BOOL success = NO;

    if ([db open]) {
        NSLog(@"AppMetricaStorageFixer.fixDatabase: db opened");
        NSMutableArray *valueQuestions = [NSMutableArray array];
        for (NSUInteger i = 0; i < criticalKeys.count; i++) {
            [valueQuestions addObject:@"?"];
        }
        NSString *query = [NSString stringWithFormat:@"DELETE FROM kv WHERE k NOT IN (%@)",
                           [valueQuestions componentsJoinedByString:@", "]];
        
        NSLog(@"AppMetricaStorageFixer.fixDatabase: run query %@", query);
        success = [db executeUpdate:query withArgumentsInArray:criticalKeys];
        
        if (!success) {
            NSLog(@"Failed to remove entries except keys: %@ with error: %@", criticalKeys, [db lastErrorMessage]);
        }
        else{
            NSLog(@"AppMetricaStorageFixer.fixDatabase: success");
        }
        
        [db close];
    }
    
    return success;
}

+ (NSString *)databasePath
{
    NSString *basePath = [AMAFileUtility persistentPath];
    NSString *dbPath = [basePath stringByAppendingPathComponent:@"storage.sqlite"];
    return dbPath;
}

@end
