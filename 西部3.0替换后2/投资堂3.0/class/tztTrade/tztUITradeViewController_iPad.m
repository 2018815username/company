/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易vc（iPad）
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUITradeViewController_iPad.h"
#import "tztTradeUserInfoView.h"

#define TradeTableHeigth        70
#define JYLeftMenuWidth   210 //左边菜单的宽度
#define JYRightTopHeight  (291 + TZTToolBarHeight+JYSegmentHeight) //右边分时以上的高度
#define JYLeftWidthWithoutRightView 400 //右边没有View 的界面类型宽度
//#define JYStockAndChangeBtnHeight   20 //分时上面的股票详细信息和分时K线切换按钮高度
#define JYGapHeight   2 // // 分时上面留空 byDBQ20130723
#define JYSegmentHeight 60

@implementation tztUITradeViewController_iPad
@synthesize pTableView = _pTableView;
@synthesize titleSegment = _titleSegment;
@synthesize pRightTradeViews = _pRightTradeViews;
@synthesize nKeyType = _nKeyType;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_TZTIPAD)
    {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self LoadLayoutView];
#ifdef Support_TradeNew
    [_pBtnView SetDefaultData];
#endif
}


-(void)SetDefaultData
{
    
}

-(void)dealloc
{
    [super dealloc];
}
//zxl 20130927 设置交易类型的功能类型
-(void)SetJYType:(int)strJyType
{
    //zxl 2013 0927 修改了类型设置方式
    if (_pRightTradeViews && [_pRightTradeViews count] > 0)
    {
        [self SetNsKeyType:strJyType];
    }else
        self.nKeyType = strJyType;
    
    if (_titleSegment)
    {
        [_titleSegment setJyType:strJyType];
    }
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    if (CGRectIsNull(rcFrame) || CGRectIsEmpty(rcFrame))
        return;
    [self onSetTztTitleView:@"委托交易" type:TZTTitleNormal];
    _tztTitleView.nLeftViewWidth = JYLeftMenuWidth;
    [_tztTitleView setFrame:_tztTitleView.frame];
    
    if (_pRightTradeViews == NULL)
        _pRightTradeViews = NewObject(NSMutableDictionary);
    
    NSString* strPath = GetPathWithListName(@"tztTradeStockSetting",NO);
    NSDictionary* listvalue = [[[NSDictionary alloc] initWithContentsOfFile:strPath] autorelease];
    if (listvalue == NULL || [listvalue count] <= 0)
    {
        strPath = GetTztBundlePlistPath(@"tztTradeStockSetting");
        listvalue = [[[NSDictionary alloc] initWithContentsOfFile:strPath] autorelease];
    }
    NSMutableArray* arrayValue = (NSMutableArray*)[listvalue objectForKey:@"TZTTradeGrid"];
    
    if (self.nKeyType == 0)
    {
        self.nKeyType = WT_JiaoYi;
    }
    
    CGRect rcSeg = _tztTitleView.frame;
    rcSeg.origin.y += rcSeg.size.height;
    rcSeg.size.height = JYSegmentHeight;
    if (_titleSegment == NULL)
    {
        _titleSegment = [[tztTradeSegment alloc] init];
        [_titleSegment setItems:arrayValue];
        _titleSegment.tztdelegate = self;
        [_tztBaseView addSubview:_titleSegment];
        [_titleSegment release];
        [_titleSegment setJyType:self.nKeyType];
    }
    _titleSegment.frame = rcSeg;
    
    CGRect rcDetail = rcFrame;
    rcDetail.origin.y = _titleSegment.frame.origin.y +_titleSegment.frame.size.height;
    rcDetail.size.width = JYLeftMenuWidth;
    rcDetail.size.height -= _tztTitleView.frame.size.height + JYSegmentHeight;
 
    if (_pTableView == NULL)
    {
        _pTableView = [[tztUITableListView alloc] initWithFrame:rcDetail];
        //zxl 20131012 修改了获取默认设置交易类型Plistfile
         NSString* Plistfile = @"tztUITradeStockListSetting";
        if (_titleSegment)
        {
            NSMutableDictionary *pDict = [_titleSegment GetCurIndexJYDict];
            if (pDict)
            {
                Plistfile = [NSString stringWithFormat:@"%@",[pDict objectForKey:tztTradeSegmentPro]];
            }
        }
        [_pTableView setPlistfile:Plistfile listname:@"TZTTradeGrid"];
        _pTableView.tztdelegate = self;
        _pTableView.bExpandALL = TRUE;
        [_tztBaseView addSubview:_pTableView];
        _pTableView.backgroundColor = [UIColor colorWithTztRGBStr:@"37,37,37"];
        [_pTableView release];
    }
    else
    {
        _pTableView.frame = rcDetail;
        [_tztBaseView bringSubviewToFront:_pTableView];
        [_pTableView reloadData];
    }
    
    CGRect rcContent = rcFrame;
    rcContent.origin.y +=  _titleSegment.frame.origin.y +_titleSegment.frame.size.height;
    rcContent.origin.x += _pTableView.frame.size.width;
    rcContent.size.width -= _pTableView.frame.size.width;
    rcContent.size.height -= rcContent.origin.y;
    //zxl 20130927 创建类型界面
    if (_pRightTradeViews && [_pRightTradeViews count] < 1)
    {
        tztTradeRight_ipad * TradeView = [[tztTradeRight_ipad alloc] init];
        TradeView.frame = rcContent;
        [_pRightTradeViews setObject:TradeView forKey:[NSString stringWithFormat:@"%d",self.nKeyType]];
        [_tztBaseView addSubview:TradeView];
        [TradeView release];
        [self NsKeyTypeFirstView];
    }else
    {
        if (self.nKeyType > 0)
            [self SetNsKeyType:self.nKeyType];
    }
}
//zxl 20130927 不同类型 首次显示功能
-(void)NsKeyTypeFirstView
{
    switch (self.nKeyType)
    {
        case WT_JiaoYi:
        case MENU_JY_PT_List:
        {
            [self DealWithMenu:WT_BUY nsParam_:nil pAy_:nil];
            if (_pTableView)
                [_pTableView SetMsgType:WT_BUY];
        }
            break;
        case WT_FUND_TRADE:
        case MENU_JY_FUND_List:
        {
            [self DealWithMenu:WT_JJRGFUND nsParam_:nil pAy_:nil];
            if (_pTableView)
                [_pTableView SetMsgType:WT_JJRGFUND];
        }
            break;
        case MENU_QS_HTSC_ZJLC_List:
        {
            [self DealWithMenu:MENU_QS_HTSC_ZJLC_RenGou nsParam_:nil pAy_:nil];
            if (_pTableView)
                [_pTableView SetMsgType:MENU_QS_HTSC_ZJLC_RenGou];
        }
            break;
        case WT_JYRZRQ:
        case MENU_JY_RZRQ_List:
        {
            [self DealWithMenu:WT_RZRQBUY nsParam_:nil pAy_:nil];
            if (_pTableView)
                [_pTableView SetMsgType:WT_RZRQBUY];
        }
            break;
        case WT_HTSC_Other:
        {
            [self DealWithMenu:MENU_JY_ZYHG_StockBuy nsParam_:nil pAy_:nil];
            if (_pTableView)
                [_pTableView SetMsgType:MENU_JY_ZYHG_StockBuy];
        }
            break;
        case WT_HTSC_YWBL:
        {
            [self DealWithMenu:WT_DZHTQS nsParam_:nil pAy_:nil];
            if (_pTableView)
                [_pTableView SetMsgType:WT_DZHTQS];
        }
            break;
        default:
            break;
    }
}

-(BOOL)tztTradeSegment:(tztTradeSegment *)tztSeg ShouldSelectAtIndex:(NSMutableDictionary *)options
{
    if (tztSeg == _titleSegment)
    {
        if (options == NULL)
            return TRUE;
        
        NSString* strID = [options tztObjectForKey:tztTradeSegmentID];
        
        if (strID && strID.length > 0)
        {
            if ([strID intValue] == WT_JYRZRQ || [strID intValue] == MENU_JY_RZRQ_List)
            {
                if ([tztJYLoginInfo getcreditfund] != 1)
                {
                    [self showMessageBox:@"对不起，请先至营业部开通融资融券业务！"
                                  nType_:TZTBoxTypeNoButton
                               delegate_:nil];
                    return FALSE;
                }
            }       //修改退出 modify by xyt 20131028
            else if ([strID intValue] == MENU_SYS_JYLogout || [strID intValue] == WT_OUT)
            {
                // 点击退出按钮的时候，弹出提示框 但是上面的类型不切换
                [TZTUIBaseVCMsg OnMsg:[strID intValue] wParam:0 lParam:0];
                return FALSE;
            }
        }
    }
    return TRUE;
}

-(void)tztTradeSegment:(tztTradeSegment *)tztSeg OnSelectAtIndex:(NSMutableDictionary*)options
{
    if (tztSeg == _titleSegment)
    {
        if (options == NULL)
            return;
        
        NSString* strID = [options tztObjectForKey:tztTradeSegmentID];
        NSString* strProfile = [options tztObjectForKey:tztTradeSegmentPro];
        if (strID && strID.length > 0)
        {
            if ([strID intValue] == WT_JYRZRQ || [strID intValue] == MENU_JY_RZRQ_List)
            {
                if ([tztJYLoginInfo getcreditfund] != 1)
                {   
                    [self showMessageBox:@"对不起，请先至营业部开通融资融券业务！"
                                  nType_:TZTBoxTypeNoButton
                               delegate_:nil];
                    return;
                }
                else
                {
                    if (_pTableView)
                        [_pTableView setPlistfile:strProfile listname:@"TZTTradeGrid"];
                    [self SetNsKeyType:[strID intValue]];
                }
            }
            else if ([strID intValue] == MENU_SYS_JYLogout)//清空界面数据
            {
                _bTradeOut = TRUE;
                _titleSegment.nPreIndex = 0;
                [TZTUIBaseVCMsg OnMsg:[strID intValue] wParam:0 lParam:0];
            }else
            {
                if (_pTableView)
                    [_pTableView setPlistfile:strProfile listname:@"TZTTradeGrid"];
                [self SetNsKeyType:[strID intValue]];
            }
        }
    }
}
//zxl 20130927 根据不同的类型来创建界面
-(void)SetNsKeyType:(int)KeyType
{
    if(_pRightTradeViews && [_pRightTradeViews count] > 0 && self.nKeyType > 0)
    {
        UIView *pView = [_pRightTradeViews objectForKey:[NSString stringWithFormat:@"%d",KeyType]];
        UIView *preView = [_pRightTradeViews objectForKey:[NSString stringWithFormat:@"%d",self.nKeyType]];
        if (self.nKeyType != KeyType)
        {
            CGRect rcContent = _tztBounds;
            rcContent.origin.y +=  _titleSegment.frame.origin.y +_titleSegment.frame.size.height;
            rcContent.origin.x += _pTableView.frame.size.width;
            rcContent.size.width -= _pTableView.frame.size.width;
            rcContent.size.height -= rcContent.origin.y;
            
            if (preView != NULL)
                [preView removeFromSuperview];
            
            if (pView == NULL)
            {
                tztTradeRight_ipad * TradeView = [[tztTradeRight_ipad alloc] init];
                TradeView.frame = rcContent;
                [_pRightTradeViews setObject:TradeView forKey:[NSString stringWithFormat:@"%d",KeyType]];
                [_tztBaseView addSubview:TradeView];
                [TradeView release];
                self.nKeyType = KeyType;
                [self NsKeyTypeFirstView];
            }else
            {
                pView.frame = rcContent;
                [_tztBaseView addSubview:pView];
                self.nKeyType = KeyType;
                //zxl 20131022 修改了设置界面功能的设置方式
                if ([pView isKindOfClass:[tztTradeRight_ipad class]])
                {
                    tztTradeRight_ipad * pRightView = (tztTradeRight_ipad *)pView;
                    tztBaseTradeView* TradeViewe =  (tztBaseTradeView *)[pRightView.topTabView GetActiveTabView];
                    if (TradeViewe && self.pTableView)
                        [self.pTableView SetMsgType:TradeViewe.nMsgType];
                }
            }
        }else
        {
            //相同界面点击的时候当前界面的功能刷新再设置一下。
            if ([pView isKindOfClass:[tztTradeRight_ipad class]])
            {
                tztTradeRight_ipad * pRightView = (tztTradeRight_ipad *)pView;
                tztBaseTradeView* TradeViewe =  (tztBaseTradeView *)[pRightView.topTabView GetActiveTabView];
                if (TradeViewe && self.pTableView)
                    [self.pTableView SetMsgType:TradeViewe.nMsgType];
            }
        }
    }
}

-(BOOL)tztUITableListView:(tztUITableListView *)pMenuView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString *)strMsgValue
{
    if (pMenuView == _pTableView)
    {
        if(nMsgType != 1234)
        {
            [self DealWithMenu:nMsgType nsParam_:nil pAy_:nil];
        }
    }
    return TRUE;
}

//处理左侧菜单点击事件
-(void)DealWithMenu:(NSInteger)nMsgType nsParam_:(NSString *)nsParam pAy_:(NSArray *)pAy
{
    if (self.nKeyType <= 0)
        return;
    
    tztTradeRight_ipad *pRightView = (tztTradeRight_ipad *)[_pRightTradeViews objectForKey:[NSString stringWithFormat:@"%d",self.nKeyType]];
    if (pRightView)
    {
        [pRightView DealWithMenu:nMsgType nsParam_:nsParam];
    }
}


-(void)SetStockBySelectStock:(NSString *)stockcode StockName:(NSString *)name
{
    if (stockcode == NULL || [stockcode length] == 0|| name == NULL || [name length] == 0)
        return;
}

- (void)CreateToolBar // iPad版本底部无toolBar byDBQ20130713
{
    
}

-(void)OnShowOrHiden:(int)nType
{
    
}

@end
