//
//  AddSoundCell.m
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/19.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import "AddSoundCell.h"

@implementation AddSoundCell

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    self.titleLabel.text = _isSelect==YES?@"停止":@"添加音频";
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
