//
//  AttributeUILabel.h
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributeUILabel : UILabel
/*
 * attribute 改变字体
 * instr 所有字体
 */
+ (void)setLableText:(UILabel*)label attribute:(NSString*)attribute instr:(NSString*)str withColor:(UIColor *)color;

+(void)setLableText:(UILabel*)label attribute:(NSString*)attribute instr:(NSString*)str withColor:(UIColor*)color lineSpaceing:(int)lineSpace;

+ (void)setLableText:(UILabel*)label attribute1:(NSString*)attribute1 attribute2:(NSString*)attribute2 instr:(NSString*)str withColor:(UIColor*)color;

//小大
+ (void)setLableTextForm:(UILabel*)label text:(NSString *)text withFont:(UIFont *)font;

//删除线
+ (void)setLableTextDelete:(UILabel *)label text:(NSString *)text color:(UIColor *)color;

@end

@interface UIDeleteLabel : UILabel

@end

