//
//  NCProxySwitcherController.m
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NCProxySwitcherController.h"
#import <SBBulletinTableView.h>

#define kBgViewTag          999
#define kDirectPacTag       1001
#define kProxyAutoPacTag    1002
#define kProxyAllPacTag     1003

#define kCurrentPacPath     @"/var/mobile/PAC/PC_Proxy.pac"
#define kDirectPacPath      @"/var/mobile/PAC/Direct.pac"
#define kProxyAutoPacPath   @"/var/mobile/PAC/Proxy_ignoreLocal.pac"
#define kProxyAllPacPath    @"/var/mobile/PAC/Proxy_all.pac"

@implementation NCProxySwitcherController
@synthesize pacArray;

- (id)init
{
	if ((self = [super init]))
	{
        self.pacArray = [NSArray arrayWithObjects:kDirectPacPath, kProxyAutoPacPath, kProxyAllPacPath, nil];
        isContentShowing = NO;
	}
    
	return self;
}

- (void)dealloc
{
    NSLog(@"Dealloc==============");
	[_view release];
	[super dealloc];
}

- (UIView *)view
{
	if (_view == nil)
	{
        
        NSLog(@"init view ===========");
		_view = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 316, 44)];
        
		UIImage *bg = [[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/NCProxySwitcher.bundle/WeeAppBackground.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:70];
		UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
		bgView.frame = CGRectMake(0, 0, 316, 44);
        bgView.tag = kBgViewTag;
		[_view addSubview:bgView];
		[bgView release];
        
        UIButton *switchBtnDirect = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtnDirect.frame = CGRectMake(0, 0, 100, 44);
        switchBtnDirect.tag = kDirectPacTag;
        switchBtnDirect.titleLabel.font = [UIFont systemFontOfSize:16];
        [switchBtnDirect setTitle:@"Direct" forState:UIControlStateNormal];
        [switchBtnDirect setTitle:@"Close" forState:UIControlStateSelected];
        [switchBtnDirect addTarget:self action:@selector(switchProxy:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *directLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        directLongPress.minimumPressDuration = 0.5f;
        [switchBtnDirect addGestureRecognizer:directLongPress];
        [directLongPress release];
        [_view addSubview:switchBtnDirect];
        
        UIButton *switchBtnProxyIgnorelocal = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtnProxyIgnorelocal.frame = CGRectMake(105, 0, 100, 44);
        switchBtnProxyIgnorelocal.tag = kProxyAutoPacTag;
        switchBtnProxyIgnorelocal.titleLabel.font = [UIFont systemFontOfSize:16];
        [switchBtnProxyIgnorelocal setTitle:@"ProxyAuto" forState:UIControlStateNormal];
        [switchBtnProxyIgnorelocal setTitle:@"Close" forState:UIControlStateSelected];
        [switchBtnProxyIgnorelocal addTarget:self action:@selector(switchProxy:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *proxyAutoLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        proxyAutoLongPress.minimumPressDuration = 0.5f;
        [switchBtnProxyIgnorelocal addGestureRecognizer:proxyAutoLongPress];
        [proxyAutoLongPress release];
        [_view addSubview:switchBtnProxyIgnorelocal];
        
        UIButton *switchBtnProxyAll = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtnProxyAll.frame = CGRectMake(210, 0, 100, 44);
        switchBtnProxyAll.tag = kProxyAllPacTag;
        switchBtnProxyAll.titleLabel.font = [UIFont systemFontOfSize:16];
        [switchBtnProxyAll setTitle:@"ProxyAll" forState:UIControlStateNormal];
        [switchBtnProxyAll setTitle:@"Close" forState:UIControlStateSelected];
        [switchBtnProxyAll addTarget:self action:@selector(switchProxy:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *proxyAllLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        proxyAllLongPress.minimumPressDuration = 0.5f;
        [switchBtnProxyAll addGestureRecognizer:proxyAllLongPress];
        [proxyAllLongPress release];
        [_view addSubview:switchBtnProxyAll];
        
        [self initButtonStatus];
	}
    
	return _view;
}

- (float)viewHeight
{
    if (_view)
    {
        return _view.frame.size.height;
    }
	return 44.0f;
}

- (void)willRotateToInterfaceOrientation:(int)interfaceOrientation
{
    NSLog(@"orientation: ======= %d", interfaceOrientation);
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        NSLog(@"Landscape====================");
        _view.frame = CGRectMake(2, 0, 476, 35);
        UIImageView *bgView = (UIImageView *)[_view viewWithTag:kBgViewTag];
        bgView.frame = CGRectMake(0, 0, 476, 35);
        for (int btnTag = kDirectPacTag; btnTag <= kProxyAllPacTag; btnTag++)
        {
            @autoreleasepool
            {
                UIButton *btn = (UIButton *)[_view viewWithTag:btnTag];
                btn.frame = CGRectMake((btnTag - kDirectPacTag) * 155, 0, 155, 35);
            }
        }
    }
    else
    {
        NSLog(@"Portrait====================");
        _view.frame = CGRectMake(2, 0, 316, 44);
        UIImageView *bgView = (UIImageView *)[_view viewWithTag:kBgViewTag];
        bgView.frame = CGRectMake(0, 0, 316, 44);
        for (int btnTag = kDirectPacTag; btnTag <= kProxyAllPacTag; btnTag++)
        {
            @autoreleasepool
            {
                UIButton *btn = (UIButton *)[_view viewWithTag:btnTag];
                btn.frame = CGRectMake((btnTag - kDirectPacTag) * 105, 0, 105, 44);
            }
        }
    }
}


- (void)viewWillDisappear
{
    [viewer dismissAnimated:NO];
}

- (void)initButtonStatus
{
    PAC_TYPE pacType = [self currentPacType];
    NSUInteger currentPacButtonTag = kDirectPacTag + pacType;
    
    UIButton *currentPacButton = (UIButton *)[_view viewWithTag:currentPacButtonTag];
    [currentPacButton setTitle:[@"· " stringByAppendingString:currentPacButton.titleLabel.text] forState:UIControlStateNormal];
    currentPacButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
}

- (void)switchProxy:(UIButton *)sender
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *pacToSwitchTo = [pacArray objectAtIndex:(sender.tag - kDirectPacTag)];
    NSError *error = nil;
    
    if ([fm fileExistsAtPath:kCurrentPacPath] && [fm fileExistsAtPath:pacToSwitchTo])
    {
        NSString *pacString = [NSString stringWithContentsOfFile:pacToSwitchTo encoding:NSUTF8StringEncoding error:&error];
        if (!error && [pacString length])
        {
            if (isContentShowing && viewer)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    viewer.textView.alpha = 0;
                } completion:^(BOOL finished){
                    if (finished)
                    {
                        viewer.textView.text = pacString;
                        [UIView animateWithDuration:0.2 animations:^{
                            viewer.textView.alpha = 1;
                        }];
                    }
                }];
                
                return;
            }
            
            error = nil;
            BOOL result = [pacString writeToFile:kCurrentPacPath atomically:NO encoding:NSUTF8StringEncoding error:&error];
            if (result)
            {
                NSLog(@"Write Successfully");
                [self changeButtonStatusIfSucceed:YES selectedButtonTag:sender.tag];
            }
            else
            {
                //[self changeButtonStatusIfSucceed:NO selectedButtonTag:sender.tag];
                NSLog(@"error: %@", [error description]);
            }
        }
        else
        {
            //[self changeButtonStatusIfSucceed:NO selectedButtonTag:sender.tag];
            NSLog(@"error: %@", [error description]);
        }
    }
    

}

- (void)changeButtonStatusIfSucceed:(BOOL)isSucceed selectedButtonTag:(NSUInteger)btnTag
{
    UIButton *selectedBtn = (UIButton *)[_view viewWithTag:btnTag];
    if (selectedBtn.titleLabel.font == [UIFont boldSystemFontOfSize:16])
    {
        return;
    }
    
    if (isSucceed)
    {
        NSLog(@"\n---------------------------\nProxy Switched to %@\n---------------------------\n", selectedBtn.titleLabel.text);
        [selectedBtn setTitle:[@"· " stringByAppendingString:selectedBtn.titleLabel.text] forState:UIControlStateNormal];
        selectedBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    else
    {
        return;
    }
    
    for (int tag = kDirectPacTag; tag <= kProxyAllPacTag; tag++)
    {
        @autoreleasepool
        {
            if (tag != btnTag)
            {
                NSString *origMessage = nil;
                switch (tag)
                {
                    case kDirectPacTag:
                        origMessage = @"Direct";
                        break;
                    case kProxyAutoPacTag:
                        origMessage = @"ProxyAuto";
                        break;
                    case kProxyAllPacTag:
                        origMessage = @"ProxyAll";
                        break;
                        
                    default:
                        origMessage = @"";
                        break;
                }
                UIButton *btn = (UIButton *)[_view viewWithTag:tag];
                [btn setTitle:origMessage forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:16];
            }
        }
    }
}

- (PAC_TYPE)currentPacType
{
    PAC_TYPE pacType = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:kCurrentPacPath])
    {
        NSError *error = nil;
        NSString *pacStr = [NSString stringWithContentsOfFile:kCurrentPacPath encoding:NSUTF8StringEncoding error:&error];
        
        if ([pacStr rangeOfString:@"PROXY"].length == 0)
        {
            pacType = PAC_DIRECT;
        }
        else if ([pacStr rangeOfString:@"localhost"].length == 0)
        {
            pacType = PAC_PROXY_ALL;
        }
        else
        {
            pacType = PAC_PROXY_IGNORELOCAL;
        }
    }
    return pacType;
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    if (!isContentShowing)
    {
        isContentShowing = YES;
        
        UIButton *button = (UIButton *)gesture.view;
        
        NSString *pacPath = nil;
        switch (button.tag)
        {
            case kDirectPacTag:
                pacPath = kDirectPacPath;
                break;
            case kProxyAutoPacTag:
                pacPath = kProxyAutoPacPath;
                break;
            case kProxyAllPacTag:
                pacPath = kProxyAllPacPath;
                break;
                
            default:
                break;
        }
        
        UITableView *NCTableView = (UITableView *)_view.superview.superview.superview;
        
        NSLog(@"NCTableView Delegate : %@", NCTableView.delegate);
        NSLog(@"NCTableView.superview : %@", _view.superview.superview.superview.superview);
        NSLog(@"NCTableView.superview.superview : %@", _view.superview.superview.superview.superview.superview);
        NSLog(@"rootWindow : %@", _view.superview.superview.superview.superview.superview.superview);
        
        UIWindow *NCView = (UIWindow *)_view.superview.superview.superview.superview;
        CGFloat origY = [_view convertPoint:CGPointMake(0, 44) toView:(UIView *)NCView].y;
        CGFloat height = 450 - origY;

        NSError *error = nil;
        NSString *pacStr = [NSString stringWithContentsOfFile:pacPath encoding:NSUTF8StringEncoding error:&error];
        viewer = [[PacViewer alloc] initWithFrame:CGRectMake(2, origY, 316, height)];
        viewer.delegate = self;
        viewer.textView.text = pacStr;

        [NCView addSubview:viewer];
        
        [viewer release];
    }
}

- (void)pacViewerWillDismiss
{
    viewer = nil;
    isContentShowing = NO;
}

@end