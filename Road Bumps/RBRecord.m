#import "RBRecord.h"

@interface RBRecord()

@property (nonatomic, strong) NSMutableArray *dataPoints;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *startTime, *endTime;

@end

@implementation RBRecord

- (id)init {
    self = [super init];
    if (self) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        self.dataPoints = [[NSMutableArray alloc] init];
        
        self.recording = NO;
    }
    
    return self;
} 

- (void)updateData {
    RBDataPoint *dataPoint = [[RBDataPoint alloc] initWithLocation:self.locationManager.location
                                                   andAcceleration:self.motionManager.accelerometerData.acceleration];
    [self.dataPoints addObject: dataPoint];
    [self.delegate recordUpdatedDataPoint:dataPoint];
}

- (void)start {
    self.startTime = [NSDate date];
    [self.locationManager startUpdatingLocation];
    [self.motionManager startAccelerometerUpdates];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                  target:self
                                                selector:@selector(updateData)
                                                userInfo:nil
                                                 repeats:YES];
    self.recording = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)stop {
    [self.timer invalidate];
    self.timer = nil;
    
    self.endTime = [NSDate date];

    [self.locationManager stopUpdatingLocation];
    [self.motionManager stopAccelerometerUpdates];

    self.recording = NO;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (NSString *)description {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    
    return [[NSString alloc ]initWithFormat:@"Collected between %@ and %@.",
                                            [formatter stringFromDate:self.startTime],
                                            [formatter stringFromDate:self.endTime]];
}

- (NSString *)filename {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_hh_mm"];
    
    return [[NSString alloc ]initWithFormat:@"RoadBumps_%@.csv",
            [formatter stringFromDate:self.startTime]];
}

- (NSData *)toCSV {
    NSMutableString *results = [NSMutableString stringWithString:@"Time,Acceleration X,Acceleration Y,Acceleration Z,Latitude,Longitude,Altitude"];
    for (RBDataPoint *dataPoint in self.dataPoints) {
        [results appendFormat:@"\n%@", dataPoint];
    }
    return [results dataUsingEncoding:NSUTF8StringEncoding];
}
@end
