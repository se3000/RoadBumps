#import "RBViewController.h"

@interface RBViewController()
    @property (nonatomic, strong) UIButton *controlButton;
    @property (nonatomic, strong) UIButton *emailButton;
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
        
        self.emailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.emailButton setTitle:@"EMail Results" forState:UIControlStateNormal];
        [self.emailButton addTarget:self action:@selector(emailData) forControlEvents:UIControlEventTouchUpInside];
        [self.emailButton setFrame:CGRectMake(220, 0, 100, 100)];
        self.emailButton.enabled = NO;

        [self.view addSubview:self.controlButton];
        [self.view addSubview:self.emailButton];
    }

    return self;
}

- (void)emailData {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Road Bumps Data"];
        [mailer setMessageBody:[recorder description] isHTML:NO];
        [mailer addAttachmentData:[recorder resultData] 
                         mimeType:@"text/csv"
                         fileName:[recorder filename]];
        [self presentViewController:mailer animated:YES completion:nil];
    }
}


- (void)controlPress {
    if ([recorder.status isEqualToString:@"recording"])
    {
        self.emailButton.enabled = YES;
        [recorder stop];
        [self.controlButton setTitle:@"Start Over" forState:UIControlStateNormal];
    } else if ([recorder.status isEqualToString:@"stopped"] || [recorder.status isEqualToString:@"new"]) {
        self.emailButton.enabled = NO;
        [recorder start];
        [self.controlButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end