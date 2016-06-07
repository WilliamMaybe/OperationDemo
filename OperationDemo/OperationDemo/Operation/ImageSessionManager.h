//
//  ImageSessionManager.h
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSessionManager : NSObject

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration NS_DESIGNATED_INITIALIZER;

- (NSURLSessionDataTask *)downloadImageWithURLString:(NSString *)urlString ignoreCached:(BOOL)ignoreCached completed:(void (^)(UIImage *image, NSError *error))completedBlock;

@end
