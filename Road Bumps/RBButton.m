#import <QuartzCore/QuartzCore.h>
#import "RBButton.h"

@implementation RBButton

+ (RBButton *)withFrame:(CGRect)frame andTitle:(NSString *)title {
    RBButton *button = [RBButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title
            forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor darkGrayColor]
                 forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    
    return button;
}

@end
