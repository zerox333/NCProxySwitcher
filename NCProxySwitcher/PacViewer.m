//
//  PacViewer.m
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-26.
//
//

#import "PacViewer.h"
#import <QuartzCore/QuartzCore.h>

#define kPacViewerRectEditing   CGRectMake(self.frame.origin.x, 20, self.frame.size.width, 244)

#define kPacViewerSize          self.bounds.size

#define kTextViewRect           CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 35)
#define kButtonsViewRect        CGRectMake(0, self.bounds.size.height - 35, self.bounds.size.width, 35)
#define kBgViewRect             CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 35)

@implementation PacViewer
@synthesize bgView;
@synthesize textView;
@synthesize buttonsView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.autoresizesSubviews = YES;
        
        [self initButtonsViewWitchFrame:CGRectMake(0, kPacViewerSize.height - 35, kPacViewerSize.width, 0)];
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kPacViewerSize.width, 0)];
        textView.delegate = self;
        textView.alpha = 0;
        textView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        textView.textColor = [UIColor whiteColor];
        
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = YES;
//        textView.layer.shadowOffset = CGSizeMake(2, 2);
//        textView.layer.shadowOpacity = 0.6;
//        textView.layer.shadowRadius = 10;
//        textView.layer.shadowColor = [UIColor blackColor].CGColor;
  
        [self addSubview:textView];
       
        bgView = [[UIView alloc] initWithFrame:kBgViewRect];
        bgView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        [UIView animateWithDuration:0.3f animations:^{
            textView.alpha = 1;
            textView.frame = kTextViewRect;
        } completion:^(BOOL finished){
            if (finished)
            {
                [self insertSubview:bgView atIndex:0];
                [UIView animateWithDuration:0.3f animations:^{
                    buttonsView.alpha = 1;
                    buttonsView.frame = kButtonsViewRect;
                }];
            }
        }];
    }    
    
    return self;
}

- (void)initButtonsViewWitchFrame:(CGRect)frame
{
    buttonsView = [[UIView alloc] initWithFrame:frame];
    buttonsView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    buttonsView.alpha = 0;
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kPacViewerSize.width / 3, 35)];
    saveBtn.tag = kSaveBtnTag;
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:saveBtn];
    [saveBtn release];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kPacViewerSize.width / 3, 0, kPacViewerSize.width / 3, 35)];
    closeBtn.tag = kCloseBtnTag;
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:closeBtn];
    [closeBtn release];
    
    UIButton *saveAndSwitchBtn = [[UIButton alloc] initWithFrame:CGRectMake(2 * kPacViewerSize.width / 3, 0, kPacViewerSize.width / 3, 35)];
    saveAndSwitchBtn.tag = kSaveAndSwitchBtnTag;
    saveAndSwitchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveAndSwitchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveAndSwitchBtn setTitle:@"Save&Switch" forState:UIControlStateNormal];
    [saveAndSwitchBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:saveAndSwitchBtn];
    [saveAndSwitchBtn release];
    
    [self addSubview:buttonsView];
}

- (void)dealloc
{
    [bgView release];
    [textView release];
    [buttonsView release];
    [super dealloc];
}

- (void)close:(UIButton *)sender
{
    [self dismissAnimated:YES btnTag:sender.tag];
}

- (void)dismissAnimated:(BOOL)animated btnTag:(NSInteger)btnTag
{
    if ([textView isFirstResponder])
    {
        [textView resignFirstResponder];
    }
    
    NSLog(@"dissmissing.......");
    
    BOOL save = (btnTag == kSaveBtnTag || btnTag == kSaveAndSwitchBtnTag);
    BOOL switchTo = (btnTag == kSaveAndSwitchBtnTag);
    
    if (animated)
    {
        [UIView animateWithDuration:0.15f animations:^{
            CGRect buttonsViewRect = buttonsView.frame;
            buttonsViewRect.size.height -= 35;
            buttonsView.alpha = 0;
            buttonsView.frame = buttonsViewRect;
        } completion:^(BOOL finished){
            if (finished)
            {
                [UIView animateWithDuration:0.2f animations:^{
                    textView.alpha = 0;
                    textView.frame = CGRectMake(0, 0, kPacViewerSize.width, 0);
                    bgView.alpha = 0;
                    bgView.frame = CGRectMake(0, 0, kPacViewerSize.width, 0);
                } completion:^(BOOL finished){
                    [delegate pacViewerWillDismissWithPacFileSaved:save switchTo:switchTo];
                    [self removeFromSuperview];
                }];
            }
        }];
    }
    else
    {
        [delegate pacViewerWillDismissWithPacFileSaved:save switchTo:switchTo];
        [self removeFromSuperview];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = kPacViewerRectEditing;
        self.textView.frame = kTextViewRect;
        bgView.frame = kBgViewRect;
        buttonsView.frame = kButtonsViewRect;
    } completion:^(BOOL finished){
        if (finished)
        {
            self.userInteractionEnabled = YES;
        }
    }];
}

@end
