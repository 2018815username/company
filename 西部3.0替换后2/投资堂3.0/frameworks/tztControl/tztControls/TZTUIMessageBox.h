/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:     TZTUIMessageBox
* 文件标识:
* 摘要说明:     自定义对话框控件
* 
* 当前版本:     2.0
* 作   者:     yinjp
* 更新日期:
* 整理修改:
*
***************************************************************/


#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

/*
 背景使用图片，直接传图片名称；使用颜色，则传rgb @"218,218,218"
 */
//提示框背景色
#define     tztMsgBoxBackColor              @"tztMsgBoxBackColor"           //e.g:@"218,218,218"
//确定按钮背景（图片）
#define     tztMsgBoxBtnOKImg               @"tztMsgBoxBtnOKImg"            //e.g:@"tztButtonRed.png"
//确定按钮字体颜色
#define     tztMsgBoxBtnOKTitleColor        @"tztMsgBoxBtnOKTitleColor"     //e.g:@"191,191,191"
//取消按钮背景（图片）
#define     tztMsgBoxBtnCancelImg           @"tztMsgBoxBtnCancelImg"        //e.g:@"tztDialogCancel.png"
//取消按钮字体颜色
#define     tztMsgBoxBtnCancelTitleColor    @"tztMsgBoxBtnCancelTitleColor" //e.g:@"0,0,0"
//标题居中方式（left-左对齐 center-居中对齐 right-右对齐，默认左对齐）
#define     tztMsgBoxTitleAlignment         @"tztMsgBoxTitleAlignment"      //e.g:@"right" (left, center, right)
//分割线位置（top-标题下绘制分割线 bottom－底部按钮上绘制. 默认top) 
#define     tztMsgBoxSepLinePos             @"tztMsgBoxSepLinePos"          //e.g:@"top"   (top, bottom)
//圆角度
#define     tztMsgBoxCornRadius             @"tztMsgBoxCornRadius"          //e.g:@"10",具体
//标题背景色
#define     tztMsgBoxTitleBackColor         @"tztMsgBoxTitleBackColor"      //e.g:@"255,255,255,0.8"

#define     tztMsgBoxLeftCancel             @"tztMsgBoxLeftCancel"

#define     tztMsgBoxXMargin                @"tztMsgBoxXMargin"

//弹出框类型
typedef NS_ENUM(NSInteger,TZTBoxType)
{
	TZTBoxTypeNoButton = 0,	//没有按钮
	TZTBoxTypeButtonOK,		//确定按钮
	TZTBoxTypeButtonCancel,	//取消按钮
	TZTBoxTypeButtonBoth	//确定、取消
};

//对话框按钮点击事件处理协议
@class TZTUIMessageBox;
@protocol TZTUIMessageBoxDelegate
@optional
- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface TZTUIMessageBox : UIView<UITextViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate> 
{
	//标题
	NSString *m_nsTitle;
	//内容
	NSString *m_nsContent;
	//行高
	CGFloat	 m_fRowHeight;
	//类型 对应TZTBoxType 默认NoButton
	NSInteger m_nType;
	//标题字体
	UIFont	 *m_TitleFont;
	//内容字体
	UIFont   *m_ContentFont;
	//高度
	CGFloat	 m_fBoxHeight;
    
	//文本显示区域
	UITextView	*m_pTextView;
    UIButton *_ButtonOK;
    UIButton *_ButtonCancel;
    UIButton *_ButtonClose;
	//代理
	id		m_pDelegate;
	//按钮文本
	//确定键
	NSString	*m_nsOK;
	//取消键
	NSString	*m_nsCancel;
	//定时器
	NSTimer		*m_tTimer;
    UIAlertView* MacAlertView;
    
    BOOL        _bHasClose;
    BOOL        _bDismiss;
    void (^blockcomple)(NSInteger);
    UIPanGestureRecognizer *_panRecognizer;
    
    
}

@property (nonatomic, retain) NSString *m_nsTitle;
@property (nonatomic, retain) NSString *m_nsContent;
@property (nonatomic, retain) UIFont	*m_TitleFont;
@property (nonatomic, retain) UIFont	*m_ContentFont;
@property (nonatomic, retain) UITextView	*m_pTextView;
@property (nonatomic, assign) id		m_pDelegate;
@property (nonatomic, retain) NSTimer	*m_tTimer;
@property (nonatomic, retain) UIAlertView   *MacAlertView;
@property (nonatomic, copy) void (^blockcomple)(NSInteger);
@property CGFloat	m_fRowHeight;
@property NSInteger	m_nType;
@property BOOL      bHasClose;
@property (nonatomic, readonly) BOOL bDismiss;
@property (nonatomic, retain)UIPanGestureRecognizer *panRecognizer;

//设置按钮的文字
-(void)setButtonText:(NSString*)nsOK cancel_:(NSString*)nsCancel;
//创建
-(id)initWithFrame:(CGRect)frame nBoxType_:(int)nBoxType delegate_:(id)delegate block:(void(^)(NSInteger))block;
//创建对话框
-(id)initWithFrame:(CGRect)frame nBoxType_:(int)nBoxType delegate_:(id)delegate;
//显示
-(void)showForView:(UIView*)view;
-(void)showForView:(UIView*)view animated:(BOOL)animated;
//隐藏
-(void)hide;

 /**
 *	@brief	设置指定文本显示格式
 *  该功能6.0以上才可以使用，否则无效
 *	@param 	dict 	显示属性
 *	@param 	string 	应用的文字
 *
 *	@return	无
 */
-(void)setTextArrtibutes:(NSMutableDictionary*)dict forString:(NSString*)string;

@end

extern void TZTShowNewMessageBox(NSString* str);
@interface UIView(tztblock) <UIAlertViewDelegate,UIActionSheetDelegate>
//UIAlertView
-(void)tztshowWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

//UIActionSheet
-(void)tztshowInView:(UIView *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)tztshowFromToolbar:(UIToolbar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)tztshowFromTabBar:(UITabBar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)tztshowFromRect:(CGRect)rect
             inView:(UIView *)view
           animated:(BOOL)animated
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

-(void)tztshowFromBarButtonItem:(UIBarButtonItem *)item
                    animated:(BOOL)animated
       withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;
@end



#pragma mark -提示对话框
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBox(NSString* strMsg);
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageTitle(NSString* strMsg,NSString* strTitle);
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlock(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType,void (^block)(NSInteger));
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlockWithDelegate(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType, id delegate, void (^block)(NSInteger));
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlockAndClose(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType, id delegate, BOOL bHasClose, void (^block)(NSInteger));

//增加动画弹出效果
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBoxAnimated(NSString* strMsg, BOOL bUseAnimated);
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageTitleAnimated(NSString* strMsg,NSString* strTitle, BOOL bUseAnimated);
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlockAnimated(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType,void (^block)(NSInteger), BOOL bUseAnimated);
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlockWithDelegateAnimated(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType, id delegate, void (^block)(NSInteger), BOOL bUseAnimated);
FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlockAndCloseAnimated(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType, id delegate, BOOL bHasClose, void (^block)(NSInteger), BOOL bUseAnimated);
#endif