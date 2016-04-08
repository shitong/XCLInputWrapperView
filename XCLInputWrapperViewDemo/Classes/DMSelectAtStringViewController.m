//
//  DMSelectAtStringViewController.m
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "DMSelectAtStringViewController.h"

@interface DMSelectAtStringViewController ()

@property (nonatomic, weak) id<DMSelectAtStringViewControllerDelegate> delegate;

@end

@implementation DMSelectAtStringViewController

- (instancetype)initWithDelegate:(id<DMSelectAtStringViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"select @";
    
    self.items = [NSMutableArray array];
    [self.items addObject:@"David"];
    [self.items addObject:@"John"];
    [self.items addObject:@"Peter"];
    [self.items addObject:@"David"];
}

- (void)onDismess
{
    [self.delegate cancelClickedWithselectAtStringViewController:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectAtStringViewController:self didSelectString:self.items[indexPath.row]];
}

@end
