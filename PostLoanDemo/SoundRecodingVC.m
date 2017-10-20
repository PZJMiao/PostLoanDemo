//
//  SoundRecodingVC.m
//  PostLoanDemo
//
//  Created by 彭昭君 on 2017/10/19.
//  Copyright © 2017年 pzj. All rights reserved.
//

#import "SoundRecodingVC.h"
#import <Masonry/Masonry.h>
#import "AddSoundCell.h"
#import "SoundCell.h"
#import <AVFoundation/AVFoundation.h>
#import "SoundRecordModel.h"
#import "FileSizeAtPath.h"

@interface SoundRecodingVC ()<UITableViewDelegate,UITableViewDataSource,SoundCellDelegate>
{
    NSTimer *_timer; //定时器
    NSInteger countDown;  //倒计时
    NSString *filePath;
    NSString *timeAtampStr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic, strong) AVAudioPlayer *player;//播放器
@property (nonatomic, strong) NSURL *recordFileUrl;//文件地址


@end

@implementation SoundRecodingVC
#pragma mark - lifeCycle                    - Method -
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - privateMethods               - Method -
- (void)initView
{
    self.title = @"录音";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.dataArray = [[NSMutableArray alloc] init];
    self.isSelect = NO;
}
//开始录音
- (void)startRecord
{
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    self.session = session;
    
    //当前时间（命名上加上时间，防止被覆盖）
    timeAtampStr = [self getTimeStamp];
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [path stringByAppendingFormat:@"/%@RRecord.wav",timeAtampStr];
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    //设置参数
    NSDictionary *recodSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  //采样率
                                  //8000/11025/22050/44100/96000（影响音频的质量）
                                  [NSNumber numberWithFloat:8000.0],AVSampleRateKey,
                                  //音频格式
                                  [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                  //采样位数 8、16、24、32 默认为16
                                  [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                  //音频通道数 1 或 2
                                  [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                  //录音质量
                                  [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                  nil];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recodSetting error:nil];
    
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self stopRecord];
//        });
    }else{
        NSLog(@"音频格式和文件存储格斯不匹配，无法初始化Recorder");
    }
}

- (void)stopRecord{
    NSLog(@"停止录音");
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSLog(@"录音完成。。。。");
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
        NSLog(@"%li",self.player.data.length/1024);
        
        SoundRecordModel *model = [[SoundRecordModel alloc] init];
        model.filePath = filePath;
        model.filePathUrl = self.recordFileUrl;
        model.dateStampStr = timeAtampStr;
        model.dateStr = [self getStampChangeToDate:timeAtampStr];
        model.recordTime = [NSString stringWithFormat:@"%.1f",self.player.duration];
        model.isSelectPlay = NO;
        
        [self.dataArray addObject:model];
        [self.tableView reloadData];

    }else{
//        _noticeLabel.text = @"最多录60秒";
    }
}

- (void)playRecord:(NSURL *)url
{
    NSLog(@"播放------");
    [self.recorder stop];
    if ([self.player isPlaying])return;
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}
- (void)stopPlayRecord:(NSURL *)url
{
    NSLog(@"暂停");
    [self.recorder stop];
    if ([self.player isPlaying])return;
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player pause];
}

//获取当前时间戳
- (NSString *)getTimeStamp
{
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970];
//    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
//    NSLog(@"111获取当前时间戳 = %@",timeString);
//    return timeString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSLog(@"获取当前时间戳 = %@",timeSp);
    return timeSp;
}
//当前时间
- (NSString *)getCurrentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    NSLog(@"获取当前时间 = %@",currentDateString);
    return currentDateString;
}
//时间戳转时间
- (NSString *)getStampChangeToDate:(NSString *)stamp
{
    NSTimeInterval interval    =[stamp doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSLog(@"服务器返回的时间戳对应的时间是:%@",dateString);
    return dateString;
}
#pragma mark - eventResponse                - Method -

#pragma mark - notification                 - Method -

#pragma mark - customDelegate               - Method -
- (void)selectPlayBtn:(SoundRecordModel *)recordModel
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (SoundRecordModel *model in self.dataArray) {
        if (model == recordModel) {
            if (recordModel.isSelectPlay) {
                model.isSelectPlay = NO;
                NSLog(@"当前选择的停止。。。");
//                [self stopPlayRecord:recordModel.filePath];
                [self.player pause];
            }else{
                model.isSelectPlay = YES;
                NSLog(@"当前选择的播放。。。");
                [self playRecord:recordModel.filePath];
            }
        }else{
            model.isSelectPlay = NO;
            NSLog(@"未选择 停止。。。");
//            [self stopPlayRecord:recordModel.filePath];
            [self.player pause];
        }
        [array addObject:model];
    }
    self.dataArray = array;
    [self.tableView reloadData];
}

- (void)selectDelBtn:(SoundRecordModel *)recordModel
{
    [self deleteDataCache:recordModel];
    [self.dataArray removeObject:recordModel];
    [self.tableView reloadData];
}
#pragma mark 清理缓存
- (void)deleteDataCache:(SoundRecordModel *)recordModel
{
    NSString *filePath = [NSString stringWithFormat:@"%@",recordModel.filePath];
    NSLog(@"要删除的音频路径-filePath = %@",filePath);
   
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{

                       NSError *error;
                       if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                           [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                       }
                       
//                       //清理全部
//                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                       FileSizeAtPath *fileSize = [[FileSizeAtPath alloc]init];
////                                              NSString *cachPath = NSHomeDirectory();
//                       NSLog(@"cachPath :%f",[fileSize folderSizeAtPath:cachPath]);
//
//                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//                       NSLog(@"files :%d",[files count]);
//                       for (NSString *p in files) {
//                           NSError *error;
//                           NSString *path = [cachPath stringByAppendingPathComponent:p];
//                           NSLog(@"path = %@",path);
//
//                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//                           }
//                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}
-(void)clearCacheSuccess
{
    NSLog(@"该条音频清理成功");
}
#pragma mark - objective-cDelegate          - Method -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"AddSoundCell";
        AddSoundCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddSoundCell" owner:self options:nil] lastObject];
        }
        cell.isSelect = self.isSelect;
        return cell;
    }else{
        static NSString *cellId = @"SoundCell";
        SoundCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SoundCell" owner:self options:nil] lastObject];
        }
        cell.delegate = self;
        if (self.dataArray.count>0) {
            cell.recordModel = self.dataArray[indexPath.row];
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSLog(@"add");
        if (self.isSelect) {
            NSLog(@"暂停");
            self.isSelect = NO;
            [self stopRecord];
        }else{
            NSLog(@"添加音频");
            self.isSelect = YES;
            [self startRecord];
        }
        [self.tableView reloadData];
    }else{
        NSLog(@"音频。。。");
    }
}
#pragma mark - getters and setters          - Method -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
