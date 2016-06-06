//
//  ImageTableViewCell.m
//  OperationDemo
//
//  Created by zhangyi on 16/6/4.
//  Copyright © 2016年 Hikvision. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "ImageManager.h"

@interface ImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *failedLabel;

@property (weak, nonatomic) IBOutlet UILabel *ignoreCacheLabel;
@property (weak, nonatomic) IBOutlet UISwitch *ignoreCacheSwitch;

@end

@implementation ImageTableViewCell

- (void)setImageURLString:(NSString *)imageURLString
{
    [self setImageURLString:imageURLString ignoreCache:NO];
}

- (void)setImageURLString:(NSString *)imageURLString ignoreCache:(BOOL)ignoreCache
{
    _imageURLString = imageURLString;
    [self imageDownloadIfNeedIgnoreCache:ignoreCache];
}

- (void)setShowIgnoreCache:(BOOL)showIgnoreCache
{
    self.ignoreCacheLabel.alpha  = showIgnoreCache;
    self.ignoreCacheSwitch.alpha = showIgnoreCache;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [self randomColor];
}

#pragma mark - API Method
- (void)startLoading
{
    [self.indicatorView startAnimating];
    self.failedLabel.alpha = 0.f;
    self.pictureView.image = nil;
}

- (void)downloadImageCompleted:(UIImage *)image
{
    [self downloadSuccess];
    self.pictureView.image = image;
}

- (void)downloadImageFailed:(NSError *)error
{
    [self downloadFailed:error];
}

#pragma mark - Button Click
- (IBAction)switchValueChanged:(UISwitch *)sender
{
    !self.ignoreCacheBlock ?: self.ignoreCacheBlock(self, sender.isOn);
}

#pragma mark - Private Method
- (void)imageDownloadIfNeedIgnoreCache:(BOOL)ignoreCache
{
    [self startLoading];
    
    ImageDownloadOperationOption option = ImageDownloadOperationOptionDefault;
    
    if (ignoreCache)
    {
        option |= ImageDownloadOperationOptionIgnoreCached;
    }
    
    __weak typeof(self) weakSelf = self;
    [[ImageManager shareInstance] downloadImageWithURLString:self.imageURLString options:option completed:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
            {
                [weakSelf downloadFailed:error];
                return;
            }
            
            weakSelf.pictureView.image = image;
            [weakSelf downloadSuccess];
        });
    }];
}

- (void)downloadFailed:(NSError *)error
{
    self.failedLabel.text = [NSString stringWithFormat:@"Load image failed:%@", error.localizedDescription];
    self.failedLabel.alpha = 1.f;
    [self.indicatorView stopAnimating];
    self.pictureView.image = nil;
}

- (void)downloadSuccess
{
    self.failedLabel.alpha = 0.0;
    [self.indicatorView stopAnimating];
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random() % 255 / 255.0
                           green:arc4random() % 255 / 255.0
                            blue:arc4random() % 255 / 255.0
                           alpha:1.0];
}

@end
