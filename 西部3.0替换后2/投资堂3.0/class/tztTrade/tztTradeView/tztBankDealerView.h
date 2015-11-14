/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        银证转账
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

@interface tztBankDealerView : tztBaseTradeView
{
    //显示表格
    tztUIVCBaseView      *_tztTableView;
    
    //银行数组
    NSMutableArray          *_ayBank;
    //币种数组  
    NSMutableArray          *_ayMoney;
    //账号数组
    NSMutableArray          *_ayAccount;
    //银行密码标识
    NSInteger                     _bNeedBankPW;
    //资金密码标识
    NSInteger                     _bNeedFundPW;
    //
    NSInteger                     _nMoneyTypeIndex;
    NSInteger                     _nBankTypeIndex;
    NSString                *_nsKYMoney;
}


@property(nonatomic,retain)tztUIVCBaseView   *tztTableView;
@property(nonatomic,retain)NSMutableArray       *ayBank;
@property(nonatomic,retain)NSMutableArray       *ayMoney;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSString             *nsKYMoney;

@end
