#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "RBDataPoint.h"
#import "RBRecordDelegate.h"

@interface RBRecord : NSObject  <CLLocationManagerDelegate>

- (void)start;
- (void)stop;
- (BOOL)recording;
- (NSString *)description;
- (NSString *)filename;
- (NSData *)toCSV;

@property (nonatomic, strong) NSString *status;
@property (nonatomic, weak) NSObject <RBRecordDelegate> *delegate;

@end