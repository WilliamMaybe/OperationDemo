//
//  Test3ViewController.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "Test3ViewController.h"
#import "ImageDownloadBaseOperation.h"

@interface ImageDownloadNonConcurrentAddingQueueOperation : ImageDownloadBaseOperation
@end

@implementation ImageDownloadNonConcurrentAddingQueueOperation

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

#define ROW indexPath.row

@interface Test3ViewController ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation Test3ViewController

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue)
    {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageArray = [NSMutableArray array];
    
    [self.imageURLStringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.imageArray addObject:[NSNull null]];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCellID" forIndexPath:indexPath];
    
    [cell startLoading];
    
    if (![self.imageArray[ROW] isKindOfClass:[NSNull class]])
    {
        [cell downloadImageCompleted:self.imageArray[ROW]];
        return cell;
    }
    
    ImageDownloadNonConcurrentAddingQueueOperation *operation = [[ImageDownloadNonConcurrentAddingQueueOperation alloc] initWithImageURL:self.imageURLStringArray[ROW] completion:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                [cell downloadImageFailed:error];
            }
            else
            {
                self.imageArray[ROW] = image;
                [cell downloadImageCompleted:image];
            }
        });
    }];
    
    [self.operationQueue addOperation:operation];
    
    return cell;
}

@end
