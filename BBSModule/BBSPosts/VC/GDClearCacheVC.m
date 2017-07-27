//
//  GDClearCacheVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDClearCacheVC.h"
#import "GDClearCacheCell.h"

@interface GDClearCacheVC (){
    UIImageView *_dxkImageView;
    UILabel *_label_size;
    float _allcache;
    BOOL  _allBool;
}
@property (weak, nonatomic) IBOutlet UITableView *cacheTable;
@property (nonatomic, strong) NSArray *cacheArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;//选中项所用数组
@property (nonatomic, strong) NSMutableArray *cacheSizeArray;//

@end

@implementation GDClearCacheVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _cacheArray = @[@"图片",@"视频",@"语音"];
    // Do any additional setup after loading the view.
    
    //图片
    float picF = [[NSString stringWithFormat:@"%lu",(unsigned long)[[SDImageCache sharedImageCache] getSize]] floatValue];
    [self.cacheSizeArray addObject:[NSString stringWithFormat:@"%.2f",picF]];
   
    //视频
    NSString *cachePath = [NSTemporaryDirectory() stringByAppendingString:@"MediaCache"];
    float videoF = [[NSString stringWithFormat:@"%.2f",[self folderSizeAtPath:cachePath]] floatValue];
    [self.cacheSizeArray addObject:[NSString stringWithFormat:@"%.2f",videoF]];
    
    //语音
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    float audioF = [[NSString stringWithFormat:@"%.2f",[self folderSizeAtPath:docDirPath]] floatValue];
    [self.cacheSizeArray addObject:[NSString stringWithFormat:@"%.2f",audioF]];

    //全部
    _allcache = videoF + picF + audioF;

}

- (IBAction)delCache:(id)sender {
    for (NSString *str in  self.selectedArray) {
        if ([str isEqualToString:@"图片"]) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [self.cacheSizeArray replaceObjectAtIndex:0 withObject:@"0.00"];
            }];
        }else if ([str isEqualToString:@"视频"]){
            NSString *cachePath = [NSTemporaryDirectory() stringByAppendingString:@"MediaCache"];
            if([self clearCacheWithFilePath:cachePath]){
                [self.cacheSizeArray replaceObjectAtIndex:1 withObject:@"0.00"];
            }
        }else if ([str isEqualToString:@"语音"]){
            NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            if([self clearCacheWithFilePath:docDirPath]){
                [self.cacheSizeArray replaceObjectAtIndex:2 withObject:@"0.00"];
            }
        }
    }
    
    [_cacheTable reloadData];
}

// 显示缓存大小
-( float )filePath
{
    NSString * cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES ) firstObject];
    DLog(@"cachPath--->%@",cachPath);
    return [ self folderSizeAtPath :cachPath];
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}

- (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
    
}

#pragma mark - 清除path文件夹下缓存大小
- (BOOL)clearCacheWithFilePath:(NSString *)path{
    
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}



#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cacheArray.count;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, tableView.frame.size.width, 57);
    UIImage *dxkImage = [UIImage imageNamed:@"module-dxk"];
    
    _dxkImageView = [[UIImageView alloc] init];
    _dxkImageView.frame = CGRectMake(13, (header.height - dxkImage.size.height)/2 , dxkImage.size.width, dxkImage.size.height);
    _dxkImageView.image = dxkImage;
    [header addSubview:_dxkImageView];
    if (_allBool) {
        _dxkImageView.image = [UIImage imageNamed:@"module-selecteddxk"];
    }else{
        _dxkImageView.image = dxkImage;
    }
    
    _label_size = [[UILabel alloc] init];
    _label_size.frame = CGRectMake(header.width - 113, (header.height - 16)/2 , 100, 16);
    _label_size.font = [UIFont systemFontOfSize:14];
    _label_size.textColor = RGBCOLOR16(0x666666);
    _label_size.textAlignment = NSTextAlignmentRight;
    _label_size.text = [NSString stringWithFormat:@"%.2fM",_allcache];
    [header addSubview:_label_size];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(_dxkImageView.frame.size.width + 25, (header.height - 16)/2 , 120, 16);
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGBCOLOR16(0x333333);
    label.text = @"全选";
    [header addSubview:label];

    UIImageView *xian = [[UIImageView alloc] init];
    xian.frame = CGRectMake(13, header.height - 1 , header.width - 26, 1);
    xian.backgroundColor = RGBCOLOR16(0xdddddd);
    [header addSubview:xian];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerRecognizer)];
    [header addGestureRecognizer:tap];
    
    return header;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"GDClearCacheCell";
    GDClearCacheCell *cell = (GDClearCacheCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil] firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = _cacheArray[indexPath.row];
    cell.cacheLabel.text = [NSString stringWithFormat:@"%@M",_cacheSizeArray[indexPath.row]];
    
    if ([self.selectedArray containsObject: _cacheArray[indexPath.row]]) {
        cell.selectImage.image = [UIImage imageNamed:@"module-selecteddxk"];
    }else{
        cell.selectImage.image = [UIImage imageNamed:@"module-dxk"];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 57;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *curstr = _cacheArray[indexPath.row];

    if ([self.selectedArray containsObject: curstr]) {
        [self.selectedArray removeObject:curstr];
        _allBool = NO;
    }else{
        [self.selectedArray addObject:curstr];
    }
    [_cacheTable reloadData];

}
//取消tableView选中 点击事件
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
  
//    NSString *curstr = _cacheArray[indexPath.row];
//    NSArray *array = [self.selectedArray mutableCopy];
//    for (NSString *str in array) {
//        if ([str isEqualToString:curstr]) {
//            [self.selectedArray removeObject:str];
//        }
//    }
////    [_cacheTable reloadData];
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)headerRecognizer{
    [self.selectedArray removeAllObjects];

    if (_allBool) {
        _allBool = NO;
    }else{
        [self.selectedArray addObjectsFromArray:_cacheArray];
        _allBool = YES;
    }
    
    [_cacheTable reloadData];
}

-(NSMutableArray *)cacheSizeArray{
    if (!_cacheSizeArray) {
        _cacheSizeArray = [NSMutableArray array];
    }
    return _cacheSizeArray;
}
-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
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
