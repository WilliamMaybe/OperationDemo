//
//  Test5ViewController.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "Test5ViewController.h"

@interface Test5ViewController ()

@property (nonatomic, strong) NSMutableArray *ignoreCacheArray;

@end

@implementation Test5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ImageManager shareInstance] setMaxConcurrentDownloads:1];
    
    self.ignoreCacheArray = [NSMutableArray array];
    [self.imageURLStringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.ignoreCacheArray addObject:@YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.tableView action:@selector(reloadData)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCellID" forIndexPath:indexPath];
    
    cell.showIgnoreCache = YES;
    
    [cell setImageURLString:self.imageURLStringArray[indexPath.row] ignoreCache:[self.ignoreCacheArray[indexPath.row] boolValue]];
    
    __weak typeof(self) weakSelf = self;
    [cell setIgnoreCacheBlock:^(ImageTableViewCell *tableViewCell, BOOL ignore) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSIndexPath *cellIndexPath = [strongSelf.tableView indexPathForCell:tableViewCell];
        strongSelf.ignoreCacheArray[cellIndexPath.row] = @(ignore);
    }];
    
    return cell;
}

@end
