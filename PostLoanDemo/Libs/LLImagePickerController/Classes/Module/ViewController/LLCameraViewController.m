//
//  LCameraViewController.m
//  LLImagePickerController
//
//  Created by 雷亮 on 16/8/23.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLCameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "Utils.h"
#import "PHImageModel.h"

static NSString *const kPublicImageMediaType = @"public.image";

@interface LLCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) CameraBlock cameraBlock;
@property (nonatomic, copy) CameraMovieBlock cameraMovieBlock;

@end

@implementation LLCameraViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    LLog(@"%@", self);
}
- (void)setCameraType:(CameraType)cameraType
{
    _cameraType = cameraType;
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) && iOS8Upwards) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alertView show];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.delegate = self;

        if (_cameraType == CameraTypeImage) {
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (iOS8Upwards) {
                self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;

        }else if (_cameraType == CameraTypeMovie){
            NSArray  *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.mediaTypes = @[mediaTypes[1]];
            self.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            self.videoMaximumDuration = 15;//视频最大录制时长，默认为10 s
//            UIImagePickerControllerQualityTypeHigh：高清质量
//            UIImagePickerControllerQualityTypeMedium：中等质量，适合WiFi传输
//            UIImagePickerControllerQualityTypeLow：低质量，适合蜂窝网传输
            self.videoQuality = UIImagePickerControllerQualityTypeMedium;
        }
    }else {
        LLog(@"设备不支持照相功能");
    }
}
#pragma mark -
#pragma mark - UIImagePickerControllerDelegate //changed by pzj
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (self.cameraType == CameraTypeImage) {//拍照
//        UIImage *image;
//        //如果允许编辑则获得编辑后的照片，否则获取原始照片
//        if (imagePicker.allowsEditing) {
//            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
//        }else{
//            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
//        }
        
        /****/
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSMutableArray *imageIds = [NSMutableArray array];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            //记录本地标识，等待完成后取到相册中的图片对象
            [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"保存成功 ---- success = %d, error = %@", success, error);
            if (success)
            {
                //成功后取相册中的图片对象
                __block PHAsset *imageAsset = nil;
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    imageAsset = obj;
                    *stop = YES;
                }];
                if (imageAsset)
                {
                    PHImageModel *model = [[PHImageModel alloc] init];
                    model.image = image;
                    model.phasset = imageAsset;
                    Block_exe(self.cameraBlock, model, imageAsset);
                }
            }else{//失败
                NSLog(@"失败。。。");
            }
            
        }];
        /****/
        
    }else if (self.cameraType == CameraTypeMovie){//录像
        /****/
        NSMutableArray *videoIds = [NSMutableArray array];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            NSURL *url = info[UIImagePickerControllerMediaURL];//视频路径
            //写入图片到相册
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
            //记录本地标识，等待完成后取到相册中的图片对象
            [videoIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"保存成功 ---- success = %d, error = %@", success, error);
            if (success)
            {
                //成功后取相册中的图片对象
                __block PHAsset *videoAsset = nil;
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:videoIds options:nil];
                [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    videoAsset = obj;
                    *stop = YES;
                }];
                
                if (videoAsset)
                {
                    [videoAsset requestMovieImageForTargetSize:[UIScreen mainScreen].bounds.size resultHandler:^(UIImage *result, NSDictionary *info, PHAsset *phAsset) {
                        dispatch_async(dispatch_get_main_queue(), ^{

                            PHImageModel *model = [[PHImageModel alloc] init];
                            model.imageName = [[[info objectForKey:@"PHImageFileSandboxExtensionTokenKey"] componentsSeparatedByString:@";"] lastObject].lastPathComponent;
                            NSString *url = [[[info objectForKey:@"PHImageFileSandboxExtensionTokenKey"] componentsSeparatedByString:@";"] lastObject];
                            
                            url = [@"file://" stringByAppendingString:url];
                            NSURL *videoURL = [NSURL URLWithString:url];
                            model.url = videoURL;
                            model.isImage = NO;
                            model.phasset = phAsset;
                            model.image = result;
                            Block_exe(self.cameraMovieBlock,model,videoAsset);
                        });
                    }];
                }
            }else{//失败
                NSLog(@"失败。。。");
            }
            
        }];
        /****/
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) { } else {
        LLog(@"设置");
        if (iOS8Upwards) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

- (void)getResultFromCameraWithBlock:(CameraBlock)block {
    self.cameraBlock = block;
}

- (void)getResultFromCameraMovieWithBlock:(CameraMovieBlock)block{
    self.cameraMovieBlock = block;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
