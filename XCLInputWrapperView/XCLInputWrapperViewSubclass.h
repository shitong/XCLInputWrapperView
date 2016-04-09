//
//  XCLInputWrapperViewSubclass.h
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "XCLInputWrapperView.h"

@protocol XCLInputWrapperViewInterface <NSObject>

@required
// 返回inputBarView可以是代码实现也可以是xib
- (UIView *)inputBarView;
// 在返回之前，保证inputTextView已经add到了inputBarView上
// inputTextView需要添加上下左右的约束，高度约束不需要添加自动维护
- (UITextView *)inputTextView;
// 初始化默认值，或者添加其他view
- (void)customConfig;

@optional
- (void)didShowKeyboard;                                            
- (void)didShowInputView;                                           
- (void)didHideKeyboard;
- (void)didHideInputView;

@end

@interface XCLInputWrapperView (XCLInputWrapperViewProtected)

- (void)setInputTextViewFixedHeight:(CGFloat)height;
- (void)setInputTextViewHeightAuto;

@end
