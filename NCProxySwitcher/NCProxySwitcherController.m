//
//  NCProxySwitcherController.m
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NCProxySwitcherController.h"

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
	}
    
	return self;
}

- (void)dealloc
{
	[_view release];
	[super dealloc];
}

- (UIView *)view
{
	if (_view == nil)
	{
		_view = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 316, 35)];
        
		UIImage *bg = [[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/NCProxySwitcher.bundle/WeeAppBackground.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:70];
		UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
		bgView.frame = CGRectMake(0, 0, 316, 35);
		[_view addSubview:bgView];
		[bgView release];
        
        UIButton *switchBtnDirect = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtnDirect.frame = CGRectMake(0, 0, 100, 35);
        switchBtnDirect.tag = kDirectPacTag;
        switchBtnDirect.titleLabel.font = [UIFont systemFontOfSize:16];
        [switchBtnDirect setTitle:@"Direct" forState:UIControlStateNormal];
        [switchBtnDirect addTarget:self action:@selector(switchProxy:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:switchBtnDirect];
        [switchBtnDirect release];
        
        UIButton *switchBtnProxyIgnorelocal = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtnProxyIgnorelocal.frame = CGRectMake(105, 0, 100, 35);
        switchBtnProxyIgnorelocal.tag = kProxyAutoPacTag;
        switchBtnProxyIgnorelocal.titleLabel.font = [UIFont systemFontOfSize:16];
        [switchBtnProxyIgnorelocal setTitle:@"ProxyAuto" forState:UIControlStateNormal];
        [switchBtnProxyIgnorelocal addTarget:self action:@selector(switchProxy:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:switchBtnProxyIgnorelocal];
        [switchBtnProxyIgnorelocal release];
        
        UIButton *switchBtnProxyAll = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtnProxyAll.frame = CGRectMake(210, 0, 100, 35);
        switchBtnProxyAll.tag = kProxyAllPacTag;
        switchBtnProxyAll.titleLabel.font = [UIFont systemFontOfSize:16];
        [switchBtnProxyAll setTitle:@"ProxyAll" forState:UIControlStateNormal];
        [switchBtnProxyAll addTarget:self action:@selector(switchProxy:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:switchBtnProxyAll];
        [switchBtnProxyAll release];
        
        [self initButtonStatus];
	}
    
	return _view;
}

- (float)viewHeight
{
	return 35.0f;
}

- (void)initButtonStatus
{
    PAC_TYPE pacType = [self currentPacType];
    NSUInteger currentPacButtonTag = kDirectPacTag + pacType;
    
    UIButton *currentPacButton = (UIButton *)[self.view viewWithTag:currentPacButtonTag];
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
    UIButton *selectedBtn = (UIButton *)[self.view viewWithTag:btnTag];
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
            UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
            [btn setTitle:origMessage forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
}

- (PAC_TYPE)currentPacType
{
    PAC_TYPE pacType;
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


@end