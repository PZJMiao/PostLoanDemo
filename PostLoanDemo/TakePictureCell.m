//
//  TakePictureCell.m
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/9.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import "TakePictureCell.h"

#import "PHImageModel.h"

@implementation TakePictureCell
- (void)delPhotoOrVideoMethod:(PHImageModel *)model{}

- (void)setModel:(PHImageModel *)model
{
    _model = model;
    self.pictureImg.image = _model.image;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)closeBtn:(id)sender {
    NSLog(@"close --- ");
    
    if ([self.delegate respondsToSelector:@selector(delPhotoOrVideoMethod:)]) {
        [self.delegate delPhotoOrVideoMethod:self.model];
    }
}
@end
