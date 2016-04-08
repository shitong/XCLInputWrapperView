//
//  DMTableViewController.m
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "DMTableViewController.h"

@interface DMTableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.items = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 15; i++) {
        [self.items addObject:[NSString stringWithFormat:@"%@", @(i)]];
    }
    
    if ([self isNeedCloseButtonItem]) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onDismess)];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)onDismess
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isNeedCloseButtonItem
{
    if (self.navigationController.viewControllers.count < 2 || self.navigationController.visibleViewController == [self.navigationController.viewControllers objectAtIndex:0]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * showUserInfoCellIdentifier = @"DMTableViewControllerCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:showUserInfoCellIdentifier];
    }
    
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

@end
