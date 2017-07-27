
//
//  GDReplyDetailsVC.m
//  BBSModule
//
//  Created by Simon on 2017/7/3.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDReplyDetailsVC.h"
#import "GDReplyDetailsCell.h"
#import "GDReplyDetailRequest.h"
#import "GDReplyListObj.h"
#import "GDReplyToReplyRequest.h"
#import "GDReplyCommentRequest.h"

@interface GDReplyDetailsVC ()
@property (weak, nonatomic) IBOutlet UITableView *replyTable;
@property (assign, nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray *replyArray;
@property (weak, nonatomic) IBOutlet UIImageView *peoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *hfpl_btn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCont;
@property (weak, nonatomic) IBOutlet UITextField *speakText;
@property (weak, nonatomic) IBOutlet UIButton *jp_btn;

@property (assign, nonatomic) NSInteger textTag;
@property (copy, nonatomic) GDReplyListObj *selectObj;
@end

@implementation GDReplyDetailsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addKeyboardNotification];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotification];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _textTag = 1;
    [_peoImage sd_setImageWithURL:[NSURL URLWithString:PEO_HEAD_PIC(_commentObj.username)] placeholderImage:nil];
    _nameLabel.text = _commentObj.name;
    _timeLabel.text = _commentObj.create_time;
    _commentLabel.text = _commentObj.content;
    
    [GDUtils setupRefresh:_replyTable WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
    
    [self.replyTable.mj_header beginRefreshing];
}
- (IBAction)jp_click:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_speakText becomeFirstResponder];
    }else{
        [_speakText resignFirstResponder];
        _textTag = 1;
        _speakText.text =@"";
    }
}
- (IBAction)hfplClick:(id)sender {
    [_speakText becomeFirstResponder];
}

#pragma mark - MJRefresh Delegate

//上拉刷新
-(void)headerRefresh{
    _page = 1;
    [self.replyArray removeAllObjects];
    [self getReplyDetail];
    
}
//下拉加载更多
-(void)footerRefresh{
    _page = _page + 1;
    [self getReplyDetail];
}
#pragma  mark --Request
-(void)getReplyDetail{
    
    GDReplyDetailRequest *request = [[GDReplyDetailRequest alloc] initWithCommentId:_commentObj.id Page:_page Rows:10];
    
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject--->%@",responseObject);
        if (responseObject) {
            
            [self.replyArray addObjectsFromArray:[GDReplyListObj objectArrayWithKeyValuesArray:responseObject[@"data"][@"replyList"]]];
            [_replyTable reloadData];
        }
        [_replyTable.mj_header endRefreshing];
        [_replyTable.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [_replyTable.mj_header endRefreshing];
        [_replyTable.mj_footer endRefreshing];
    }];
}
-(void)replyCommentId:(NSInteger)commentId{
    
    GDReplyCommentRequest *request = [[GDReplyCommentRequest alloc] initWithArticleId:[_postDict[@"id"] integerValue]
                                                                            CommentId:commentId
                                                                                Title:_postDict[@"title"]
                                                                               Attach:@""
                                                                              Content:_speakText.text];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            DLog(@"responseObject-->%@",responseObject);
            [self.replyTable.mj_header beginRefreshing];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)replyToReplyCommentId:(NSInteger)commentId {
    GDReplyToReplyRequest * request=[[GDReplyToReplyRequest alloc] initWithCommentId:commentId
                                                                           ArticleId:[_postDict[@"id"] integerValue]
                                                                            TargetId:_selectObj.uId
                                                                          TargetName:_selectObj.name
                                                                               Title:_postDict[@"title"]
                                                                              Attach:@""
                                                                             Content:_speakText.text];
    
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            DLog(@"responseObject-->%@",responseObject);
            [self.replyTable.mj_header beginRefreshing];
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
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDReplyDetailsCell";
    GDReplyDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDReplyDetailsCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    [cell initWithReplyListObj:self.replyArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectObj = self.replyArray[indexPath.row];
    _textTag = 2;
    _speakText.text = [NSString stringWithFormat:@"回复%@：",_selectObj.name];
    [_speakText becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
   
    if (_textTag == 1) {//评论
        if (textField.text.length == 0) {
            [SVProgressHUD showImage:nil status:@"请输入内容"];
        }else{
            [self replyCommentId:_commentObj.id];
        }
        
    }else{//回复评论
        if (textField.text.length == 0 || [textField.text isEqualToString:[NSString stringWithFormat:@"回复%@：",_commentObj.name]]) {
            [SVProgressHUD showImage:nil status:@"请输入内容"];

        }else{
            [self replyToReplyCommentId:_commentObj.id];
        }
    }
    _textTag = 1;
    _speakText.text =@"";
    return YES;
}

//键盘上弹
-(void)openKeyboard:(NSNotification *)notification{
    CGRect keyboardFrame = [self keyboardFrame:notification];
    NSTimeInterval duration = [self duration:notification];
    UIViewAnimationOptions option = [self option:notification];
    _bottomCont.constant = keyboardFrame.size.height;
    [_jp_btn setImage:[UIImage imageNamed:@"module-jp"] forState:UIControlStateNormal];
    _jp_btn.selected = YES;
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:nil];
}
//恢复键盘
-(void)closeKeyboard:(NSNotification *)notification{
    
    NSTimeInterval duration = [self duration:notification];
    UIViewAnimationOptions option = [self option:notification];
    _bottomCont.constant = 0;
    [_jp_btn setImage:[UIImage imageNamed:@"module-jp2"] forState:UIControlStateNormal];
    _jp_btn.selected = NO;
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.bottomView layoutIfNeeded];
    } completion:nil];
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
