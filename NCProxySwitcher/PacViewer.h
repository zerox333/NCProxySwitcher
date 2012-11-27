//
//  PacViewer.h
//  NCProxySwitcher
//
//  Created by ding_yuanyi on 12-11-26.
//
//

#import <UIKit/UIKit.h>

@class PacViewer;

@protocol PacViewerDelegate <NSObject>

@optional

- (void)pacViewerWillDismiss;

@end

@interface PacViewer : UIView <UITextViewDelegate>
{
    UIView *bgView;
    UITextView *textView;
    UIButton *closeBtn;
    id<PacViewerDelegate> delegate;
}

@property(nonatomic, retain) UIView *bgView;
@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, retain) UIButton *closeBtn;
@property(nonatomic, assign) id<PacViewerDelegate> delegate;

- (void)dismissAnimated:(BOOL)animated;

@end
