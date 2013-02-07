#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface RBRecorder : NSObject  <CLLocationManagerDelegate>

- (void)start;
- (void)stop;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *collectedData;
@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSTimer *timer; //make private later

@end