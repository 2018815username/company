/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		tztUIProgressView
* 文件标识:
* 摘要说明:		进度条控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/

#import <UIKit/UIKit.h>
@protocol tztUIProgressViewDelegate;
/**
 *  自定义进度条显示控件
 */
@interface tztUIProgressView : UIView 
{
	UILabel				*_pLabel;
	CGAffineTransform	_rotationTransform;
	UIActivityIndicatorView *_pIndicator;
	int					_nMargin;
    int                 _nCount;
	CGSize				_szSize;
    NSString            *_nsShowMsg;
    id<tztUIProgressViewDelegate> _tztdelegate;
}
/**
 *  指示控件
 */
@property (nonatomic, retain) UIActivityIndicatorView *pIndicator;
/**
 *  显示提示文本控件
 */
@property (nonatomic, retain)	UILabel				*pLabel;
/**
 *  代理
 */
@property (nonatomic,assign) id tztdelegate;
/**
 *  显示大小
 */
@property CGSize szSize;

/**
 *  计数（暂未使用）
 */
@property int nCount;
/**
 *  显示的提示文本
 */
@property (nonatomic, retain) NSString* nsShowMsg;

/**
 *  初始化创建控件
 *
 *  @param frame 区域
 *
 *  @return UIProgressview对象
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *  显示进度条
 *
 *  @param strMsg 提示信息
 */
+ (void)showWithMsg:(NSString *)strMsg;

/**
 *  显示进度条
 *
 *  @param strMsg   提示信息
 *  @param delegate 代理回调
 */
+ (void) showWithMsg:(NSString *)strMsg withdelegate:(id)delegate;

/**
 *  隐藏进度条
 */
+ (void)hidden;
@end

/**
 *  tztUIProgressView协议
 */
@protocol tztUIProgressViewDelegate<NSObject>
@optional
/**
 *  取消显
 *
 *  @param tztProgressView tztUIProgressView对象
 */
- (void)tztUIProgressViewCancel:(tztUIProgressView *)tztProgressView;
@end

extern tztUIProgressView *g_tztUIProgressView;
