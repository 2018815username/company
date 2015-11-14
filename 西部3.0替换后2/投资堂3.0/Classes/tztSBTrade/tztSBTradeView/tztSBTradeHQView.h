/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ipad三板行情
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztBaseTradeView.h"
#import "tztSBTradeTopHQSelectView.h"
#import "tztSBTradeSearchView.h"

@interface tztSBTradeHQView : tztBaseTradeView
{
    tztSBTradeTopHQSelectView       *_pHQView;
    tztSBTradeSearchView            *_pSearchView;
}

@property(nonatomic,retain)tztSBTradeTopHQSelectView    *pHQView;
@property(nonatomic,retain)tztSBTradeSearchView         *pSearchView;

-(void)SetSelectType:(NSString*)nsStock _nsType:(NSString*)nsType;
@end
