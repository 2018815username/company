/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ipad三板行情选择界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>

@interface tztSBTradeTopHQSelectView : UIView
{
    tztUIVCBaseView *_tztSBHQView;
    
    NSMutableArray  *_pAySelectType;
	NSMutableArray  *_pAyType;
    int             m_nSelectType;
    
    id              _pDelegate;
}
@property(nonatomic,retain)tztUIVCBaseView *tztSBHQView;
@property(nonatomic,retain)NSMutableArray   *pAySelectType;
@property(nonatomic,retain)NSMutableArray   *pAyType;
@property(nonatomic,assign)id     pDelegate;

-(void)SetDefaultData;
@end
