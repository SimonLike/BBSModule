
//
//  AttributeUILabel.m
//  BBSModule
//
//  Created by Simon on 2017/7/13.
//  Copyright © 2017年 Simon. All rights reserved.
//

#import "AttributeUILabel.h"

@implementation AttributeUILabel

/**
 文字局部变色
 **/
+(void)setLableText:(UILabel*)label attribute:(NSString*)attribute instr:(NSString*)str withColor:(UIColor*)color
{
    if ([NSString isBlankString:attribute]) {
        attribute = @"";
    }
    NSRange matchRange = [str rangeOfString:attribute];
    if (matchRange.location != NSNotFound) {
        NSMutableAttributedString *attributestr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributestr addAttribute:NSForegroundColorAttributeName value:color range:matchRange];
        
        label.attributedText = attributestr;
    } else {
        label.text = str;
    }
}
+(void)setLableText:(UILabel*)label attribute:(NSString*)attribute instr:(NSString*)str withColor:(UIColor*)color lineSpaceing:(int)lineSpace
{
    if ([NSString isBlankString:attribute]) {
        attribute = @"";
    }
    NSRange matchRange = [str rangeOfString:attribute];
    if (matchRange.location != NSNotFound) {
        NSMutableAttributedString *attributestr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributestr addAttribute:NSForegroundColorAttributeName value:color range:matchRange];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:lineSpace];
        [attributestr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
        
        label.attributedText = attributestr;
    } else {
        label.text = str;
    }
}
//文字多个部分部分局部变色
+ (void)setLableText:(UILabel*)label attribute1:(NSString*)attribute1 attribute2:(NSString*)attribute2 instr:(NSString*)str withColor:(UIColor*)color{
    
    NSRange matchRange1 = [str rangeOfString:attribute1];
    
    NSRange matchRange2 = [str rangeOfString:attribute2];
    
    if (matchRange1.location != NSNotFound && matchRange2.location != NSNotFound) {
        
        NSMutableAttributedString *attributestr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributestr addAttribute:NSForegroundColorAttributeName value:color range:matchRange1];
        [attributestr addAttribute:NSForegroundColorAttributeName value:color range:matchRange2];
        
        label.attributedText = attributestr;
        
    } else {
        
        label.text = str;
    }
    
}
//小大
+(void)setLableTextForm:(UILabel*)label text:(NSString *)text withFont:(UIFont *)font
{
    NSInteger length = text.length;
    NSRange matchRange = NSMakeRange(1, length - 1);
    if (matchRange.location != NSNotFound) {
        NSMutableAttributedString *attributestr = [[NSMutableAttributedString alloc] initWithString:text];
        [attributestr addAttribute:NSFontAttributeName value:font range:matchRange];
        label.attributedText = attributestr;
    } else {
        label.text = text;
    }
}

+ (void)setLableTextDelete:(UILabel *)label text:(NSString *)text color:(UIColor *)color
{
    NSInteger length = text.length;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attributedString addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, length)];
    [label setAttributedText:attributedString];
}


@end

@implementation UIDeleteLabel

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 170.0, 170.0, 170.0, 1);
    CGContextSetLineWidth(context, 1);
    CGFloat height = self.bottom / 2.0;
    CGContextMoveToPoint(context, 0, height);
    CGContextAddLineToPoint(context, self.width, height);
    CGContextStrokePath(context);
    [super drawRect:rect];
}

@end
