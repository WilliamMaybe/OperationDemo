//
//  TestBaseViewController.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 money. All rights reserved.
//

#import "TestBaseViewController.h"

@interface TestBaseViewController ()

@end

@implementation TestBaseViewController

- (NSArray *)imageURLStringArray
{
    if (!_imageURLStringArray)
    {
        _imageURLStringArray = @[@"http://pic15.nipic.com/20110630/6322714_105943746342_2.jpg",
                                 @"http://pic.58pic.com/10/20/29/99bOOOPIC77.jpg",
                                 @"http://pic3.nipic.com/20090528/2488154_232626056_2.jpg"];
    }
    return _imageURLStringArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ImageCellID"];
    
    [ImageManager shareInstance].manually = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.imageURLStringArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCellID" forIndexPath:indexPath];
    
    cell.imageURLString = self.imageURLStringArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

@end
