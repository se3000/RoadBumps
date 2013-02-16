#import <Foundation/Foundation.h>
@class RBDataPoint;

@protocol RBRecordDelegate <NSObject>

- (void)recordUpdatedDataPoint:(RBDataPoint *)dataPoint;

@end
