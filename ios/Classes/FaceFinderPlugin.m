#import "FaceFinderPlugin.h"
#import <face_finder/face_finder-Swift.h>

@implementation FaceFinderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFaceFinderPlugin registerWithRegistrar:registrar];
}
@end
