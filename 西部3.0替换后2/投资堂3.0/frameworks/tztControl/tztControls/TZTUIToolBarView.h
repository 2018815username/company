/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        工具栏view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
            读取配置文件中的配置，创建toolbar按钮
 ***************************************************************/

#import "TZTUIBaseView.h"

@protocol TZTUIToolBarViewDelegate<NSObject>
@optional
-(BOOL)didSelectItemAtIndex:(NSInteger)nIndex options_:(NSDictionary*)options;
-(void)didSelectMoreView;
-(void)OnReturnPreSelect;
@end

@interface TZTUIToolBarView : TZTUIBaseView
{
    NSMutableArray      *_ayToolBarItem;
    
    NSInteger                 _nPreSelectd;//上一个选中的
    
    NSInteger                 _nSelected;
    
    UIImageView         *_pSelectedView;
    
    CGRect              _rcSelected;

    UIImageView         *_pBackGroundView;
}

@property(nonatomic,retain)UIImageView *pSelectedView;
@property(nonatomic,retain)UIImageView *pBackGroundView;
@property NSInteger  nSelected;
@property NSInteger  nPreSelectd;
-(void) OnDealToolBarAtIndex:(NSInteger)nIndex options_:(NSDictionary*)options;
-(void)OnDealToolBarByName:(NSString*)nsName;
//根据配置的名称获取对应的索引，用于跳转
-(int)GetTabItemIndexByName:(NSString*)nsName;
//根据配置的ID获取对应的索引，用于跳转
-(int)GetTabItemIndexByID:(unsigned int)nsID;
- (void)reload;
//重新加载toolbar图片，用于图片切换
-(void)ReloadToolBar:(NSString *)strData;
@end

extern TZTUIToolBarView *g_pToolBarView;