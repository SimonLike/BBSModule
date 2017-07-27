//
//  GDUserObj.m
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "GDUserObj.h"

@implementation GDUserObj

- (void)dealloc
{
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.userId forKey:@"userId"];
    [encoder encodeInteger:self.projectId forKey:@"projectId"];
    [encoder encodeObject:self.token forKey:@"token"];

}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.userId = [decoder decodeIntegerForKey:@"userId"];
        self.projectId = [decoder decodeIntegerForKey:@"projectId"];
        self.token = [decoder decodeObjectForKey:@"token"];
     
    }
    return self;
}


@end
