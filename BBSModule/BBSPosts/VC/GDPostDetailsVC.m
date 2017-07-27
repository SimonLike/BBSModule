//
//  GDPostDetailsVC.m
//  BBSModule
//
//  Created by Simon on 2017/7/3.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDPostDetailsVC.h"
#import "GDPostDetailsCell.h"
#import "GDReplyDetailsVC.h"
#import "GDArticleDetailRequest.h"
#import "GDCommentListObj.h"
#import "HRPicCollectionView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GDDeleteArticleRequest.h"
#import "GDSendPostVC.h"
#import "GDReplyCommentRequest.h"
#import "GDDeleteMyCommentRequest.h"
#import "GDQuickReplyArticleRequest.h"

@interface GDPostDetailsVC ()<AVAudioPlayerDelegate>{
    NSString   *_videoFilePath;
    NSString   *_audioFilePath;
}
@property (weak, nonatomic) IBOutlet UIImageView *peoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *del_btn;

@property (weak, nonatomic) IBOutlet UILabel *tltLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tltTopCont;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contTopCont;
@property (weak, nonatomic) IBOutlet UILabel *contLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yunyinTopCont;
@property (weak, nonatomic) IBOutlet UIButton *yuyin_btn;

@property (weak, nonatomic) IBOutlet HRPicCollectionView *picView;
@property (nonatomic, strong)NSMutableArray *picspathArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoTopCont;
@property (weak, nonatomic) IBOutlet UIView *videoBgView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UITextField *speakText;
@property (weak, nonatomic) IBOutlet UIButton *jp_btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHit;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *pl_array;
@property (weak, nonatomic) IBOutlet UITableView *postTable;


@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


@property (strong, nonatomic) MPMoviePlayerViewController *playerVC;
@property (strong, nonatomic) NSDictionary *postDict;
@property (assign, nonatomic) NSInteger textTag;// 1评论  2回复评论
@property (assign, nonatomic) GDCommentListObj *commentObj;// 点击选择
@end

@implementation GDPostDetailsVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
    
    [_audioPlayer stop];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _textTag = 1;

    [self getArticleDetail];
}

#pragma  mark -- Request
-(void)getArticleDetail{
    GDArticleDetailRequest *request = [[GDArticleDetailRequest alloc] initWithArticleId:_articleId Rows:30 Page:1];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject->%@",responseObject);
        if (responseObject) {
            
            NSDictionary *dict = responseObject[@"data"][@"article"];
            _postDict = dict;
            [_peoImage sd_setImageWithURL:[NSURL URLWithString:dict[@"head"]] placeholderImage:nil];
            _nameLabel.text = dict[@"name"];
            _timeLabel.text = dict[@"create_time"];
            _contLabel.text = dict[@"content"];
            if ([dict[@"userId"] integerValue] != [GDUtils readUser].userId) {
                _edit_btn.hidden = YES;
                _del_btn.hidden = YES;
            }
            
            //标题
            float tltHit =  [self showBiaoTiStr:dict[@"title"]];
            //发帖内容
            float contHit = [self showContentStr:dict[@"content"]];
            //语音
            float yuyinHit = [self showYuyinStr:dict[@"audio"]];
            //图片
            float picHit = [self showPictureStr:dict[@"image"]];
            //视频
            float videoHit = [self showVideoStr:dict[@"video"]];
            _videoFilePath = dict[@"video"];
            _audioFilePath = dict[@"audio"];
            DLog(@"tltHit->%f",tltHit);
            DLog(@"contHit->%f",contHit);
            DLog(@"yuyinHit->%f",yuyinHit);
            DLog(@"picHit->%f",picHit);
            DLog(@"videoHit->%f",videoHit);
            
            _commentLabel.text = [NSString stringWithFormat:@"%@人评论",dict[@"num"]];
            [self.pl_array removeAllObjects];
            NSArray *arr = [GDCommentListObj objectArrayWithKeyValuesArray:responseObject[@"data"][@"commentList"]];
            [self.pl_array addObjectsFromArray:arr];
            _tableHit.constant =  + 152 * self.pl_array.count ;
                        
            [_postTable reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)quickReplyArticle:(NSString *)text ArticleId:(NSInteger)articleId{
    GDQuickReplyArticleRequest *request = [[GDQuickReplyArticleRequest alloc] initWithArticleId:articleId content:text];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            //请空回复输入框 赋默认值
            _speakText.text = @"";
            _textTag = 1;
            [self getArticleDetail];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)replyCommentId:(NSInteger)commentId{
    
    GDReplyCommentRequest *request = [[GDReplyCommentRequest alloc] initWithArticleId:_articleId
                                                                            CommentId:commentId
                                                                                Title:_postDict[@"title"]
                                                                               Attach:@""
                                                                              Content:_speakText.text];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            DLog(@"responseObject-->%@",responseObject);
            [self getArticleDetail];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)deleteMyCommentId:(NSInteger)commentId CommId:(NSInteger)commId{
    GDDeleteMyCommentRequest *request = [[GDDeleteMyCommentRequest alloc] initWithCommentId:commentId CommId:commId];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            DLog(@"responseObject-->%@",responseObject);
            [self getArticleDetail];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark -- 标题 语音 图片 视频操作
//标题
-(float)showBiaoTiStr:(NSString *)str{
    float hit = 0.0;
    CGSize tltsize ;
    if ([str isEqualToString:@""]) {
        self.tltLabel.text = @"";
        self.tltTopCont.constant = 0;
    }else{
        self.tltLabel.text = str;
        tltsize = [GDUtils textHeightSize:str maxSize:CGSizeMake(SCREEN_WIDTH - 48, 100) textFont:[UIFont systemFontOfSize:12]];
        self.tltTopCont.constant = 13;
        
        hit = tltsize.height + 13;
    }
    
    return hit;
}
//
//内容
-(float)showContentStr:(NSString *)str{
    
    float hit = 0.0;
    if ([str isEqualToString:@""]) {
        self.contLabel.text = @"";
        self.contTopCont.constant = 0;
    }else{
        self.contLabel.text = str;
        CGSize contsize = [GDUtils getTextMultilineContent:str withFont:[UIFont systemFontOfSize:12] withSize:CGSizeMake(SCREEN_WIDTH - 46, 10000)];
        
        self.contTopCont.constant = 10;
        hit = contsize.height;
    }
    
    return hit;
}
//
//语音
-(float)showYuyinStr:(NSString *)str{
    float hit = 0.0;
    
    UIImage *imge = [UIImage imageNamed:@"mudule_yuyin2"];
    if([str isEqualToString:@""]){
        self.yunyinTopCont.constant = 13 - imge.size.height;
        self.yuyin_btn.hidden = YES;
        hit = 13;
    }else{
        self.yunyinTopCont.constant = 13;
        self.yuyin_btn.hidden = NO;
        hit = imge.size.height + 13;
    }
    return hit;
}
////图片
-(float)showPictureStr:(NSString *)str{
    if([str isEqualToString:@""]){
        self.picViewHit.constant = 0;
        self.picView.hidden = YES;
    }else{
        
        NSArray *array = [str componentsSeparatedByString:@";"];
        self.picView.picTypeTnt = 1;//显示
        self.picView.picspathArr = array;
        if (array.count%3 == 0) {
            self.picViewHit.constant = array.count/3 *  ((self.picView.frame.size.width - 30)/3 + 10);
        }else{
            self.picViewHit.constant = (array.count/3 + 1) * ((self.picView.width - 30)/3 + 10);
        }
        
        self.picView.hidden = NO;
        CGRect frame = self.picView.pic_collection.frame;
        frame.size.height = self.picViewHit.constant;
        self.picView.pic_collection.frame = frame;
        [self.picView.pic_collection reloadData];
    }
    return self.picViewHit.constant;
}
//视频
-(float)showVideoStr:(NSString *)str{
    float hit = 0.0;
    
    UIImage *imge = [UIImage imageNamed:@"module_videobg"];
    if([str isEqualToString:@""]){
        self.videoBgView.hidden = YES;
        self.videoTopCont.constant = hit - imge.size.height;
    }else{
        self.videoBgView.hidden = NO;
        hit = imge.size.height + 15;
    }
    return hit;
}

- (IBAction)post_click:(UIButton *)sender {
    if (sender.tag == 10) {//编辑
        GDSendPostVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDSendPost"];
        vc.vcType = @"editPost";
        vc.articleId = _articleId;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 11) {//删除
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除该帖子？" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            GDDeleteArticleRequest *request = [[GDDeleteArticleRequest alloc] initWithArticleId:_articleId];
            [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
                if(responseObject){
                    DLog(@"responseObject-->%@",responseObject);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if (sender.tag == 12){//播放视频
        
        NSString *url = [NSString stringWithFormat:@"%@%@",PIC_HOST,_videoFilePath];
        DLog(@"_videoFilePath-->%@",url);

        //        NSString *url = @"http://120.25.226.186:32812/resources/videos/minion_02.mp4";
        NSURL *videoURL = [NSURL URLWithString:url];
        self.playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        self.playerVC.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        self.playerVC.moviePlayer.shouldAutoplay = YES;
        //moviePlayerController.moviePlayer.controlStyle = MPMovieControlStyleNone;
        [self.playerVC.moviePlayer prepareToPlay];
        [self.playerVC.moviePlayer play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:[self.playerVC moviePlayer]];
        
        [self presentMoviePlayerViewControllerAnimated:self.playerVC];
        
    }else if (sender.tag == 13){//播放语音
        [self playRecord];
    }else if (sender.tag == 14) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [_speakText becomeFirstResponder];
        }else{
            [_speakText resignFirstResponder];
            _textTag = 1;
            _speakText.text =@"";
        }
    }
}

//当点击Done按键或者播放完毕时调用此函数
- (void) playVideoFinished:(NSNotification *)theNotification {
    MPMoviePlayerController *player = [theNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [self.playerVC dismissMoviePlayerViewControllerAnimated];
    self.playerVC = nil;
}
#pragma mark --UITableView delegate datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pl_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 152;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDPostDetailsCell";
    GDPostDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDPostDetailsCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.cz_btn.tag = 10 + indexPath.row;
    [cell initWithCommentListObj:self.pl_array[indexPath.row]];
    
    __weak typeof(self) ws = self;
    cell.block = ^(NSInteger tag) {
        GDCommentListObj *obj = ws.pl_array[indexPath.row];
        if (obj.userId == [GDUtils readUser].userId) {//判断是自己评论的  删除评论
            [self deleteMyCommentId:obj.id CommId:0];
        }else{//回复评论
//            [self replyCommentId:obj.id];
            _commentObj = obj;
            ws.textTag = 2;
            [_speakText becomeFirstResponder];
            _speakText.text = [NSString stringWithFormat:@"回复%@：",obj.name];
        }
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GDCommentListObj *obj = self.pl_array[indexPath.row];
    GDReplyDetailsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDReplyDetails"];
    vc.commentObj = obj;
    vc.postDict = _postDict;
    [self.navigationController pushViewController:vc animated:YES];
}

//键盘上弹
-(void)openKeyboard:(NSNotification *)notification{
    CGRect keyboardFrame = [self keyboardFrame:notification];
    NSTimeInterval duration = [self duration:notification];
    UIViewAnimationOptions option = [self option:notification];
    _bottomCont.constant = keyboardFrame.size.height;
    [_jp_btn setImage:[UIImage imageNamed:@"module-jp"] forState:UIControlStateNormal];
    _jp_btn.selected = YES;
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:nil];
}
//恢复键盘
-(void)closeKeyboard:(NSNotification *)notification{
    
    NSTimeInterval duration = [self duration:notification];
    UIViewAnimationOptions option = [self option:notification];
    _bottomCont.constant = 0;
    [_jp_btn setImage:[UIImage imageNamed:@"module-jp2"] forState:UIControlStateNormal];
    _jp_btn.selected = NO;

    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:nil];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
   
    if (_textTag == 1) {//评论
        if (textField.text.length == 0) {
            [SVProgressHUD showImage:nil status:@"请输入内容"];
        }else{
            [self quickReplyArticle:textField.text ArticleId:_articleId];
        }
    }else{//回复评论
        if (textField.text.length == 0||[textField.text isEqualToString:[NSString stringWithFormat:@"回复%@：",_commentObj.name]]) {
            [SVProgressHUD showImage:nil status:@"请输入内容"];
        }else{
            [self replyCommentId:_commentObj.id];
        }
    }
    
    _textTag = 1;
    _speakText.text =@"";
    return YES;
}

-(void)playRecord{
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HOST,_audioFilePath]];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    
    //将数据保存到本地指定位置

    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.caf", docDirPath , @"temp"];
    if (filePath.length > 0) {
//        NSError *error = nil;
//        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }else{
        [audioData writeToFile:filePath atomically:YES];

    }
    
  
    NSLog(@"_fileURLsss-->%@",filePath);
   
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
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

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self suspendRecord];
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

-(NSMutableArray *)pl_array{
    if (!_pl_array) {
        _pl_array = [NSMutableArray array];
    }
    return _pl_array;
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
