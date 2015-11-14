/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztTabView
 * 文件标识：
 * 摘    要：   标签页显示
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <UIKit/UIKit.h>
@class tztTabView;

@protocol tztTabViewDelegate <NSObject>

@optional
-(void)tztTabView:(tztTabView *)tabview didCloseItem:(id)object;
-(void)tztTabView:(tztTabView *)tabview didSwitchItem:(id)object;

@end

@interface tztTabView : UIView
{
    id <tztTabViewDelegate> _tztdelegate;
}
@property(nonatomic, assign)id<tztTabViewDelegate>tztdelegate;

-(BOOL)IsExistType:(NSInteger)nMsgType;
-(void)AddViewToTab:(UIView*)pView nsName_:(NSString*)nsName;
//zxl 20131022 删除指定索引的界面
-(void)RemoveViewAtIndex:(NSInteger)index;
-(void)RemoveAllViews;
-(int)GetViewIndex:(UIView*)pView;
-(UIView*)GetActiveTabView;
@end
