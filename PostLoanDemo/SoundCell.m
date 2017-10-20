//
//  SoundCell.m
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/19.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import "SoundCell.h"
#import "SoundRecordModel.h"

@implementation SoundCell

- (void)selectPlayBtn:(SoundRecordModel *)recordModel{}
- (void)selectDelBtn:(SoundRecordModel *)recordModel{}

- (void)setIsPlay:(BOOL)isPlay
{
    _isPlay = isPlay;
}

- (void)setRecordModel:(SoundRecordModel *)recordModel
{
    _recordModel = recordModel;
    if (_recordModel == nil) {
        return;
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@  %@s",_recordModel.dateStr,_recordModel.recordTime];
    
    NSString *playStr = recordModel.isSelectPlay==YES?@"停止":@"播放";
     [self.playBtn setTitle:playStr forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectPlayBtn:)]) {
        [self.delegate selectPlayBtn:self.self.recordModel];
    }
}

- (IBAction)delBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectDelBtn:)]) {
        [self.delegate selectDelBtn:self.recordModel];
    }
    
}
@end
