#import "RBRecorder.h"

@implementation RBRecorder
@synthesize collectedData, motionManager, locationManager, status, timer;

- (id)init {
    self = [super init];
    if (self) {
        collectedData = @"Acceleration X,Acceleration Y,Acceleration Z,Latitude,Longitude,Altitude\n";
        motionManager = [[CMMotionManager alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self setStatus:@"new"];
    }
    
    return self;
}

- (void)updateData {
    CLLocationCoordinate2D coordinate = locationManager.location.coordinate;
    CMAcceleration acceletation = motionManager.accelerometerData.acceleration;
    
    NSString *newData = [[NSString alloc] initWithFormat:@"%f,%f,%f,%f,%f,%f\n",
                         acceletation.x, acceletation.y, acceletation.z,
                         coordinate.latitude, coordinate.longitude, locationManager.location.altitude];
    
    [self setCollectedData:[collectedData stringByAppendingString:newData]] ;
    NSLog(@"%@", collectedData);
}

- (void)start {
    [locationManager startUpdatingLocation];
    [motionManager startAccelerometerUpdates];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                             target:self
                                           selector:@selector(updateData)
                                           userInfo:nil
                                            repeats:YES];
    
    [self setStatus:@"recording"];
}

- (void)stop {
    [locationManager stopUpdatingLocation];
    [motionManager stopAccelerometerUpdates];
    
    [timer invalidate];
    timer = nil;
    
    [self setStatus:@"stopped"];
}
@end
