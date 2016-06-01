//
//  XZStatusTableViewCell.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/6.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZStatusTableViewCell.h"
#import "XZStatus.h"
#import "XZUser.h"
#import "XZStatusFrame.h"
#import "UIImageView+WebCache.h"
#import "XZPhoto.h"
#import "XZStatusToolbar.h"
#import "XZStatusPhotosView.h"
#import "XZIconView.h"
#import "XZStatusTextView.h"
@interface XZStatusTableViewCell ()
/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) XZIconView *iconView;

/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) XZStatusPhotosView *photosView;

//@property (nonatomic, weak) UIImageView *photoView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) XZStatusTextView *contentLabel;

/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) XZStatusTextView *retweetContentLabel;
/** 转发配图 */
//@property (nonatomic, weak) UIImageView *retweetPhotoView;

@property (nonatomic, weak) XZStatusPhotosView *retweetPhotosView;

@property (nonatomic, weak) XZStatusToolbar *toolbar;
@end

@implementation XZStatusTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    XZStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XZStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupOriginal];
        [self setupRetweet];
        [self setupToolbar];
    }
    return self;

}
/**
 * 初始化原创微博
 */
- (void)setupOriginal
{
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    XZIconView *iconView = [[XZIconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    XZStatusPhotosView *photoView = [[XZStatusPhotosView alloc] init];
    [originalView addSubview:photoView];
    self.photosView = photoView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = XZStatusCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = XZStatusCellTimeFont;
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = XZStatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    XZStatusTextView *contentLabel = [[XZStatusTextView alloc] init];
//    contentLabel.font = XZStatusCellContentFont;
//    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;

}
/**
 * 初始化转发微博
 */
- (void)setupRetweet
{
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = XZColor(247, 247, 247);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    XZStatusTextView *retweetContentLabel = [[XZStatusTextView alloc] init];
//    retweetContentLabel.numberOfLines = 0;
//    retweetContentLabel.font = XZStatusCellRetweetContentFont;
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发微博配图 */
    XZStatusPhotosView *retweetPhotoView = [[XZStatusPhotosView alloc] init];
    [retweetView addSubview:retweetPhotoView];
    self.retweetPhotosView = retweetPhotoView;
}

/**
 * 初始化工具条
 */
- (void)setupToolbar
{
    XZStatusToolbar *toolbar = [XZStatusToolbar toolbar];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}
-(void)setStatusFrame:(XZStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    XZStatus *status = statusFrame.status;
    XZUser *user = status.user;
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    /** 配图 */
    if (status.pic_urls.count) {
        self.photosView.frame = statusFrame.photoViewF;
        self.photosView.photos = status.pic_urls;
        self.photosView.hidden = NO;
    } else {
        self.photosView.hidden = YES;
    }
    
    
    
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 时间 */
    self.timeLabel.text = status.created_at;
    self.timeLabel.frame = statusFrame.timeLabelF;
    
    /** 来源 */
    self.sourceLabel.text = status.source;
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    
    /** 正文 */
    //NSSring 
    self.contentLabel.attributedText = status.attributedText;
    self.contentLabel.frame = statusFrame.contentLabelF;
    
    /** 被转发的微博 */
    if (status.retweeted_status) {
        XZStatus *retweeted_status = status.retweeted_status;
        XZUser *retweeted_status_user = retweeted_status.user;
        
        self.retweetView.hidden = NO;
        /** 被转发的微博整体 */
        self.retweetView.frame = statusFrame.retweetViewF;
        
        /** 被转发的微博正文 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        self.retweetContentLabel.text = retweetContent;
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        
        /** 被转发的微博配图 */
        if (retweeted_status.pic_urls.count) {
            self.retweetPhotosView.frame = statusFrame.retweetPhotoViewF;
            self.retweetPhotosView.photos = retweeted_status.pic_urls;
            self.retweetPhotosView.hidden = NO;
        } else {
            self.retweetPhotosView.hidden = YES;
        }
    } else {
        self.retweetView.hidden = YES;
    }


    //工具条
    self.toolbar.frame = statusFrame.toolbarF;
    self.toolbar.status = status;
}
@end
