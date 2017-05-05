//
//  ImageDownloadBaseOperation.h
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 money. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageDownloadOperationOption) {
    ImageDownloadOperationOptionDefault      = 0,
    ImageDownloadOperationOptionIgnoreCached = 1 << 0,
};

typedef void(^ImageDownloadCompletedBlock)(UIImage *image, NSError *error);

@interface ImageDownloadBaseOperation : NSOperation

@property (assign, nonatomic, getter=isExecutingA) BOOL executingA;
@property (assign, nonatomic, getter=isFinishedA) BOOL finishedA;

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, copy) ImageDownloadCompletedBlock completedBlock;

@property (nonatomic, assign) ImageDownloadOperationOption options;

- (instancetype)initWithImageURL:(NSString *)imageURL completion:(ImageDownloadCompletedBlock)completedBlock;
- (instancetype)initWithImageURL:(NSString *)imageURL options:(ImageDownloadOperationOption)options completion:(ImageDownloadCompletedBlock)completedBlock;

- (void)reset;

@end
