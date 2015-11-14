/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        质押回购交易操作(质押债券入库，质押债券出库，融资回购，融券回购)
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUITradeZYHGTradeViewController.h"

@interface tztUITradeZYHGTradeViewController ()

@end

@implementation tztUITradeZYHGTradeViewController
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
    if (self.pStockInfo && self.pStockInfo.stockCode)
    {
        [_tztTradeView setStockCode:[NSString stringWithFormat:@"%@", self.pStockInfo.stockCode]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
    {
        switch (_nMsgType)
        {
            case WT_ZYHG_ZQRK:
            case MENU_JY_ZYHG_StockBuy:
                strTitle = @"质押债券入库";
                break;
            case WT_ZYHG_ZQCK:
            case MENU_JY_ZYHG_StockSell:
                strTitle = @"质押债券出库";
                break;
            case WT_ZYHG_RZHG:
            case MENU_JY_ZYHG_RZBuy:
                strTitle = @"融资回购";
                break;
            case WT_ZYHG_RQHG:
            case MENU_JY_ZYHG_RQBuy:
                strTitle = @"融券回购";
                break;
            default:
                strTitle = @"";
                break;
        }
    }
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= _tztTitleView.frame.size.height;
    
    if (_tztTradeView == nil)
    {
        _tztTradeView = [[tztZYHGTradeView alloc] init];
        _tztTradeView.delegate = self;
        _tztTradeView.nMsgType = _nMsgType;
        _tztTradeView.frame = rcFrame;
        [_tztBaseView addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
    {
        _tztTradeView.frame = rcFrame;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    
}

@end
