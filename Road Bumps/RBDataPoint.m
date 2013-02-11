#import "RBDataPoint.h"

@implementation RBDataPoint
@synthesize acceleration, coordinate, altitude, recordedAt;

- (id)initWithLocation:(CLLocation *)location andAcceleration:(CMAcceleration)newAcceleration
{
    self = [super init];
    if (self) {
        acceleration = newAcceleration;
        coordinate = location.coordinate;
        altitude = location.altitude;
        recordedAt = [NSDate date];
    }
    
    return self;
}

- (NSString *)description
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
    
    return [[NSString alloc] initWithFormat:@"%@,%f,%f,%f,%f,%f,%f", 
            [dateFormatter stringFromDate:recordedAt],
            acceleration.x,
            acceleration.y,
            acceleration.z,
            coordinate.latitude,
            coordinate.longitude,
            altitude];
}

@end
