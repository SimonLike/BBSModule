//
//  NSMutableArray+Extend.m
//  ZJBDMIOS
//
//  Created by 转角街坊 on 16/7/18.
//  Copyright © 2016年 转角街坊. All rights reserved.
//

#import "NSMutableArray+Extend.h"

@implementation NSMutableArray (Extend)

- (void)addNil:(id)anObject{
    
    if (anObject == nil) {
        
        [self addObject:@""];
        return;
    }
    if (anObject)
    {
        [self addObject:anObject];
    }
}


@end
