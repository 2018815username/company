/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        底部工具栏统一创配置
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
@class tztBaseViewUIView;
@interface tztUIBarButtonItem : UIBarButtonItem
{
    id          _pDelegate;
    NSString    *_nsTitle;
    NSInteger         _ntztTag;
}

@property(nonatomic, retain)NSString    *nsTitle;
@property NSInteger ntztTag;

-(id)initWithTitle:(NSString*)title tag:(NSInteger)tag target:(id)target nMsgID_:(NSInteger)nMsgID nTotalWidth_:(int)nTotalWidth;

//-(BOOL) IsHaveActionAndDelegate;

//-(NSString*) GetTitleString;


//根据数组创建底部工具栏（用户自定义）
+(void)GetToolBarItemByArray:(NSArray*)pAy delegate_:(id)delegate forToolbar_:(UIToolbar*)toolbar;
+(void) GetToolBarItemByKey:(NSString*)nsKey delegate_:(id)delegate forToolbar_:(UIToolbar*)toolbar;
+(void)ToolBarItemLayout:(UIToolbar*)toolbar;
+(void)getTradeBottomItemByArray:(NSArray*)pAy target:(id)delegate withSEL:(SEL)sel forView : (tztBaseViewUIView *)view; // 新版本底部操作样式配置 byDBQ20130718
+(void)getTradeBottomItemByArray:(NSArray*)pAy target:(id)delegate withSEL:(SEL)sel forView : (tztBaseViewUIView *)view BtnImage_:(UIImage*)btnBgImg btnSelImage_:(UIImage*)btnSelImg;

+(void)getTradeBottomItemByArray:(NSArray*)pAy
                          target:(id)delegate
                         withSEL:(SEL)sel
                        forView : (UIView *)view
                         height_:(CGFloat)height;

+(void)getTradeBottomItemByArray:(NSArray*)pAy
                          target:(id)delegate
                         withSEL:(SEL)sel
                        forView : (UIView *)view
                         height_:(CGFloat)height
                          width_:(CGFloat)width;

@end
