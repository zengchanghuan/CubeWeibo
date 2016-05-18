//
//  XZComposeViewController.m
//  Cube
//
//  Created by ZengChanghuan on 16/4/7.
//  Copyright © 2016年 ZengChanghuan. All rights reserved.
//

#import "XZComposeViewController.h"
#import "XZAccountTool.h"
#import "XZTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "XZComposeToolbar.h"
#import "XZComposePhotosView.h"
#import "XZEmotionKeyboard.h"
#import "XZEmotion.h"
#import "XZEmotionTextView.h"
@interface XZComposeViewController ()<UITextViewDelegate,XZComposeToolbarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, weak) XZEmotionTextView *textView;
@property (nonatomic, weak) XZComposeToolbar *toolbar;
@property (nonatomic, weak) XZComposePhotosView *photosView;
@property (nonatomic, strong) XZEmotionKeyboard *emotionKeyboard;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;
@end

@implementation XZComposeViewController
#pragma mark - 懒加载
- (XZEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[XZEmotionKeyboard alloc] init];
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNav];
    [self setupTextView];
    [self setupToolbar];
    [self setupPhotosView];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
    [self.textView becomeFirstResponder];
}

- (void)dealloc
{
    [XZNotificationCenter removeObserver:self];
}
#pragma mark- setupNav
- (void)setupNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *name = [XZAccountTool account].name;
    NSString *prefix = @"发微博";
    if (name) {
        UILabel *titleView = [[UILabel alloc] init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        // 自动换行
        titleView.numberOfLines = 0;
        titleView.y = 50;
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        
        // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
    } else {
        self.title = prefix;
    }

}
- (void)setupTextView
{
    // 在这个控制器中，textView的contentInset.top默认会等于64
    XZEmotionTextView *textView = [[XZEmotionTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    //    textView.placeholderColor = [UIColor redColor];
    
//    textView.attributedText
    
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 监听通知  文字改变的通知

    [XZNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    //    UIKeyboardWillChangeFrameNotification
    //    UIKeyboardDidChangeFrameNotification
    // 键盘显示时发出的通知
    //    UIKeyboardWillShowNotification
    //    UIKeyboardDidShowNotification
    // 键盘隐藏时发出的通知
    //    UIKeyboardWillHideNotification
    //    UIKeyboardDidHideNotification
    
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [XZNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //表情选中的通知
    [XZNotificationCenter addObserver:self selector:@selector(emotionDidSelect:) name:XZEmotionDidSelectNotification object:nil];
    
    //删除文字的通知
    [XZNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:XZEmotionDidDeleteNotification object:nil];
    
}
#pragma mark - 监听方法
/**
 *  删除文字
 */
- (void)emotionDidDelete
{
    [self.textView deleteBackward];
}
#pragma mark - 监听方法
/**
 *  表情被选中
 *
 */
- (void)emotionDidSelect:(NSNotification *)notification
{
    XZEmotion *emotion = notification.userInfo[XZSelectEmotionKey];
    NSLog(@"%@ 表情被选中了",emotion.chs);

    [self.textView insertEmotion:emotion];
}
#pragma mark - 监听方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    

    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
        XZLog(@"%@", NSStringFromCGRect(self.toolbar.frame));
    }];
    
    //
}
- (void)setupToolbar
{
    XZComposeToolbar *toolbar = [[XZComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.composeToolDelegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}
- (void)setupPhotosView
{
    XZComposePhotosView *photosView = [[XZComposePhotosView alloc] init];
    photosView.y = 100;
    photosView.width = self.view.width;
    photosView.height = self.view.height;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)send
{
    if (self.photosView.photos.count) {
        [self sendWithImage];
    } else {
        [self sendWithoutImage];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendWithImage
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XZAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
    [mgr POST:@"" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
    
}
-(void)sendWithoutImage
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XZAccountTool account].access_token;
    params[@"status"] = self.textView.text;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];

}
- (void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark -composeToolDelegate
-(void)composeToolbar:(XZComposeToolbar *)toolbar didClickButton:(XZComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case XZComposeToolbarButtonTypeCamera: // 拍照
            [self openCamera];
            break;
            
        case XZComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case XZComposeToolbarButtonTypeMention: // @
            XZLog(@"--- @");
            break;
            
        case XZComposeToolbarButtonTypeTrend: // #
            XZLog(@"--- #");
            break;
            
        case XZComposeToolbarButtonTypeEmotion: // 表情\键盘
            XZLog(@"--- 表情");
            [self switchKeyboard];
            break;
    }
}
- (void)switchKeyboard
{
    // self.textView.inputView == nil : 使用的是系统自带的键盘
    if (self.textView.inputView == nil) { // 切换为自定义的表情键盘
        XZEmotionKeyboard *emotionKeyboard = [[XZEmotionKeyboard alloc] init];
        emotionKeyboard.width = self.view.width;
        emotionKeyboard.height = 216;
        self.textView.inputView = emotionKeyboard;
    } else { // 切换为系统自带的键盘
        self.textView.inputView = nil;
    }
    
    // 开始切换键盘
    self.switchingKeybaord = YES;
    
    // 退出键盘
    [self.textView endEditing:YES];
    //    [self.view endEditing:YES];
    //    [self.view.window endEditing:YES];
    //    [self.textView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.textView becomeFirstResponder];
        
        // 结束切换键盘
        self.switchingKeybaord = NO;
    });
}
#pragma mark - 其他方法
- (void)openCamera
{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openAlbum
{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
    // UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    //    self.picking = YES;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // info中就包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 添加图片到photosView中
    [self.photosView addPhoto:image];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        self.picking = NO;
    //    });
}
@end
