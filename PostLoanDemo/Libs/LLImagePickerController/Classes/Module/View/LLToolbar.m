//
//  LLToolbar.m
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/22.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLToolbar.h"
#import "Utils.h"
#import "UIView+LLAdd.h"
#import "ConstDefine.h"
#import "FunctionDefines.h"
#import "iPhoneVersion.h"

@interface LLToolbar ()

@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *finishedButton;
@property (nonatomic, strong) UILabel *selectNumberLabel;
@property (nonatomic, copy) LLToolbarBlock previewBlock;
@property (nonatomic, copy) LLToolbarBlock finishedBlock;

@end

@implementation LLToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.barStyle = UIBarStyleDefault;
        
        CGFloat width = 70;
        CGFloat height = frame.size.height;
        
        self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewButton.frame = CGRectMake(0, 0, width, height);
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        
        self.finishedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishedButton.frame = CGRectMake(0, 0, width, height);
        _finishedButton.right = kScreenWidth;
        [_finishedButton setTitle:@"完成" forState:UIControlStateNormal];
        
        self.selectNumberLabel = [Utils building:1 textColor:HEXCOLOR(0xffffff) textAligment:1 font:BoldFont(15) superview:self];
        _selectNumberLabel.size = CGSizeMake(25, 25);
        _selectNumberLabel.centerY = _finishedButton.centerY;
        _selectNumberLabel.right = _finishedButton.left + 10;
        _selectNumberLabel.backgroundColor = HEXCOLOR(0x09c106);
        _selectNumberLabel.layer.cornerRadius = _selectNumberLabel.width / 2;
        _selectNumberLabel.clipsToBounds = YES;
        _selectNumberLabel.userInteractionEnabled = YES;
        
        /*
         * iOS11后toolBar有问题，解决方法有：
         * 1、如下代码根据系统不同的加载方式
         * 2、或者直接加载2的方法，但是都需要加上[self layoutIfNeeded]; 这句
         */
        
        //1、
        if (iOS11Upwards) {

            UIBarButtonItem *previewItem = [[UIBarButtonItem alloc] initWithCustomView:_previewButton];
            UIBarButtonItem *selectNumberLabelItem = [[UIBarButtonItem alloc] initWithCustomView:_selectNumberLabel];

            UIBarButtonItem *finishedItem = [[UIBarButtonItem alloc] initWithCustomView:_finishedButton];
            NSArray *items = @[previewItem,selectNumberLabelItem,finishedItem];
            [self setItems:items];

        }else{
            [self addSubview:self.selectNumberLabel];
            [self addSubview:self.previewButton];
            [self addSubview:self.finishedButton];
        }
        
//        //2、
//        [self addSubview:self.selectNumberLabel];
//        [self addSubview:self.previewButton];
//        [self addSubview:self.finishedButton];
        
        //add by pzj
        [self layoutIfNeeded];
        
        [self resetPreviewButtonEnable:NO];
        [self resetFinishedButtonEnable:NO];
        [self resetSelectPhotosNumber:0];
        
        [self.previewButton addTarget:self action:@selector(previewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.finishedButton addTarget:self action:@selector(finishedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)previewButtonAction:(UIButton *)sender {
    Block_exe(self.previewBlock);
}

- (void)finishedButtonAction:(UIButton *)sender {
    Block_exe(self.finishedBlock);
}

- (void)handlePreviewButtonWithBlock:(LLToolbarBlock)block {
    self.previewBlock = block;
}

- (void)handleFinishedButtonWithBlock:(LLToolbarBlock)block {
    self.finishedBlock = block;
}

- (void)resetPreviewButtonEnable:(BOOL)enable {
    self.previewButton.enabled = enable;
    if (enable) {
        [_previewButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    } else {
        [_previewButton setTitleColor:HEXCOLOR(0xb1b1b1) forState:UIControlStateNormal];
    }
}

- (void)resetFinishedButtonEnable:(BOOL)enable {
    self.finishedButton.enabled = enable;
    if (enable) {
        [_finishedButton setTitleColor:HEXCOLOR(0x09c106) forState:UIControlStateNormal];
    } else {
        [_finishedButton setTitleColor:HEXCOLOR(0xb2e0b4) forState:UIControlStateNormal];
    }
}

- (void)resetSelectPhotosNumber:(NSInteger)number {
    if (number == 0) {
        self.selectNumberLabel.hidden = YES;
    } else {
        self.selectNumberLabel.hidden = NO;
        self.selectNumberLabel.text = Format(@"%zd", number);
        
        self.selectNumberLabel.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:3.f initialSpringVelocity:8.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.selectNumberLabel.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hiddenPreviewButton {
    self.previewButton.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
