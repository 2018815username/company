/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金开户
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFoundHKVC.h"

@implementation tztUIFoundHKVC

@synthesize pFundKhView = _pFundKhView;
@synthesize nsJJGSDM = _nsJJGSDM;
@synthesize nsJJGSMC = _nsJJGSMC;
@synthesize nReturn = _nReturn;
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
    //标题view
    NSString* strTitle= GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case MENU_QS_HTSC_ZJLC_Kaihu:
                strTitle = @"紫金开户";
                break;
            default:
                strTitle = @"基金开户";
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
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
    if (_pFundKhView == nil)
    {
        _pFundKhView = [[tztUIFundKHView alloc] init];
        _pFundKhView.delegate = self;
        _pFundKhView.nMsgType = _nMsgType;
        _pFundKhView.frame = rcBuySell;
        //如果这些都存在 就去显示这些信息
        if (self.nsJJGSMC && [self.nsJJGSMC length] > 0 && self.nsJJGSDM&&[self.nsJJGSDM length] > 0)
        {
            [_pFundKhView SetShowMSG:self.nsJJGSMC NSFundDM:self.nsJJGSDM Return:self.nReturn];
        }
        else
        {
            if (_pFundKhView && [_pFundKhView respondsToSelector:@selector(SetDefaultData)])
            {
                [_pFundKhView SetDefaultData];
            }
        }
        [_tztBaseView addSubview:_pFundKhView];
        [_pFundKhView release];
    }
    else
    {
        _pFundKhView.frame = rcBuySell;
    }
    
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}


-(void)CreateToolBar
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
	[tztUIBarButtonItem GetToolBarItemByKey:@"TZTToolTradeFundKH" delegate_:self forToolbar_:toolBar];
#endif
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pFundKhView)
    {
        bDeal = [_pFundKhView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick: sender];
}

@end
