//
//  GDRitView.h
//  BBSModule
//
//  Created by Simon on 2017/6/29.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RitBlock)(NSInteger tag);

@interface GDRitView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ritTable;
@property (nonatomic, strong) NSArray *ritArray;
@property (nonatomic, copy) RitBlock ritBlock;

+(instancetype) initRitView;
@end
