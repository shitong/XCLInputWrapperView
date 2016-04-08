//
//  XCLInputTextView.h
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XCLInputTextView;

@protocol XCLInputTextViewDelegate <UITextViewDelegate>

- (void)inputTextView:(XCLInputTextView *)inputTextView contentHeightDidChanged:(CGFloat)height boundsHeight:(CGFloat)boundsHeight;
- (void)didBecomeFirstResponder:(XCLInputTextView *)inputTextView;
- (void)didResignFirstResponder:(XCLInputTextView *)inputTextView;

@end

@interface XCLInputTextView : UITextView

@property (nonatomic, weak) id<XCLInputTextViewDelegate> delegate;

@end
