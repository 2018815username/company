/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券委托撤单
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUIRZRQWithDrawViewController.h"

@implementation tztUIRZRQWithDrawViewController
@synthesize pWithDrawView = _pWithDrawView;

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
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
    if (_pWithDrawView)
        [_pWithDrawView OnRequestData];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
            case WT_RZRQQUERYDRWT:
            case MENU_JY_RZRQ_QueryDraw://当日委托 //新功能号 add by xyt 20131018
                strTitle = @"当日委托";
                break;
            case WT_RZRQQUERYHZLS:
            case MENU_JY_RZRQ_TransQueryDraw://划转流水 add by xyt 20131021
                strTitle = @"划转流水";
                break;
            case WT_RZRQQUERYWITHDRAW:
            case MENU_JY_RZRQ_Withdraw://委托撤单
                strTitle = @"委托撤单";
                break;
            case WT_RZRQWITHDRAWHZ://划转撤单
            case MENU_JY_RZRQ_TransWithdraw://划转撤单
                strTitle = @"划转撤单";
                break;
            case MENU_JY_RZRQ_NoTradeQueryDraw:
                strTitle = @"非交易委托过户";
                break;
            default:
                break;
        }
    }
    
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcSearch = rcFrame;
    rcSearch.origin.y += _tztTitleView.frame.size.height;
    rcSearch.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pWithDrawView == nil) 
    {
        _pWithDrawView = [[tztRZRQTradeWithDrawView alloc] init];
        _pWithDrawView.delegate = self;
        _pWithDrawView.nMsgType = _nMsgType;
        _pWithDrawView.frame = rcSearch;
        [_tztBaseView addSubview:_pWithDrawView];
        [_pWithDrawView release];
    }
    else
    {
        _pWithDrawView.frame = rcSearch;
    }
    
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
        self.tztTitleView.fourthBtn.hidden = YES;
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"详细|6808"];
    [pAy addObject:@"刷新|6802"];
    [pAy addObject:@"撤单|6807"];
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
    if (_pWithDrawView)
    {
        bDeal = [_pWithDrawView OnToolbarMenuClick:sender];
    }
    
    UIButton *pBtn = (UIButton*)sender;
    
    if (!bDeal || pBtn.tag == TZTToolbar_Fuction_WithDraw)
        [super OnToolbarMenuClick:sender];
}


-(void)OnBtnNextStock:(id)sender
{
    if (_pWithDrawView)
        [_pWithDrawView OnGridNextStock:_pWithDrawView.pGridView ayTitle_:_pWithDrawView.ayTitle];
}

-(void)OnBtnPreStock:(id)sender
{
    if (_pWithDrawView)
        [_pWithDrawView OnGridPreStock:_pWithDrawView.pGridView ayTitle_:_pWithDrawView.ayTitle];
}
@end
