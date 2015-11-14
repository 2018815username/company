/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUIDateViewController.m
* 文件标识:
* 摘要说明:
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/

#define Show_Nildate 0
#define Show_Begdate 1
#define Show_Enddate 2

#import "TZTUIDateViewController.h"
#import "tztUITradeSearchViewController.h"

@implementation TZTUIDateViewController
@synthesize pDateView = _pDateView;
@synthesize vcType = _vcType;
- (void)dealloc 
{
    [super dealloc];
}

-(void)setVcType:(NSInteger)type
{
    _vcType = type;
    _nMsgType = _vcType;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
 

    NSString* strTitle = GetTitleByID(_nMsgType);
    
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_RZRQZJLSHis:
            case MENU_JY_RZRQ_QueryFundsHis://资金流水历史 //新功能号 add by xyt 20131018
                strTitle = @"资金流水历史";
                break;
            case WT_RZRQQUERYLS://”资金流水“
            case MENU_JY_RZRQ_QueryFundsDayHis: //资金流水
            
                strTitle = @"资金流水";
                break;
            case WT_RZRQQUERYFZLS://”负债变动流水“
            case MENU_JY_RZRQ_QueryFZQKHis:// 负债变动 负债变动流水
                strTitle = @"负债变动流水";
                break;
            case WT_RZRQQUERYLSCJ:
            case WT_QUERYLSCJ:  //"历史成交"
            case MENU_JY_PT_QueryTransHis://历史成交 新功能号add by xyt 20131128
            case MENU_QS_HTSC_ZJLC_QueryVerifyHis:
            case WT_JJINQUIRECJ:
            case MENU_JY_RZRQ_QueryTransHis://历史成交 
            case MENU_JY_FUND_QueryVerifyHis://历史确认(历史成交？)
                strTitle = @"历史成交";
                break;            
            case WT_RZRQQUERYDZD://”对账单查询“
            case MENU_JY_RZRQ_QueryDZD://对账单查询
                strTitle = @"对账单查询";
                break;
            case WT_QUERYPH:    //"查询配号"
            case MENU_JY_PT_QueryPH:
                strTitle = @"查询配号";
                break;
            case WT_QUERYLS:    //"资金明细"
            case MENU_JY_PT_QueryZJMX:
                strTitle = @"资金明细";
                break;
            case WT_RZRQQUERYJG:
            case WT_QUERYJG:    //"查询交割"
            case MENU_JY_PT_QueryJG:
            case MENU_JY_RZRQ_QueryJG://交割单查询
                strTitle = @"查询交割";
                break;
            case MENU_JY_PT_QueryHisTrade:
                strTitle = @"查询历史委托";
                break;
            case WT_RZRQQUERYLSWT://历史委托
            case MENU_JY_RZRQ_QueryWTHis://历史委托
            case WT_JJINQUIREWT:
            case MENU_QS_HTSC_ZJLC_QueryWTHis:
            case WT_DKRY_LSWT:
            case MENU_JY_BJHG_HisQuery: //13848  历史委托查询389 byDBQ20131011
            case MENU_JY_FUND_QueryWTHis://历史委托
                strTitle = @"历史委托";
                break;
            case WT_DKRY_WTQR:
                strTitle = @"委托确认";
                break;
            case WT_RZRQYPC:        //信用合约已平仓
            case MENU_JY_RZRQ_QueryDealOver:
                strTitle = @"已平仓";
                break;
            case WT_JJPHInquireHisEntrust://基金盘后历史委托查询  LOF历史委托
                strTitle = @"LOF历史委托";
                break;
            case WT_JJPHInquireHisCJ://
                strTitle = @"LOF历史成交";
                break;
            case WT_ETFInquireHisEntrust:////货币基金(ETF)历史委托查询
            case MENU_JY_FUND_HBQueryHis://货币基金历史委托
                strTitle = @"货币基金历史委托";
                break;

            case MENU_JY_RZRQ_RZFZHis: //15306  已偿还融资负债 474
                strTitle = @"已偿还融资负债";
                break;
            case MENU_JY_RZRQ_RQFZHis: //15307  已偿还融券负债 475
                strTitle = @"已偿还融券负债";
                break;
            case MENU_JY_FUND_XJBLEDSetting:
            case MENU_JY_FUND_PHQueryHisWT:
                strTitle =@"历史委托";
                break;
            case MENU_JY_RZRQ_NoTradeTransHis:  //历史非交易过户委托
                strTitle = @"历史非交易过户委托";
                break;
                
            case MENU_JY_RZRQ_NewStockPH:
                strTitle = @"查询新股配号";
                break;
            case  MENU_JY_RZRQ_NewStockZQ:
            case MENU_JY_PT_QueryNewStockZQ:
                strTitle = @"查询新股中签";
                break;
            default:
                break;

        
        };
    }
 
    
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn];
    
    CGRect rc = _tztBounds;
    rc.origin = CGPointZero;
    rc.origin.y += _tztTitleView.frame.size.height;
    rc.size.height -=  _tztTitleView.frame.size.height;
	if (_pDateView == nil)
    {
        _pDateView = [[tztUIDateView alloc] init];
        _pDateView.vcType = _nMsgType;
        _pDateView.frame = rc;
        [_tztBaseView addSubview:_pDateView];
        [_pDateView release];
    }
    else
        _pDateView.frame = rc;
}
/*函数功能：设置默认最大时间
 入参：时间
 出参：
 */
-(void)SetMaxDate:(NSDate *)MaxDate
{
    if (_pDateView)
        [_pDateView setMaxDate:MaxDate];
}
/*函数功能：设置默认最小时间
 入参：时间
 出参：
 */
-(void)SetMinDate:(NSDate *)MinDate
{
    if (_pDateView)
        [_pDateView SetMinDate:MinDate];
}
//
-(void)CreateToolBar
{
    
}

-(void)OnReturnBack
{
    //返回，取消风火轮显示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [g_navigationController popViewControllerAnimated:UseAnimated]; //通过popVC清除队列
    UIViewController* pTop = g_navigationController.topViewController;
    if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
    {
        g_navigationController.navigationBar.hidden = NO;
        [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
    }
}
@end
