//
//  ImageDownloadOperation.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "ImageDownloadOperation.h"

@interface ImageDownloadOperation () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSMutableData *imageData;

@end

@implementation ImageDownloadOperation

- (instancetype)initWithImageURL:(NSString *)imageURL completion:(ImageDownloadCompletedBlock)completedBlock
{
    if (self = [super initWithImageURL:imageURL completion:completedBlock])
    {
        self.request = [[NSURLRequest alloc] initWithURL:self.imageURL];
    }
    return self;
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (void)start
{
    if (self.isCancelled)
    {
        self.finishedA = YES;
        [self reset];
        return;
    }
    
    self.executingA = YES;
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    CFRunLoopRun();
}

#pragma mark - NSURLConnection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.imageData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    CFRunLoopStop(CFRunLoopGetCurrent());
    UIImage *image = [UIImage imageWithData:self.imageData];
    !self.completedBlock ?: self.completedBlock(image, nil);
    self.finishedA = YES;
    self.executingA = NO;
    [self reset];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    CFRunLoopStop(CFRunLoopGetCurrent());
    !self.completedBlock ?: self.completedBlock(nil, error);
    self.finishedA = YES;
    self.executingA = NO;
    [self reset];
}

@end
