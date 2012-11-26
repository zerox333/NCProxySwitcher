//
//  PacViewer.m
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-26.
//
//

#import "PacViewer.h"
#import <QuartzCore/QuartzCore.h>

@implementation PacViewer
@synthesize textView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
        textView.delegate = self;
        textView.alpha = 0;
        textView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        textView.textColor = [UIColor whiteColor];
        
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = YES;
//        textView.layer.shadowOffset = CGSizeMake(5, 3);
//        textView.layer.shadowOpacity = 0.6;
//        textView.layer.shadowRadius = 5;
//        textView.layer.shadowColor = [UIColor blackColor].CGColor;
  
        [self addSubview:textView];
        
        [UIView animateWithDuration:0.3f animations:^{
            textView.alpha = 1;
            textView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 35);
        }];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(0, self.bounds.size.height - 35, 320, 35);
        closeBtn.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}

- (void)dealloc
{
    [textView release];
    [super dealloc];
}

- (void)tap:(UIButton *)sender
{
    [delegate pacViewerTapped:self];
}

@end
