#import "RBViewController.h"

@interface RBViewController()
    @property (nonatomic, strong) UIButton *controlButton;
@end

@implementation RBViewController
@synthesize recorder;


- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        recorder = [[RBRecorder alloc] init];
        self.controlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.controlButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.controlButton addTarget:self action:@selector(controlPress) forControlEvents:UIControlEventTouchUpInside];
        [self.controlButton setFrame:CGRectMake(0, 0, 100, 100)];
        [self.view addSubview:self.controlButton];
    }

    return self;
}


- (void)controlPress {
    if ([recorder.status isEqualToString:@"recording"])
    {
        [recorder stop];
        [self.controlButton setTitle:@"Start Over" forState:UIControlStateNormal];
    } else if ([recorder.status isEqualToString:@"stopped"] || [recorder.status isEqualToString:@"new"]) {
        [recorder start];
        [self.controlButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
}
@end