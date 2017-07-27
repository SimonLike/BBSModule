

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
#import "GDSendPostVC.h"
#import "GDDeleteArticleRequest.h"

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
    GDMyArticleListRequest *request = [[GDMyArticleListRequest alloc] initWithRows:10 page:_page];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject-->%@",responseObject);
        if (responseObject) {
            
            [self.postsArray addObjectsFromArray:[GDMyArticleListObj objectArrayWithKeyValuesArray:responseObject[@"data"][@"articleList"]]];
            [_postTable reloadData];
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
    cell.tag = indexPath.row;
    
    [cell initWithMyArticleListObj:self.postsArray[indexPath.row]];
    __weak typeof(self)ws = self;
    cell.postsBlock = ^(NSInteger cellTag, NSInteger tag) {
        GDMyArticleListObj *obj = ws.postsArray[cellTag];
        if (tag == 10) {//编辑贴子
            GDSendPostVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDSendPost"];
            vc.vcType = @"editPost";
            vc.articleId = obj.id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除该帖子？" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                GDDeleteArticleRequest *request = [[GDDeleteArticleRequest alloc] initWithArticleId:obj.id];
                [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
                    if(responseObject){
                        DLog(@"responseObject-->%@",responseObject);
                        [_postTable.mj_header beginRefreshing];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [ws presentViewController:alertController animated:YES completion:nil];
            
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GDMyArticleListObj *obj = self.postsArray[indexPath.row];

    GDPostDetailsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDPostDetails"];
    vc.articleId = obj.id;
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
