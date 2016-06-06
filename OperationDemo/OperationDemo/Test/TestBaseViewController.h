//
//  TestBaseViewController.h
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloadBaseOperation.h"
#import "ImageTableViewCell.h"
#import "ImageManager.h"

@interface TestBaseViewController : UITableViewController

@property (nonatomic, strong) NSArray *imageURLStringArray;

@end
