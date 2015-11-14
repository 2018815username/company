/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金盘后 分拆，合并
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUITradeFundPHViewController.h"

@interface tztUITradeFundPHViewController ()

@end

@implementation tztUITradeFundPHViewController
@synthesize tztTradeView = _tztTradeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;// self.view.bounds;
    
    NSString *strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_FundPH_JJFC:
            case MENU_JY_FUND_PHSplit:
                strTitle = @"基金分拆";
                break;
            case WT_FundPH_JJHB:
            case MENU_JY_FUND_PHMerge:
                strTitle = @"基金合并";
                break;
            case WT_FundPH_JJZH:
                strTitle = @"基金转换";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcView = rcFrame;
    rcView.origin.y += _tztTitleView.frame.size.height;
    if (g_pSystermConfig.bShowbottomTool)
    {
        rcView.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    }
    else
    {
        rcView.size.height -= _tztTitleView.frame.size.height;
    }
    
    if (_tztTradeView == NULL)
    {
        _tztTradeView = [[tztFundPHTradeView alloc] init];
        _tztTradeView.delegate = self;
        _tztTradeView.nMsgType = _nMsgType;
        _tztTradeView.frame = rcView;
        [_tztBaseView addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
        _tztTradeView.frame = rcView;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    
}


@end
