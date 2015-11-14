/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIBankDealerViewController.h"

@implementation tztUIBankDealerViewController
@synthesize pBankDealerView = _pBankDealerView;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_BANKTODEALER:
            case MENU_JY_PT_Bank2Card:
            case WT_DFBANKTODEALER:
            case WT_RZRQBANKTODEALER:
            case MENU_JY_RZRQ_Bank2Card:
                strTitle = @"银行转证券";
                break;
            case WT_DEALERTOBANK:
            case MENU_JY_PT_Card2Bank:
            case WT_DFDEALERTOBANK:
            case WT_RZRQDEALERTOBANK:
            case MENU_JY_RZRQ_Card2Bank:
                strTitle = @"证券转银行";
                break;
            case WT_QUERYBALANCE:
            case MENU_JY_PT_BankYue:
            case WT_DFQUERYBALANCE:
            case WT_RZRQQUERYBALANCE:
            case MENU_JY_RZRQ_BankYue:
                strTitle = @"银行余额";
                break;
            default:
                break;
        }
    }
    
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    CGRect rcBuySell = _tztBounds;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    rcBuySell.size.height -= (_tztTitleView.frame.size.height/* + TZTToolBarHeight*/);
    if (_pBankDealerView == nil)
    {
        _pBankDealerView = [[tztBankDealerView alloc] init];
        _pBankDealerView.delegate = self;
        _pBankDealerView.nMsgType = _nMsgType;
        _pBankDealerView.frame = rcBuySell;
        [_tztBaseView addSubview:_pBankDealerView];
        [_pBankDealerView release];
    }
    else
    {
        _pBankDealerView.frame = rcBuySell;
    }
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
}

-(void)CreateToolBar
{
#ifdef tzt_NewVersion // 新版去toolbar byDBQ20130716
#else
    if (!g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"取消|3599"];
    
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
#endif
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pBankDealerView)
    {
        bDeal = [_pBankDealerView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}


@end
