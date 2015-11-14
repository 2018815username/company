//
//  TZTFundSearchCashProd.h
//  tztMobileApp
//
//  Created by deng wei on 13-3-18.
//  Copyright (c) 2013年 中焯. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "tztBaseTradeView.h"

#define tztCanWithDraw  @"是"
#define tztCannotWithDraw @"否"

@interface TZTFundSearchCashProd : tztBaseTradeView<tztGridViewDelegate>
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
    
    NSInteger                     _nDateIndex;      //日期
    NSInteger                     _nCONTACTINDEX;
    
    NSInteger                     _nCURRENTSET;//当前分红设置
}

@property(nonatomic, retain)TZTUIReportGridView *pGridView;
@property(nonatomic, retain)NSString            *reqAction;
@property(nonatomic, retain)NSString            *nsBeginDate;
@property(nonatomic, retain)NSString            *nsEndDate;

-(void)OnRequestData;
-(void)DealIndexData:(tztNewMSParse*)pParse;
-(BOOL)OnToolbarMenuClick:(id)sender;

@end