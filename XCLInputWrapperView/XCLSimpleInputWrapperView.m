//
//  XCLSimpleInputWrapperView.m
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "XCLSimpleInputWrapperView.h"
#import "XCLInputWrapperViewSubclass.h"

@interface XCLSimpleInputWrapperView () <XCLInputWrapperViewInterface>

@property (nonatomic, strong) UIView *simpleInputBarView;

@end

@implementation XCLSimpleInputWrapperView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _simpleInputBarView                 = [[UIView alloc] init];
        _simpleInputBarView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - XCLInputWrapperViewInterface

- (UIView *)inputBarView
{
    return self.simpleInputBarView;
}

- (UITextView *)inputTextView
{
    UITextView *inputTextView = [[UITextView alloc] init];
    inputTextView.backgroundColor = [UIColor whiteColor];
    inputTextView.layer.cornerRadius = 5;
    inputTextView.layer.borderWidth = 0.5;
    inputTextView.layer.borderColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1].CGColor;
    inputTextView.backgroundColor = [UIColor clearColor];
    inputTextView.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
    inputTextView.font = [UIFont systemFontOfSize:16];
    inputTextView.returnKeyType = UIReturnKeySend;
    
    UIEdgeInsets insets = inputTextView.textContainerInset;
    insets.left = 8;
    insets.right = 8;
    [inputTextView setTextContainerInset:insets];
    [inputTextView setContentInset:UIEdgeInsetsZero];
    
    
    
    inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.simpleInputBarView addSubview:inputTextView];
    
    UIEdgeInsets textViewEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
    
    [inputTextView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:inputTextView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:inputTextView.superview
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:textViewEdgeInsets.top]];
    
    [inputTextView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:inputTextView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:inputTextView.superview
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                   constant:-textViewEdgeInsets.bottom]];
    
    [inputTextView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:inputTextView
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:inputTextView.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:textViewEdgeInsets.left]];
    
    [inputTextView.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:inputTextView
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:inputTextView.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:-textViewEdgeInsets.right]];
    
    return inputTextView;
}

- (void)customConfig
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self.simpleInputBarView addSubview:line];
    
    [line.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:line
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:0.5]];
    [line.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:line
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:line.superview
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                   constant:0]];
    [line.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:line
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:line.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1.0f
                                   constant:0]];
    [line.superview addConstraint:
     [NSLayoutConstraint constraintWithItem:line
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:line.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                   constant:0]];
}

@end
