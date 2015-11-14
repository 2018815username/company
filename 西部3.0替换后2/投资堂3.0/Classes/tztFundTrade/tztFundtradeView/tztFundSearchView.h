/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金交易ipad
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
#import "tztUIFundSearchView.h"

@interface tztFundSearchView : tztBaseTradeView
{
    tztUIFundSearchView*    _pFundSearch;
    tztBaseTradeView*       _pBaseView;
    float                   _pLeftWidth;
}
@property(nonatomic,retain)tztUIFundSearchView * pFundSearch;
@property(nonatomic,retain)tztBaseTradeView * pBaseView;
-(void)SetLeftViewByPageType;
-(void)ShowRightView:(BOOL)Show;
@end
