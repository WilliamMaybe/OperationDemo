//
//  Test6ViewController.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 money. All rights reserved.
//

#import "Test6ViewController.h"
#import "ImageSessionManager.h"

#define ROW indexPath.row

@interface Test6ViewController ()

@property (nonatomic, strong) ImageSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableArray *ignoreCacheArray;

@end

@implementation Test6ViewController

- (ImageSessionManager *)sessionManager
{
    if (!_sessionManager)
    {
        _sessionManager = [[ImageSessionManager alloc] init];
    }
    return _sessionManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ignoreCacheArray = [NSMutableArray array];
    [self.imageURLStringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.ignoreCacheArray addObject:@YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.tableView action:@selector(reloadData)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCellID" forIndexPath:indexPath];
    
    cell.showIgnoreCache = YES;
    
    __weak typeof(self) weakSelf = self;
    [cell setIgnoreCacheBlock:^(ImageTableViewCell *tableViewCell, BOOL ignore) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSIndexPath *cellIndexPath = [strongSelf.tableView indexPathForCell:tableViewCell];
        strongSelf.ignoreCacheArray[cellIndexPath.row] = @(ignore);
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageTableViewCell *aCell = (ImageTableViewCell *)cell;
    [aCell startLoading];
    
    [[self.sessionManager downloadImageWithURLString:self.imageURLStringArray[ROW] ignoreCached:[self.ignoreCacheArray[ROW] boolValue] completed:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                [aCell downloadImageFailed:error];
            }
            else
            {
                [aCell downloadImageCompleted:image];
            }
        });
        
    }] resume];

}

@end
