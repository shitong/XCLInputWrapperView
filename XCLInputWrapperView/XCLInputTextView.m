//
//  XCLInputTextView.m
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "XCLInputTextView.h"

@interface XCLInputTextView ()

@end

@implementation XCLInputTextView

@dynamic delegate;

#pragma mark - init method

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self pri_init];
    }
    return self;
}

- (void)awakeFromNib
{
    [self pri_init];
}

- (void)pri_init
{
    // 这句很关键，必须设置，虽然苹果是default is NO
    // 否则在汉语输入法时，拼音占位删除时contentSize会快速变化一次，导致输入框抖动
    self.layoutManager.allowsNonContiguousLayout = NO;
    [self addObserver:self forKeyPath:@"contentSize" options:kNilOptions context:NULL];
    [self defaultConfig];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentSize"];
}

- (void)defaultConfig
{
    self.backgroundColor = [UIColor whiteColor];
    self.scrollsToTop = NO;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1].CGColor;
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    self.font = [UIFont systemFontOfSize:16];
    self.returnKeyType = UIReturnKeySend;
    
    UIEdgeInsets insets = self.textContainerInset;
    insets.left = 8;
    insets.right = 8;
    [self setTextContainerInset:insets];
    [self setContentInset:UIEdgeInsetsZero];
}

#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self contentHeightDidChanged];
    }
}

- (void)contentHeightDidChanged
{
    CGFloat contentHeight = self.contentSize.height;
    CGFloat boundsHeight  = self.bounds.size.height;
    
    if (boundsHeight == contentHeight) {
        return;
    }
    
    [self.delegate inputTextView:self contentHeightDidChanged:contentHeight boundsHeight:boundsHeight];
}

- (BOOL)becomeFirstResponder
{
    BOOL ret = [super becomeFirstResponder];
    if (ret && [self.delegate respondsToSelector:@selector(didBecomeFirstResponder:)]) {
        [self.delegate didBecomeFirstResponder:self];
    }
    return ret;
}

- (BOOL)resignFirstResponder
{
    BOOL ret = [super resignFirstResponder];
    if (ret && [self.delegate respondsToSelector:@selector(didResignFirstResponder:)]) {
        [self.delegate didResignFirstResponder:self];
    }
    return ret;
}

@end
