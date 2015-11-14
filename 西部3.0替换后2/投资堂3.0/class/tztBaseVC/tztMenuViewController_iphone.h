/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        行情市场菜单显示vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"

@interface tztMenuViewController_iphone : TZTUIBaseViewController<tztUITableListViewDelegate>
{
    //表格菜单
    tztUITableListView  *_pMenuView;
    
    NSMutableDictionary *_pCurrentDict;
    
    NSString            *_nsMenuID;
    
    //需要隐藏的市场类型
    NSString            *_nsHiddenMenuID;
    int                 _nTztTitleType;
}

@property(nonatomic, retain)tztUITableListView  *pMenuView;
@property(nonatomic, retain)NSMutableDictionary *pCurrentDict;
@property(nonatomic, retain)NSString            *nsMenuID;
@property(nonatomic, retain)NSString            *nsHiddenMenuID;
@property(nonatomic)int                         nTztTitleType;
@property(nonatomic)int                         nFixBackColor;

-(void)setTitle:(NSString *)title;
@end
