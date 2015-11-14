/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券买卖vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUIRZRQBuySellViewController.h"
#ifdef kSUPPORT_XBSC
#import "RZRQMacro.h"
#endif
@implementation tztUIRZRQBuySellViewController
@synthesize pRZRQBuySell = _pRZRQBuySell;
@synthesize bBuyFlag  = _bBuyFlag;
@synthesize CurStockCode = _CurStockCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return YES;
    }
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self LoadLayoutView];
}

//xianlan 获取指定卖券还款选中的信息（定义这个方法其实想法是为了通用的方法  写这个是为了方便搜索）
-(void)acquireInfo:(NSMutableArray*)ayTitle
{
    
//    for(int i=0;i<[ayTitle count];i++)
//    {
    
       _contractNumber=ayTitle[1];
        _repaymentAmount=ayTitle[2];
//    }
}


-(NSString *)GetTitle:(NSInteger)nType
{ //标题view
    NSString *strTitle = GetTitleByID(nType);
    if (strTitle == nil || strTitle.length <= 0)
    {
        switch (nType)
        {
            case WT_RZRQBUY://普通买入（信用买入）  担保品买入//新功能号 by xyt
                strTitle = @"普通买入";
                break;
            case MENU_JY_RZRQ_PTBuy:
                strTitle = @"担保品买入";
                break;
            case WT_RZRQSALE://            case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
                strTitle = @"普通卖出";
                break;
            case MENU_JY_RZRQ_PTSell:
                strTitle = @"担保品卖出";
                break;
                
            case WT_RZRQRZBUY:
            case MENU_JY_RZRQ_XYBuy:// 融资买入
                strTitle = @"融资买入";
                break;
            case WT_RZRQRQSALE:
            case MENU_JY_RZRQ_XYSell://融券卖出
                strTitle = @"融券卖出";
                break;
            case WT_RZRQBUYRETURN:
            case MENU_JY_RZRQ_BuyReturn://买券还券
                strTitle = @"买券还券";
                break;
            case WT_RZRQSALERETURN:
            case MENU_JY_RZRQ_SellReturn://卖券还款
                strTitle = @"卖券还款";
                break;
#ifdef kSUPPORT_XBSC
            case kRZRQ_ZDMQHK:
                 strTitle = @"指定卖券还款";
                break;
#endif
            
            default:
                break;
        }
    }
    return strTitle;
}

-(void)tztChangeMsgType:(int)nType bBuyFlag_:(BOOL)bFlag
{
    NSString *strTitle = [self GetTitle:nType];
    if (strTitle == NULL)
        strTitle = @"";
    _nMsgType = nType;
    self.nsTitle = [NSString stringWithFormat:@"%@",strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn];
    _bBuyFlag = bFlag;
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    
    NSString * sTitle = [self GetTitle:_nMsgType];
    if (sTitle == NULL)
        sTitle = @"";
    self.nsTitle = [NSString stringWithFormat:@"%@", sTitle];
    
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn]; // 融资融券加返回 byDBQ20130724
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    if (IS_TZTIPAD||!g_pSystermConfig.bShowbottomTool)
        rcBuySell.size.height -= _tztTitleView.frame.size.height;
    else
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    
    if (_pRZRQBuySell == nil) 
    {
        _pRZRQBuySell = [[tztRZRQBuySellView alloc] init];
        _pRZRQBuySell.bBuyFlag = _bBuyFlag;
        _pRZRQBuySell.delegate = self;
        _pRZRQBuySell.nMsgType = _nMsgType;
        _pRZRQBuySell.frame = rcBuySell;
        [_pRZRQBuySell tztperformSelector:@"SetSeraialNo:" withObject:self.nsSeraialNo];
        if (self.CurStockCode && [self.CurStockCode length] > 0) // 赋值self.CurStockCode byDBQ20130729
        {
            [_pRZRQBuySell setStockCode:self.CurStockCode];
            if (_pRZRQBuySell && [_pRZRQBuySell respondsToSelector:@selector(setCurContractNumber)])
            {
                // cs 西部
                [_pRZRQBuySell setCurContractNumber:self.contractNumber];
            }
            if (_pRZRQBuySell && [_pRZRQBuySell respondsToSelector:@selector(setCurRepaymentAmount)])
            {
                [_pRZRQBuySell setCurRepaymentAmount:self.repaymentAmount];
            }
//            [_pRZRQBuySell setCurContractNumber:self.contractNumber];
//              [_pRZRQBuySell setCurRepaymentAmount:self.repaymentAmount];
            [_pRZRQBuySell OnRefresh];
        }
        [_tztBaseView addSubview:_pRZRQBuySell];
        [_pRZRQBuySell release];

    }
    else
    {
        _pRZRQBuySell.frame = rcBuySell;
    }
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    if (!g_pSystermConfig.bShowbottomTool)
        return;
   
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolRZRQStockBuy" delegate_:self forToolbar_:toolBar];
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pRZRQBuySell)
    {
        bDeal = [_pRZRQBuySell OnToolbarMenuClick:sender];
    }
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn.tag == TZTToolbar_Fuction_Switch)
    {
        tztStockInfo *pStock = NewObject(tztStockInfo);
        pStock.stockCode = [NSString stringWithString:self.pRZRQBuySell.CurStockCode];
        int nSwitchMsyType = 0;
        switch (_nMsgType)
        {
            case WT_RZRQBUY:
            case MENU_JY_RZRQ_PTBuy://普通买入（信用买入） 担保品买入//新功能号 by xyt
                nSwitchMsyType = WT_RZRQSALE;
                break;
            case WT_RZRQSALE:
            case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
                nSwitchMsyType = WT_RZRQBUY;
                break;
            case WT_RZRQRZBUY:
            case MENU_JY_RZRQ_XYBuy:// 融资买入
                nSwitchMsyType = WT_RZRQRQSALE;
                break;
            case WT_RZRQRQSALE:
            case MENU_JY_RZRQ_XYSell://融券卖出
                nSwitchMsyType = WT_RZRQRZBUY;
                break;
            case WT_RZRQBUYRETURN:
            case MENU_JY_RZRQ_BuyReturn://买券还券
                nSwitchMsyType = WT_RZRQSALERETURN;
                break;
            case WT_RZRQSALERETURN:
            case MENU_JY_RZRQ_SellReturn://卖券还款
                nSwitchMsyType = WT_RZRQBUYRETURN;
                break;
            default:
                break;
        }
        if(nSwitchMsyType != 0)
        {
            [TZTUIBaseVCMsg OnMsg:nSwitchMsyType wParam:(NSUInteger)pStock lParam:0];
        }
        [pStock release];
        return;
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

-(void)OnRequestData
{
    if (self.CurStockCode == NULL || self.CurStockCode.length < 1)
    {
        if (_pRZRQBuySell)
        {
            [_pRZRQBuySell ClearData];
        }
    }
    else
    {
        if (_pRZRQBuySell)
        {
            [_pRZRQBuySell ClearData];
            [_pRZRQBuySell setStockCode:self.CurStockCode];
            [_pRZRQBuySell OnRefresh];
        }
    }
    
}

-(void)tztRefreshData
{
    if (_pRZRQBuySell && [_pRZRQBuySell respondsToSelector:@selector(tztRefreshData)])
    {
        [_pRZRQBuySell tztRefreshData];
    }
}

@end
