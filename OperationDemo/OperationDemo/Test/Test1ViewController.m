//
//  Test1ViewController.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/6.
//  Copyright © 2016年 money. All rights reserved.
//

#import "Test1ViewController.h"
#import "ImageDownloadBaseOperation.h"

@interface ImageDownloadNonConcurrentOperation : ImageDownloadBaseOperation
@end

@implementation ImageDownloadNonConcurrentOperation

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

@interface Test1ViewController ()

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation Test1ViewController

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
    
    ImageDownloadNonConcurrentOperation *operation = [[ImageDownloadNonConcurrentOperation alloc] initWithImageURL:self.imageURLStringArray[ROW] completion:^(UIImage *image, NSError *error) {
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
