//
//  tztUIFundCNTradeVC.m
//  tztMobileApp
//
//  Created by deng wei on 13-3-14.
//  Copyright (c) 2013年 中焯. All rights reserved.
//

#import "tztUIFundCNTradeVC.h"

@implementation tztUIFundCNTradeVC

@synthesize pFundTradeCN = _pFundTradeCN;
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

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_JJRGFUNDEX:
            case MENU_JY_FUNDIN_RenGou://场内基金认购
                strTitle = @"场内基金认购";
                break;
            case WT_JJAPPLYFUNDEX:
            case MENU_JY_FUNDIN_ShenGou://场内基金申购
                strTitle = @"场内基金申购";
                break;
            case WT_JJREDEEMFUNDEX:
            case MENU_JY_FUNDIN_ShuHui://场内基金赎回
                strTitle = @"场内基金赎回";
                break;
            case WT_HBJJ_RG:
                strTitle = @"货币基金认购";
                break;
            case WT_HBJJ_SG:
            case MENU_JY_FUND_HBShenGou:
                strTitle = @"货币基金申购";
                break;
            case WT_HBJJ_SH:
            case MENU_JY_FUND_HBShuHui:
                strTitle = @"货币基金赎回";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    //标题view
    CGRect rcTitle = _tztTitleView.frame;
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += rcTitle.size.height;
    
    //zxl 20130718 修改了不需要底部工具条Frame 高度修改
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcBuySell.size.height -= _tztTitleView.frame.size.height;
    }else
    {
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    if (_pFundTradeCN == nil)
    {
        _pFundTradeCN = [[tztUIFundCNTradeView alloc] init];
        _pFundTradeCN.nMsgType = _nMsgType;
        _pFundTradeCN.delegate = self;
        _pFundTradeCN.frame = rcBuySell;
        if (self.CurStockCode && [self.CurStockCode length] > 0)
            _pFundTradeCN.CurStockCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
        [_pFundTradeCN SetDefaultData];
        [_tztBaseView addSubview:_pFundTradeCN];
        [_pFundTradeCN release];
    }
    else
    {
        _pFundTradeCN.frame = rcBuySell;
    }
    
    [self CreateToolBar];
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
    //zxl 20130718 修改了不需要底部工具条直接返回
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    //加载默认
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeFundKH" delegate_:self forToolbar_:toolBar];
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pFundTradeCN)
    {
        bDeal = [_pFundTradeCN OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

@end
