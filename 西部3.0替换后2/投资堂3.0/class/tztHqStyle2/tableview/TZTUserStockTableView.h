/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    自选股表
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import <UIKit/UIKit.h>

typedef  enum{
    PriceNature = 100,
    PriceAscend,
    PriceDesend,
}PriceType;

typedef enum{
    RankNature = 1000,
    RankAscend,
    RankDesend,
}RankType;

@interface TZTUserStockTableView : tztHqBaseView /*<shareDelegate>*/

@property (nonatomic, assign)BOOL     bNOFresh; // To control the tableView not to fresh so that can prevent scrollview disordered
@property (nonatomic, assign)int   nTickCount;

@property(nonatomic,retain)UITableView  *pTableView;

@property (nonatomic, assign) PriceType   priceType;
@property (nonatomic, assign) RankType    rankType;

@property (nonatomic, assign) int centerCount;
@property (nonatomic, assign) int nonCenCount;
@property (nonatomic, assign) int priceCount;
@property (nonatomic, assign) int rankCount;

@property (nonatomic, assign) int nShowInQuote;

@end
