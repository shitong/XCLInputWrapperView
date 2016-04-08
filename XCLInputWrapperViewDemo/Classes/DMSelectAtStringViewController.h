//
//  DMSelectAtStringViewController.h
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "DMTableViewController.h"

@class DMSelectAtStringViewController;

@protocol DMSelectAtStringViewControllerDelegate <NSObject>

- (void)selectAtStringViewController:(DMSelectAtStringViewController *)selectAtStringViewController didSelectString:(NSString *)string;
- (void)cancelClickedWithselectAtStringViewController:(DMSelectAtStringViewController *)selectAtStringViewController;

@end

@interface DMSelectAtStringViewController : DMTableViewController

- (instancetype)initWithDelegate:(id<DMSelectAtStringViewControllerDelegate>)delegate;

@end
