//
//  XZStatusPhotosView.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/6.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZStatusPhotosView.h"
#import "XZPhoto.h"
#import "XZStatusImageView.h"

#define XZStatusPhotoWH 70
#define XZStatusPhotoMargin 10
#define XZStatusPhotoMaxCol(count) ((count==4)?2:3)

@implementation XZStatusPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    NSInteger photosCount = photos.count;
    
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        XZStatusImageView *photoView = [[XZStatusImageView alloc] init];
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        XZStatusImageView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    // 设置图片的尺寸和位置
    NSInteger photosCount = self.photos.count;
    int maxCol = XZStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        XZStatusImageView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (XZStatusPhotoWH + XZStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (XZStatusPhotoWH + XZStatusPhotoMargin);
        photoView.width = XZStatusPhotoWH;
        photoView.height = XZStatusPhotoWH;
    }

}
+(CGSize)sizeWithCount:(NSInteger)count
{
    // 最大列数（一行最多有多少列）
    NSInteger maxCols = XZStatusPhotoMaxCol(count);
    
    ///Users/apple/Desktop/课堂共享/05-iPhone项目/1018/代码/黑马微博2期35-相册/黑马微博2期/Classes/Home(首页)/View/XZStatusPhotosView.m 列数
    NSInteger cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * XZStatusPhotoWH + (cols - 1) * XZStatusPhotoMargin;
    
    // 行数
    NSInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * XZStatusPhotoWH + (rows - 1) * XZStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}
@end
