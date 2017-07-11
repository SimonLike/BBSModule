

//
//  GDMyPostsVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/30.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDMyPostsVC.h"
#import "GDMyPostsCell.h"
#import "GDPostDetailsVC.h"
#import "GDMyArticleListRequest.h"
#import "GDMyArticleListObj.h"

@interface GDMyPostsVC ()
@property (weak, nonatomic) IBOutlet UITableView *postTable;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *postsArray;

@end

@implementation GDMyPostsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [GDUtils setupRefresh:_postTable WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
    
    [_postTable.mj_header beginRefreshing];
}


#pragma mark - MJRefresh Delegate

//上拉刷新
-(void)headerRefresh{
    _page = 1;
    [self.postsArray removeAllObjects];
    [self getMyArticleList];
    
}
//下拉加载更多
-(void)footerRefresh{
    _page = _page + 1;
    [self getMyArticleList];
}
-(void)getMyArticleList{
    GDMyArticleListRequest *request = [[GDMyArticleListRequest alloc] initWithUserId:1 rows:10 page:1];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject-->%@",responseObject);
        if (responseObject) {
            
            [self.postsArray addObjectsFromArray:[GDMyArticleListObj objectArrayWithKeyValuesArray:responseObject[@"data"][@"articleList"]]];
        }
        [_postTable.mj_header endRefreshing];
        [_postTable.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_postTable.mj_header endRefreshing];
        [_postTable.mj_footer endRefreshing];
    }];
}

#pragma mark --UITableView delegate datasoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDMyPostsCell";
    GDMyPostsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDMyPostsCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell initWithMyArticleListObj:self.postsArray[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GDPostDetailsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDPostDetails"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSMutableArray *)postsArray{
    if (!_postsArray) {
        _postsArray = [NSMutableArray array];
    }
    return _postsArray;
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
