#import "FtbasePlugin.h"
#if __has_include(<ftbase/ftbase-Swift.h>)
#import <ftbase/ftbase-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ftbase-Swift.h"
#endif

@implementation FtbasePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFtbasePlugin registerWithRegistrar:registrar];
}
@end
