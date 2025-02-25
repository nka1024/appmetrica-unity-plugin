#import <Foundation/Foundation.h>
#import <AppMetricaCore/AppMetricaCore.h>
#import <AppMetricaCoreUtils/AppMetricaCoreUtils.h>
#import "AMALogFacade+PlusKidsNSLog.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation AMALogFacade (PlusKidsNSLog)

+ (void)load {
    NSLog(@"Swizzle start: AMALogFacade.logMessageToChannel:level:...");
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^
  {
      @autoreleasepool
      {
          Method original = class_getInstanceMethod([AMALogFacade class], @selector(logMessageToChannel:level:file:function:line:addBacktrace:message:));
          Method swizzled = class_getInstanceMethod([self class], @selector(plusKidsLogMessageToChannel:level:file:function:line:addBacktrace:message:));
          method_exchangeImplementations(original, swizzled);
          NSLog(@"Swizzle success. AMALogFacade.logMessageToChannel:...message:");
          
          original = class_getInstanceMethod([AMALogFacade class], @selector(logMessageToChannel:level:file:function:line:addBacktrace:format:));
          swizzled = class_getInstanceMethod([self class], @selector(plusKidsLogMessageToChannel:level:file:function:line:addBacktrace:format:));
          method_exchangeImplementations(original, swizzled);
          NSLog(@"Swizzle success. AMALogFacade.logMessageToChannel:...format:");
      };
  });
}

- (void)plusKidsLogMessageToChannel:(AMALogChannel)channel
                      level:(AMALogLevel)level
                       file:(const char *)file
                   function:(const char *)function
                       line:(NSUInteger)line
               addBacktrace:(BOOL)addBacktrace
                    message:(NSString *)message;
{
    NSLog(@"DRAWIE_APPMETRICA_LOG: %@", message);
}

- (void)plusKidsLogMessageToChannel:(AMALogChannel)channel
                      level:(AMALogLevel)level
                       file:(const char *)file
                   function:(const char *)function
                       line:(NSUInteger)line
               addBacktrace:(BOOL)addBacktrace
                             format:(NSString *)message, ... NS_FORMAT_FUNCTION(7, 8)
{
    va_list args;
    va_start(args, message);
    NSString *msg = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);
    NSLog(@"DRAWIE_APPMETRICA_LOG: %@", msg);
}

@end
