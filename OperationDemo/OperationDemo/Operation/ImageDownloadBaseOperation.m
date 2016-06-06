//
//  ImageDownloadBaseOperation.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "ImageDownloadBaseOperation.h"

@interface ImageDownloadBaseOperation ()

@end

@implementation ImageDownloadBaseOperation

@synthesize executingA = _executingA;
@synthesize finishedA  = _finishedA;

@synthesize executing = _executing;
@synthesize finished = _finished;

- (void)setExecutingA:(BOOL)executingA
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executingA;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecutingA
{
    return _executing;
}

- (void)setFinishedA:(BOOL)finishedA
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finishedA;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isFinished
{
    return _finished;
}

- (instancetype)initWithImageURL:(NSString *)imageURL completion:(ImageDownloadCompletedBlock)completedBlock
{
    return [self initWithImageURL:imageURL options:ImageDownloadOperationOptionDefault completion:completedBlock];
}

- (instancetype)initWithImageURL:(NSString *)imageURL options:(ImageDownloadOperationOption)options completion:(ImageDownloadCompletedBlock)completedBlock
{
    if (self = [super init])
    {
        _imageURL = [NSURL URLWithString:[imageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        _completedBlock = [completedBlock copy];
        _options = options;
    }
    return self;
}

- (void)reset
{
    _completedBlock = nil;
}

@end
