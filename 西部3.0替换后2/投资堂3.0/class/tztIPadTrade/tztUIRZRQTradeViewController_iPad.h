/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券交易界面vc（iPad）
 * 文件标识:        
 * 摘要说明:        (20130927 zxl 修改了界面展示风格，显示所有的右侧交易界面根据类型来创建一个交易类型的View集合，然后根据不同的
 类型显示不同的界面)
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:            xyt
 *
 ***************************************************************/  
#import "TZTUIBaseViewController.h"
#import "tztBaseTradeView.h"
#import "TradeTabButtonView_iPad.h"

#import "tztTradeSegment.h"
#import "tztTradeRight_ipad.h"

@class tztTradeTableView;

@interface tztUIRZRQTradeViewController_iPad : TZTUIBaseViewController<tztUITableListViewDelegate,tztHqBaseViewDelegate,UIGestureRecognizerDelegate, tztTabViewDelegate , tztTradeSegmentDelegate>
{
    tztUITableListView      *_pTableView;
    NSMutableDictionary     *_pRightTradeViews;//交易界面右侧根据交易类型的View集合
    int                _nKeyType;//交易类型KEy
    
    tztTradeSegment         *_titleSegment;
    
    BOOL                    _bTradeOut;
}
@property(nonatomic, retain)tztUITableListView      *pTableView;
@property(nonatomic, retain)tztTradeSegment         *titleSegment;
@property(nonatomic, retain)NSMutableDictionary     *pRightTradeViews;
@property int                nKeyType;

-(void)SetJYType:(int)strJyType;
//-(void)OnShowOrHiden:(int)nType;
-(void)DealWithMenu:(NSInteger)nMsgType nsParam_:(NSString *)nsParam pAy_:(NSArray *)pAy;
@end

