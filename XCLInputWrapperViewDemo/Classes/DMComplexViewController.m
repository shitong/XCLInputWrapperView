//
//  DMComplexViewController.m
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "DMComplexViewController.h"
#import "DMSelectAtStringViewController.h"
#import "DMComplexInputWrapperView.h"

@interface DMComplexViewController () <XCLInputWrapperViewDelegate, DMSelectAtStringViewControllerDelegate>

@property (nonatomic, strong) DMComplexInputWrapperView *inputWrapperView;

@end

@implementation DMComplexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Complex";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"@Stone" style:UIBarButtonItemStylePlain target:self action:@selector(onAt)];
    self.navigationItem.rightBarButtonItem = item;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.items = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 3; i++) {
        [self.items addObject:[NSString stringWithFormat:@"%@", @(i)]];
    }
    
    self.inputWrapperView = [DMComplexInputWrapperView inputWrapperViewWithSuperview:self.view];
    self.inputWrapperView.delegate = self;
    self.inputWrapperView.cancelBackdropView = self.tableView;
    self.inputWrapperView.cancelOnDragScrollView = self.tableView;
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = self.inputWrapperView.bounds.size.height;
    self.tableView.contentInset = contentInset;
    self.tableView.scrollIndicatorInsets = contentInset;
}

- (void)onAt
{
    [self.inputWrapperView inputAtString:@"@Stone"];
    [self.inputWrapperView showKeyboard];
}



#pragma mark - XCLInputWrapperViewDelegate

- (void)inputWrapperView:(XCLInputWrapperView *)inputWrapperView heightDidChanged:(CGFloat)height
{
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, height, 0);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.items.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)inputWrapperView:(XCLInputWrapperView *)inputWrapperView submitWithText:(NSString *)text
{
    [self.items addObject:text];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.items.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.items.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)atInputtedWithinputWrapperView:(XCLInputWrapperView *)inputWrapperView
{
    DMSelectAtStringViewController *controller = [[DMSelectAtStringViewController alloc] initWithDelegate:self];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)inputWrapperViewDidShowKeyboard:(XCLInputWrapperView *)inputWrapperView
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)inputWrapperViewDidShowInputView:(XCLInputWrapperView *)inputWrapperView
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)inputWrapperViewDidHideKeyboard:(XCLInputWrapperView *)inputWrapperView
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)inputWrapperViewDidHideInputView:(XCLInputWrapperView *)inputWrapperView
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - DMSelectAtStringViewControllerDelegate

- (void)selectAtStringViewController:(DMSelectAtStringViewController *)selectAtStringViewController didSelectString:(NSString *)string
{
    [selectAtStringViewController dismissViewControllerAnimated:YES completion:nil];
    [self.inputWrapperView inputAtString:string];
    [self.inputWrapperView showKeyboard];
}

- (void)cancelClickedWithselectAtStringViewController:(DMSelectAtStringViewController *)selectAtStringViewController
{
    [selectAtStringViewController dismissViewControllerAnimated:YES completion:nil];
    [self.inputWrapperView showKeyboard];
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        DMTableViewController *controller = [[[self class] alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        DMTableViewController *controller = [[[self class] alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
