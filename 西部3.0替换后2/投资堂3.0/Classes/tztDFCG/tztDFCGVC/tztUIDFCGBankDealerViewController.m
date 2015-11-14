/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztUIDFCGBankDealerViewController
 * 文件标识:
 * 摘要说明:		多方存管 银转证 、证转银、查询余额、资金内转界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIDFCGBankDealerViewController.h"

@implementation tztUIDFCGBankDealerViewController
@synthesize pView = _pView;
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
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_DFBANKTODEALER:
                strTitle = @"卡转证券";
                break;
            case WT_DFDEALERTOBANK:
            case MENU_JY_DFBANK_Bank2Card://证券转卡
                strTitle = @"证券转卡";
                break;
            case WT_DFQUERYBALANCE:
                strTitle = @"查询余额";
                break;
            case WT_NeiZhuan:
                strTitle = @"资金内转";
                break;
            case MENU_JY_DFBANK_Transit:
                strTitle =@"资金调拨";
                break;
            case MENU_JY_DFBANK_Card2Bank:
                strTitle = @"资金转出";
                break;
                case MENU_JY_DFBANK_BankYue:
                strTitle  =@"银行余额";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    if (g_pSystermConfig && g_pSystermConfig.bShowbottomTool)
    {
        rcView.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    else
    {
        rcView.size.height -= _tztTitleView.frame.size.height;
    }
    
    if (_pView == NULL)
    {
        _pView = [[tztDFCGBankDealerView alloc] init];
        _pView.delegate = self;
        _pView.nMsgType = _nMsgType;
        _pView.frame = rcView;
        [_tztBaseView addSubview:_pView];
        [_pView release];
    }
    else
        _pView.frame = rcView;
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
 
    [self CreateToolBar];
}
-(void)CreateToolBar
{
    if (g_pSystermConfig && !g_pSystermConfig.bShowbottomTool)
        return;
    [super CreateToolBar];
    
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"取消|3599"];
    
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pView)
    {
        bDeal = [_pView OnToolbarMenuClick:sender];
    }
    
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}
@end
