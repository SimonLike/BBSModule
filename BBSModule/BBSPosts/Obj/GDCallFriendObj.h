//
//  GDCallFriendObj.h
//  BBSModule
//
//  Created by Simon on 2017/7/25.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDCallFriendObj : NSObject
/*
 callId = 7284;
 name = "\U5468\U56f4\U4eae";
 username = WeiliangZhou;
 */

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,assign) NSInteger callId;

@end
