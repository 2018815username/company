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

#import "tztHomePageInfoView.h"
#import "TZTUIBaseVCMsg.h"

#define tztTitleHeight 33

@interface tztHomePageInfoView(tztPrivate)
-(void)initdata;
- (void)datawithframe;
-(void)OnBtnFullScreen:(id)sender;
-(void)OnBtnNewInfo:(id)sender;
-(void)OnBtnNewStockInfo:(id)sender;
-(void)OnBtnFuturInfo:(id)sender;
-(void)OnBtnMore:(id)sender;
@end

@implementation tztHomePageInfoView
@synthesize tztHomePageInfodelegate = _tztHomePageInfodelegate;

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initdata];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initdata]; 
        [self datawithframe];
    }
    return self;
}

- (void)datawithframe
{
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    CGFloat infoheight = rcFrame.size.height - tztTitleHeight;
    rcFrame.size.height = tztTitleHeight;
    if (_pView)
    {
        _pView.frame = rcFrame;
    }
    
    CGRect rcBtn = rcFrame;
    rcBtn.size.width = 30;
    if(_pBtnFullScreen)
    {
        _pBtnFullScreen.frame = rcBtn;
    }
    
    rcBtn.origin.x += rcBtn.size.width;
    rcBtn.size.width =80;
    if(_pBtnNewInfo)
    {
        _pBtnNewInfo.frame = rcBtn;
    }
    
    rcBtn.origin.x += rcBtn.size.width;
    rcBtn.size.width =80;
    if (_pBtnNewStockInfo)
    {
        _pBtnNewStockInfo.frame = rcBtn;
    }
    
    rcBtn.origin.x += rcBtn.size.width;
    rcBtn.size.width =80;
    if (_pBtnFuturInfo)
    {
        _pBtnFuturInfo.frame = rcBtn;
    }
    
    rcBtn.origin.x = rcFrame.size.width - 30;
    rcBtn.size.width =30;
    if (_pBtnMore)
    {
        _pBtnMore.frame = rcBtn;
    }
    
    if (_pTableInfoView)
    {
        _pTableInfoView.frame = CGRectMake(0, tztTitleHeight, self.bounds.size.width, infoheight);
    }
}

- (void)initdata
{
#if 1
    //头
    if (_pView == nil)
    {
        _pView = [[UIView alloc] init];
        _pView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTTabInfoImg.png"]];
        [self addSubview:_pView];
        [_pView release];
    }

    if (_pBtnFullScreen == nil)
    {
        _pBtnFullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnFullScreen setBackgroundImage:[UIImage imageTztNamed:@"TZTUpPageImg.png"] forState:UIControlStateNormal];
        [_pBtnFullScreen addTarget:self action:@selector(OnBtnFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [_pBtnFullScreen setShowsTouchWhenHighlighted:YES];
        [_pView addSubview:_pBtnFullScreen];
    }

    
    if (_pBtnNewInfo == nil)
    {
        _pBtnNewInfo = [tztUISwitch buttonWithType:UIButtonTypeCustom];
        _pBtnNewInfo.switched = NO;
        _pBtnNewInfo.yestitle = @"最新要闻";
        _pBtnNewInfo.notitle = @"最新要闻";
        
        _pBtnNewInfo.yesImage = [UIImage imageTztNamed:@"TZTTabSelectBtnImg.png"]; 
        _pBtnNewInfo.noImage = nil;
        [_pBtnNewInfo setTztTitleColor:[UIColor whiteColor]];
        [_pBtnNewInfo setChecked:TRUE];
        
        _pBtnNewInfo.titleLabel.font = tztUIBaseViewTextBoldFont(14.0f);
        _pBtnNewInfo.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_pBtnNewInfo addTarget:self action:@selector(OnBtnNewInfo:) forControlEvents:UIControlEventTouchUpInside];
        [_pView addSubview:_pBtnNewInfo];
    }
    
    if (_pBtnNewStockInfo == nil)
    {
        _pBtnNewStockInfo = [tztUISwitch buttonWithType:UIButtonTypeCustom];
        _pBtnNewStockInfo.switched = NO;
        _pBtnNewStockInfo.yestitle = @"新股在线";
        _pBtnNewStockInfo.notitle = @"新股在线";
        
        _pBtnNewStockInfo.yesImage = [UIImage imageTztNamed:@"TZTTabSelectBtnImg.png"]; 
        _pBtnNewStockInfo.noImage = nil;
        [_pBtnNewStockInfo setTztTitleColor:[UIColor whiteColor]];
        [_pBtnNewStockInfo setChecked:FALSE];
        
        _pBtnNewStockInfo.titleLabel.font = tztUIBaseViewTextBoldFont(14.0f);
        _pBtnNewStockInfo.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_pBtnNewStockInfo addTarget:self action:@selector(OnBtnNewStockInfo:) forControlEvents:UIControlEventTouchUpInside];
        [_pView addSubview:_pBtnNewStockInfo];
    }
    
    
    if (_pBtnFuturInfo == nil)
    {
        _pBtnFuturInfo = [tztUISwitch buttonWithType:UIButtonTypeCustom];
        _pBtnFuturInfo.switched = NO;
        _pBtnFuturInfo.yestitle = @"期货聚焦";
        _pBtnFuturInfo.notitle = @"期货聚焦";
        
        _pBtnFuturInfo.yesImage = [UIImage imageTztNamed:@"TZTTabSelectBtnImg.png"]; 
        _pBtnFuturInfo.noImage = nil;
        [_pBtnFuturInfo setTztTitleColor:[UIColor whiteColor]];
        [_pBtnFuturInfo setChecked:FALSE];
        
        _pBtnFuturInfo.titleLabel.font = tztUIBaseViewTextBoldFont(14.0f);
        _pBtnFuturInfo.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_pBtnFuturInfo addTarget:self action:@selector(OnBtnFuturInfo:) forControlEvents:UIControlEventTouchUpInside];
        [_pView addSubview:_pBtnFuturInfo];
    }
    
    if (_pBtnMore == nil)
    {
        _pBtnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnMore setTitle:@"更多" forState:UIControlStateNormal];
        _pBtnMore.titleLabel.font = tztUIBaseViewTextBoldFont(14.0f);
        _pBtnMore.titleLabel.adjustsFontSizeToFitWidth = YES;
        _pBtnMore.showsTouchWhenHighlighted = YES;
        [_pBtnMore addTarget:self action:@selector(OnBtnMore:) forControlEvents:UIControlEventTouchUpInside];
        [_pView addSubview:_pBtnMore];
    }
#endif
    if (_pTableInfoView == nil)
    {
        _pTableInfoView = [[tztInfoTableView alloc] init];
        _pTableInfoView.nTableRowHeight = 28;
        _pTableInfoView.nCellRow = 2;
        _pTableInfoView.nsOp_Type = @"1";
        _pTableInfoView.HsString = @"1";
        _pTableInfoView.tztdelegate = self;
        _pTableInfoView.tztinfodelegate = self;
        _pTableInfoView.nMaxCount = 20;
        _pTableInfoView.nsBackImage = @"TZTReportContentBG.png";
        [_pTableInfoView setStockInfo:self.pStockInfo Request:1];
        [self addSubview:_pTableInfoView];
        [_pTableInfoView release];
    }
}

-(void)RequestData
{
    if (_pTableInfoView)
    {
        [_pTableInfoView setStockInfo:self.pStockInfo Request:1];
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];  
    [self datawithframe];
}


-(void)OnBtnFullScreen:(id)sender
{
    _nClickCount++;
    BOOL bFull = (_nClickCount % 2 != 0);
    if (!bFull)
    {
        [_pBtnFullScreen setBackgroundImage:[UIImage imageTztNamed:@"TZTUpPageImg.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_pBtnFullScreen setBackgroundImage:[UIImage imageTztNamed:@"TZTDownpPageImg.png"] forState:UIControlStateNormal];
    }
    
    if (_tztHomePageInfodelegate && [_tztHomePageInfodelegate respondsToSelector:@selector(tztHomePageInfoView:fullscreen:)])
    {
        [_tztHomePageInfodelegate tztHomePageInfoView:self fullscreen:bFull];
    }
}

//最新要闻
-(void)OnBtnNewInfo:(id)sender
{
    if (_pTableInfoView)
    {
        _pTableInfoView.HsString = @"1";
        [_pTableInfoView setStockInfo:self.pStockInfo Request:1];
    }
    [_pBtnNewInfo setChecked:YES];
    [_pBtnFuturInfo setChecked:NO];
    [_pBtnNewStockInfo setChecked:NO];
}

//新股资讯
-(void)OnBtnNewStockInfo:(id)sender
{
    if (_pTableInfoView)
    {
        _pTableInfoView.HsString = @"805632192";
        [_pTableInfoView setStockInfo:self.pStockInfo Request:1];
    }
    [_pBtnNewInfo setChecked:NO];
    [_pBtnFuturInfo setChecked:NO];
    [_pBtnNewStockInfo setChecked:YES];
}

//期货聚焦
-(void)OnBtnFuturInfo:(id)sender
{
    if (_pTableInfoView)
    {
        _pTableInfoView.HsString = @"2081";
        [_pTableInfoView setStockInfo:self.pStockInfo Request:1];
    }
    [_pBtnNewInfo setChecked:NO];
    [_pBtnFuturInfo setChecked:YES];
    [_pBtnNewStockInfo setChecked:NO];
}

- (void)reloadAllData
{
    if(_pTableInfoView && _pTableInfoView.tableView)
    {
        [_pTableInfoView.tableView reloadData];
    }
}

//更多
-(void)OnBtnMore:(id)sender
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Center wParam:0 lParam:0];
}


#pragma tztInfoDelegate
-(void)SetInfoData:(NSMutableArray*)ayData
{
    
}

-(void)SetInfoItem:(id)delegate pItem_:(tztInfoItem *)pItem
{
    if (pItem == NULL)
        return;
    if (delegate == _pTableInfoView)
    {
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Content wParam:(NSUInteger)pItem lParam:(NSUInteger)_pTableInfoView];
    }
}

@end
