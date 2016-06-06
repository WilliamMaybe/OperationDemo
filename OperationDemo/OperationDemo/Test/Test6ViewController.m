//
//  Test6ViewController.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "Test6ViewController.h"
#import "ImageSessionManager.h"

#define ROW indexPath.row

@interface Test6ViewController ()

@property (nonatomic, strong) ImageSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableArray *imageArray;

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
    self.imageArray = [NSMutableArray array];
    [self.imageURLStringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.imageArray addObject:[NSNull null]];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCellID" forIndexPath:indexPath];
    
    [cell startLoading];
    
    if (![self.imageArray[ROW] isKindOfClass:[NSNull class]])
    {
        [cell downloadImageCompleted:self.imageArray[ROW]];
        return cell;
    }
    
    [[self.sessionManager downloadImageWithURLString:self.imageURLStringArray[ROW] completed:^(UIImage *image, NSError *error) {
        if (error)
        {
            [cell downloadImageFailed:error];
        }
        else
        {
            self.imageArray[ROW] = image;
            [cell downloadImageCompleted:image];
        }
    }] resume];
    
    return cell;
}

@end
