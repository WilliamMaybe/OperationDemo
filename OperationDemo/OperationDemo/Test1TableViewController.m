//
//  Test1TableViewController.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "Test1TableViewController.h"

@interface Test1TableViewController ()

@end

@implementation Test1TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ImageManager shareInstance].manually = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCellID" forIndexPath:indexPath];
    
    [cell startLoading];
    
    ImageDownloadOperation *operation = [[ImageManager shareInstance] downloadImageWithURLString:self.imageURLStringArray[indexPath.row] completed:^(UIImage *image, NSError *error) {
        
        if (error)
        {
            [cell downloadImageFailed:error];
        }
        else
        {
            [cell downloadImageCompleted:image];
        }
        
    }];
    
    [operation start];
    
    return cell;
}

@end
