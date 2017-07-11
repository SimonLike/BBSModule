//
//  GDClearCacheVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDClearCacheVC.h"
#import "GDClearCacheCell.h"

@interface GDClearCacheVC ()
@property (weak, nonatomic) IBOutlet UITableView *cacheTable;
@property (nonatomic, strong) NSArray *cacheArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;//选中项所用数组

@end

@implementation GDClearCacheVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _cacheArray = @[@"全选",@"图片",@"视频",@"语音"];
    // Do any additional setup after loading the view.
}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cacheArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"GDClearCacheCell";
    GDClearCacheCell *cell = (GDClearCacheCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil] firstObject];
    }
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = _cacheArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.selectedArray addObject:_cacheArray[indexPath.row]];
}
//取消tableView选中 点击事件
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSString *curstr = _cacheArray[indexPath.row];
    NSArray *array = [self.selectedArray mutableCopy];
    for (NSString *str in array) {
        if ([str isEqualToString:curstr]) {
            [self.selectedArray removeObject:str];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
