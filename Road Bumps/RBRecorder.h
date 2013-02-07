#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface RBRecorder : NSObject  <CLLocationManagerDelegate>

- (void)start;
- (void)stop;
- (NSString *)description;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *collectedData, *status;

@end