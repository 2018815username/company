/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        etf撤单
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIETFWithDrawViewController.h"

@interface tztUIETFWithDrawViewController ()

@end

@implementation tztUIETFWithDrawViewController
@synthesize tztWithDraw = _tztWithDraw;

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
    if (_tztWithDraw)
        [_tztWithDraw OnRequestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
            case WT_ETFWithDraw:
            case MENU_JY_ETFWX_Withdraw:
                strTitle = @"查撤委托";
                break;
            default:
                break;
        }
    }
    
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_tztWithDraw == nil)
    {
        _tztWithDraw = [[tztETFWithDrawView alloc] init];
        _tztWithDraw.nMsgType = _nMsgType;
        _tztWithDraw.delegate = self;
        _tztWithDraw.frame = rcBuySell;
        [_tztBaseView addSubview:_tztWithDraw];
        [_tztWithDraw release];
    }
    else
    {
        _tztWithDraw.frame = rcBuySell;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    //加载默认
    switch (_nMsgType)
    {
        case WT_ETFWithDraw:
        case MENU_JY_ETFWX_Withdraw:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"撤单|6807"];
        }
    }
    
#ifdef tzt_NewVersion
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_tztWithDraw)
    {
        bDeal = [_tztWithDraw OnToolbarMenuClick:sender];
    }
    
    UIButton *pBtn = (UIButton*)sender;
    
    if (!bDeal || pBtn.tag == TZTToolbar_Fuction_WithDraw)
        [super OnToolbarMenuClick:sender];
}



-(void)OnBtnNextStock:(id)sender
{
    if (_tztWithDraw)
        [_tztWithDraw OnGridNextStock:_tztWithDraw.pGridView ayTitle_:_tztWithDraw.aytitle];
}

-(void)OnBtnPreStock:(id)sender
{
    if (_tztWithDraw)
        [_tztWithDraw OnGridPreStock:_tztWithDraw.pGridView ayTitle_:_tztWithDraw.aytitle];
}
@end
