#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "RBRecord.h"
#import "RBButton.h"

@interface RBViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) RBRecord *recorder;

@end
