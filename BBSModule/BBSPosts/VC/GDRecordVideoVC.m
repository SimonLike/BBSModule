
//
//  GDRecordVideoVC.m
//  BBSModule
//
//  Created by Simon on 2017/7/6.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDRecordVideoVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "WCLRecordProgressView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WCLRecordEngine.h"


@interface GDRecordVideoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,WCLRecordEngineDelegate>

@property (weak, nonatomic) IBOutlet UIButton *flashLightBT;
@property (weak, nonatomic) IBOutlet UIButton *changeCameraBT;
@property (weak, nonatomic) IBOutlet UIButton *recordNextBT;
@property (weak, nonatomic) IBOutlet UIButton *recordBt;
@property (weak, nonatomic) IBOutlet UIButton *locationVideoBT;
@property (weak, nonatomic) IBOutlet WCLRecordProgressView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTop;

@property (strong, nonatomic) WCLRecordEngine         *recordEngine;
@property (assign, nonatomic) UploadVieoStyle         videoStyle;//视频的类型
@property (assign, nonatomic) BOOL                    allowRecord;//允许录制
@property (strong, nonatomic) UIImagePickerController *moviePicker;//视频选择器

@end

@implementation GDRecordVideoVC

- (void)dealloc {
    _recordEngine = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.recordEngine shutdown];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_recordEngine == nil) {
        [self.recordEngine previewLayer].frame = self.view.bounds;
        [self.view.layer insertSublayer:[self.recordEngine previewLayer] atIndex:0];
    }
    [self.recordEngine startUp];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allowRecord = YES;

}
//根据状态调整view的展示情况
- (void)adjustViewFrame {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.recordBt.selected) {
            self.topViewTop.constant = -64;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }else {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            self.topViewTop.constant = 0;
        }
        if (self.videoStyle == VideoRecord) {
            self.locationVideoBT.alpha = 0;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - set、get方法
- (WCLRecordEngine *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[WCLRecordEngine alloc] init];
        _recordEngine.delegate = self;
    }
    return _recordEngine;
}

- (UIImagePickerController *)moviePicker {
    if (_moviePicker == nil) {
        _moviePicker = [[UIImagePickerController alloc] init];
        _moviePicker.delegate = self;
        _moviePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _moviePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    }
    return _moviePicker;
}

#pragma mark - Apple相册选择代理
//选择了某个照片的回调函数/代理回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeMovie]) {
        
        NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];

        [picker dismissViewControllerAnimated:YES completion:^{
            if (self.recordBlock) {
                self.recordBlock(sourceURL);
            }
        }];

        
        //获取视频的名称
//        NSString * videoPath=[NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerMediaURL]];
//        NSRange range =[videoPath rangeOfString:@"trim."];//匹配得到的下标
//        NSString *content=[videoPath substringFromIndex:range.location+5];
//        //视频的后缀
//        NSRange rangeSuffix=[content rangeOfString:@"."];
//        NSString * suffixName=[content substringFromIndex:rangeSuffix.location+1];
//        //如果视频是mov格式的则转为MP4的
//        if ([suffixName isEqualToString:@"MOV"]) {
//            NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
//            __weak typeof(self) weakSelf = self;
//            [self.recordEngine changeMovToMp4:videoUrl dataBlock:^(UIImage *movieImage) {
//                
//               
//            }];
//        }
    }
}
#pragma mark - WCLRecordEngineDelegate
- (void)recordProgress:(CGFloat)progress {
    if (progress >= 1) {
        [self recordAction:self.recordBt];
        self.allowRecord = NO;
    }
    self.progressView.progress = progress;
}


#pragma mark - 各种点击事件
//返回点击事件
- (IBAction)dismissAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//开关闪光灯
- (IBAction)flashLightAction:(id)sender {
    if (self.changeCameraBT.selected == NO) {
        self.flashLightBT.selected = !self.flashLightBT.selected;
        if (self.flashLightBT.selected == YES) {
            [self.recordEngine openFlashLight];
        }else {
            [self.recordEngine closeFlashLight];
        }
    }
}

//切换前后摄像头
- (IBAction)changeCameraAction:(id)sender {
    self.changeCameraBT.selected = !self.changeCameraBT.selected;
    if (self.changeCameraBT.selected == YES) {
        //前置摄像头
        [self.recordEngine closeFlashLight];
        self.flashLightBT.selected = NO;
        [self.recordEngine changeCameraInputDeviceisFront:YES];
    }else {
        [self.recordEngine changeCameraInputDeviceisFront:NO];
    }
}

//录制下一步点击事件
- (IBAction)recordNextAction:(id)sender {
    if (_recordEngine.videoPath.length > 0) {
        __weak typeof(self) weakSelf = self;
        [self.recordEngine stopCaptureHandler:^(UIImage *movieImage) {
            
            NSURL* url = [NSURL fileURLWithPath:weakSelf.recordEngine.videoPath];
            if (weakSelf.recordBlock) {
                weakSelf.recordBlock(url);
            }
        }];
    }else {
        NSLog(@"请先录制视频~");
    }
}


//本地视频点击视频
- (IBAction)locationVideoAction:(id)sender {
    self.videoStyle = VideoLocation;
    [self.recordEngine shutdown];
    [self presentViewController:self.moviePicker animated:YES completion:nil];
}

//开始和暂停录制事件
- (IBAction)recordAction:(UIButton *)sender {
    if (self.allowRecord) {
        self.videoStyle = VideoRecord;
        self.recordBt.selected = !self.recordBt.selected;
        if (self.recordBt.selected) {
            if (self.recordEngine.isCapturing) {
                [self.recordEngine resumeCapture];
            }else {
                [self.recordEngine startCapture];
            }
        }else {
            [self.recordEngine pauseCapture];
        }
        [self adjustViewFrame];
    }
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
