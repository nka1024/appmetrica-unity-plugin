
#include "AMAUAppMetricaPushHelper.h"
#include "AMAUAppMetricaProxy.h"

@implementation AMAUAppMetricaPushHelper

+ (void)activateAppMetricaByUnityConfig:(char *)config
{
    amau_activate(config);
    if (_unityLogDelegate != nil) {
        _unityLogDelegate(@"activateAppMetricaByUnityConfig: %s", config);
    }
 
}

@end
