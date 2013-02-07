#import "RBRecorder.h"

@interface RBRecorder()

@property (nonatomic, strong) NSString *collectedData;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *startTime, *endTime;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation RBRecorder
@synthesize motionManager, locationManager,
            collectedData, timer,
            status, startTime, endTime,
            dateFormatter;

- (id)init {
    self = [super init];
    if (self) {
        collectedData = @"Time,Acceleration X,Acceleration Y,Acceleration Z,Latitude,Longitude,Altitude\n";
        motionManager = [[CMMotionManager alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
        
        [self setStatus:@"new"];
    }
    
    return self;
} 

- (void)updateData {
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    CLLocationCoordinate2D coordinate = locationManager.location.coordinate;
    CMAcceleration acceletation = motionManager.accelerometerData.acceleration;
    
    NSString *newData = [[NSString alloc] initWithFormat:@"%@,%f,%f,%f,%f,%f,%f\n",
                         currentTime,
                         acceletation.x,
                         acceletation.y,
                         acceletation.z,
                         coordinate.latitude,
                         coordinate.longitude,
                         locationManager.location.altitude];
    
    [self setCollectedData:[collectedData stringByAppendingString:newData]] ;
}

- (void)start {
    startTime = [NSDate date];
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
    [timer invalidate];
    timer = nil;
    
    endTime = [NSDate date];

    [locationManager stopUpdatingLocation];
    [motionManager stopAccelerometerUpdates];

    [self setStatus:@"stopped"];
}

- (NSString *)description {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    return [[NSString alloc ]initWithFormat:@"Collected between %@ and %@.",
                                            [formatter stringFromDate:startTime],
                                            [formatter stringFromDate:endTime]];
}

- (NSString *)filename {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_hh_mm"];
    
    return [[NSString alloc ]initWithFormat:@"RoadBumps_%@.csv",
            [formatter stringFromDate:startTime]];
}

- (NSData *)resultData {
    return [collectedData dataUsingEncoding:NSUTF8StringEncoding] ;
}
@end
