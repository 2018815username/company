/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        质押回购查询vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUITradeZYHGSearchViewController.h"

@interface tztUITradeZYHGSearchViewController ()

@end

@implementation tztUITradeZYHGSearchViewController
@synthesize tztSearchView = _tztSearchView;

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
    if (_tztSearchView)
        [_tztSearchView OnRequestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadLayoutView
{
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_ZYHG_ZYMX:
            case MENU_JY_ZYHG_QueryInfo:
            {
                strTitle = @"质押明细查询";
            }
                break;
            case WT_ZYHG_WDQHG:
            case MENU_JY_ZYHG_QueryNoDue:
            {
                strTitle = @"未到期回购查询";
            }
                break;
            case WT_ZYHG_BZQMX:
            case MENU_JY_ZYHG_QueryStanda:
            {
                strTitle = @"标准券明细查询";
            }
                break;
            case MENU_JY_ZYHG_QueryBuySell:
            {
                strTitle = @"出入库查询";
            }
            default:
                strTitle = @"";
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    CGRect rcFrame = _tztBounds;
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    
    if (_tztSearchView == nil)
    {
        _tztSearchView = [[tztZYHGSearchView alloc] init];
        _tztSearchView.frame = rcFrame;
        _tztSearchView.delegate = self;
        _tztSearchView.nMsgType = _nMsgType;
        [_tztBaseView addSubview:_tztSearchView];
        [_tztSearchView release];
    }
    else
    {
        _tztSearchView.frame = rcFrame;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
#ifndef tzt_NewVersion
    [super CreateToolBar];
#endif
    
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"详细|6808"];
    [pAy addObject:@"刷新|6802"];
    
#ifdef tzt_NewVersion
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_tztSearchView)
    {
        bDeal = [_tztSearchView OnToolbarMenuClick:sender];
    }
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}


-(void)OnBtnNextStock:(id)sender
{
    if (_tztSearchView)
        [_tztSearchView OnGridNextStock:_tztSearchView.pGridView ayTitle_:_tztSearchView.ayTitle];
}

-(void)OnBtnPreStock:(id)sender
{
    if (_tztSearchView)
        [_tztSearchView OnGridPreStock:_tztSearchView.pGridView ayTitle_:_tztSearchView.ayTitle];
}

@end
