#import "RBViewController.h"

@interface RBViewController()
    @property (nonatomic, strong) UIButton *controlButton;
@end

@implementation RBViewController

@synthesize collectedData, motionManager, locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        collectedData = @"Acceleration X,Acceleration Y,Acceleration Z,Latitude,Longitude,Altitude\n";
        motionManager = [[CMMotionManager alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        self.controlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.controlButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.controlButton addTarget:self action:@selector(controlPress) forControlEvents:UIControlEventTouchUpInside];
        [self.controlButton setFrame:CGRectMake(0, 0, 100, 100)];
        [self.view addSubview:self.controlButton];
    }

    return self;
}

- (void)locationManager:(CLLocationManager *)manager 
     didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    CMAcceleration acceletation = motionManager.accelerometerData.acceleration;
    
    NSString *newData = [[NSString alloc] initWithFormat:@"%f,%f,%f,%f,%f,%f\n",
                              acceletation.x, acceletation.y, acceletation.z,
                              coordinate.latitude, coordinate.longitude, newLocation.altitude];
    
    [self setCollectedData:[collectedData stringByAppendingString:newData]] ;
    NSLog(@"%@", collectedData);
}

- (void)controlPress {
    [self.controlButton setTitle:@"Stop" forState:UIControlStateNormal];
    [locationManager startUpdatingLocation];
    [motionManager startAccelerometerUpdates];
}
@end