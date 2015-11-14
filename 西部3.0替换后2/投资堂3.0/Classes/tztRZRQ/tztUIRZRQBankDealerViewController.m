//
//  tztUIRZRQBankDealerViewController.m
//  tztMobileApp_xcsc
//
//  Created by x yt on 13-4-19.
//  Copyright (c) 2013年 11111. All rights reserved.
//

#import "tztUIRZRQBankDealerViewController.h"

@implementation tztUIRZRQBankDealerViewController
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
    CGRect rcFrame = _tztBounds;
    //标题view
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_BANKTODEALER:
            case WT_DFBANKTODEALER:
            case WT_RZRQBANKTODEALER:
            case MENU_JY_RZRQ_Bank2Card://新功能号 add by xyt 20131021
                strTitle = @"资金转入";
                break;
            case WT_DEALERTOBANK:
            case WT_DFDEALERTOBANK:
            case WT_RZRQDEALERTOBANK:
            case MENU_JY_RZRQ_Card2Bank://新功能号
                strTitle = @"资金转出";
                break;
            case WT_QUERYBALANCE:
            case WT_DFQUERYBALANCE:
            case WT_RZRQQUERYBALANCE:
            case MENU_JY_RZRQ_BankYue://新功能号
                strTitle = @"银行余额";
                break;
            default:
                break;
        }
    }
    
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin = CGPointZero;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    if (!g_pSystermConfig.bShowbottomTool)
    {
        rcBuySell.size.height -= (_tztTitleView.frame.size.height);
    }
    else
    {
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    if (_pBankDealerView == nil)
    {
        _pBankDealerView = [[tztRZRQBankDealerView alloc] init];
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
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"确定|6801"];
    [pAy addObject:@"取消|3599"];
    
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    DelObject(pAy);
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
