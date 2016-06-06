//
//  ViewController.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/3.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "ViewController.h"

static NSString *tableViewIdentifier = @"tableViewIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *testArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Operation Demo";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
    
    self.testArray = @[@"非并发Operation 手动启动，不加在queue中",
                       @"并发Operation 手动启动，不加在queue中",
                       @"非并发Operation 加在queue",
                       @"并发Operation 加在queue",
                       @"NSURLConnection+Queue"];
}


#pragma mark - UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.testArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    
    cell.textLabel.text = self.testArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = [NSString stringWithFormat:@"Test%@ViewController", @(indexPath.row + 1)];
    
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    viewController.title = self.testArray[indexPath.row];
    
    if (!viewController) return;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
