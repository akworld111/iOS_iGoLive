//
//  LMImageSelector.m
//  LMImageSelector
//
//  Created by 高翔 on 16/7/1.
//  Copyright © 2016年 高翔. All rights reserved.
//

#import "LMImageSelector.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UploadParam.h"
#define POST_TEMP_DIRECTORY @"TempFile"

@interface LMImageSelector ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIViewController *_viewController;
    ResultBlock _resultBlock;
    int _type;
}

@property(nonatomic,strong)UIImagePickerController *photoController;
@property(nonatomic,strong)UIImagePickerController *photoAlbumController;

@end

@implementation LMImageSelector

- (void)showImageSheetWithView:(UIViewController *)viewController type:(int)type result:(ResultBlock)resultBlock{
    _viewController = viewController;
    _type = type;
    UIActionSheet *photoSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo", @"Choose from photos", nil];
    photoSheet.delegate = self;
    [photoSheet showInView:_viewController.view];
    _resultBlock = resultBlock;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        {
            return;
        }
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus != AVAuthorizationStatusAuthorized && authStatus != AVAuthorizationStatusNotDetermined)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"to access your phone, setting->privacy->phone" delegate:self cancelButtonTitle:@"confirm" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        self.photoController = [[UIImagePickerController alloc] init];
        self.photoController.delegate = self;
        self.photoController.mediaTypes = @[(NSString*)kUTTypeImage];
        self.photoController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.photoController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.photoController.allowsEditing = YES;
        [self.photoController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        [_viewController presentViewController:self.photoController animated:YES completion: nil];
    }
    else if (buttonIndex == 1)
    {
        self.photoAlbumController = [[UIImagePickerController alloc]init];
        self.photoAlbumController.delegate = self;
        self.photoAlbumController.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
        self.photoAlbumController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.photoAlbumController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.photoAlbumController.allowsEditing = YES;
        [self.photoAlbumController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        [_viewController presentViewController:self.photoAlbumController animated:YES completion: nil];
        UINavigationBar *naviBar =  self.photoAlbumController.navigationBar;
        if (_type == 1) {
            [ViewModifierHelpers addGradientColorFadedSubLayerToNavBarView:naviBar hexColorStart:col_view_bg_drk_purple hexColorEnd:col_view_bg_lt_purple];
        }else{
            [ViewModifierHelpers addGradientColorFadedSubLayerToNavBarView:naviBar hexColorStart:col_btnDone_drk_green hexColorEnd:col_btnDone_lt_green];
        }
        

    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (editedImage)
        {
            imageToSave = editedImage;
        }
        else
        {
            imageToSave = originalImage;
        }
        imageToSave = [self rotateImage:imageToSave];
        
        // Save the new image (original or edited) to the Camera Roll
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        }
        
        float fWidth = imageToSave.size.width;
        float fHeight = imageToSave.size.height;
        
        //1.get middle image(square)
        CGRect rect;
        if(fWidth >= fHeight)
        {
            rect  = CGRectMake((fWidth-fHeight)/2, 0, fHeight, fHeight);
        }
        else
        {
            rect  = CGRectMake(0,(fHeight-fWidth)/2, fWidth, fWidth);
        }
        
        UIImage *imgTemp = [self scaleToSize:CGSizeMake(350,350) image:[self getSubImage:imageToSave rect:rect]];
        
    
        NSData *imageData = UIImageJPEGRepresentation(imgTemp,1.0);
        NSString *imagePathDir = [self getTempPath];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExists = [fileManager fileExistsAtPath:imagePathDir];
        if (fileExists)
        {
            [fileManager removeItemAtPath:imagePathDir error:nil];
        }
        
        //create director
        [fileManager createDirectoryAtPath:imagePathDir  withIntermediateDirectories:YES  attributes:nil error:nil];
        
        //save file
        NSString *fileName = [self createImageNameByDateTime:@"jpg"];
        NSString *imagePath = [imagePathDir stringByAppendingPathComponent:fileName];
        [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
        
        //3.assign userVo value

        UploadParam *param = [[UploadParam alloc] init];
        param.data = [Common compressImage:imgTemp];
        param.name = @"file";
        param.filename = fileName;
        param.mimeType = @"image/jpeg";
        [MBProgressHUD showMessage:@"Uploading..."];
        [HttpService uplaodHeadImageWithloadParam:param result:^(CommonReturn *commonReturn) {
            [MBProgressHUD hideHUD];
            LiveUser *user = [Config myProfile];

            if (commonReturn.state==1) {
                [MBProgressHUD showSuccess:@"Upload Success"];
                _resultBlock(imgTemp);
                user.avatar = fileName;
                } else {
                [MBProgressHUD showError:@"Upload Error"];
                _resultBlock([UIImage imageNamed:@"HeadDefault"]);
                    user.avatar = @"";

            }
            [Config updateProfile:user];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"icon" object:nil];

        }];
    }
    [picker dismissViewControllerAnimated:YES completion: nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*)createImageNameByDateTime:(NSString*)strExtension
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDateTime = [dateFormatter stringFromDate:[NSDate date]];
    strDateTime = [NSString stringWithFormat:@"%@.%@",strDateTime,strExtension];
    return strDateTime;
}

- (UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    UIImageOrientation orient = aImage.imageOrientation;
    UIImageOrientation newOrient = UIImageOrientationUp;
    switch (orient)
    {
        case 3:
            newOrient = UIImageOrientationRight;
            break;
        case 2:
            newOrient = UIImageOrientationLeft;
            break;
        case 0:
            newOrient = UIImageOrientationUp;
            break;
        case 1:
            newOrient = UIImageOrientationDown;
            break;
        default:
            newOrient = UIImageOrientationRight;
            break;
    }
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGFloat ratio = 0;
    if ((width > 1024) || (height > 1024))
    {
        if (width >= height)
        {
            ratio = 1024/width;
        }
        else
        {
            ratio = 1024/height;
        }
        width *= ratio;
        height *= ratio;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    switch(newOrient)
    {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
            
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (newOrient == UIImageOrientationRight || newOrient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

- (UIImage*)getSubImage:(UIImage *)image rect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CFRelease(subImageRef);
    return smallImage;
}

- (UIImage*)scaleToSize:(CGSize)size image:(UIImage *)image
{
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//"temp/TempFile"
- (NSString *)getTempPath
{
    NSString *strTempPathDir = [[self tmpDirectory] stringByAppendingPathComponent:POST_TEMP_DIRECTORY];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:strTempPathDir];
    if (!fileExists)
    {
        //not exist,then create
        [fileManager createDirectoryAtPath:strTempPathDir withIntermediateDirectories:YES  attributes:nil error:nil];
    }
    return strTempPathDir;
}

- (NSString *)tmpDirectory
{
    return  NSTemporaryDirectory();
}

@end
