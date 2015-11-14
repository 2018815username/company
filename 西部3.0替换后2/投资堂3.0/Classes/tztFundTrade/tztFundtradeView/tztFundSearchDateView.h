/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金历史成交,历史委托等  带日期的查询界面
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
#import "tztUIBaseDateView.h"
#import "tztUIFundSearchView.h"

@interface tztFundSearchDateView : tztBaseTradeView<tztUIBaseDateViewDelegate>
{
    tztUIBaseDateView       *_pDateView;
    
    tztUIFundSearchView     *_pSearchView;
}

@property(nonatomic,retain)tztUIBaseDateView       *pDateView;
@property(nonatomic,retain)tztUIFundSearchView     *pSearchView;
@end
