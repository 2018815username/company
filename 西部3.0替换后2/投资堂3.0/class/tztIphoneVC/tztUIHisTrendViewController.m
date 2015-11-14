/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        历史分时viewController
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIHisTrendViewController.h"

@interface tztUIHisTrendViewController ()

@end

@implementation tztUIHisTrendViewController
@synthesize pHisTrendView = _pHisTrendView;
@synthesize nsHisDate = _nsHisDate;
@synthesize tztdelegate = _tztdelegate;

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
//    [self LoadLayoutView];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(500, 600);
    [super viewWillAppear:animated];
    [self LoadLayoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    //历史分时翻页，打开刷新
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztStopRequest:)])
    {
        [_tztdelegate tztStopRequest:TRUE];
    }
    [super dealloc];
}

-(void)LoadLayoutView
{
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"历史分时";
    
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    //zxl 20131012 修改了ipad 显示历史分时的时候Title 特殊处理
    if (IS_TZTIPAD)
        [self onSetTztTitleView:self.nsTitle type:TZTTitleNormal];
    else
        [self onSetTztTitleView:self.nsTitle type:TZTTitleReturn];
    
    [self setRequestDate:self.nsHisDate pStock_:self.pStockInfo];
    _tztBaseView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGRect rcFrame = _tztBounds;
    if (IS_TZTIPAD)
    {
        rcFrame = self.view.bounds;
    }
    rcFrame.origin.y += _tztTitleView.frame.size.height;
    rcFrame.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pHisTrendView == nil)
    {
        _pHisTrendView = [[tztHisTrendView alloc] initWithFrame:rcFrame];
        _pHisTrendView.tztdelegate = self;
        [_tztBaseView addSubview:_pHisTrendView];
        if (self.nsHisDate && self.nsHisDate.length > 0)
        {
            _pHisTrendView.pStockInfo = self.pStockInfo;
            [_pHisTrendView onRequestHisData:self.nsHisDate];
        }
    }
    else
    {
        _pHisTrendView.frame = rcFrame;
    }
    
    [self CreateToolBar];
}

-(void)setRequestDate:(NSString*)nsDate pStock_:(tztStockInfo*)pStock
{
    self.pStockInfo = pStock;
    if (nsDate)
        self.nsHisDate = [[[NSString alloc] initWithFormat:@"%@", nsDate] autorelease];// [NSString stringWithFormat:@"%@", nsDate];
    else
        self.nsHisDate = @"";
    
    NSString* strTitle = @"历史分时";
    if (self.pStockInfo)
    {
        NSString* strCode = [NSString stringWithFormat:@"%@", self.pStockInfo.stockCode];
        NSString* strName = [NSString stringWithFormat:@"%@", self.pStockInfo.stockName];
        strTitle = [NSString stringWithFormat:@"%@ %@ %@", self.nsHisDate, strName, strCode];
    }
    //zxl 20131012 修改了ipad 显示历史分时的时候Title 特殊处理
    [self.tztTitleView setTitle:strTitle];
//    if (IS_TZTIPAD)
//        [self onSetTztTitleView:strTitle type:TZTTitleNormal];
//    else
//        [self onSetTztTitleView:strTitle type:TZTTitleReturn];
}

-(void)setNsHisDate:(NSString *)nsDate
{
    if (nsDate)
        _nsHisDate = [NSString stringWithFormat:@"%@", nsDate];
    else
        _nsHisDate = @"";
    _pHisTrendView.pStockInfo = self.pStockInfo;
    if (_pHisTrendView)
    {
        [_pHisTrendView onClearData];
        [_pHisTrendView onRequestHisData:self.nsHisDate];
    }
}

-(void)CreateToolBar
{
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"前一日|6809"];
    [pAy addObject:@"后一日|6810"];
//#ifdef tzt_NewVersion
    if (IS_TZTIPAD)
    {
        [super CreateToolBar];
        [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
    }
    else
        [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
//#else
//#endif
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    switch (pBtn.tag) {
        case TZTToolbar_Fuction_Pre://前一日
        {
            [self tztUIHisTrendChanged:0];
        }
            break;
        case TZTToolbar_Fuction_Next://后一日
        {
            [self tztUIHisTrendChanged:1];
        }
            break;
            
        default:
            break;
    }
}

-(void)tztUIHisTrendChanged:(UInt16)nDirection
{
    //历史分时翻页，关闭刷新
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztStopRequest:)])
    {
        [_tztdelegate tztStopRequest:FALSE];
    }
    
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(GetHisDate:direction:)])
    {
        NSString* strDate = [_tztdelegate GetHisDate:_tztdelegate direction:nDirection];
        
        if (strDate)
        {
            [self setRequestDate:strDate pStock_:self.pStockInfo];
        }
    }
}



@end
