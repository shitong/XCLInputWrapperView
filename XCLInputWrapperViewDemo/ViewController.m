//
//  ViewController.m
//  XCLInputWrapperViewDemo
//
//  Created by stone on 16/4/8.
//  Copyright © 2016年 stone. All rights reserved.
//

#import "ViewController.h"
#import "DMSimpleViewController.h"
#import "DMComplexViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DMSimpleViewController *controller = [[DMSimpleViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        } else if (indexPath.row == 1) {
            DMComplexViewController *controller = [[DMComplexViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
