/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券划转view
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

@interface tztRZRQStockHzView : tztBaseTradeView
{
    tztUIVCBaseView         *_pStockHz;
    
    NSString                *_CurStockCode;
    NSString                *_CurStockName;
    NSString                *_CurAccount;       //当前账号
    NSString                *_CurPTAccount;     //当前融资融券对应的普通对号
    NSMutableArray          *_pAyPicker;        //划转方向
    
	NSMutableArray          *_ayPTAccount;      //普通股东帐号列表
    NSMutableArray          *_ayXYAccount;      //信用股东帐号列表
	NSMutableArray          *_ayPTType;         //普通帐号类别
	NSMutableArray          *_ayXYType;         //信用帐号类别
	NSMutableArray          *_ayPTStockNum;     //信用可卖量
	NSMutableArray          *_ayXYStockNum;     //信用可卖量
    
    NSMutableArray          *_ayData;           //保存持仓数据
    int                     _nCurrentSel;
    
    int     _nSelectPT;
    int     _nSelectXY;
	int     _nSelectType;
    BOOL                    _bInquireCC;
}

@property(nonatomic, retain)tztUIVCBaseView         *pStockHz;
@property(nonatomic, retain)NSString                *CurStockCode;
@property(nonatomic, retain)NSString                *CurStockName;
@property(nonatomic,retain) NSString                *CurAccount;
@property(nonatomic,retain)NSString                 *CurPTAccount;
@property(nonatomic,retain)NSMutableArray           *ayData;

-(void)SetDefaultData;
-(void)OnRequestData;
//查询持仓
-(void)onInquireCCData;
@end
