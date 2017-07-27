
//
//  GDRitView.m
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDRitView.h"
#import "GDRitCell.h"

@implementation GDRitView

-(void)awakeFromNib{
    [super awakeFromNib];
    _ritTable.delegate = self;
    _ritTable.dataSource = self;
    _ritTable.layer.borderWidth = 1;
    _ritTable.layer.borderColor = RGBCOLOR16(0xeeeeee).CGColor;
    _ritTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _ritArray = @[@"回复我的",@"@我的",@"我的评论",@"个人中心"];
}

+(instancetype) initRitView{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"GDRitView" owner:nil options:nil];
    return [objs firstObject];
}
- (IBAction)btnClick:(id)sender {
    self.hidden = YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ritArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GDRitCell";
    GDRitCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"GDRitCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.label.text = _ritArray[indexPath.row];
    if (indexPath.row==0) {
        if (_replyNum.integerValue >0) {
            cell.dianImage.hidden = NO;
        }
    }else if(indexPath.row == 1){
        if (_callNum.integerValue > 0) {
            cell.dianImage.hidden = NO;
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_ritBlock) {
        _ritBlock(indexPath.row);
    }
}

@end
