//
//  PhotoChoseUtil.m
//  FHDemo
//
//  Created by 彭昭君 on 15/8/4.
//  Copyright (c) 2015年 FangLin. All rights reserved.
//

#import "PhotoChoseUtil.h"

@implementation PhotoChoseUtil

static BOOL isFromSelf = NO;

static PhotoChoseUtil *instance = nil;

+ (PhotoChoseUtil *)shareInstance
{
    @synchronized (self){
        if (instance == nil) {
            isFromSelf = YES;
            instance = [[PhotoChoseUtil alloc] init];
            isFromSelf = NO;
        }
    }
    return instance;
}

+(id)alloc
{
    if (isFromSelf) {
        return [super alloc];
    }
    else
    {
        return [self shareInstance];
    }
}

#pragma mark - 相册中取照片
- (void) selectImage:(UIViewController *)vc isimage:(BOOL)imagestr image:(void (^)(NSObject *image))onImageSelected
{
    _isImage = imagestr;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    selectedImageCallback=[onImageSelected copy];
    [vc presentViewController:ipc animated:YES completion:nil];
}
#pragma mark - 拍照
- (void)photograph:(UIViewController *)vc isimage:(BOOL)imagestr image:(void (^)(NSObject *))onImageSelected
{
    _isImage = imagestr;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    picker.showsCameraControls = YES;
    selectedImageCallback = [onImageSelected copy];
    [vc presentModalViewController:picker animated:YES];//进入照相界面
    
    
}
+ (void) photograph:(UIViewController *)vc isimage:(BOOL)imagestr image:(void (^)(NSObject *image))onImageSelected
{
    [[PhotoChoseUtil shareInstance] selectImage:vc isimage:imagestr image:onImageSelected];
}
+ (void) selectImage:(UIViewController *)vc isimage:(BOOL)imagestr image:(void (^)(NSObject *image))onImageSelected
{
    [[PhotoChoseUtil shareInstance] selectImage:vc isimage:imagestr image:onImageSelected];
}
#pragma mark 修正图片旋转90度的方法
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;  
    }  
    
    // And now we just create a new UIImage from the drawing context  
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);  
    UIImage *img = [UIImage imageWithCGImage:cgimg];  
    CGContextRelease(ctx);  
    CGImageRelease(cgimg);  
    return img;  
}

//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
//  contextInfo:(void *)contextInfo{
//    
//    NSLog(@"saved..");
//}
#pragma mark- UIImagePickerControllerDelegate, UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    
//    UIImage *img2 = [info objectForKey:UIImagePickerControllerEditedImage];
//    UIImageWriteToSavedPhotosAlbum(img2, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    
    NSData * data1 = UIImageJPEGRepresentation(img, 1);
   img = [self fixOrientation:img];
    if (_isImage) {
        if (selectedImageCallback) {
            selectedImageCallback(img);
        }
    }
    else
    {
        if (img != nil) {
            NSData * data = UIImageJPEGRepresentation(img, 0.1);
//            NSString *imagePath = [FileUtil getFilePathFolderName:@"fhApp" fileName:@"image.jpg"];
            //保存
//            [[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
            
//            if (selectedImageCallback) {
//                selectedImageCallback(imagePath);
//            }
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
