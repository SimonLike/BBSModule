
//
//  GDOCJSWebViewVC.m
//  BBSModule
//
//  Created by Simon on 2017/8/14.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDOCJSWebViewVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SGImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "GDRecordVideoVC.h"

@interface GDOCJSWebViewVC ()<UIWebViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    NSURL *_videoFilePath;////拍摄 本地视频地址url

}
@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)JSContext *jscontext;
@property (nonatomic, strong)NSMutableArray *picspathArr;
@property (strong, nonatomic) UIImagePickerController *imagePicker;//视频选择器  相册相机

@end

@implementation GDOCJSWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OCAndJS";
    // Do any additional setup after loading the view.
    [self loadHtml];
}

- (void)loadHtml {
    //创建webview
    CGRect webViewRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
    self.webView = [[UIWebView alloc] initWithFrame:webViewRect];
    self.webView.backgroundColor = [UIColor lightGrayColor];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    //webview加载html
//    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"native" ofType:@"html"];
    //    NSURL *url = [NSURL fileURLWithPath:htmlPath];

    NSString *htmlPath = @"http://139.196.41.31/GDH5";
    NSURL *url = [NSURL URLWithString:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

//在webview加载完成后，调用js文件中的方法，
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // init初始化JSContext对象
    _jscontext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self)weakSelf = self;//避免循环引用 弱化
    
    _jscontext[@"getPics"] = ^(JSValue *value){
        
        
        SGImagePickerController *picker = [SGImagePickerController new];
        //返回选择的缩略图
        [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
            NSLog(@"缩略图%@",thumbnails);
            if (self.picspathArr.count > 8) {
                [SVProgressHUD showImage:nil status:@"最多上传9张照片"];
                return ;
            }
            //            [self uploadIma:thumbnails];
            [weakSelf.picspathArr addObjectsFromArray:thumbnails];
            
            NSString *nativeFile=@"nativeFile({'type':1,'data':[1,2,3]})"; //准备执行的js代码
            [weakSelf.jscontext evaluateScript:nativeFile];//通过oc方法调用js的alert
        }];
        [weakSelf presentViewController:picker animated:YES completion:nil];
    };
    _jscontext[@"takePic"] = ^(JSValue *value){
        DLog(@"takePic");
    };
    
    
    _jscontext[@"jscandoiOS"] = ^(JSValue *value){
        NSInteger strInt = value.toString.integerValue;//把接收到的JSValue对象转换OC中的NSString类型
       
        dispatch_async(dispatch_get_main_queue(), ^{//在GCD中 进行异步操作
            
            if (strInt == 1) {//相机
                 [weakSelf pickImageFromCamera];
            }else if (strInt == 2) {//相册
                SGImagePickerController *picker = [SGImagePickerController new];
                //返回选择的缩略图
                [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
                    NSLog(@"缩略图%@",thumbnails);
                    if (self.picspathArr.count > 8) {
                        [SVProgressHUD showImage:nil status:@"最多上传9张照片"];
                        return ;
                    }
                    //            [self uploadIma:thumbnails];
                    [weakSelf.picspathArr addObjectsFromArray:thumbnails];
                    
                    NSString *nativeFile=@"nativeFile({'type':1,'data':[1,2,3]})"; //准备执行的js代码
                    [weakSelf.jscontext evaluateScript:nativeFile];//通过oc方法调用js的alert
                }];
                [weakSelf presentViewController:picker animated:YES completion:nil];
            }else if (strInt == 3) {//拍摄视频
                GDRecordVideoVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDRecordVideo"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
                vc.recordBlock = ^(NSURL *url) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                    NSURL *newVideoUrl ; //一般.mp4
                    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
                    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
                    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
                    
                    [weakSelf convertVideoQuailtyWithInputURL:url outputURL:newVideoUrl completeHandler:nil];
                    
                };
            }else if (strInt == 4) {//本地视频
                [weakSelf presentViewController:weakSelf.imagePicker animated:YES completion:nil];
            }else if (strInt == 5) {//开始录音
            }else if (strInt == 6) {//停止录音
            }
            
        });
    };
}

-(void)addImagePicker{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self pickImageFromCamera];
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        SGImagePickerController *picker = [SGImagePickerController new];
        //返回选择的缩略图
        [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
            NSLog(@"缩略图%@",thumbnails);
            if (self.picspathArr.count > 8) {
                [SVProgressHUD showImage:nil status:@"最多上传9张照片"];
                return ;
            }
//            [self uploadIma:thumbnails];
        }];
        [self presentViewController:picker animated:YES completion:nil];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
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
            
            DLog(@"shipinfilePath--->%@-->%@",newVideoUrl,[sourceURL absoluteString]);
//            DLog(@"qiansourceURL---->%.2fMB",[self fileSize:sourceURL]);
            [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
            
        }];

    }
    
}
#pragma mark - 视频压缩
- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}
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
                DLog(@"hou---->%.2fMB",[self fileSize:_videoFilePath]);
                
//                [self uploadVideo:outputURL];
                break;
            }
            case AVAssetExportSessionStatusFailed:DLog(@"Failed");
                
                break;
        }
    }];
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
