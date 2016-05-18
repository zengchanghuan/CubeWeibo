//
//  XZEmotionTextView.m
//  Cube
//
//  Created by ZengChanghuan on 16/5/5.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZEmotionTextView.h"
#import "XZEmotionAttachment.h"

@implementation XZEmotionTextView

-(void)insertEmotion:(XZEmotion *)emotion
{
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
        //加载图片
        XZEmotionAttachment *attch = [[XZEmotionAttachment alloc] init];
        
        //传递图片
        attch.emotion = emotion;
        
        //设置图片的尺寸
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        //根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        //插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            //设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
        
        


    }
}

-(NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        XZEmotionAttachment *attch = attrs[@"NSAttachment"];
        if (attch) { // 图片
            [fullText appendString:attch.emotion.chs];
        } else { // emoji、普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}
@end
