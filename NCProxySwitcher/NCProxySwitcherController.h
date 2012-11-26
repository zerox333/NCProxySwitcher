//
//  NCProxySwitcherController.h
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SpringBoard/BBWeeAppController.h"
#import "PacViewer.h"

typedef enum{
	PAC_DIRECT,//直接连接
	PAC_PROXY_IGNORELOCAL,//代理连接（忽略本地请求）
    PAC_PROXY_ALL//代理连接
}PAC_TYPE;

@interface NCProxySwitcherController : NSObject <BBWeeAppController, PacViewerDelegate>
{
    UIView *_view;
    NSArray *pacArray;
    BOOL isContentShowing;
    PacViewer *viewer;
}

@property(nonatomic, retain) NSArray *pacArray;

- (UIView *)view;

@end