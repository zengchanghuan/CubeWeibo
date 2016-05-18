//
//  XZComposePhotosView.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/11.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZComposePhotosView.h"
@interface XZComposePhotosView ()
@end
@implementation XZComposePhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

-(void)addPhoto:(UIImage *)photo
{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = photo;
    [self addSubview:photoView];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    // 设置图片的尺寸和位置
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    
    for (int i = 0; i<count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (imageWH + imageMargin);
        
        int row = i / maxCol;
        photoView.y = row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }

}
@end
