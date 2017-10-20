//
//  SoundCell.h
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/19.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoundRecordModel;

@protocol SoundCellDelegate <NSObject>

- (void)selectPlayBtn:(SoundRecordModel *)recordModel;
- (void)selectDelBtn:(SoundRecordModel *)recordModel;

@end

@interface SoundCell : UITableViewCell<SoundCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

- (IBAction)playBtn:(id)sender;
- (IBAction)delBtn:(id)sender;

@property (nonatomic, weak) id<SoundCellDelegate>delegate;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) SoundRecordModel *recordModel;

@end
