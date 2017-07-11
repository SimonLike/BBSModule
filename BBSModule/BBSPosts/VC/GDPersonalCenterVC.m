
//
//  GDPersonalCenterVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDPersonalCenterVC.h"
#import "GDPersonalCenterCell.h"
#import "GDMyPostsVC.h"
#import "GDClearCacheVC.h"


@interface GDPersonalCenterVC ()
@property (nonatomic, strong) NSArray *personalArray;

@end

@implementation GDPersonalCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _personalArray = @[@"我的帖子",@"清除缓存"];
}
#pragma mark --UITableView delegate datasoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _personalArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDPersonalCenterCell";
    GDPersonalCenterCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDPersonalCenterCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.label.text = _personalArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        GDMyPostsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDMyPosts"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        GDClearCacheVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDClearCache"];
        [self.navigationController pushViewController:vc animated:YES];
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
