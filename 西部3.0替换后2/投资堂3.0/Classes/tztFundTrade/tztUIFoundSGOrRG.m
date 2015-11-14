/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金申购赎回vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFoundSGOrRG.h"

@implementation tztUIFoundSGOrRG
@synthesize pFundTradeRGSG = _pFundTradeRGSG;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.contentSizeForViewInPopover = CGSizeMake(500, 580);
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

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_JJRGFUND:
            case MENU_JY_FUND_RenGou: //基金认购 //新功能号add by xyt 20131018
                strTitle = @"基金认购";
                break;
            case MENU_QS_HTSC_ZJLC_RenGou:
                strTitle = @"产品认购";
                break;
            case WT_JJAPPLYFUND:
            case MENU_JY_FUND_ShenGou://基金申购
                strTitle = @"基金申购";
                break;
            case MENU_QS_HTSC_ZJLC_ShenGou:
                strTitle = @"产品申购";
                break;
            case WT_JJREDEEMFUND:
            case MENU_JY_FUND_ShuHui://基金赎回
                strTitle = @"基金赎回";
                break;
            case MENU_QS_HTSC_ZJLC_ShuHui:
                strTitle = @"产品赎回";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    _tztTitleView.bHasCloseBtn = IS_TZTIPAD;
    if (IS_TZTIPAD)
        [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn|TZTTitleNormal];
    else
        [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    //zxl 20130718 修改了不需要底部工具条Frame 高度修改
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcBuySell.size.height -= _tztTitleView.frame.size.height; 
    }else
    {
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    if (_pFundTradeRGSG == nil)
    {
        _pFundTradeRGSG = [[tztUIFundTradeRGSGView alloc] init];
        _pFundTradeRGSG.nMsgType = _nMsgType;
        _pFundTradeRGSG.delegate = self;
//        if (IS_TZTIPAD) {
//            _pFundTradeRGSG.isFullWidth = YES;
//        }
        _pFundTradeRGSG.frame = rcBuySell;
        if (self.CurStockCode && [self.CurStockCode length] > 0)
            _pFundTradeRGSG.CurStockCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
        if (_pFundTradeRGSG && [_pFundTradeRGSG respondsToSelector:@selector(SetDefaultData)]) {
            [_pFundTradeRGSG SetDefaultData];
        }
        [_pFundTradeRGSG fundCustomerInqireLevel];
        [_tztBaseView addSubview:_pFundTradeRGSG];
        [_pFundTradeRGSG release];
    }
    else
    {
        _pFundTradeRGSG.frame = rcBuySell;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    if (!IS_TZTIPAD)
        [self CreateToolBar];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    if (!IS_TZTIPAD)
    {
        //zxl 20130718 修改了不需要底部工具条直接返回
        if (!g_pSystermConfig.bShowbottomTool)
            return;
#ifdef tzt_NewVersion
        NSArray *pAy = [g_pSystermConfig.pDict objectForKey:@"TZTToolTradeFundKH"];
        if (pAy == NULL || [pAy count] < 1)
            return;
        [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
        [super CreateToolBar];
        //加载默认
        [tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeFund" delegate_:self forToolbar_:toolBar];
#endif
    }
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pFundTradeRGSG)
    {
        bDeal = [_pFundTradeRGSG OnToolbarMenuClick:sender];
    }
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

@end
