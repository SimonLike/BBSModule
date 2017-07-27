
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
#import "GDCreateArticleRequest.h"
#import "GDUpdateArticleRequest.h"
#import "GDCallFriendObj.h"

#import "GDChooseFriendVC.h"

#import "XQUploadHelper.h"
#import "AFUploadFile.h"

@interface GDSendPostVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    
    NSURL *_videoFilePath;////拍摄 本地视频地址url
    AVAudioPlayer *player;//播放
//    AVAudioRecorder *recorder;//录制
    NSString *recoderName;//文件名
    NSString *_audioFilePath;
    
}

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bti_topCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btiHitCont;
@property (weak, nonatomic) IBOutlet UITextField *bti_text;

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
@property (nonatomic, strong) NSURL *fileURL; //录音url
@property (strong, nonatomic) UIImagePickerController *imagePicker;//视频选择器  相册相机
@property (strong, nonatomic) MPMoviePlayerViewController *playerVC;

@property (strong, nonatomic) WCLRecordEngine         *recordEngine;
@property (assign, nonatomic) UploadVieoStyle         videoStyle;//视频的类型

@property (nonatomic, strong) NSString *fileAudio; //语音参数
@property (nonatomic, strong) NSString *fileVideo; //视频参数
@property (nonatomic, strong) NSArray *callArray; //@朋友参数

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
    [self showBiaoTiHidden:YES];
    [self showYuyinHidden:YES];
    [self showPictureHidden:YES];
    [self showVideoHidden:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.delegate = self;
    
    self.bgView.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    self.bgView.layer.borderWidth = 1;
    
    [self addViewBlock];
    
    if ([_vcType isEqualToString:@"editPost"]) {
        self.title = @"编辑帖子";
        GDGetEditArticleRequest *request = [[GDGetEditArticleRequest alloc] initWithArticleId:_articleId];
        [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject) {
                NSDictionary *dict = responseObject[@"data"];
                _textView.text = dict[@"content"];
                if (![dict[@"title"] isEqualToString:@""]) {
                    _bti_text.text = dict[@"title"];
                    [self showBiaoTiHidden:NO];
                }
                if (![dict[@"audio"] isEqualToString:@""]) {
                    _fileURL = dict[@"audio"];
                    [self showYuyinHidden:NO];
                }
                if (![dict[@"video"] isEqualToString:@""]) {
                    [self showVideoHidden:NO];
                }
                if (![dict[@"image"] isEqualToString:@""]) {
                    [self showPictureHidden:NO];
                    NSArray *array = [dict[@"image"] componentsSeparatedByString:@";"];

                    [self.picspathArr addObjectsFromArray:array];
                    [self setConstant];
                }
                DLog(@"responseObject-->%@",responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}

#pragma mark --add Block

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
                [ws uploadIma:thumbnails];
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
    _peratingPostView.ppBlock = ^(UIButton *btn,NSInteger tag) {
        if (tag == 10) {//语音
            if (!ws.picView.hidden || !ws.videoView.hidden) {
                [SVProgressHUD showImage:nil status:@"语音，图片，视频只能选择一种发帖！"];
                return ;
            }
            
            if (ws.yuyinBtn.hidden) {
                ws.peratingPostView.speakView.hidden = NO;
                ws.peratingPostView.btnsView.hidden = YES;
            }else{
                [ws showYuyinHidden:YES];
            }
            
        }else if (tag == 11){//@
            GDChooseFriendVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDChooseFriend"];
            [ws.navigationController pushViewController:vc animated:YES];
            vc.callblock = ^(NSArray *array) {
                [ws.navigationController popViewControllerAnimated:YES];
                _callArray = array;
            };
        }else if (tag == 12){//图片
            
            if (!ws.yuyinBtn.hidden || !ws.videoView.hidden) {
                [SVProgressHUD showImage:nil status:@"语音，图片，视频只能选择一种发帖！"];
                return ;
            }
            if (ws.picView.hidden) {
                [ws showPictureHidden:NO];
            }else{
                [ws showPictureHidden:YES];
            }
            
        }else if (tag == 13){//视频
            if (!ws.yuyinBtn.hidden || !ws.picView.hidden) {
                [SVProgressHUD showImage:nil status:@"语音，图片，视频只能选择一种发帖！"];
                return ;
            }
            if (ws.videoView.hidden) {
            }else{
                [ws showVideoHidden:YES];
                return;
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                GDRecordVideoVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDRecordVideo"];
                [ws.navigationController pushViewController:vc animated:YES];
                
                vc.recordBlock = ^(NSURL *url) {
                    [ws.navigationController popViewControllerAnimated:YES];
                    
                    NSURL *newVideoUrl ; //一般.mp4
                    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
                    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
                    
                    [ws convertVideoQuailtyWithInputURL:url outputURL:newVideoUrl completeHandler:nil];
                    
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
            if (ws.bti_text.hidden) {
                [ws showBiaoTiHidden:NO];
            }else{
                [ws showBiaoTiHidden:YES];
                
            }
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
#pragma mark -- 发布
- (IBAction)sendReleaseClick:(id)sender {
    NSString *title = @"";
    NSString *content = @"";
    NSString *image = @"";
    NSString *video = @"";
    NSString *audio = @"";
    NSString *call = @"";
    
    if (!self.bti_text.hidden) {
        title = self.bti_text.text;
        if ([title isEqualToString:@""]) {
            [SVProgressHUD showImage:nil status:@"请输入标题"];
            return;
        }
    }
    content = self.textView.text;
    if ([content isEqualToString:@"请输入你要发布的内容"]||[content isEqualToString:@""]) {
        content = @"";
    }
    
    if (!self.yuyinBtn.hidden) {
        audio =  _fileAudio;
    }
    
    if (!self.videoView.hidden) {
        video =  _fileVideo;
    }
    if (!self.picView.hidden) {
        //上传图片拼接串
        for (int i = 0; i < self.picspathArr.count; i++) {
            if (i == self.picspathArr.count - 1) {
                image = [image stringByAppendingString:[NSString stringWithFormat:@"%@",self.picspathArr[i]]];
            }else{
                image = [image stringByAppendingString:[NSString stringWithFormat:@"%@;",self.picspathArr[i]]];
            }
        }
    }
    
    if (_callArray.count > 0) {
        //拼接串
        for (int i = 0; i < _callArray.count; i++) {
            if (i == _callArray.count - 1) {
                call = [call stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[(GDCallFriendObj*)_callArray[i] callId]]];
            }else{
                call = [call stringByAppendingString:[NSString stringWithFormat:@"%ld;",(long)[(GDCallFriendObj*)_callArray[i] callId]]];
            }
        }
    }
    
    if ([_vcType isEqualToString:@"editPost"]) {
        GDUpdateArticleRequest *request = [[GDUpdateArticleRequest alloc] initWithArticleId:_articleId
                                                                                      Title:title
                                                                                    Content:self.textView.text
                                                                                      Image:image
                                                                                      Video:video
                                                                                      Audio:audio
                                                                                       Call:call];
        
        [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }else{
        GDCreateArticleRequest *request = [[GDCreateArticleRequest alloc] initWithTitle:title
                                                                                Content:self.textView.text
                                                                                  Image:image
                                                                                  Video:video
                                                                                  Audio:audio
                                                                                   Call:call];
        [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

#pragma mark -- 标题 语音 图片 视频操作
//标题
-(void)showBiaoTiHidden:(BOOL)state{
    
    if (state) {
        self.btiHitCont.constant = 0;
        self.bti_topCont.constant = 0;
        self.bti_text.hidden = YES;
    }else{
        self.btiHitCont.constant = 36;
        self.bti_topCont.constant = 25;
        self.bti_text.hidden = NO;
    }
}
//语音
-(void)showYuyinHidden:(BOOL)state{
    
    UIImage *imge = [UIImage imageNamed:@"mudule_yuyin2"];
    
    if (state) {
        self.yy_topcont.constant = 25 - imge.size.height;
        self.yuyinBtn.hidden = YES;
        
        [_peratingPostView.yuyin_btn setImage:[UIImage imageNamed:@"module_yyicon"] forState:UIControlStateNormal];
    }else{
        [_peratingPostView.yuyin_btn setImage:[UIImage imageNamed:@"module_selectedyyicon"] forState:UIControlStateNormal];
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
        
        [_peratingPostView.pic_btn setImage:[UIImage imageNamed:@"module_tpicon"] forState:UIControlStateNormal];
    }else{
        self.pic_ts_label.text = @"你还可以上传8张";
        self.pic_topcont.constant = 15;
        self.picViewHit.constant =  (self.picView.frame.size.width - 30)/3 + 10;
        self.picView.hidden = NO;
        CGRect frame = self.picView.pic_collection.frame;
        frame.size.height = self.picViewHit.constant;
        self.picView.pic_collection.frame = frame;
        
        [_peratingPostView.pic_btn setImage:[UIImage imageNamed:@"module_selectedtpicon"] forState:UIControlStateNormal];

    }
}
-(void)showVideoHidden:(BOOL)state{
    UIImage *imge = [UIImage imageNamed:@"module_videobg"];

    if (state) {
        self.fbbtn_topcont.constant = 30 - imge.size.height - 20;
        self.videoView.hidden = YES;
        [_peratingPostView.video_btn setImage:[UIImage imageNamed:@"module_videobtn"] forState:UIControlStateNormal];

    }else{
        self.fbbtn_topcont.constant = 30;
        self.videoView.hidden = NO;
        [_peratingPostView.video_btn setImage:[UIImage imageNamed:@"module_selectedvideobtn"] forState:UIControlStateNormal];
    }

}

#pragma mark -- 语音

- (IBAction)yuyinClick:(id)sender {
    [self playRecord];
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
    [self uploadAudio:_fileURL];
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
    NSString *documentPath  = [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    
    NSDate *date = [NSDate date];
    //获取当前时间
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *curretDateAndTime = [dateFormat stringFromDate:date];
    //命名文件
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",curretDateAndTime,suffix];
    
    //指定文件存储路径
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName]];
     DLog(@"yuyinfilePath--->%@",filePath);
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


//播放本地音频文件的触发时间,可以添加按钮或其他来触发播放
-(void)playRecord{
    NSLog(@"_fileURLsss-->%@",_fileURL);
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

#pragma mark --视频

- (IBAction)playVideo:(id)sender {
    self.playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:_videoFilePath];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[self.playerVC moviePlayer]];
    [[self.playerVC moviePlayer] prepareToPlay];
    
    [self presentMoviePlayerViewControllerAnimated:self.playerVC];
    [[self.playerVC moviePlayer] play];
}

//当点击Done按键或者播放完毕时调用此函数
- (void) playVideoFinished:(NSNotification *)theNotification {
    MPMoviePlayerController *players = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:players];
    [players stop];
    [self.playerVC dismissMoviePlayerViewControllerAnimated];
    self.playerVC = nil;
}
#pragma mark --图片

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
      
    }else if ([type isEqualToString:(NSString*)kUTTypeMovie]) {//视频
        
        [picker dismissViewControllerAnimated:YES completion:^{

            NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
            NSURL *newVideoUrl ; //一般.mp4
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
            [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
           
//            NSString *documentPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            
            NSString *documentPath  = [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];

            
            newVideoUrl = [NSURL fileURLWithPath:[documentPath stringByAppendingFormat:@"/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。

//            //指定文件存储路径
//            [documentPath writeToFile:[documentPath stringByAppendingFormat:@"/output-%@.mp4", [formater stringFromDate:[NSDate date]]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            
            DLog(@"shipinfilePath--->%@",newVideoUrl);

            [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
            
        }];
        
//        //获取视频的名称
//
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
//            }];
//        }
    }

}
#pragma mark --upload 上传
//图片
-(void)uploadIma:(NSArray *)pics{
    for (UIImage *img in pics) {
        long long num = [GDUtils getLongNumFromDate:[NSDate date]];
        NSString* code = [GDUtils ret32bitString];
        // 上传图片
        NSDictionary *dict = @{@"token":[GDUtils readUser].token,@"userId":@([GDUtils readUser].userId)};
        NSData *fileData = UIImageJPEGRepresentation(img, 0.5);
        NSString *fileName = [NSString stringWithFormat:@"%@-%lld-%@.png",[GDUtils readUser].token,num,code];//命名，必须唯一
        
        [AFUploadFile upLoadToUrlString:[NSString stringWithFormat:@"%@/appservice/basicController/uploadPicture",PIC_UPDATE] parameters:dict fileData:fileData name:@"file" fileName:fileName mimeType:@"image/jpeg" response:JSON progress:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"success:%@ %@",responseObject, [responseObject objectForKey:@"msg"]);
            if(responseObject){
                NSString *url = responseObject[@"data"][@"path"];
                [self.picspathArr addObject:url];
                _pic_ts_label.text = [NSString stringWithFormat:@"你还可以上传%lu张",9 - self.picspathArr.count];
                if (self.picspathArr.count>0) {
                    [self setConstant];
                }
            }
           
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }
}
//音频
-(void)uploadAudio:(NSURL *)url{
    DLog(@"url --->%@",url);
    NSData *audioData = [NSData dataWithContentsOfURL:url];    //上传

    long long num = [GDUtils getLongNumFromDate:[NSDate date]];
    NSString* code = [GDUtils ret32bitString];
    NSString *fileName = [NSString stringWithFormat:@"%@-%lld-%@.caf",[GDUtils readUser].token,num,code];
    NSDictionary *dict = @{@"token":[GDUtils readUser].token,@"userId":@([GDUtils readUser].userId)};
    
    [AFUploadFile upLoadToUrlString:[NSString stringWithFormat:@"%@/appservice/basicController/uploadFile",PIC_UPDATE] parameters:dict fileData:audioData name:@"file" fileName:fileName mimeType:@"application/octet-stream" response:JSON progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
         NSLog(@"yinpin上传成功%@",responseObject);
        if (responseObject) {
            _fileAudio = responseObject[@"data"][@"path"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}
//视频
-(void)uploadVideo:(NSURL *)url{
    //压缩视频
    NSData *videoData = [NSData dataWithContentsOfURL:url];    //视频上传
//    if (lengthTime >10.0f) {
//        NSLog(@"文件过大只允许上传10s视频");
//    }else {
        long long num = [GDUtils getLongNumFromDate:[NSDate date]];
        NSString* code = [GDUtils ret32bitString];
        NSString *fileName = [NSString stringWithFormat:@"%@-%lld-%@.mp4",[GDUtils readUser].token,num,code];
        NSDictionary *dict = @{@"token":[GDUtils readUser].token,@"userId":@([GDUtils readUser].userId)};
        [AFUploadFile upLoadToUrlString:[NSString stringWithFormat:@"%@/appservice/basicController/uploadFile",PIC_UPDATE] parameters:dict fileData:videoData name:@"file" fileName:fileName mimeType:@"video/quicktime" response:JSON progress:^(NSProgress *uploadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [self showVideoHidden:NO];

            NSLog(@"上传成功%@",responseObject);
            if (responseObject) {
                _fileVideo = responseObject[@"data"][@"path"];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"%@",error);
            
        }];
        
//    }
    
}
#pragma mark - 获取视频时间
- (CGFloat) getVideoLength:(NSURL *)URL
{
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}

#pragma mark - 视频压缩

- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    DLog(@"outputURL--->%@",outputURL);

    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusUnknown:
                DLog(@"StatusUnknown");
                break;
            case AVAssetExportSessionStatusWaiting:DLog(@"StatusWaiting");
                break;
            case AVAssetExportSessionStatusExporting:DLog(@"StatusExporting");
                break;
            case AVAssetExportSessionStatusCompleted: {
                DLog(@"Completed");
                _videoFilePath = outputURL;

                [self uploadVideo:outputURL];
                break;
            }
            case AVAssetExportSessionStatusFailed:DLog(@"Failed");

                break;
        }
    }];
}

#pragma mark - 获取视频的大小
- (CGFloat) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}
#pragma mark - 获取当前时间
- (NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    //    NSString *str = [NSString stringWithFormat:@"%@mdxx",dateTime];
    //    NSString *tokenStr = [str stringToMD5:str];
    return dateTime;
    
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextIn {
    NSLog(@"照片保存成功");
}

#pragma mark 视频保存完毕的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextIn {
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

-(void)setConstant{
    
    self.picView.picspathArr = self.picspathArr;
    if ((self.picspathArr.count + 1)%3 == 0) {
        self.picViewHit.constant = (self.picspathArr.count + 1)/3 * ((self.picView.frame.size.width - 30)/3 + 10);
    }else{
        self.picViewHit.constant = ((self.picspathArr.count + 1)/3 + 1) * ((self.picView.frame.size.width - 30)/3 + 10);
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

#pragma mark -textViewdelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请输入你要发布的内容"]) {
        textView.text = @"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入你要发布的内容";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
//        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
