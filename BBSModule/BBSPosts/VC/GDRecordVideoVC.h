//
//  GDRecordVideoVC.h
//  BBSModule
//
//  Created by Simon on 2017/7/6.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^RecordBlock)(NSString *videoPath);
@interface GDRecordVideoVC : BaseViewController

@property (nonatomic, copy)RecordBlock recordBlock;

@end
