//
//  PacViewer.h
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-26.
//
//

#import <UIKit/UIKit.h>

#define kSaveBtnTag             2001
#define kCloseBtnTag            2002
#define kSaveAndSwitchBtnTag    2003

@class PacViewer;

@protocol PacViewerDelegate <NSObject>

@optional

- (void)pacViewerWillDismissWithPacFileSaved:(BOOL)save switchTo:(BOOL)switchToPac;

@end

@interface PacViewer : UIView <UITextViewDelegate>
{
    UIView *bgView;                 //背景
    UITextView *textView;           //文本框
    UIView *buttonsView;            //按钮栏
    id<PacViewerDelegate> delegate;
}

@property(nonatomic, retain) UIView *bgView;
@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, retain) UIView *buttonsView;
@property(nonatomic, assign) id<PacViewerDelegate> delegate;

- (void)dismissAnimated:(BOOL)animated btnTag:(NSInteger)btnTag;

@end
