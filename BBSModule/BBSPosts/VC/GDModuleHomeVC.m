    //
//  GDModuleHomeVC.m
//  BBSModule
//
//  Created by Simon on 2017/6/27.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDModuleHomeVC.h"
#import "GDModuleHomeCell.h"
#import "GDRitView.h"
#import "GD_MyselfVC.h"
#import "GDReplyToMyVC.h"
#import "GDMyCommentsVC.h"
#import "GDSendPostVC.h"
#import "GDPersonalCenterVC.h"
#import "GDArticleListRequest.h"
#import "GDArticleListObj.h"
#import "GDPostDetailsVC.h"
#import "GDReplyDetailsVC.h"
#import "GDDeleteArticleRequest.h"
#import "GDTextAlertView.h"
#import "GDQuickReplyArticleRequest.h"

@interface GDModuleHomeVC (){
    
}
@property (weak, nonatomic) IBOutlet UITableView *moduleTable;
@property (strong, nonatomic) GDRitView *ritView;
@property (strong, nonatomic) NSMutableArray *moduleArray;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) GDTextAlertView *textAlertView;
@end

@implementation GDModuleHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBtnleft.hidden = YES;
    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    detailButton.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [detailButton setImage:[UIImage imageNamed:@"module_rit"] forState:UIControlStateNormal];
    [detailButton setImage:[UIImage imageNamed:@"module_rit"] forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(showRoomContact) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    
    [GDUtils setupRefresh:_moduleTable WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
    _page = 1;

    [self getArticleList];
}
#pragma mark - MJRefresh Delegate

//上拉刷新
-(void)headerRefresh{
    _page = 1;
    [self.moduleArray removeAllObjects];
    [self getArticleList];

}
//下拉加载更多
-(void)footerRefresh{
    _page = _page + 1;
    [self getArticleList];
}

-(void)getArticleList{
    GDArticleListRequest *request = [[GDArticleListRequest alloc] initWithRows:10 Page:_page];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject--->%@",responseObject);
        if (responseObject) {
            [self.moduleArray addObjectsFromArray:[GDArticleListObj objectArrayWithKeyValuesArray: responseObject[@"data"][@"articleList"]]];
            [self.moduleTable reloadData];
        }
        
        [_moduleTable.mj_header endRefreshing];
        [_moduleTable.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_moduleTable.mj_header endRefreshing];
        [_moduleTable.mj_footer endRefreshing];
    }];
}
-(void)quickReplyArticle:(NSString *)text ArticleId:(NSInteger)articleId{
    GDQuickReplyArticleRequest *request = [[GDQuickReplyArticleRequest alloc] initWithArticleId:articleId content:text];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            //请空回复输入框 赋默认值
            _textAlertView.textView.text = @"请输入文字";
            
            [self getArticleList];//刷新首页状态
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//右边按钮点击事件
-(void)showRoomContact{
    if (_ritView == nil) {
        _ritView = [GDRitView initRitView];
        _ritView.frame = self.view.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:_ritView];
    }
    _ritView.hidden = NO;
    __weak typeof(self) ws = self;

    _ritView.ritBlock = ^(NSInteger tag) {
        
        if (tag == 0) {//@"回复我的"
            GDReplyToMyVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDReplyToMy"];
            [ws.navigationController pushViewController:vc animated:YES];
        }else if (tag == 1){//,@"@我的"
            GD_MyselfVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GD_Myself"];
            [ws.navigationController pushViewController:vc animated:YES];
        }else if (tag == 2){//,@"我的评论"
            GDMyCommentsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDMyComments"];
            [ws.navigationController pushViewController:vc animated:YES];
        }else if (tag == 3){//,发布帖子
            GDSendPostVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDSendPost"];
            [ws.navigationController pushViewController:vc animated:YES];
        }else if (tag == 4){//,个人中心
            GDPersonalCenterVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDPersonalCenter"];
            [ws.navigationController pushViewController:vc animated:YES];
        }
        ws.ritView.hidden = YES;

    };
    
//    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideritView)];
//    backTap.numberOfTapsRequired = 1;
//    [_ritView addGestureRecognizer:backTap];
    
}
//隐藏菜单
//-(void)hideritView{
//    _ritView.hidden = YES;
//}
#pragma mark --UITableView delegate datasoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moduleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDArticleListObj *obj = self.moduleArray[indexPath.row];
    if (![obj.video isEqualToString:@""]) {
        return 370;
    }else if (![obj.audio isEqualToString:@""]) {
        return 242;
    }else {
        GDModuleHomeCell *cell = (GDModuleHomeCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.heights;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDModuleHomeCell";
    GDModuleHomeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDModuleHomeCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    GDArticleListObj *obj = self.moduleArray[indexPath.row];
    [cell initWithArticleListObj:obj];
    
    __weak typeof(self)ws = self;
    cell.moduleBlock = ^(NSInteger tag) {
        if (tag == 10) {//评论
            GDMyCommentsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDMyComments"];
            [ws.navigationController pushViewController:vc animated:YES];
        }else if (tag == 11) {//回复
//            GDReplyDetailsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDReplyDetails"];
//            [ws.navigationController pushViewController:vc animated:YES];
            if (!ws.textAlertView) {
                ws.textAlertView = [GDTextAlertView initTextAlertView];
                ws.textAlertView.frame = self.view.bounds;
                ws.textAlertView.bt_label.text = @"快速回复";
                [self.view addSubview:ws.textAlertView];
            }
            ws.textAlertView.hidden = NO;
            
            ws.textAlertView.block = ^(NSInteger tag,NSString *text) {
                if (tag == 11) {//确定
                    DLog(@"text--->%@",text);
                    [self quickReplyArticle:text ArticleId:obj.id];
                }
                ws.textAlertView.hidden = YES;

            };
            
        }else if (tag == 12) {//编辑
            GDSendPostVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDSendPost"];
            vc.vcType = @"editPost";
            vc.articleId = obj.id;
            [ws.navigationController pushViewController:vc animated:YES];
        }else if (tag == 13) {//删除
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除该帖子？" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                GDDeleteArticleRequest *request = [[GDDeleteArticleRequest alloc] initWithArticleId:obj.id];
                [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
                    if(responseObject){
                        DLog(@"responseObject-->%@",responseObject);
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
    GDArticleListObj *obj = self.moduleArray[indexPath.row];

    GDPostDetailsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDPostDetails"];
    vc.articleId = obj.id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSMutableArray *)moduleArray{
    if (!_moduleArray) {
        _moduleArray = [NSMutableArray array];
    }
    return _moduleArray;
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
