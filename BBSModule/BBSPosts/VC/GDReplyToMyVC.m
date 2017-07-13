
//
//  GDReplyToMyVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDReplyToMyVC.h"
#import "GDReplyToMyCell.h"
#import "GDReplyMeRequest.h"
#import "GDDeleteReplyMeRequest.h"
#import "GDReplyMeObj.h"

@interface GDReplyToMyVC ()
@property (weak, nonatomic) IBOutlet UITableView *replyTable;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *replyArray;
@end

@implementation GDReplyToMyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [GDUtils setupRefresh:_replyTable WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
    [_replyTable.mj_header beginRefreshing];
}

#pragma mark - MJRefresh Delegate
//上拉刷新
-(void)headerRefresh{
    _page = 1;
    [self.replyArray removeAllObjects];
    [self getReplyMe];
    
}
//下拉加载更多
-(void)footerRefresh{
    _page = _page + 1;
    [self getReplyMe];
}
#pragma mark - request
-(void)getReplyMe{
    GDReplyMeRequest *request = [[GDReplyMeRequest alloc] initWithPage:_page Rows:10];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            [self.replyArray addObjectsFromArray:[GDReplyMeObj objectArrayWithKeyValuesArray:responseObject[@"data"][@"replyList"]]];
            [_replyTable reloadData];
        }
        [_replyTable.mj_header endRefreshing];
        [_replyTable.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_replyTable.mj_header endRefreshing];
        [_replyTable.mj_footer endRefreshing];
    }];
}
-(void)deleteDeleteReplyMe{
    GDDeleteReplyMeRequest *request = [[GDDeleteReplyMeRequest alloc] init];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            [self getReplyMe];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark --UITableView delegate datasoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDReplyToMyCell *cell = (GDReplyToMyCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.heights;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDReplyToMyCell";
    GDReplyToMyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDReplyToMyCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell initWithReplyMeObj:self.replyArray[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(NSMutableArray *)replyArray{
    if (!_replyArray) {
        _replyArray = [NSMutableArray array];
    }
    return _replyArray;
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
