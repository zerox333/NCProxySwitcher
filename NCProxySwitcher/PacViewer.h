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

- (void)pacViewerTapped:(PacViewer *)pacViewer;

@end

@interface PacViewer : UIView <UITextViewDelegate>
{
    UITextView *textView;
    id<PacViewerDelegate> delegate;
}

@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, assign) id<PacViewerDelegate> delegate;

@end
