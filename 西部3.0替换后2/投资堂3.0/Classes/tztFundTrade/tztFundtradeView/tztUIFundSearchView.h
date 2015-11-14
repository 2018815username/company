/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金普通查询
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#ifndef __TZTUIFUNDSEARCHVIEW_H__
#define __TZTUIFUNDSEARCHVIEW_H__
#import <UIKit/UIKit.h>
#import "tztBaseTradeView.h"

#define tztCanWithDraw  @"是"
#define tztCannotWithDraw @"否"

@interface tztUIFundSearchView : tztBaseTradeView<tztGridViewDelegate>
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
    
    NSInteger                     _nJJGSDM;        //基金公司代码
    NSInteger                     _nJJGSMC;        //基金公司名称
    
    NSInteger                     _balanceindex;      //金额
    NSInteger                     _currencycodeindex;      //币种代码
    NSInteger                     _bankindex;      //银行
    NSInteger                     _currencyindex;      //币种
    
    NSInteger                     _nDateIndex;      //日期
    NSInteger                     _nCONTACTINDEX;
    NSInteger                     _nInitDateIndex; // 发生日期
    NSInteger                     _nSerialNoIndex; // 预约取消流水号
    
    NSInteger                     _nCURRENTSET;//当前分红设置
    NSInteger                     _nSignIndex;
    NSInteger                     _nSendSNIndex;      //委托流水号索引
    NSInteger                     _nSNoIndex;         //机构编码索引
    NSInteger                     _nBeginDateIndex;   //开始日期索引
    NSInteger                     _nEndDateIndex;     //结束日期索引
    NSInteger                     _nKgrqIndex;        //扣款日期索引
    NSInteger                     _nKgzqIndex;        //扣款周期索引
    NSInteger                     _nTZJEIndex;        //投资金额索引
    NSInteger                     _nTZYTIndex;        //投资用途索引
    
    NSInteger                     _nProductType;      //品种代码
    NSInteger                     _nJJKYINDEX;
    
    NSInteger                     _nExpDateIndex;     // 保留额度有限期 -- 保留额度设置 byDBQ20130926
    
    NSInteger                     _nFundAccountIndex;
    NSInteger                     _nAccountTypeIndex;
    //zxl 20130718 查询的条件
    //基金公司代码
	NSString	*_nsJJGSDM;
	//基金状态
	NSString	*_nsJJState;
	//基金类型
	NSString	*_nsJJKind;
	//基金代码
	NSString	*_nsJJCode;
	//基金名称
	NSString	*_nsJJName;
    NSInteger               _nMarketIndexx;//市场类别 新增加 wry 有就发送 没有不发
}
@property(nonatomic,copy)  NSString *a;
@property(nonatomic,assign) NSInteger  nStartIndex1;
@property(nonatomic, retain)TZTUIReportGridView *pGridView;
@property(nonatomic, retain)NSString            *reqAction;
@property(nonatomic, retain)NSString            *nsBeginDate;
@property(nonatomic, retain)NSString            *nsEndDate;
@property(nonatomic, retain)NSString                *nsJJGSDM;
@property(nonatomic, retain)NSString                *nsJJState;
@property(nonatomic, retain)NSString                *nsJJKind;
@property(nonatomic, retain)NSString                *nsJJCode;
@property(nonatomic, retain)NSString                *nsJJName;
@property(nonatomic, retain)NSMutableArray          *aytitle;
@property (nonatomic,strong) NSMutableArray* marketArray;

-(void)OnRequestData;
-(void)DealIndexData:(tztNewMSParse*)pParse;
-(BOOL)OnToolbarMenuClick:(id)sender;
-(void)AddSearchInfo:(NSMutableDictionary *)pDict;
@end

#endif
