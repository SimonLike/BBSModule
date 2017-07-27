//
//  GDChooseFriendVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDChooseFriendVC.h"
#import "GDChooseFriendCell.h"
#import "GDCallFriendRequest.h"
#import "GDCallFriendObj.h"

@interface GDChooseFriendVC ()
@property (weak, nonatomic) IBOutlet UITableView *cf_table;
@property (nonatomic ,strong) NSArray *friendArr;
@property (nonatomic ,strong) NSMutableArray *selectArr;
@end

@implementation GDChooseFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"确定" forState:UIControlStateNormal];
    _cf_table.allowsMultipleSelection = YES;
    GDCallFriendRequest *request = [[GDCallFriendRequest alloc] init];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            _friendArr = [GDCallFriendObj objectArrayWithKeyValuesArray:responseObject[@"callList"]];
            [_cf_table reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)rightAction{
    if (_callblock) {
        _callblock(self.selectArr);
    }

}

#pragma mark --UITableView delegate datasoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDChooseFriendCell";
    GDChooseFriendCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDChooseFriendCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    GDCallFriendObj *obj = _friendArr[indexPath.row];
    cell.nameLabel.text = obj.name;
    [cell.txImage sd_setImageWithURL:[NSURL URLWithString:PEO_HEAD_PIC(obj.username)] placeholderImage:nil];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.selectArr addObject:_friendArr[indexPath.row]];
}
//取消tableView选中 点击事件
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GDCallFriendObj *curobj  = _friendArr[indexPath.row];
    NSArray *array = [self.selectArr mutableCopy];
    for (GDCallFriendObj *obj  in array) {
        if (curobj.callId == obj.callId) {
            [self.selectArr removeObject:obj];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
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
