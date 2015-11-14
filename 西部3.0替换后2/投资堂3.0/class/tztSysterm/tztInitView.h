/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        初始化界面
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
@protocol tztInitViewDelegate;
@interface tztInitView : UIView 
{
    UIImageView            *_imageview;
    NSString* _tipinfo;
    id<tztInitViewDelegate> _tztdelegate;
    dispatch_source_t _initTimer;
}
@property (nonatomic,assign) id tztdelegate;
@property (nonatomic, retain) UIImageView *imageview;
@property (nonatomic, retain) NSString* tipinfo;
- (void)setTipText:(NSString*)strTip;
- (void)setupInitTimerWithTimeout:(NSTimeInterval)timeout;
- (void)endInitTimer;
@end

@protocol tztInitViewDelegate<NSObject>
@optional
- (void)tztInitViewTimeOut:(tztInitView *)initview;
@end