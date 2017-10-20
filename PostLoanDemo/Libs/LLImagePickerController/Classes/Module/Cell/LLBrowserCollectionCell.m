//
//  LLBrowserCollectionCell.m
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/17.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLBrowserCollectionCell.h"
#import "LLBrowserScrollView.h"
#import "Config.h"
#import "PHImageModel.h"


@interface LLBrowserCollectionCell ()

@property (nonatomic, strong) LLBrowserScrollView *scrollView;
@property (nonatomic, strong) ALAsset *alAsset;
@property (nonatomic, strong) PHAsset *phAsset;

@end

@implementation LLBrowserCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[LLBrowserScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self addSubview:_scrollView];
        
        _scrollView.zoomScale = 1.f;
        _scrollView.contentSize = _scrollView.size;
    
    }
    return self;
}

- (void)handleSingleTapActionWithBlock:(dispatch_block_t)block {
    [_scrollView handleSingleTapActionWithBlock:block];
}

- (void)reloadDataWithALAsset:(ALAsset *)asset {
    self.alAsset = asset;
    _scrollView.image = [asset fullScreenImage];
}

- (void)reloadDataWithPHAsset:(PHAsset *)asset {
    self.phAsset = asset;
    _scrollView.zoomScale = 1.f;
    _scrollView.contentSize = _scrollView.size;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [asset requestImageForTargetSize:[UIScreen mainScreen].bounds.size resultHandler:^(UIImage *result, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _scrollView.image = result;
            });
        }];
    });
}

- (void)reloadDataWithMoviePHAsset:(PHAsset *)asset resultHandler:(void(^)(PHImageModel *model,PHAsset *phAsset))resultHandler{
    self.phAsset = asset;
    _scrollView.zoomScale = 1.f;
    _scrollView.contentSize = _scrollView.size;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
//        [asset requestImageForTargetSize:[UIScreen mainScreen].bounds.size resultHandler:^(UIImage *result, NSDictionary *info) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                _scrollView.image = result;
//            });
//        }];
//
        [asset requestMovieImageForTargetSize:[UIScreen mainScreen].bounds.size resultHandler:^(UIImage *result, NSDictionary *info, PHAsset *phAsset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"result = %@ ,phAsset = %@ , info =   %@",result,phAsset,info);
                
                 _scrollView.image = result;

                PHImageModel *model = [[PHImageModel alloc] init];
                model.imageName = [[[info objectForKey:@"PHImageFileSandboxExtensionTokenKey"] componentsSeparatedByString:@";"] lastObject].lastPathComponent;
                NSString *url = [[[info objectForKey:@"PHImageFileSandboxExtensionTokenKey"] componentsSeparatedByString:@";"] lastObject];
                
                url = [@"file://" stringByAppendingString:url];
                NSURL *videoURL = [NSURL URLWithString:url];
                model.url = videoURL;
                model.isImage = NO;
                model.phasset = phAsset;
                NSLog(@"model = %@",model);
                
                Block_exe(resultHandler,model,asset);
                
            });
        }];
        
    });
}


@end
