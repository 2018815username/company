/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易基础查询类
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztBaseTradeView.h"

#define tztCanWithDraw  @"是"
#define tztCannotWithDraw @"否"

@interface tztTradeSearchView : tztBaseTradeView<tztGridViewDelegate,tztUIRightSearchDelegate>
{
    //表格显示控件
    TZTUIReportGridView     *_pGridView;
    NSString                *_reqAction;//请求的功能号
    //起始位置
    NSInteger                     _nStartIndex;
    //请求条数
    NSInteger                     _nMaxCount;
    //返回页数
    NSInteger                     _nPageCount;
//    int                     _nRZRQHZStock;
    
    NSInteger     _valuecount; //总数据数
    NSInteger     _reqAdd; //翻页新增
    NSInteger     _reqchange;//更改数据数
    
    NSString                *_nsBeginDate;
    NSString                *_nsEndDate;
    NSMutableArray          *_aytitle;  
    
    NSInteger                     _nStockCodeIndex;//代码索引
    NSInteger                     _nStockNameIndex;//名称索引
    NSInteger                     _nAccountIndex;  //账号索引
    NSInteger                     _nDrawIndex;     //可撤标识
    NSInteger                     _nYKIndex;       //盈亏
    NSInteger                     _nContactIndex;  //合同号
    int                     _seialnoindex;    //合约编号索引
    int                     _needreturnbalanceindex; //需还款数量的索引 需还款金额索引
    int                     _backdateindex;  //到货日期索引
    int                     _debitbalanceindex; //负债金额 （费用负债）索引
    int                     _debitinterestindex; //预计利息索引
    int                     _debittypeindex; //负债类型索引
    NSInteger               _nMarketIndexx;//市场类别
}

@property(nonatomic, retain)TZTUIReportGridView *pGridView;
@property(nonatomic, retain)NSString            *reqAction;
@property(nonatomic, retain)NSString            *nsBeginDate;
@property(nonatomic, retain)NSString            *nsEndDate;
@property(nonatomic, retain)NSMutableArray      *ayTitle;
@property (nonatomic,strong) NSMutableArray* marketArray;



- (void)initdata;
-(NSString*)GetReqAction:(NSInteger)nMsgID;
-(void)OnRequestData;
-(void)DealIndexData:(tztNewMSParse*)pParse;
-(void)AddSearchInfo:(NSMutableDictionary*)pDict;

@end
