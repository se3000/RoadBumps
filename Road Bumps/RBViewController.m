#import "RBViewController.h"

@interface RBViewController()
    @property (nonatomic, strong) RBButton *controlButton;
    @property (nonatomic, strong) RBButton *emailButton;
@end

@implementation RBViewController
@synthesize recorder;


- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        recorder = [[RBRecorder alloc] init];
        self.controlButton = [RBButton withFrame:CGRectMake(20, 300, 280, 70)
                                        andTitle:@"Start new log"];
        [self.controlButton addTarget:self 
                               action:@selector(controlPress)
                     forControlEvents:UIControlEventTouchUpInside];
        
        self.emailButton = [RBButton withFrame:CGRectMake(20, 380, 280, 70)
                                      andTitle:@"Export as email"];
        [self.emailButton addTarget:self 
                             action:@selector(emailData) 
                   forControlEvents:UIControlEventTouchUpInside];
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
        [mailer addAttachmentData:[recorder toCSV]
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
        [self.controlButton setTitle:@"Reset and start new log"
                            forState:UIControlStateNormal];
    } else if ([recorder.status isEqualToString:@"stopped"] || [recorder.status isEqualToString:@"new"]) {
        self.emailButton.enabled = NO;
        [recorder start];
        [self.controlButton setTitle:@"Stop logging"
                            forState:UIControlStateNormal];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end