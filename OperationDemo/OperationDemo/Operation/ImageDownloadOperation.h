//
//  ImageDownloadOperation.h
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "ImageDownloadBaseOperation.h"

typedef void(^ImageDownloadCompletedBlock)(UIImage *image, NSError *error);

@interface ImageDownloadOperation : ImageDownloadBaseOperation

@end
