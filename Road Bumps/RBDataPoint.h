#import <Foundation/Foundation.h>
#include <CoreMotion/CoreMotion.h>
#include <CoreLocation/CoreLocation.h>

@interface RBDataPoint : NSObject

@property (readwrite) CMAcceleration acceleration;
@property (readwrite) CLLocationCoordinate2D coordinate;
@property (readwrite) float altitude;
@property (nonatomic, strong) NSDate *recordedAt;

- (id)initWithLocation:(CLLocation *)location andAcceleration:(CMAcceleration)acceleration;

@end