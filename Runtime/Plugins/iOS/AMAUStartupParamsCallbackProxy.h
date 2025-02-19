
#import "AMAUUtils.h"
#import <AppMetricaCore/AppMetricaCore.h>

typedef void (*AMAUStartupParamsCallbackDelegate)(AMAUAction action, const char *result, const char *errorReason);
typedef void (*AMAULogCallbackDelegate)(const char *message);

NSArray *amau_fixStartupParamsKeys(NSArray *keys);
const char *amau_serializeStartupParamsResult(NSDictionary<AMAStartupKey,id> *identifiers);
const char *amau_serializeStartupParamsError(NSError *error);
