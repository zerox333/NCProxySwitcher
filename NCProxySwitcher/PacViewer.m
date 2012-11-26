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
        textView.editable = NO;
        textView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        textView.textColor = [UIColor whiteColor];
        
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = YES;
        textView.layer.shadowOffset = CGSizeMake(5, 3);
        textView.layer.shadowOpacity = 0.6;
        textView.layer.shadowRadius = 5;
        textView.layer.shadowColor = [UIColor blackColor].CGColor;
  
        [self addSubview:textView];
        
        [UIView animateWithDuration:0.3f animations:^{
            textView.alpha = 1;
            textView.frame = self.bounds;
        }];
    }
    return self;
}

- (void)dealloc
{
    [textView release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [delegate pacViewerTapped:self];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [delegate pacViewerTapped:self];
}

@end
