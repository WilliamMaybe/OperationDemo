//
//  ImageManager.h
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDownloadOperation.h"

typedef NS_ENUM(NSUInteger, ImageDownloadOperationOption) {
    ImageDownloadOperationOptionDefault      = 0,
    ImageDownloadOperationOptionIgnoreCached = 1 << 0,
};

@interface ImageManager : NSOperation

+ (instancetype)shareInstance;

- (ImageDownloadOperation *)downloadImageWithURLString:(NSString *)urlString completed:(ImageDownloadCompletedBlock)completedBlock;
- (ImageDownloadOperation *)downloadImageWithURLString:(NSString *)urlString options:(ImageDownloadOperationOption)options completed:(ImageDownloadCompletedBlock)completedBlock;

@property (nonatomic, assign) NSInteger maxConcurrentDownloads;

/// default is NO
@property (nonatomic, assign) BOOL manually;

@end
