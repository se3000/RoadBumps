#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "RBDataPoint.h"

@interface RBRecorder : NSObject  <CLLocationManagerDelegate>

- (void)start;
- (void)stop;
- (NSString *)description;
- (NSString *)filename;
- (NSData *)toCSV;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *status;

@end