//
//  GDModuleHomeCell.h
//  BBSModule
//
//  Created by Simon on 2017/6/27.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDArticleListObj.h"
#import "HRPicCollectionView.h"

typedef void(^ModuleHomeBlock)(NSInteger tag);

@interface GDModuleHomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *peoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tltLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tltTopCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tltBtmCont;
@property (weak, nonatomic) IBOutlet UIImageView *tltBtmImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contTopCont;
@property (weak, nonatomic) IBOutlet UILabel *contLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yunyinTopCont;
@property (weak, nonatomic) IBOutlet UIImageView *yuyinImage;

@property (weak, nonatomic) IBOutlet HRPicCollectionView *picView;
@property (nonatomic, strong)NSMutableArray *picspathArr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewHit;

@property (weak, nonatomic) IBOutlet UIView *videoView;
@property (weak, nonatomic) IBOutlet UIButton *pl_btn;
@property (weak, nonatomic) IBOutlet UIButton *hf_btn;
@property (weak, nonatomic) IBOutlet UIButton *edit_btn;
@property (weak, nonatomic) IBOutlet UIButton *del_btn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, assign) CGFloat heights;
@property (nonatomic, copy) ModuleHomeBlock moduleBlock;

- (void) initWithArticleListObj:(GDArticleListObj *)obj;

@end
