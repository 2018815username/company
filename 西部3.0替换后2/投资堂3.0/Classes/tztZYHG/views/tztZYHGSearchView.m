/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        质押回购查询
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztZYHGSearchView.h"

@implementation tztZYHGSearchView

-(NSString*)GetReqAction:(int)nMsgID
{
    switch (nMsgID) {
        case WT_ZYHG_ZYMX://质押明细
        case MENU_JY_ZYHG_QueryInfo:
            _reqAction = @"604";
            break;
        case WT_ZYHG_WDQHG://未到期明细
        case MENU_JY_ZYHG_QueryNoDue:
            _reqAction = @"605";
            break;
        case WT_ZYHG_BZQMX://标准券明细
        case MENU_JY_ZYHG_QueryStanda:
            _reqAction = @"606";
            break;
        case MENU_JY_ZYHG_QueryBuySell: // 质押出入库
            _reqAction = @"608";
            break;
        default:
            break;
    }
    return _reqAction;
}

-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
    if (_nMsgType == WT_ZYHG_WDQHG || _nMsgType == WT_ZYHG_BZQMX)
    {
        //获取当前使用的账号，添加资金账号等信息
        NSString* nsFundCode = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsFundAccount;
        NSString* nsAccount = @"";// [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].nsAccount;
        NSString* nsAccountType = @"";
        tztZJAccountInfo* pZJ = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType].ZjAccountInfo;
        if (pZJ)
        {
            nsAccount = pZJ.nsAccount;
            nsAccountType = pZJ.nsAccountType;
        }
        
        if (nsFundCode)
            [pDict setTztValue:nsFundCode forKey:@"fundaccount"];
        if (nsAccount)
            [pDict setTztValue:nsAccount forKey:@"WTAccount"];
        if (nsAccountType)
            [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
        
    }
}

-(BOOL)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    bDeal = [super OnToolbarMenuClick:sender];
    return bDeal;
}

@end
