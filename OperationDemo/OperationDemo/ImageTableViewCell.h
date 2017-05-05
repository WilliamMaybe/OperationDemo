//
//  ImageTableViewCell.h
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 money. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell

/**
 *  使用set后自动下载使用NSOperationQueue图片
 */
@property (nonatomic, strong) NSString *imageURLString;
- (void)setImageURLString:(NSString *)imageURLString ignoreCache:(BOOL)ignoreCache;

@property (nonatomic, assign) BOOL showIgnoreCache;
@property (nonatomic, copy) void (^ignoreCacheBlock)(ImageTableViewCell *cell, BOOL ignore);

- (void)startLoading;
- (void)downloadImageCompleted:(UIImage *)image;
- (void)downloadImageFailed:(NSError *)error;

@end
