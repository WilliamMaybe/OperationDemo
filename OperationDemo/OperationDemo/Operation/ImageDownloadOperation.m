//
//  ImageDownloadOperation.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 money. All rights reserved.
//

#import "ImageDownloadOperation.h"

@interface ImageDownloadOperation () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSMutableData *imageData;

@end

@implementation ImageDownloadOperation

- (instancetype)initWithImageURL:(NSString *)imageURL options:(ImageDownloadOperationOption)options completion:(ImageDownloadCompletedBlock)completedBlock
{
    if (self = [super initWithImageURL:imageURL options:options completion:completedBlock])
    {
        self.request = [[NSURLRequest alloc] initWithURL:self.imageURL cachePolicy:(self.options & ImageDownloadOperationOptionIgnoreCached ? NSURLRequestReloadIgnoringCacheData : NSURLRequestUseProtocolCachePolicy) timeoutInterval:60];
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
//    SESSION_LOG(@"%@", NSStringFromSelector(_cmd));
    self.imageData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    SESSION_LOG(@"<connection: %p> : %@", connection, @"didReceiveData");
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    SESSION_LOG(@"<connection: %p> : %@", connection, @"didFinishLoading");
    CFRunLoopStop(CFRunLoopGetCurrent());
    UIImage *image = [UIImage imageWithData:self.imageData];
    !self.completedBlock ?: self.completedBlock(image, nil);
    self.finishedA = YES;
    self.executingA = NO;
    [self reset];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    SESSION_LOG(@"<connection: %p> : %@", connection, @"didFail");
    CFRunLoopStop(CFRunLoopGetCurrent());
    !self.completedBlock ?: self.completedBlock(nil, error);
    self.finishedA = YES;
    self.executingA = NO;
    [self reset];
}

@end
