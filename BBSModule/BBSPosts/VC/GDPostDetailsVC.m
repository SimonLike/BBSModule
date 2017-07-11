//
//  GDPostDetailsVC.m
//  BBSModule
//
//  Created by Simon on 2017/7/3.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDPostDetailsVC.h"
#import "GDPostDetailsCell.h"
#import "GDReplyDetailsVC.h"
#import "GDArticleDetailRequest.h"
#import "GDCommentListObj.h"

@interface GDPostDetailsVC ()
@property (weak, nonatomic) IBOutlet UIImageView *peoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *del_btn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contLabel;
@property (weak, nonatomic) IBOutlet UIView *videoBgView;
@property (weak, nonatomic) IBOutlet UIButton *yuyin_btn;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UITextField *speakText;
@property (weak, nonatomic) IBOutlet UIButton *jp_btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHit;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *pl_array;
@property (weak, nonatomic) IBOutlet UITableView *postTable;

@end

@implementation GDPostDetailsVC

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
   
    GDArticleDetailRequest *request = [[GDArticleDetailRequest alloc] initWithUserId:1 ArticleId:_articleId Rows:30 Page:1];
    [request requestDataWithsuccess:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject->%@",responseObject);
        if (responseObject) {
            NSDictionary *dict = responseObject[@"data"][@"article"];
            [_peoImage sd_setImageWithURL:[NSURL URLWithString:dict[@"head"]] placeholderImage:nil];
            _nameLabel.text = dict[@"name"];
            _timeLabel.text = dict[@"create_time"];
            _titleLab.text = dict[@"title"];
            _contLabel.text = dict[@"content"];
//            697 × 331
            CGFloat selfW = [UIScreen mainScreen].bounds.size.width - 48;

            if (![dict[@"video"] isEqualToString:@""]) {
                _videoBgView.hidden = NO;
                _contLabel.hidden = YES;
                _yuyin_btn.hidden = YES;
                self.imageTopCont.constant = selfW * 331 / 697 + 30;
            }else if (![dict[@"audio"] isEqualToString:@""]) {
                _videoBgView.hidden = YES;
                _contLabel.hidden = YES;
                _yuyin_btn.hidden = NO;
                self.imageTopCont.constant = 70;
            }else {
                CGSize labelsize = [GDUtils textHeightSize:_contLabel.text maxSize:CGSizeMake(selfW, 100) textFont:[UIFont systemFontOfSize:12]];
                self.imageTopCont.constant = labelsize.height + 30;
            }
            _commentLabel.text = [NSString stringWithFormat:@"%@人评论",dict[@"num"]];
            
            NSArray *arr = [GDCommentListObj objectArrayWithKeyValuesArray:responseObject[@"data"][@"commentList"]];
            [self.pl_array addObjectsFromArray:arr];
            _tableHit.constant = 152 * self.pl_array.count;

            [_postTable reloadData];
            DLog(@"arr--->%@",arr);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (IBAction)post_click:(UIButton *)sender {
    
    if (sender.tag == 14) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [_speakText becomeFirstResponder];
        }else{
            [_speakText resignFirstResponder];
        }
        
    }
}


#pragma mark --UITableView delegate datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pl_array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 152;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDPostDetailsCell";
    GDPostDetailsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDPostDetailsCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell initWithCommentListObj:self.pl_array[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GDReplyDetailsVC *vc = [[UIStoryboard storyboardWithName:@"BBSPosts" bundle:nil] instantiateViewControllerWithIdentifier:@"GDReplyDetails"];
    [self.navigationController pushViewController:vc animated:YES];
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
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(NSMutableArray *)pl_array{
    if (!_pl_array) {
        _pl_array = [NSMutableArray array];
    }
    return _pl_array;
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
