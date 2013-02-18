#import "RBViewController.h"
#import "RBRecordDelegate.h"
#import "RBDataPoint.h"

@interface RBViewController() <RBRecordDelegate>
    @property (nonatomic, strong) RBButton *controlButton, *emailButton;
    @property (nonatomic, strong) UISwitch *lockSwitch;
    @property (nonatomic, strong) UILabel *longitude, *latitude, *altitude,
                                          *accelerationX, *accelerationY, *accelerationZ;
    @property (nonatomic, strong) RBRecord *record;
@end

@implementation RBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        self.record = [[RBRecord alloc] init];
        self.record.delegate = self;
        
        [self.view addSubview:self.controlButton];
        [self.view addSubview:self.emailButton];
        [self.view addSubview:self.lockSwitch];
        
        [self.view addSubview:[self labelWithText:@"Lock Screen" startingAtPoint:CGPointMake(125, 250)]];
        [self.view addSubview:self.latitude];
        [self.view addSubview:self.longitude];
        [self.view addSubview:self.altitude];
        [self.view addSubview:self.accelerationX];
        [self.view addSubview:self.accelerationY];
        [self.view addSubview:self.accelerationZ];
    }

    return self;
}

- (void)emailData {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Road Bumps Data"];
        [mailer setMessageBody:[self.record description] isHTML:NO];
        [mailer addAttachmentData:[self.record toCSV]
                         mimeType:@"text/csv"
                         fileName:[self.record filename]];
        [self presentViewController:mailer animated:YES completion:nil];
    }
}

- (void)controlPress {
    if (self.record.recording)
    {
        [self.record stop];
        self.lockSwitch.enabled = NO;
        [self.controlButton setTitle:@"Reset and start new log"
                            forState:UIControlStateNormal];
    } else {
        [self.record start];
        self.lockSwitch.enabled = YES;
        [self.controlButton setTitle:@"Stop logging"
                            forState:UIControlStateNormal];
    }
    [self updateEmailButton];
}

- (void)lockSwitchUpdated {
    if (self.lockSwitch.on) {
        self.controlButton.enabled = false;
    } else {
        self.controlButton.enabled = true;
    }
    [self updateEmailButton];
}

- (RBButton *)controlButton {
    if (!_controlButton) {
        _controlButton = [RBButton withFrame:CGRectMake(20, 310, 280, 60)
                                    andTitle:@"Start new log"];
        [_controlButton addTarget:self
                           action:@selector(controlPress)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _controlButton;
}

- (RBButton *)emailButton {
    if (!_emailButton) {
        _emailButton = [RBButton withFrame:CGRectMake(20, 380, 280, 60)
                                  andTitle:@"Export as email"];
        [_emailButton addTarget:self
                         action:@selector(emailData)
               forControlEvents:UIControlEventTouchUpInside];
        _emailButton.enabled = NO;
    }
    return _emailButton;
}

- (UISwitch *)lockSwitch {
    if (!_lockSwitch) {
        _lockSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(120, 270, 40, 20)];
        [_lockSwitch addTarget:self action:@selector(lockSwitchUpdated) forControlEvents:UIControlEventValueChanged];
        [_lockSwitch setTintColor:[UIColor blackColor]];
        [_lockSwitch setOnTintColor:[UIColor redColor]];
        _lockSwitch.transform = CGAffineTransformMakeScale(1.25, 1.25);
        _lockSwitch.enabled = NO;
    }
    return _lockSwitch;
}

- (UILabel *)latitude {
    if (!_latitude) {
        _latitude = [self labelWithText:@"Latitude:" startingAtPoint:CGPointMake(10, 0)];

    }
    return _latitude;
}

- (UILabel *)longitude {
    if (!_longitude) {
        _longitude = [self labelWithText:@"Longitude:" startingAtPoint:CGPointMake(10, 20)];
    }
    return _longitude;
}

- (UILabel *)altitude {
    if (!_altitude) {
        _altitude = [self labelWithText:@"Altitude:" startingAtPoint:CGPointMake(10, 40)];
    }
    return _altitude;
}

- (UILabel *)accelerationX {
    if (!_accelerationX) {
        _accelerationX = [self labelWithText:@"Acceleration X:" startingAtPoint:CGPointMake(160, 0)];
    }
    return _accelerationX;
}

- (UILabel *)accelerationY {
    if (!_accelerationY) {
        _accelerationY = [self labelWithText:@"Acceleration Y:" startingAtPoint:CGPointMake(160, 20)];
    }
    return _accelerationY;
}

- (UILabel *)accelerationZ {
    if (!_accelerationZ) {
        _accelerationZ = [self labelWithText:@"Acceleration Z:" startingAtPoint:CGPointMake(160, 40)];
    }
    return _accelerationZ;
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark RBRecordDelegate

- (void)recordUpdatedDataPoint:(RBDataPoint *)dataPoint {
    self.latitude.text = [NSString stringWithFormat:@"Latitude:     %f", dataPoint.coordinate.latitude];
    self.longitude.text = [NSString stringWithFormat:@"Longitude: %f", dataPoint.coordinate.longitude];
    self.altitude.text = [NSString stringWithFormat:@"Altitude:      %f", dataPoint.altitude];
    self.accelerationX.text = [NSString stringWithFormat:@"Acceleration X:  %f", dataPoint.acceleration.x];
    self.accelerationY.text = [NSString stringWithFormat:@"Acceleration Y:  %f", dataPoint.acceleration.y];
    self.accelerationZ.text = [NSString stringWithFormat:@"Acceleration Z:  %f", dataPoint.acceleration.z];
}

#pragma mark private

- (UILabel *)labelWithText:(NSString *)text startingAtPoint:(CGPoint)point {
    UIFont *font = [UIFont systemFontOfSize:12];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){point, [@"Acceleration X: 0.00000000" sizeWithFont: font]}];
    [label setFont:font];
    label.text = text;
    
    return label;
}

- (void)updateEmailButton {
    if (self.record.recording) {
        self.emailButton.enabled = false;
    } else {
        self.emailButton.enabled = true;
    }
}

@end