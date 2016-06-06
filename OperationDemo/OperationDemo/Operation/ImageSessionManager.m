//
//  ImageSessionManager.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "ImageSessionManager.h"

typedef void(^ImageSessionDownloadCompletedBlock)(UIImage *image, NSError *error);

@interface ImageSessionTaskDelegate : NSObject <NSURLSessionDataDelegate>

@property (nonatomic, copy) ImageSessionDownloadCompletedBlock completedBlock;
@property (nonatomic, strong) NSMutableData *imageData;

@end

@implementation ImageSessionTaskDelegate

- (instancetype)init
{
    if (self = [super init])
    {
        _imageData = [NSMutableData data];
    }
    return self;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data
{
    [self.imageData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    if (!self.completedBlock) { return; }
    
    UIImage *image = [UIImage imageWithData:self.imageData];
    self.completedBlock(image, error);
}

@end

@interface ImageSessionManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSMutableDictionary *taskCompletedDelegatesKeyByTaskIdentifier;

@end

@implementation ImageSessionManager

- (instancetype)init
{
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
{
    if (self = [super init])
    {
        self.taskCompletedDelegatesKeyByTaskIdentifier = [NSMutableDictionary dictionary];
        
        if (!sessionConfiguration)
        {
            sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        
        // 其实queue有没有也无所谓,delegateQueue为nil时session会自动创建一个串行队列
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:self.operationQueue];
    }
    return self;
}

- (NSURLSessionDataTask *)downloadImageWithURLString:(NSString *)urlString completed:(void (^)(UIImage *, NSError *))completedBlock
{
    NSURLSessionDataTask *dataTask;
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    dataTask = [self.session dataTaskWithRequest:request];
    
    ImageSessionTaskDelegate *delegate = [[ImageSessionTaskDelegate alloc] init];
    delegate.completedBlock = completedBlock;
    self.taskCompletedDelegatesKeyByTaskIdentifier[@(dataTask.taskIdentifier)] = delegate;
    
    // 需要自己调用
//    [dataTask resume];
    return dataTask;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    ImageSessionTaskDelegate *delegate = self.taskCompletedDelegatesKeyByTaskIdentifier[@(dataTask.taskIdentifier)];
    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    ImageSessionTaskDelegate *delegate = self.taskCompletedDelegatesKeyByTaskIdentifier[@(task.taskIdentifier)];
    if (delegate)
    {
        [delegate URLSession:session task:task didCompleteWithError:error];
        
        [self.taskCompletedDelegatesKeyByTaskIdentifier removeObjectForKey:@(task.taskIdentifier)];
    }
}

@end
