//
//  AppDelegate.h
//  BBSModule
//
//  Created by Simon on 2017/6/26.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

