/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        iphone行情横屏显示vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	增加分时、k线滑动切换
 *
 ***************************************************************/
#import "TZTUIBaseViewController.h"
#import "tztUIStockView.h"
typedef enum TZTHoriViewKind
{
    HoriViewKind_Trend = 0,
    HoriViewKind_Tech = 1,
}TZTHoriViewKind;

@interface tztUIHQHoriViewController_iphone : TZTUIBaseViewController<tztHqBaseViewDelegate, tztGridViewDelegate,tztMutilScrollViewDelegate>
{
    TZTUIBaseTitleView   * _pTitleView;
    TZTHoriViewKind _viewkind;
    //分时
    tztTrendView* _trendView;
    // K线
    tztTechView* _techView;
    //把列表传递进来
    id           _pListView;
    // 划动页
    tztMutilScrollView *_pMutilViews;
    // 划动页数组
    NSMutableArray *_pAyViews;
}
@property(nonatomic, retain)TZTUIBaseTitleView *pTitleView;
@property(nonatomic, retain)id                  pListView;
@property(nonatomic, retain)tztMutilScrollView *pMutilViews;
@property(nonatomic, retain)NSMutableArray     *pAyViews;
-(void)setViewKind:(TZTHoriViewKind)viewkind;
-(void)setStockInfo:(tztStockInfo*)pStockInfo nRequest_:(int)nRequest;
@end
