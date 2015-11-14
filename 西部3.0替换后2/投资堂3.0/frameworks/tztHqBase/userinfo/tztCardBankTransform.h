/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTCardBankTransform
* 文件标识:
* 摘要说明:		银行币种信息基类
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/
#ifndef __TZTCARDBANKTRANSFORM_H__
#define __TZTCARDBANKTRANSFORM_H__

#import <Foundation/Foundation.h>

@interface tztCardBankTransform : NSObject 
{
	//银行币种信息获取是否成功
	BOOL                    _bGetBankInfoSuc;
    //银行列表
    NSMutableArray          *_saBankList;
    //银行名称转代码
    NSMutableDictionary     *_mapBankNameToNo;
	//银行名称转密码标志
    NSMutableDictionary     *_mapBankNameToPWFlag;
	//银行转币种
	NSMutableDictionary     *_mapBankToMoney; // 银行对应币种
	//资金账号列表
	NSMutableArray          *_saAccountList;
	// 资金账号对应银行
	NSMutableDictionary     *_mapAccountToBank; 
    // 资金账号对应可取金额
    NSMutableDictionary     *_mapAccountToAvailableVolume; 
	// 资金账号对应可用金额
    NSMutableDictionary     *_mapAccountToUseVolume; 
	// 资金账号对应币种
    NSMutableDictionary     *_mapAccountToMoney; 
    //币种名称
    NSMutableArray          *_saMoneyType;
    //币种名称转代码
    NSMutableDictionary     *_mapMoneyTypeToNo;
	// 币种转银行
    NSMutableDictionary     *_mapMoneyToBank; 
	//交易账号
	NSString                *_sAccount;
	//交易密码
    NSString                *_sAccountPW;
	//选择的资金账号
	NSString                *_sFundAccount;
    //银行密码
    NSString                *_sBankPW;
	//资金密码
    NSString                *_sDealerPW;
    //转账金额
    float                   _fTranseVolume;
    //银行名称
    NSString                *_sBankName;
	//银行编码
    NSString                *_sBankNo;
    
    //新增 银行密码标识，0标识不需要密码，1标识需要密码
    NSString                *_strBankPWFlag;
    //币种名称
    NSString                *_sMoneyTypeName;
	//币种编码
    NSString                *_sMoneyTypeNo;
    //Token
    NSString                *_sToken;
    //开始日期
    NSString                *_sStartDate;
	//结束日期
    NSString                *_sEndDate;
	//资金转入账号
	NSString                *_sInFundAccount;
    //资金转出账号
	NSString                *_sOutFundAccount;
	//Key
    long                    _nKey;
	//功能号
	NSInteger                     _nQuestType;
}
@property(nonatomic,retain)NSMutableArray* saBankList;
@property(nonatomic,retain)NSMutableArray* saMoneyType;
@property(nonatomic,retain)NSMutableArray* saAccountList;

//交易账号
@property(nonatomic,retain)NSString                *sAccount;
//交易密码
@property(nonatomic,retain)NSString                *sAccountPW;
//选择的资金账号
@property(nonatomic,retain)NSString                *sFundAccount;
//银行密码
@property(nonatomic,retain)NSString                *sBankPW;
//资金密码
@property(nonatomic,retain)NSString                *sDealerPW;
//银行名称
@property(nonatomic,retain)NSString                *sBankName;
//银行编码
@property(nonatomic,retain)NSString                *sBankNo;

//新增 银行密码标识，0标识不需要密码，1标识需要密码
@property(nonatomic,retain)NSString                *strBankPWFlag;
//币种名称
@property(nonatomic,retain)NSString                *sMoneyTypeName;
//币种编码
@property(nonatomic,retain)NSString                *sMoneyTypeNo;
//Token
@property(nonatomic,retain)NSString                *sToken;
//开始日期
@property(nonatomic,retain)NSString                *sStartDate;
//结束日期
@property(nonatomic,retain)NSString                *sEndDate;
//资金转入账号
@property(nonatomic,retain)NSString                *sInFundAccount;
//资金转出账号
@property(nonatomic,retain)NSString                *sOutFundAccount;

-(void) CardBankTransform_;
-(void) CardBankTransform__;
//清空数据
-(void) RemoveAllInfo;
//加入银行信息以及币种信息
-(BOOL) AddBank:(NSString*)sBankName sBankNo_:(NSString*)sBankNo;
-(BOOL) AddBank:(NSString*)sBankName sBankNo_:(NSString*)sBankNo BankPW_:(NSString*)strBankPWFlag;
//币种类别
-(BOOL) AddMoneyType:(NSString*)sMoneyType sMoneyNo_:(NSString*)sMoneyNo;
//加入资金账号信息及银行信息，币种信息
-(BOOL) AddAccount:(NSString*)sAccount sBankName_:(NSString*)sBankName sMoneyName_:(NSString*)sMoneyName;
//加入资金账号可用金额信息
-(BOOL) AddUseVolume:(NSString*)sAccount strMoney_:(NSString*)strMoney sUseValume_:(NSString*)sUseValume; 
//加入资金账号可取金额信息
-(BOOL) AddAvailableVolume:(NSString*)sAccount strMoney_:(NSString*)strMoney sAvailableValume_:(NSString*)sAvailableValume; 
//增加银行－币种对应关系
-(void) AddBankToMoney:(NSString*)strBank strMoney_:(NSString*)strMoney;
//币种-银行对应关系
-(void) AddMoneyToBank:(NSString*)strMoney strBank_:(NSString*)strBank;

//三方存管银行数
-(NSInteger) GetBankCount;
//币种数
-(NSInteger) GetMoneyTypeCount;
//账号数
-(NSInteger) GetAccountCount;

//获取指定下标的银行名称和币种名称
-(NSString*) GetBankName:(int)nIdx;
-(NSString*) GetMoneyType:(int)nIdx;
-(NSString*) GetAccount:(int)nIdx;


//根据资金账号获取银行
-(NSString*) GetBankNameByAccount:(NSString*)strAccount;
//根据银行和币种获取资金账号
-(NSString*) getAccountByBank:(NSString*)strBank strMoney_:(NSString*)strMoney;
//根据资金账号和币种获取可用资金
-(NSString*) getUseVolumeByAccount:(NSString*)sAccount strMoney_:(NSString*)strMoney;
//根据资金账号和币种获取可取资金
-(NSString*) getAvailableVolumeByAccount:(NSString*)sAccount strMoney_:(NSString*)strMoney;


//填入账号以及账号密码
-(void) SetAccount:(NSString*)sAccount;//{			m_sAccount = sAccount;};
-(void) SetAccountPassword:(NSString*)sPassword;//{ m_sAccountPW = sPassword;};
-(void) setFundAccount:(NSString*)sFundAccount;
//资金账号
-(NSString*) GetFundAccount;

//填入银行以及币种
-(void) SetBank:(NSString*)sBackName;
-(void) SetMoneyType:(NSString*)sMoneyType;

-(NSString*) GetBankName;
-(NSString*) GetMoneyTypeName;

//资金转入账号
-(void) SetInFundAccount:(NSString*)inFundAccount;
-(NSString*) GetInFundAccount;

//资金转出账号
-(void) SetOutFundAccount:(NSString*)outFundAccount;
-(NSString*) GetOutFundAccount;

//银行密码标识
-(BOOL) IsShowBankPW:(NSString*)strBankName;

//填入银行密码
-(void) SetBankPassword:(NSString*)sPassword;
//设置资金密码
-(void) SetDealerPassword:(NSString*)sPassword;

//设定转账数量
-(void) SetTransferVolume:(float)fMoney;

//银行转券商请求
-(NSString*) MakeStrBankToDealer:(NSMutableDictionary*) pDict;
//券商转银行请求
-(NSString*) MakeStrDealerToBank:(NSMutableDictionary*) pDict;

//组合查询银证转账流水以及余额的字符串
-(NSString*) MakeStrQueryHistroy:(BOOL)isMoneyNotify sNO_:(NSString*)sNo strSend_:(NSMutableDictionary*) pDict;
-(NSString*) MakeStrQueryBalance:(NSMutableDictionary*) pDict;

//资金内转请求
-(NSString*) MakeStrZiJinNeiZhuan:(NSMutableDictionary*) pDict;
//查询银行列表请求
-(NSString*) MakeStrGetBankList:(NSMutableDictionary*) pDict;

-(void) SetToken:(NSString*)sToken;
-(void) SetStartDate:(NSString*)sStartDate;
-(void) SetEndDate:(NSString*)sEndDate;

//币种－银行列表
-(NSMutableArray*) GetBankListByMoney:(NSString*)strMoney;
//银行－币种列表
-(NSMutableArray*) GetMoneyListByBank:(NSString*)strBank;
//获取银行列表信息
-(void) GetBankList:(NSMutableArray*)ayBank;
//获取币种列表信息
-(void) GetMoneyList:(NSMutableArray*)ayMoney;

-(void) ReceiveBankInfoSuc:(BOOL)bSuc;
//是否有银证转账银行
-(BOOL) HaveBankInfo;
//清空可用资金
-(void) ClearUseVolumeData;
//清空可取资金
-(void) ClearAvailableVolumeData;
-(void) SetKey:(int)nKey;
-(void) SetTransferType:(NSInteger)nTransferType;
//银行密码标识
-(BOOL) IsShowBankPW:(NSString*)strBank nType_:(NSInteger)nType;
//资金密码标识
-(BOOL) IsShowFundPW:(NSString*)strBank nType_:(NSInteger)nType;
@end

#endif
