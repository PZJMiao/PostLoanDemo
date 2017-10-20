 //
//  TakePictureCell.h
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/9.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHImageModel;

@protocol TakePictureCellDelegate <NSObject>

- (void)delPhotoOrVideoMethod:(PHImageModel *)model;

@end

@interface TakePictureCell : UICollectionViewCell<TakePictureCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImg;
- (IBAction)closeBtn:(id)sender;

@property (nonatomic, weak) id<TakePictureCellDelegate>delegate;
@property (nonatomic, strong) PHImageModel *model;

@end
