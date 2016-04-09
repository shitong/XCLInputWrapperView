//
//  XCLInputWrapperView.h
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XCLInputWrapperView;
@protocol XCLInputWrapperViewDelegate <NSObject>

@optional
- (void)inputWrapperView:(XCLInputWrapperView *)inputWrapperView heightDidChanged:(CGFloat)height;
- (BOOL)inputWrapperViewShouldBeginInputing:(XCLInputWrapperView *)XCLInputWrapperView;
- (void)inputWrapperView:(XCLInputWrapperView *)inputWrapperView submitWithText:(NSString *)text;
- (void)atInputtedWithInputWrapperView:(XCLInputWrapperView *)inputWrapperView;

- (void)inputWrapperViewDidShowKeyboard:(XCLInputWrapperView *)inputWrapperView;
- (void)inputWrapperViewDidShowInputView:(XCLInputWrapperView *)inputWrapperView;
- (void)inputWrapperViewDidHideKeyboard:(XCLInputWrapperView *)inputWrapperView;
- (void)inputWrapperViewDidHideInputView:(XCLInputWrapperView *)inputWrapperView;

@end

@interface XCLInputWrapperView : UIView

+ (instancetype)inputWrapperViewWithSuperview:(UIView *)superview;
- (void)inputAtString:(NSString *)string;

- (void)showKeyboard;
- (void)hideKeyboard;
- (BOOL)isShowKeyboard;

- (void)showCustomInputView;
- (void)hideCustomInputView;
- (BOOL)isShowCustomInputView;

- (void)hideKeyboardOrCustomInputViewIfNeeded;

@property (nonatomic, weak  ) id<XCLInputWrapperViewDelegate> delegate;
@property (nonatomic, strong, readonly) UITextView            *textView;

@property (nonatomic, strong) UIView       *cancelBackdropView;                     // default is nil
@property (nonatomic, strong) UIScrollView *cancelOnDragScrollView;                 // default is nil
@property (nonatomic, strong) UIView       *customInputView;                        // default is nil
@property (nonatomic, strong) UIColor      *customInputViewBackViewBackgroundColor; // default is white color
@property (nonatomic        ) BOOL         returnToSubmit;                          // default is YES
@property (nonatomic        ) BOOL         enableAt;                                // default is YES

@property (nonatomic        ) CGFloat      inputTextViewMinHeight;                  // default is 36
@property (nonatomic        ) CGFloat      inputTextViewMaxHeight;                  // default is 112

@end
