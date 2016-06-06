
//
//  Test2ViewController.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "Test2ViewController.h"

#define ROW indexPath.row

@interface ImageDownloadConcurrentOperation : ImageDownloadBaseOperation
@end

@implementation ImageDownloadConcurrentOperation

- (void)start
{
    if (self.isCancelled)
    {
        [self reset];
        self.finishedA = YES;
        return;
    }
    
    NSLog(@"[%@ start]", self.imageURL);
    NSError *error = nil;
    self.executingA = YES;
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL options:NSDataReadingMappedIfSafe error:&error];
    
    if (error)
    {
        !self.completedBlock ?: self.completedBlock(nil, error);
        self.completedBlock = nil;
        self.finishedA = YES;
        self.executingA = NO;
        return;
    }
    
    if (imageData)
    {
        UIImage *image = [UIImage imageWithData:imageData];
        !self.completedBlock ?: self.completedBlock(image, nil);
        self.completedBlock = nil;
        self.finishedA = YES;
        self.executingA = NO;
    }
}

- (BOOL)isAsynchronous
{
    return YES;
}

@end

@interface Test2ViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation Test2ViewController

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
    
    ImageDownloadConcurrentOperation *operation = [[ImageDownloadConcurrentOperation alloc] initWithImageURL:self.imageURLStringArray[ROW] completion:^(UIImage *image, NSError *error) {
        if (error)
        {
            [cell downloadImageFailed:error];
        }
        else
        {
            self.imageArray[ROW] = image;
            [cell downloadImageCompleted:image];
        }
    }];
    
    [operation start];
    
    return cell;
}

@end
