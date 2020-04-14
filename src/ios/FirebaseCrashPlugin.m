#import "FirebaseCrashPlugin.h"

@import Firebase;

@implementation FirebaseCrashPlugin

- (void)pluginInitialize {
    NSLog(@"Starting Firebase Crashlytics plugin");

    if(![FIRApp defaultApp]) {
        [FIRApp configure];
    }
}

- (void)log:(CDVInvokedUrlCommand *)command {
    NSString* errorMessage = [command.arguments objectAtIndex:0];

    [[FIRCrashlytics crashlytics] log:errorMessage];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)logError:(CDVInvokedUrlCommand*)command {
    NSString *domain = [[NSBundle mainBundle] bundleIdentifier];
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
    NSString *uiDescription = NSLocalizedString(@"Description", nil),
    userInfo[uiDescription] = NSLocalizedString([command argumentAtIndex:0 withDefault:@"No Message Provided"], nil);
    
    if ([command.arguments count] > 1) { 
        NSArray* stackFrames = [command.arguments objectAtIndex:1];
        for (NSDictionary* stackFrame in stackFrames) {
            
            NSString *sfSymbol = NSLocalizedString(@"Symbol", nil),
            userInfo[sfSymbol] = stackFrame[@"functionName"];

            NSString *sfFilename = NSLocalizedString(@"Filename", nil),
            userInfo[sfFilename] = stackFrame[@"fileName"];

            NSString *sfLibrary = NSLocalizedString(@"Library", nil),
            userInfo[sfLibrary] = stackFrame[@"source"];

            NSString *sfOffset = NSLocalizedString(@"Offset", nil),
            userInfo[sfOffset] = (uint64_t) [stackFrame[@"columnNumber"] intValue];

            NSString *sfLineNumber = NSLocalizedString(@"LineNumber", nil),
            userInfo[sfLineNumber] = (uint32_t) [stackFrame[@"lineNumber"] intValue]];
        }
    }

    NSError *error = [NSError errorWithDomain:domain code:-1 userInfo:userInfo];

    [[FIRCrashlytics crashlytics] recordError:error];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setUserId:(CDVInvokedUrlCommand *)command {
    NSString* userId = [command.arguments objectAtIndex:0];

    [[FIRCrashlytics crashlytics] setUserID:userId];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setEnabled:(CDVInvokedUrlCommand *)command {
    bool enabled = [[command.arguments objectAtIndex:0] boolValue];

    [[FIRCrashlytics crashlytics] setCrashlyticsCollectionEnabled:enabled];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
