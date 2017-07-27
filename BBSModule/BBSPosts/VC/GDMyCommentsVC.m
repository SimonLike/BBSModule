
//
//  GDMyCommentsVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDMyCommentsVC.h"
#import "GDMyCommentsCell.h"
#import "GDMyCommentRequest.h"
#import "GDDeleteMyCommentRequest.h"
#import "GDMyCommentObj.h"

@interface GDMyCommentsVC ()
@property (weak, nonatomic) IBOutlet UITableView *commentTable;
@property (strong, nonatomic) NSMutableArray *commetArray;
@property (assign, nonatomic) NSInteger page;

@end

@implementation GDMyCommentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [GDUtils setupRefresh:_commentTable WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
    [_commentTable.mj_header beginRefreshing];
}


#pragma mark - MJRefresh Delegate
//上拉刷新
-(void)headerRefresh{
    _page = 1;
    [self.commetArray removeAllObjects];
    [self getMyComment];
    
}
//下拉加载更多
-(void)footerRefresh{
    _page = _page + 1;
    [self getMyComment];
}
#pragma mark - request
-(void)getMyComment{
    GDMyCommentRequest *request = [[GDMyCommentRequest alloc] initWithPage:_page Rows:10];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            [self.commetArray addObjectsFromArray:[GDMyCommentObj objectArrayWithKeyValuesArray:responseObject[@"data"][@"myCommentList"]]];
            [_commentTable reloadData];
        }
        [_commentTable.mj_header endRefreshing];
        [_commentTable.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_commentTable.mj_header endRefreshing];
        [_commentTable.mj_footer endRefreshing];
    }];
}
-(void)deleteMyCommentId:(NSInteger)commentId CommId:(NSInteger)commId{
   GDDeleteMyCommentRequest *request = [[GDDeleteMyCommentRequest alloc] initWithCommentId:commentId CommId:commId];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            [_commentTable.mj_header beginRefreshing];
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
    return self.commetArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDMyCommentsCell *cell = (GDMyCommentsCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.heights;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDMyCommentsCell";
    GDMyCommentsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDMyCommentsCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.del_btn.tag = 100 + indexPath.row;
    [cell initWithMyCommentObj:self.commetArray[indexPath.row]];
    
    __weak typeof(self)ws = self;
    cell.deleteBlock = ^(NSInteger cellTag) {
        GDMyCommentObj *obj = ws.commetArray[cellTag - 100];
        [ws deleteMyCommentId:obj.id CommId:obj.commId];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(NSMutableArray *)commetArray{
    if (!_commetArray) {
        _commetArray = [NSMutableArray array];
    }
    return _commetArray;
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
