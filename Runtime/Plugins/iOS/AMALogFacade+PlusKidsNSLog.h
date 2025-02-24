#import <Foundation/Foundation.h>
#import <AppMetricaLog/AppMetricaLog.h>
#import <AppMetricaLog/AMALogFacade.h>
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCoreUtils/AppMetricaCoreUtils.h>


@interface AMALogFacade (PlusKidsNSLog)
- (void)plusKidsLogMessageToChannel:(AMALogChannel)channel
                      level:(AMALogLevel)level
                       file:(const char *)file
                   function:(const char *)function
                       line:(NSUInteger)line
               addBacktrace:(BOOL)addBacktrace
                    message:(NSString *)message;

- (void)plusKidsLogMessageToChannel:(AMALogChannel)channel
                      level:(AMALogLevel)level
                       file:(const char *)file
                   function:(const char *)function
                       line:(NSUInteger)line
               addBacktrace:(BOOL)addBacktrace
                             format:(NSString *)message, ... NS_FORMAT_FUNCTION(7, 8);
@end
