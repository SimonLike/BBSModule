
//
//  GD_MyselfVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/28.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GD_MyselfVC.h"
#import "GD_MyselfCell.h"
#import "GDCallMeRequest.h"
#import "GDCallMeObj.h"
#import "GDPostDetailsVC.h"
#import "GDDeleteCallMeRequest.h"

@interface GD_MyselfVC ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (assign, nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray *callArray;
@end

@implementation GD_MyselfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"清空" forState:UIControlStateNormal];
    
    [GDUtils setupRefresh:_table WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
    
    [self.table.mj_header beginRefreshing];
}

-(void)rightAction{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
  
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        GDDeleteCallMeRequest *request = [[GDDeleteCallMeRequest alloc] init];
        [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
            if (responseObject) {
                DLog(@"responseObject->%@",responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - MJRefresh Delegate

//上拉刷新
-(void)headerRefresh{
    _page = 1;
    [self.callArray removeAllObjects];
    [self getCallMeRequest];
    
}
//下拉加载更多
-(void)footerRefresh{
    _page = _page + 1;
    [self getCallMeRequest];
}
-(void)getCallMeRequest{

    GDCallMeRequest *request = [[GDCallMeRequest alloc] initWithRows:10 page:_page];
    
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject--->%@",responseObject);
        if (responseObject) {
            
            [self.callArray addObjectsFromArray:[GDCallMeObj objectArrayWithKeyValuesArray:responseObject[@"data"][@"callMeList"]]];
        }
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_table.mj_header endRefreshing];
        [_table.mj_footer endRefreshing];
    }];
}

#pragma mark --UITableView delegate datasoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.callArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GD_MyselfCell";
    GD_MyselfCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GD_MyselfCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell initWithCallMeObj:self.callArray[indexPath.row]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GDCallMeObj *obj = self.callArray[indexPath.row];
    
    GDPostDetailsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDPostDetails"];
    vc.articleId = obj.article_id;
    [self.navigationController pushViewController:vc animated:YES];

}

-(NSMutableArray *)callArray{
    if (!_callArray) {
        _callArray = [NSMutableArray array];
    }
    return _callArray;
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
