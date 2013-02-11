#import "RBRecord.h"

@interface RBRecord()

@property (nonatomic, strong) NSMutableArray *dataPoints;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *startTime, *endTime;

@end

@implementation RBRecord
@synthesize dataPoints, motionManager, locationManager, timer, status, startTime, endTime;

- (id)init {
    self = [super init];
    if (self) {
        motionManager = [[CMMotionManager alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        dataPoints = [[NSMutableArray alloc] init];
        
        [self setStatus:@"new"];
    }
    
    return self;
} 

- (void)updateData {
    RBDataPoint *dataPoint = [[RBDataPoint alloc] initWithLocation:locationManager.location 
                                                   andAcceleration:motionManager.accelerometerData.acceleration];
    [self.dataPoints addObject: dataPoint];
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

- (NSData *)toCSV {
    NSMutableString *results = [NSMutableString stringWithString:@"Time,Acceleration X,Acceleration Y,Acceleration Z,Latitude,Longitude,Altitude"];
    for (RBDataPoint *dataPoint in dataPoints) {
        [results appendFormat:@"\n%@", dataPoint];
    }
    return [results dataUsingEncoding:NSUTF8StringEncoding];
}
@end
