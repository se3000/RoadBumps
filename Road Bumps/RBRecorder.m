#import "RBRecorder.h"

@interface RBRecorder()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation RBRecorder
@synthesize collectedData, motionManager, locationManager, status, timer, dateFormatter;

- (id)init {
    self = [super init];
    if (self) {
        collectedData = @"Time,Acceleration X,Acceleration Y,Acceleration Z,Latitude,Longitude,Altitude\n";
        motionManager = [[CMMotionManager alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS "];
        
        [self setStatus:@"new"];
    }
    
    return self;
} 

- (void)updateData {
    CLLocationCoordinate2D coordinate = locationManager.location.coordinate;
    CMAcceleration acceletation = motionManager.accelerometerData.acceleration;
    
    NSString *newData = [[NSString alloc] initWithFormat:@"%@,%f,%f,%f,%f,%f,%f\n",
                         [self currentTime],
                         acceletation.x,
                         acceletation.y,
                         acceletation.z,
                         coordinate.latitude,
                         coordinate.longitude,
                         locationManager.location.altitude];
    
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

- (NSString *)currentTime {
    return [dateFormatter stringFromDate:[NSDate date]];
}
@end
