/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ETF查询功能
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztETFSearchView.h"

@implementation tztETFSearchView

-(NSString*)GetReqAction:(NSInteger)nMsgID
{
    switch (nMsgID)
    {
        case WT_ETFCrashRGQuery:     //网下认购查询
        case  MENU_JY_ETFWX_QueryFund: //14041  现金认购查询
            _reqAction = @"668";
            break;
        case WT_ETFStockRGQuery:    //网下股票认购
        case MENU_JY_ETFWX_QueryStock: //14042  股票认购查询
            _reqAction = @"670";
            break;
        case WT_ETF_HS_CrashQUery:  //沪市现金查询
        case MENU_JY_ETFKS_HSQueryFund: //14081  沪市现金查询
            _reqAction = @"668";
            break;
        case WT_ETF_HS_StockQuery:  //沪市股票查询
        case MENU_JY_ETFKS_HSQueryStock: //14082  沪市股票查询
            _reqAction = @"670";
            break;
        case WT_ETF_SS_RGQuery:     //深市认购查询
        case MENU_JY_ETFKS_SSRGQuery: //14083  深市认购查询
            _reqAction = @"661";
            break;
        case WT_ETFInquireEntrust://货币基金当日委托
        case MENU_JY_FUND_HBQueryDraw://货币基金当日委托 add by xyt 20131113
        case MENU_JY_FUND_HBWithdraw://货币基金委托撤单
            _reqAction = @"643";
            break;
        case WT_ETFInquireHisEntrust://货币基金历史委托查询
        case MENU_JY_FUND_HBQueryHis://货币基金历史委托
            _reqAction = @"652";
            break;

        default:
            break;
    }
    
    return _reqAction;
}

//各个不同的请求增加个字特定的请求数据字段
-(void)AddSearchInfo:(NSMutableDictionary *)pDict
{
    switch (_nMsgType)
    {
        case WT_ETFInquireEntrust:
        case MENU_JY_FUND_HBQueryDraw://货币基金当日委托
        case MENU_JY_FUND_HBWithdraw:
        {
            [pDict setTztValue:@"0" forKey:@"Direction"];
        }
            break;
//        case MENU_JY_FUND_HBWithdraw:
//        {
//            [pDict setTztValue:@"1" forKey:@"Direction"];
//        }
//            break;
        default:
            break;
    }
}

//-(BOOL)OnToolbarMenuClick:(id)sender
//{
//    UIButton *pBtn = (UIButton*)sender;
//    switch (pBtn.tag)
//    {
//        case TZTToolbar_Fuction_Detail:
//        {
//            return [self OnDetail:_pGridView ayTitle_:_aytitle];
//        }
//            break;
//        case TZTToolbar_Fuction_Refresh:
//        {
//            [self OnRequestData];
//            return TRUE;
//        }
//            break;
//        case WT_RZRQSALE:
//        {
//            return TRUE;
//        }
//            break;
//        default:
//            break;
//    }
//    return FALSE;
//}
@end
