#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "RBRecorder.h"
#import "RBButton.h"

@interface RBViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) RBRecorder *recorder;

@end
