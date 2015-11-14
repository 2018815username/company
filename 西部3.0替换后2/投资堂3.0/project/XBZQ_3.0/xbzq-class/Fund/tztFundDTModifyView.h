/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金定投view  另一种界面
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

@interface tztFundDTModifyView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTradeTable;
    //
    NSString                *_CurStockCode;
    NSMutableArray          *_ayZq;     //定投周期发送日
    NSMutableArray          *_ayZqData;
    NSMutableArray          *_ayQMTJ;   //期满条件

    NSMutableArray          *_ayJJGSDM; //基金公司代码
    int                     _nCurSelect;
    NSString                *_CurJJGSDM; //当前基金公司选项的基金公司代码
    
    BOOL                    _bInquire;
    
    NSMutableArray          *_ayJJDM;//基金代码
    
    NSString                *_nsLastMoney;//记录定投修修改时候金额是否相同
    NSString                *_nsSENDSN;//定投序列号
    NSString                *_nsCompanyCode;//基金公司代码
    NSString                *_nsProductType;//品种代码
    NSString                *_nsWTAccount;//
    NSMutableDictionary     *_pDefaultDataDict;
    
    NSMutableArray          *_ayYDTJJ;  //已经定投的基金
}
@property(nonatomic,retain)tztUIVCBaseView      *tztTradeTable;
@property(nonatomic,retain)NSMutableArray       *ayZq;
@property(nonatomic,retain)NSMutableArray       *ayZqData;
@property(nonatomic,retain)NSString             *nsCompanyCode;
@property(nonatomic,retain)NSString             *CurStockCode;
@property(nonatomic,retain)NSMutableDictionary  *pDefaultDataDict;
@property(nonatomic,retain)NSString             *CurJJGSDM;
@property(nonatomic,retain)NSString             *nsLastMoney;
@property(nonatomic,retain)NSString             *nsSENDSN;
@property(nonatomic,retain)NSString             *nsProductType;
@property(nonatomic,retain)NSString             *nsWTAccount;

//设置数据
-(void)SetData:(NSMutableDictionary*)pDict;
-(void)SetDefaultData;
-(void)OnSend;
-(void)OnRequestJJGSData;
-(void)DealWithStockCode:(NSString*)nsStockCode;
@end