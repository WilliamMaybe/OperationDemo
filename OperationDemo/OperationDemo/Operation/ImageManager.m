
//  ImageManager.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "ImageManager.h"

NSUInteger CahceCostForImage(UIImage *image)
{
    return image.size.width * image.size.height * image.scale * image.scale;
}

@interface ImageManager ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSCache *imageCache;

@end

@implementation ImageManager

+ (instancetype)shareInstance
{
    static ImageManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue)
    {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (NSCache *)imageCache
{
    if (!_imageCache)
    {
        _imageCache = [[NSCache alloc] init];
    }
    return _imageCache;
}

- (NSInteger)maxConcurrentDownloads
{
    return self.operationQueue.maxConcurrentOperationCount;
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads
{
    self.operationQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

#pragma mark - API Method
- (ImageDownloadOperation *)downloadImageWithURLString:(NSString *)urlString completed:(ImageDownloadCompletedBlock)completedBlock
{
    return [self downloadImageWithURLString:urlString options:ImageDownloadOperationOptionDefault completed:completedBlock];
}

- (ImageDownloadOperation *)downloadImageWithURLString:(NSString *)urlString options:(ImageDownloadOperationOption)options completed:(ImageDownloadCompletedBlock)completedBlock
{
    UIImage *image = [self.imageCache objectForKey:urlString];
    if (options & ImageDownloadOperationOptionIgnoreCached)
    {
        image = nil;
    }
    
    if (image)
    {
        !completedBlock ?: completedBlock(image, nil);
        ImageDownloadOperation *operation = [ImageDownloadOperation new];
        return operation;
    }
    
    ImageDownloadOperation *operation = [[ImageDownloadOperation alloc] initWithImageURL:urlString completion:^(UIImage *image, NSError *error) {
        if (image)
        {
            [self.imageCache setObject:image forKey:urlString cost:CahceCostForImage(image)];
        }
        
        !completedBlock ?: completedBlock(image, error);
    }];
    
    if (!self.manually)
    {
        [self.operationQueue addOperation:operation];
    }
    
    return operation;
}

@end
