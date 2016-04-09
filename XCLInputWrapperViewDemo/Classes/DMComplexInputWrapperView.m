//
//  DMComplexInputWrapperView.m
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "DMComplexInputWrapperView.h"
#import "XCLInputWrapperViewSubclass.h"
#import "XCLInputTextView.h"

@interface DMComplexInputWrapperView () <XCLInputWrapperViewInterface>

@property (strong, nonatomic) IBOutlet UIView           *complexInputBarView;
@property (strong, nonatomic) IBOutlet UIView           *moreInputView;

@property (weak, nonatomic  ) IBOutlet XCLInputTextView *myInputTextView;
@property (weak, nonatomic  ) IBOutlet UIButton         *bnVoice;
@property (weak, nonatomic  ) IBOutlet UIButton         *bnSwitch;
@property (weak, nonatomic  ) IBOutlet UIButton         *bnMore;
@property (weak, nonatomic  ) IBOutlet UIButton         *bnCamera;
@property (weak, nonatomic  ) IBOutlet UIButton         *bnPhoto;

@end

@implementation DMComplexInputWrapperView

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - XCLInputWrapperViewInterface

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    }
    return self;
}

- (UIView *)inputBarView
{
    return self.complexInputBarView;
}

- (XCLInputTextView *)inputTextView
{
    return self.myInputTextView;
}

- (void)customConfig
{
    CGColorRef borderColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1].CGColor;
    self.bnCamera.layer.cornerRadius = 5;
    self.bnCamera.layer.borderWidth = 0.5;
    self.bnCamera.layer.borderColor = borderColor;
    
    self.bnPhoto.layer.cornerRadius = 5;
    self.bnPhoto.layer.borderWidth = 0.5;
    self.bnPhoto.layer.borderColor = borderColor;
    
    [self.bnVoice setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.bnVoice setTitle:@"松开结束" forState:UIControlStateHighlighted];
    self.bnVoice.layer.cornerRadius = CGRectGetHeight(self.bnVoice.bounds)/2;
    self.bnVoice.layer.borderWidth = 0.5;
    self.bnVoice.layer.borderColor = borderColor;
    self.bnVoice.hidden = YES;
    self.myInputTextView.hidden = NO;
    self.customInputView = self.moreInputView;
}

- (void)inputAtString:(NSString *)string
{
    [super inputAtString:string];
    [self showVoiceButton:NO];
    [self showMoreInputView:NO];
}

- (void)showVoiceButton:(BOOL)isShow
{
    if (self.bnVoice.hidden != isShow) {
        return;
    }
    
    if (isShow) {
        [self setInputTextViewFixedHeight:self.inputTextViewMinHeight];
        [self.bnSwitch setImage:[UIImage imageNamed:@"icon_keyboard"] forState:UIControlStateNormal];
    } else {
        [self setInputTextViewHeightAuto];
        [self.bnSwitch setImage:[UIImage imageNamed:@"icon_voice"] forState:UIControlStateNormal];
    }
    
    self.bnVoice.hidden = !isShow;
    self.myInputTextView.hidden = isShow;
}

- (void)showMoreInputView:(BOOL)isShow
{
    if (isShow) {
        [self showCustomInputView];
    } else {
        [self showKeyboard];
    }
}

#pragma mark - action

- (IBAction)onSwitch:(id)sender
{
    [self showVoiceButton:self.bnVoice.hidden];
    
    if (self.bnVoice.hidden) {
        [self showKeyboard];
    } else {
        [self hideKeyboardOrCustomInputViewIfNeeded];
    }
}

- (IBAction)onMore:(id)sender
{
    [self showVoiceButton:NO];
    [self showMoreInputView:!self.isShowCustomInputView];
}

@end
