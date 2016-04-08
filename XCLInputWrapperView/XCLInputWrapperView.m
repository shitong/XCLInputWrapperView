//
//  XCLInputWrapperView.m
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "XCLInputWrapperView.h"
#import "XCLInputWrapperViewSubclass.h"
#import "XCLInputTextView.h"

@interface XCLInputWrapperView () <XCLInputTextViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *pri_tapGestureRecognizer;
@property (nonatomic, strong) UIView                 *pri_backView;
@property (nonatomic, strong) UIView                 *pri_inputBarView;
@property (nonatomic, strong) XCLInputTextView       *pri_inputTextView;

@property (nonatomic, strong) NSLayoutConstraint     *pri_inputBarViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint     *pri_inputTextViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint     *pri_customInputViewBottomConstraint;

@property (nonatomic        ) BOOL                   pri_isInputTextViewHeightFixed;
@property (nonatomic        ) BOOL                   pri_isShowKeyboard;
@property (nonatomic        ) BOOL                   pri_isShowCustomInputView;

@property (nonatomic, weak  ) id <XCLInputWrapperViewInterface> pri_child;

@end

@implementation XCLInputWrapperView

#pragma mark - init & dealloc

+ (instancetype)inputWrapperViewWithSuperview:(UIView *)superview
{
    return [[[self class] alloc] initWithSuperview:superview];
}

- (instancetype)initWithSuperview:(UIView *)superview
{
    self = [self init];
    if (self) {
        [self defaultConfig];
        
        _pri_child                    = (id<XCLInputWrapperViewInterface>)self;
        _pri_backView                 = [[UIView alloc] init];
        _pri_backView.backgroundColor = _customInputViewBackViewBackgroundColor;
        _pri_inputBarView             = [_pri_child inputBarView];
        _pri_inputTextView            = [_pri_child inputTextView];
        _pri_inputTextView.delegate   = self;
        
        [superview addSubview:self];
        [self addSubview:_pri_backView];
        [self addSubview:_pri_inputBarView];
        
        [self wrapperViewAddConstraints];
        [self backViewAddConstraints];
        [self inputBarViewAddConstraints];
        
        [_pri_child customConfig];
        [self layoutIfNeeded];
        [self addObserver];
        
    }
    return self;
}

- (void)defaultConfig
{
    self.backgroundColor                    = [UIColor clearColor];
    _cancelBackdropView                     = nil;
    _cancelOnDragScrollView                 = nil;
    _customInputView                        = nil;
    _customInputViewBackViewBackgroundColor = [UIColor whiteColor];
    _returnToSubmit                         = YES;
    _enableAt                               = YES;

    _inputTextViewMinHeight                 = 36;
    _inputTextViewMaxHeight                 = 112;
    
    _pri_isInputTextViewHeightFixed         = NO;
    _pri_isShowKeyboard                     = NO;
    _pri_isShowCustomInputView              = NO;
}

- (void)addObserver
{
    [self addObserver:self forKeyPath:@"frame" options:kNilOptions context:NULL];
    [self addObserver:self forKeyPath:@"center" options:kNilOptions context:NULL];
    [self addObserver:self forKeyPath:@"bounds" options:kNilOptions context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
    [self removeObserver:self forKeyPath:@"center"];
    [self removeObserver:self forKeyPath:@"bounds"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (_cancelBackdropView) {
        _cancelBackdropView = nil;
    }
    
    if (_cancelOnDragScrollView) {
        [_cancelOnDragScrollView removeObserver:self forKeyPath:@"contentOffset"];
        _cancelOnDragScrollView = nil;
    }
}

#pragma mark - outside method

- (void)inputAtString:(NSString *)string
{
    if (string.length > 0) {
        NSString *fourPerEmSpace = @"\u2005";// 四分之一空格，U+2005
        NSString *atStr = [NSString stringWithFormat:@"%@%@", string, fourPerEmSpace];
        NSMutableString *textNew = [NSMutableString stringWithString:self.pri_inputTextView.text];
        NSRange selectedRange = self.pri_inputTextView.selectedRange;
        [textNew insertString:atStr atIndex:selectedRange.location];
        self.pri_inputTextView.text = textNew;
        self.pri_inputTextView.selectedRange = NSMakeRange(selectedRange.location + atStr.length, 0);
    }
}

- (void)showKeyboard
{
    if (self.pri_isShowKeyboard) {
        return;
    }
    
    self.pri_isShowKeyboard = YES;
    [self.pri_inputTextView becomeFirstResponder];
}

- (void)hideKeyboard
{
    if (!self.pri_isShowKeyboard) {
        return;
    }
    
    self.pri_isShowKeyboard = NO;
    [self.pri_inputTextView resignFirstResponder];
}

- (BOOL)isShowKeyboard
{
    return self.pri_isShowKeyboard;
}

- (void)showCustomInputView
{
    if (!self.customInputView) {
        return;
    }
    
    if (self.pri_isShowCustomInputView) {
        return;
    }
    
    self.pri_isShowCustomInputView = YES;
    
    if (self.pri_isShowKeyboard) {
        [self hideKeyboard];
    }
    
    self.pri_customInputViewBottomConstraint.constant = 0;
    [self layoutBarViewWithBottomInset:CGRectGetHeight(self.customInputView.bounds)];
    
    
    if ([self.pri_child respondsToSelector:@selector(didShowInputView)]) {
        [self.pri_child didShowInputView];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputWrapperViewDidShowInputView:)]) {
        [self.delegate inputWrapperViewDidShowInputView:self];
    }
}

- (void)hideCustomInputView
{
    if (!self.customInputView) {
        return;
    }
    
    if (!self.pri_isShowCustomInputView) {
        return;
    }
    
    self.pri_isShowCustomInputView = NO;
    self.pri_customInputViewBottomConstraint.constant = CGRectGetHeight(self.customInputView.bounds);
    [self layoutBarViewWithBottomInset:0];
    
    
    if ([self.pri_child respondsToSelector:@selector(didHideInputView)]) {
        [self.pri_child didHideInputView];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputWrapperViewDidHideInputView:)]) {
        [self.delegate inputWrapperViewDidHideInputView:self];
    }
}

- (BOOL)isShowCustomInputView
{
    return self.pri_isShowCustomInputView;
}

- (void)hideKeyboardOrCustomInputViewIfNeeded
{
    if (self.pri_isShowKeyboard) {
        [self hideKeyboard];
    } else if (self.pri_isShowCustomInputView) {
        [self hideCustomInputView];
    }
}

- (UITextView *)textView
{
    return self.pri_inputTextView;
}

#pragma mark - event response

- (void)onHideAll
{
    if (self.pri_isShowCustomInputView) {
        [self hideCustomInputView];
    } else if (self.pri_isShowKeyboard) {
        [self hideKeyboard];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self]) {
        if ([keyPath isEqualToString:@"frame"] ||
            [keyPath isEqualToString:@"center"] ||
            [keyPath isEqualToString:@"bounds"]) {
            
            if ([self.delegate respondsToSelector:@selector(inputWrapperView:heightDidChanged:)]) {
                [self.delegate inputWrapperView:self heightDidChanged:CGRectGetHeight(self.bounds)];
            }
        }
    } else if ([object isEqual:self.cancelOnDragScrollView]) {
        if ((self.pri_isShowKeyboard || self.pri_isShowCustomInputView) && self.cancelOnDragScrollView.tracking) {
            [self onHideAll];
        }
    }
}

#pragma mark - keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (keyboardHeight == 0) {
        return;
    }
    
    [self layoutBarViewWithBottomInset:keyboardHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.pri_isShowCustomInputView) {
        return;
    }
    
    [self layoutBarViewWithBottomInset:0];
}

#pragma mark - XCLInputTextViewDelegate

- (void)inputTextView:(XCLInputTextView *)inputTextView contentHeightDidChanged:(CGFloat)height boundsHeight:(CGFloat)boundsHeight
{
    if (self.pri_isInputTextViewHeightFixed) {
        return;
    }
    [self setInputTextViewHeight:height];
}

- (void)didBecomeFirstResponder:(XCLInputTextView *)inputTextView
{
    if (self.pri_isShowCustomInputView) {
        // 弹出键盘后，需要设置pri_isShowCustomInputView为NO
        self.pri_isShowCustomInputView = NO;
        self.pri_customInputViewBottomConstraint.constant = CGRectGetHeight(self.customInputView.bounds);
        
        if ([self.pri_child respondsToSelector:@selector(didHideInputView)]) {
            [self.pri_child didHideInputView];
        }
        
        if ([self.delegate respondsToSelector:@selector(inputWrapperViewDidHideInputView:)]) {
            [self.delegate inputWrapperViewDidHideInputView:self];
        }
    }
    
    // 通过点击输入框弹出键盘后，需要设置pri_isShowKeyboard为YES
    self.pri_isShowKeyboard = YES;
    
    if ([self.pri_child respondsToSelector:@selector(didShowKeyboard)]) {
        [self.pri_child didShowKeyboard];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputWrapperViewDidShowKeyboard:)]) {
        [self.delegate inputWrapperViewDidShowKeyboard:self];
    }
}

- (void)didResignFirstResponder:(XCLInputTextView *)inputTextView
{
    self.pri_isShowKeyboard = NO;
    if ([self.pri_child respondsToSelector:@selector(didHideKeyboard)]) {
        [self.pri_child didHideKeyboard];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputWrapperViewDidHideKeyboard:)]) {
        [self.delegate inputWrapperViewDidHideKeyboard:self];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputWrapperViewShouldBeginInputing:)]) {
        return [self.delegate inputWrapperViewShouldBeginInputing:self];
    } else {
        return YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.enableAt) {
        
        if ([text isEqualToString:@"@"] ) {
            if ([self.delegate respondsToSelector:@selector(atInputtedWithinputWrapperView:)]) {
                textView.text = [textView.text stringByReplacingCharactersInRange:range withString:@"@"];
                textView.selectedRange = NSMakeRange(range.location + 1, 0);
                [self.delegate atInputtedWithinputWrapperView:self];
                return NO;
            }
        } else if ([text isEqualToString:@""] && range.length == 1) {
            // 当删除1个字符，同时删除的是fourPerEmSpace，则连同fourPerEmSpace到@的字符全部删除, 如果没有找到@，则仅删除fourPerEmSpace
            NSString *string = [textView.text substringWithRange:range];
            NSString *fourPerEmSpace = @"\u2005";// 四分之一空格，U+2005
            if ([string isEqualToString:fourPerEmSpace]) {
                for (NSInteger i = range.location; i >= 0; i--) {
                    NSRange deleteRange = NSMakeRange(i, range.location - i + 1);
                    NSString *deleteString = [textView.text substringWithRange:deleteRange];
                    if ([deleteString hasPrefix:@"@"]) {
                        textView.text = [textView.text stringByReplacingCharactersInRange:deleteRange withString:@""];
                        textView.selectedRange = NSMakeRange(deleteRange.location, 0);
                        return NO;
                    }
                }
                // 如果就是以fourPerEmSpace开头，则不用特殊处理，默认就是删除
            }
        }
    }
    
    if ([text isEqualToString:@"\n"] && self.returnToSubmit) {
        
        if (textView.text.length > 0) {
            if ([self.delegate respondsToSelector:@selector(inputWrapperView:submitWithText:)]) {
                [self.delegate inputWrapperView:self submitWithText:textView.text];
                textView.text = @"";
            }
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - private methods

- (void)wrapperViewAddConstraints
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0]];
    
    [self.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0]];
    
    [self.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0]];
}

- (void)backViewAddConstraints
{
    self.pri_backView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.pri_backView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.pri_backView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.pri_inputBarView
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0]];
    
    [self.pri_backView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.pri_backView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.pri_backView.superview
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:0]];
    
    [self.pri_backView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.pri_backView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.pri_backView.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0]];
    
    [self.pri_backView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.pri_backView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.pri_backView.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0]];
}

- (void)inputBarViewAddConstraints
{
    self.pri_inputBarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.pri_inputTextViewHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.pri_inputTextView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0f
                                  constant:self.inputTextViewMinHeight];
    [self.pri_inputTextView addConstraint:self.pri_inputTextViewHeightConstraint];
    
    
    self.pri_inputBarViewBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.pri_inputBarView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.pri_inputBarView.superview
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:0];
    [self.superview addConstraint:self.pri_inputBarViewBottomConstraint];
    
    [self.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.pri_inputBarView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.pri_inputBarView.superview
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0]];
    
    [self.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.pri_inputBarView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.pri_inputBarView.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0]];
    
    [self.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.pri_inputBarView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.pri_inputBarView.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0]];
}

- (void)customInputViewAddConstraints
{
    if (!self.customInputView) {
        return;
    }
    
    self.customInputView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.pri_customInputViewBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.customInputView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.customInputView.superview
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:CGRectGetHeight(self.customInputView.bounds)];
    
    [self.customInputView.superview addConstraint:self.pri_customInputViewBottomConstraint];
    
    [self.customInputView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.customInputView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:CGRectGetHeight(self.customInputView.bounds)]];
    
    [self.customInputView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.customInputView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.customInputView.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0]];
    
    [self.customInputView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:self.customInputView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.customInputView.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0]];
}

- (void)setInputTextViewFixedHeight:(CGFloat)height
{
    self.pri_isInputTextViewHeightFixed = YES;
    [self setInputTextViewHeight:height];
}

- (void)setInputTextViewHeightAuto
{
    self.pri_isInputTextViewHeightFixed = NO;
    [self setInputTextViewHeight:self.pri_inputTextView.contentSize.height];
}

- (void)setInputTextViewHeight:(CGFloat)height
{
    height = MAX(self.inputTextViewMinHeight, height);
    height = MIN(self.inputTextViewMaxHeight, height);
    
    if (self.pri_inputTextViewHeightConstraint.constant == height) {
        return;
    }
    
    self.pri_inputTextViewHeightConstraint.constant = height;
    [self frameChanged];
}

- (void)layoutBarViewWithBottomInset:(CGFloat)insert
{
    self.pri_inputBarViewBottomConstraint.constant = -insert;
    [self frameChanged];
    
    if (insert > 0) {
        if (self.cancelBackdropView && ![self.cancelBackdropView.gestureRecognizers containsObject:self.pri_tapGestureRecognizer]) {
            [self.cancelBackdropView addGestureRecognizer:self.pri_tapGestureRecognizer];
        }
    } else {
        if (self.cancelBackdropView && [self.cancelBackdropView.gestureRecognizers containsObject:self.pri_tapGestureRecognizer]) {
            [self.cancelBackdropView removeGestureRecognizer:self.pri_tapGestureRecognizer];
        }
    }
}

- (void)frameChanged
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.layer layoutIfNeeded];
    }];
}

#pragma mark - getters and setters

- (void)setCancelBackdropView:(UIView *)cancelBackdropView
{
    _cancelBackdropView = cancelBackdropView;
    _cancelBackdropView.userInteractionEnabled = YES;
    self.pri_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHideAll)];
    
    if (self.pri_isShowKeyboard) {
        [self addGestureRecognizer:self.pri_tapGestureRecognizer];
    }
}

- (void)setCancelOnDragScrollView:(UIScrollView *)cancelOnDragScrollView
{
    if (_cancelOnDragScrollView == cancelOnDragScrollView) {
        return;
    }
    
    if (_cancelOnDragScrollView) {
        [_cancelOnDragScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    _cancelOnDragScrollView = cancelOnDragScrollView;
    [_cancelOnDragScrollView addObserver:self forKeyPath:@"contentOffset" options:kNilOptions context:NULL];
    
}

- (void)setCustomInputView:(UIView *)customInputView
{
    if (_customInputView || !customInputView) {
        return;
    }
    
    _customInputView = customInputView;
    self.pri_isShowCustomInputView = NO;
    
    [self insertSubview:_customInputView belowSubview:self];
    [self customInputViewAddConstraints];
}

@end
