/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        报价回购查询vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUITradeBJHGSearchViewController.h"

@interface tztUITradeBJHGSearchViewController ()

@end

@implementation tztUITradeBJHGSearchViewController
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

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_BJHG_WTCX:
            case MENU_JY_BJHG_QueryDraw:
                strTitle = @"委托查询";
                break;
            case WT_BJHG_XXZZ:
                strTitle = @"终止续作";
                break;
            case MENU_JY_BJHG_Ahead: //13842  提前购回/终止
            case WT_BJHG_TQGH:
                strTitle = @"提前终止";
                break;
            case WT_BJHG_YYTG:
            case MENU_JY_BJHG_MakeAn:
                strTitle = @"预约提前购回";
                break;
            case MENU_JY_BJHG_QueryNoDue: //13860  未到期
            case WT_BJHG_WDQ:
                strTitle = @"未到期";
                break;
            case WT_BJHG_ZYMX:
            case MENU_JY_BJHG_QueryInfo:
                strTitle = @"质押明细";
                break;
            case MENU_JY_BJHG_AllInfo:  //13844  所有信息查询380
                strTitle = @"信息查询";
                break;
            case MENU_JY_BJHG_DEYYZZ:   //13845  大额预约终止391
                strTitle = @"大额预约终止";
                break;
            case MENU_JY_BJHG_Withdraw: //13846  委托撤单393
                strTitle = @"委托撤单";
                break;
            case MENU_JY_BJHG_YYZZWithdraw: //13847  预约终止撤单392
                strTitle = @"预约终止撤单";
                break;
            case MENU_JY_BJHG_Stop: //13841  终止续作387/390
                strTitle = @"续作终止";
                break;
            case MENU_JY_BJHG_DealQuery: //13849  成交查询 650
                strTitle = @"成交查询";
                break;
            default:
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    
    if (_tztSearchView == nil)
    {
        _tztSearchView = [[tztBJHGSearchView alloc] init];
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
    switch (_nMsgType)
    {
        case WT_BJHG_ZYMX:
        case MENU_JY_BJHG_QueryInfo:
        case WT_BJHG_WDQ:
        case WT_BJHG_WTCX:
        case MENU_JY_BJHG_QueryNoDue: //13860  未到期
        case MENU_JY_BJHG_AllInfo:  //13844  所有信息查询380
        case MENU_JY_BJHG_DealQuery: //13849  成交查询 650
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
        }
            break;
        case MENU_JY_BJHG_YYZZWithdraw: //13847  预约终止撤单392
        case MENU_JY_BJHG_Withdraw: //13846  委托撤单393
        case MENU_JY_BJHG_QueryDraw: //13840  委托查询
        case WT_BJHG_XXZZ:
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"撤单|6807"];
        }
            break;
        case WT_BJHG_TQGH://
        case WT_BJHG_YYTG:
        case MENU_JY_BJHG_MakeAn:
        case MENU_JY_BJHG_Ahead: //13842  提前购回
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"购回|6807"];
        }
            break;
        case MENU_JY_BJHG_Stop: //13841  终止续作387/390
        case MENU_JY_BJHG_DEYYZZ:   //13845  大额预约终止391
        {
            [pAy addObject:@"详细|6808"];
            [pAy addObject:@"刷新|6802"];
            [pAy addObject:@"终止|6807"];
        }
            break;
        default:
            break;
    }
    
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
