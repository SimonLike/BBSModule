
//
//  GDSendPostVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDSendPostVC.h"
#import "HRPicCollectionView.h"
#import "SGImagePickerController.h"
#import "GDPeratingPostView.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <MediaPlayer/MediaPlayer.h>

#import "GDRecordVideoVC.h"
#import "WCLRecordEngine.h"
#import "GDTextAlertView.h"
#import "GDGetEditArticleRequest.h"
#import "GDChooseFriendVC.h"

@interface GDSendPostVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    
    NSURL *recordedFile;//存放路径
    AVAudioPlayer *player;//播放
//    AVAudioRecorder *recorder;//录制
    NSString *recoderName;//文件名
    NSString *_audioFilePath;
    
    NSString * _videoPath;//拍摄 本地视频地址
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) GDPeratingPostView *peratingPostView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preraBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yy_topcont;
@property (weak, nonatomic) IBOutlet UIButton *yuyinBtn;
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (nonatomic, strong)GDTextAlertView *textAlertView;

@property (weak, nonatomic) IBOutlet UILabel *pic_ts_label;
@property (weak, nonatomic) IBOutlet HRPicCollectionView *picView;
@property (nonatomic, strong)NSMutableArray *picspathArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pic_topcont;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fbbtn_topcont;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSURL *fileURL;
@property (strong, nonatomic) UIImagePickerController *imagePicker;//视频选择器  相册相机
@property (strong, nonatomic) MPMoviePlayerViewController *playerVC;

@property (strong, nonatomic) WCLRecordEngine         *recordEngine;
@property (assign, nonatomic) UploadVieoStyle         videoStyle;//视频的类型

@end

@implementation GDSendPostVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:[_playerVC moviePlayer]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认设置
    [self showYuyinHidden:YES];
    [self showPictureHidden:YES];
    [self showVideoHidden:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.delegate = self;
    
    self.bgView.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.bgView.layer.borderWidth = 1;
    
    [self addViewBlock];
    
    if ([_vcType isEqualToString:@"editPost"]) {
        GDGetEditArticleRequest *request = [[GDGetEditArticleRequest alloc] initWithArticleId:_articleId];
        [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject) {
                NSDictionary *dict = responseObject[@"data"];
                _textView.text = dict[@"content"];
                
                
                DLog(@"responseObject-->%@",responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}
//语音
-(void)showYuyinHidden:(BOOL)state{
    
    UIImage *imge = [UIImage imageNamed:@"mudule_yuyin2"];
    
    if (state) {
        self.yy_topcont.constant = 25 - imge.size.height;
        self.yuyinBtn.hidden = YES;
    }else{
        self.yy_topcont.constant = 25;
        self.yuyinBtn.hidden = NO;
    }
}
//图片
-(void)showPictureHidden:(BOOL)state{
    if (state) {//隐藏
        self.pic_ts_label.text = @"";
        self.pic_topcont.constant = 0;
        self.picViewHit.constant = 0;
        self.picView.hidden = YES;
    }else{
        self.pic_ts_label.text = @"你还可以上传8张";
        self.pic_topcont.constant = 15;
        self.picViewHit.constant =  (self.picView.frame.size.width - 40)/4 + 10;
        self.picView.hidden = NO;
        CGRect frame = self.picView.pic_collection.frame;
        frame.size.height = self.picViewHit.constant;
        self.picView.pic_collection.frame = frame;
    }
}
-(void)showVideoHidden:(BOOL)state{
    UIImage *imge = [UIImage imageNamed:@"module_videobg"];

    if (state) {
        self.fbbtn_topcont.constant = 30 - imge.size.height - 20;
        self.videoView.hidden = YES;

    }else{
        self.fbbtn_topcont.constant = 30;
        self.videoView.hidden = YES;
    }

}

- (void)addViewBlock{
    __weak typeof(self) ws = self;

    //添加照片
    _picView.addPicBlock = ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [ws pickImageFromCamera];
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            SGImagePickerController *picker = [SGImagePickerController new];
            //返回选择的缩略图
            [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
                NSLog(@"缩略图%@",thumbnails);
                if (ws.picspathArr.count > 8) {
                    [SVProgressHUD showImage:nil status:@"最多上传9张照片"];
                    return ;
                }
                [ws.picspathArr addObjectsFromArray:thumbnails];
                if (self.picspathArr.count>0) {
                    [ws setConstant];
                }
                //                [weakSelf uploadIma:thumbnails];
            }];
            [ws presentViewController:picker animated:YES completion:nil];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController addAction:action3];
        [ws presentViewController:alertController animated:YES completion:nil];
    };
    
    //删除照片
    _picView.delPicBlock = ^(NSInteger tag) {
        [ws.picspathArr removeObjectAtIndex:tag];
        [ws setConstant];
    };
   
    //添加操作按钮View
    _peratingPostView = [GDPeratingPostView initPeratingPostView];
    _peratingPostView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50);
    _peratingPostView.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    _peratingPostView.layer.borderWidth = 1;
    [self.view addSubview:_peratingPostView];
    _peratingPostView.hidden = YES;
    
    //操作
    _peratingPostView.ppBlock = ^(NSInteger tag) {
        if (tag == 10) {//语音
            ws.peratingPostView.speakView.hidden = NO;
            ws.peratingPostView.btnsView.hidden = YES;
        }else if (tag == 11){//@
            GDChooseFriendVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDChooseFriend"];
            [ws.navigationController pushViewController:vc animated:YES];
        }else if (tag == 12){//图片
            [ws showPictureHidden:NO];
        }else if (tag == 13){//视频
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                GDRecordVideoVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDRecordVideo"];
                [ws.navigationController pushViewController:vc animated:YES];
                
                vc.recordBlock = ^(NSString *videoPath) {
                    _videoPath = videoPath;
                    [ws showVideoHidden:NO];
                    [ws.navigationController popViewControllerAnimated:YES];
                };
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"本地视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                ws.videoStyle = VideoLocation;
                [ws.recordEngine shutdown];
                [ws presentViewController:ws.imagePicker animated:YES completion:nil];
            }];
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"视频链接" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (!ws.textAlertView) {
                    ws.textAlertView = [GDTextAlertView initTextAlertView];
                    ws.textAlertView.frame = ws.view.bounds;
                    ws.textAlertView.bt_label.text = @"";
                    ws.textAlertView.bt_topCont.constant = 0;
                    [ws.view addSubview:ws.textAlertView];
                }
                ws.textAlertView.hidden = NO;
                [ws.textAlertView.textView becomeFirstResponder];
                ws.textAlertView.block = ^(NSInteger tag,NSString *text) {
                    if (tag == 10) {//取消
                        
                    }else{//确定
                    
                    }
                    ws.textAlertView.hidden = YES;
                };
                
            }];
            
            UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController addAction:action3];
            [alertController addAction:action4];
            [ws presentViewController:alertController animated:YES completion:nil];
            
        }else if (tag == 15){//标题
            
        }else if (tag == 16){//键盘
            
        }
    };
    _peratingPostView.speakBlock = ^(NSString *spkType) {
        if ([spkType isEqualToString:@"start"]) {
            [ws startRecord];
        }else{
            [ws stopRecord];
            [ws showYuyinHidden:NO];
        }
    };
}
- (IBAction)yuyinClick:(id)sender {
    [self playRecord];
}

//获取录音文件设置
- (NSDictionary *)getAudioSetting
{
    NSMutableDictionary *recordSetting = [NSMutableDictionary dictionary];
    //设置录音格式
    [recordSetting setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率,8000是电话采样率,对于一般录音已经够用了
    [recordSetting setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道为单声道
    [recordSetting setObject:@(2) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8,16,24,32
    [recordSetting setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [recordSetting setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    return recordSetting;
}
//获取文件名:由时间+后缀组成
- (NSString *)getSavePathWithFileSuffix:(NSString *)suffix
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSDate *date = [NSDate date];
    //获取当前时间
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *curretDateAndTime = [dateFormat stringFromDate:date];
    //命名文件
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",curretDateAndTime,suffix];
    //指定文件存储路径
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

//重写get:录音机对象
- (AVAudioRecorder *)audioRecorder
{
    if (!_audioRecorder) {
        _audioFilePath = [self getSavePathWithFileSuffix:@"caf"];
        //录音文件保存路径
        _fileURL = [NSURL fileURLWithPath:_audioFilePath];
        //录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:_fileURL settings:setting error:&error];
        if (error) {
            NSLog(@"创建录音机失败,错误信息:%@",error);
            return nil;
        }
    }
    return _audioRecorder;
}
- (IBAction)playVideo:(id)sender {
    self.playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:_videoPath]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[self.playerVC moviePlayer]];
    [[self.playerVC moviePlayer] prepareToPlay];
    
    [self presentMoviePlayerViewControllerAnimated:self.playerVC];
    [[self.playerVC moviePlayer] play];
}

//当点击Done按键或者播放完毕时调用此函数
- (void) playVideoFinished:(NSNotification *)theNotification {
    MPMoviePlayerController *player = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [self.playerVC dismissMoviePlayerViewControllerAnimated];
    self.playerVC = nil;
}
//开始录音
-(void)startRecord{
    //    初始化设置音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil){
    }
    else {
        [session setActive:YES error:nil];
    }

    
    if (_audioFilePath.length > 0) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:_audioFilePath error:&error];
    }
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder prepareToRecord];
        //首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        [self.audioRecorder record];
    }
}
-(void)stopRecord{
    
    [self.audioRecorder stop];

}
//播放本地音频文件的触发时间,可以添加按钮或其他来触发播放
-(void)playRecord{
    NSLog(@"_fileURL-->%@",_fileURL);
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    //默认情况下扬声器播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //建议播放之前设置yes，播放结束设置no，这个功能是开启红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_fileURL error:nil];
    _audioPlayer.currentTime = 0;
    _audioPlayer.delegate = self;
    //开始播放
    [_audioPlayer play];
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:nil];
}

-(void)suspendRecord{
    //关闭红外感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    //暂停播放
    [_audioPlayer stop];
}
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"AVAudioSessionCategoryPlayAndRecord");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"AVAudioSessionCategoryPlayback");

        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self suspendRecord];
}

- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return _imagePicker;
}

- (void)pickImageFromCamera
{
    //判断是否有相机
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        return;
    }
   
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}
- (void)pickImageFromAlbum
{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - image Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        data = UIImageJPEGRepresentation(image, 0.5);
        
        //图片保存的路径
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/SendPostTempImage", NSHomeDirectory()] withIntermediateDirectories:YES attributes:nil error:nil];
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SendPostTempImage"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        NSString *fileName = [BGHelper random32bitString];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@.png",fileName]] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
//        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath, [NSString stringWithFormat:@"/%@.png",fileName]];
        //if([self.photoType isEqualToString:@"0"])
        //    [self uploadUserBgIMG];
        //else
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else if ([type isEqualToString:(NSString*)kUTTypeMovie]) {//视频
        //获取视频的名称
        NSString * videoPath=[NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerMediaURL]];
        NSRange range =[videoPath rangeOfString:@"trim."];//匹配得到的下标
        NSString *content=[videoPath substringFromIndex:range.location+5];
        //视频的后缀
        NSRange rangeSuffix=[content rangeOfString:@"."];
        NSString * suffixName=[content substringFromIndex:rangeSuffix.location+1];
        //如果视频是mov格式的则转为MP4的
        if ([suffixName isEqualToString:@"MOV"]) {
            NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
            __weak typeof(self) weakSelf = self;
            [self.recordEngine changeMovToMp4:videoUrl dataBlock:^(UIImage *movieImage) {
                
                [weakSelf.imagePicker dismissViewControllerAnimated:YES completion:^{
                    _videoPath = weakSelf.recordEngine.videoPath;
                    [weakSelf showVideoHidden:NO];
             
                }];
            }];
        }
    }

}

-(void)setConstant{
    
    self.picView.picspathArr = self.picspathArr;
    if ((self.picspathArr.count + 1)%4 == 0) {
        self.picViewHit.constant = (self.picspathArr.count + 1)/4 * ((self.picView.frame.size.width - 40)/4 + 10);
    }else{
        self.picViewHit.constant = ((self.picspathArr.count + 1)/4 + 1) * ((self.picView.frame.size.width - 40)/4 + 10);
    }
    CGRect frame = self.picView.pic_collection.frame;
    frame.size.height = self.picViewHit.constant;
    self.picView.pic_collection.frame = frame;
    [self.picView.pic_collection reloadData];
}

//键盘上弹
-(void)openKeyboard:(NSNotification *)notification{
    CGRect keyboardFrame = [self keyboardFrame:notification];
    NSTimeInterval duration = [self duration:notification];
    UIViewAnimationOptions option = [self option:notification];
    
    _peratingPostView.hidden = NO;
    _peratingPostView.frame = CGRectMake(0, self.view.frame.size.height - keyboardFrame.size.height - 50, self.view.frame.size.width, 50);

    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [_peratingPostView layoutIfNeeded];
    } completion:nil];
}
//恢复键盘
-(void)closeKeyboard:(NSNotification *)notification{
   
    _peratingPostView.frame = CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, 50);

    NSTimeInterval duration = [self duration:notification];
    UIViewAnimationOptions option = [self option:notification];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [_peratingPostView layoutIfNeeded];
        _peratingPostView.hidden = YES;

    } completion:nil];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
//        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark - set、get方法
- (WCLRecordEngine *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[WCLRecordEngine alloc] init];
    }
    return _recordEngine;
}

-(NSMutableArray *)picspathArr{
    if (!_picspathArr) {
        _picspathArr = [NSMutableArray array];
    }
    return _picspathArr;
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
