//
//  ImageTableViewCell.h
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell

/**
 *  使用set后自动下载使用NSOperationQueue图片
 */
@property (nonatomic, strong) NSString *imageURLString;

- (void)startLoading;
- (void)downloadImageCompleted:(UIImage *)image;
- (void)downloadImageFailed:(NSError *)error;

@end
