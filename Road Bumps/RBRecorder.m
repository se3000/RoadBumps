#import "RBRecorder.h"

@implementation RBRecorder
@synthesize collectedData, motionManager, locationManager, status;

- (id)init {
    self = [super init];
    if (self) {
        collectedData = @"Acceleration X,Acceleration Y,Acceleration Z,Latitude,Longitude,Altitude\n";
        motionManager = [[CMMotionManager alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self setStatus:@"new"];
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    CMAcceleration acceletation = motionManager.accelerometerData.acceleration;
    
    NSString *newData = [[NSString alloc] initWithFormat:@"%f,%f,%f,%f,%f,%f\n",
                         acceletation.x, acceletation.y, acceletation.z,
                         coordinate.latitude, coordinate.longitude, newLocation.altitude];
    
    [self setCollectedData:[collectedData stringByAppendingString:newData]] ;
    NSLog(@"%@", collectedData);
}

- (void)start {
    [locationManager startUpdatingLocation];
    [motionManager startAccelerometerUpdates];
    [self setStatus:@"recording"];
}

- (void)stop {
    [locationManager stopUpdatingLocation];
    [motionManager stopAccelerometerUpdates];
    [self setStatus:@"stopped"];
}
@end
