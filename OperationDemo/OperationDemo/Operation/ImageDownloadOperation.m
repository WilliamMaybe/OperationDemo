//
//  ImageDownloadOperation.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "ImageDownloadOperation.h"

@interface ImageDownloadOperation ()

@end

@implementation ImageDownloadOperation

/**
 *  如果start和main方法都实现了，就不执行main了
 *
 *  以start优先
 */
// 并发 concurrent
//- (void)start
//{
//    if (self.isCancelled)
//    {
//        self.finished = YES;
//        return;
//    }
//    
//    NSLog(@"NSThread:%@  [%@ start]", [NSThread currentThread], self.name);
//    
//
//    self.finished = YES;
//}

// 非并发 non-concurrent
- (void)main
{
    // 不是很明白为什么要使用释放池
    @autoreleasepool {
        if (self.isCancelled)
        {
            [self reset];
            self.finishedA = YES;
            return;
        };
        NSLog(@"[%@ main]", self.imageURL);
        NSError *error = nil;
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL options:NSDataReadingMappedIfSafe error:&error];
        
        if (error)
        {
            !self.completedBlock ?: self.completedBlock(nil, error);
            self.completedBlock = nil;
            self.finishedA = YES;
            return;
        }
        
        if (imageData)
        {
            UIImage *image = [UIImage imageWithData:imageData];
            !self.completedBlock ?: self.completedBlock(image, nil);
            self.completedBlock = nil;
            self.finishedA = YES;
        }
    }
}

@end
