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

#import "tztUIListDetailViewController.h"

@interface tztUIListDetailViewController (tztPrivate)
-(NSMutableArray*)GetContent;
@end
@implementation tztUIListDetailViewController
@synthesize pDetailView = _pDetailView;
@synthesize pAyData = _pAyData;
@synthesize pAyTitle = _pAyTitle;
@synthesize pAyContent = _pAyContent;
@synthesize nCurIndex = _nCurIndex;
@synthesize pAyToolBar = _pAyToolBar;
@synthesize pDictIndex = _pDictIndex;
@synthesize nMaxColNum = _nMaxColNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
//    [self LoadLayoutView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(400, 550);
    [super viewWillAppear:animated];
//    self.contentSizeForViewInPopover = CGSizeMake(500, 10000);
    
    //增加手势侦听事件
    UISwipeGestureRecognizer *swipeTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnBtnNextStock:)];
    [swipeTap setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_pDetailView addGestureRecognizer:swipeTap];
    [swipeTap release];
    
    swipeTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnBtnPreStock:)];
    [swipeTap setDirection:UISwipeGestureRecognizerDirectionRight];
    [_pDetailView addGestureRecognizer:swipeTap];
    [swipeTap release];
    [self LoadLayoutView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [super dealloc];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;

    if (IS_TZTIPAD)
    {
        rcFrame = self.view.bounds;
    }
    NSString* strTitle = GetTitleByID(_nMsgType);
    if (!ISNSStringValid(strTitle))
        strTitle = @"详情显示";
    self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    [self onSetTztTitleView:self.nsTitle type:(TZTTitleReturn | TZTTitleStock | TZTTitlePreNext)];
     
    CGRect rcSearch = rcFrame;
    rcSearch.origin.y += _tztTitleView.frame.size.height;
    if (IS_TZTIPAD)
        rcSearch.size.height -= (_tztTitleView.frame.size.height);
    else
        rcSearch.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    if (_pDetailView == nil)
    {
        _pDetailView = [[tztListDetailView alloc] init];
        _pDetailView.delegate = self;
        _pDetailView.frame = rcSearch;
        
        NSMutableArray* pAyContent = [self GetContent];
        [_pDetailView SetDetailData:_pAyTitle ayContent_:pAyContent];
        [_tztBaseView addSubview:_pDetailView];
        [_pDetailView release];
    }
    else
    {
        _pDetailView.frame = rcSearch;
    }
    [self CreateToolBar];
}

-(void)setPAyData:(NSMutableArray *)ayData
{
    if (_pAyData == NULL)
        _pAyData = NewObject(NSMutableArray);
    [_pAyData removeAllObjects];
    [_pAyData addObjectsFromArray:ayData];
    
}
-(void)CreateToolBar
{
    if (IS_TZTIPAD)
    {
        NSMutableArray *pAy = NewObject(NSMutableArray);
        [pAy addObject:@"上条|6809"];
        [pAy addObject:@"下条|6810"];
        [super CreateToolBar];
        [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
        
//        return;
//        [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
        DelObject(pAy);
        return;
    }
#ifdef tzt_NewVersion // 新版本去toolbar byDBQ20130718
#else
    [super CreateToolBar];
#endif
    
    NSMutableArray *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"上条|6809"];
    [pAy addObject:@"下条|6810"];
    
#if 1
    for (int i = 0; i < [_pAyToolBar count]; i++)
    {
#ifdef tzt_NewVersion
        id obj = [_pAyToolBar objectAtIndex:i];
        if (obj)
        {
            if ([obj isKindOfClass:[UIButton class]])
            {
                UIButton* pBtn = (UIButton*)[_pAyToolBar objectAtIndex:i];
                if (pBtn.tag == TZTToolbar_Fuction_Detail
                    || pBtn.tag == TZTToolbar_Fuction_Pre
                    || pBtn.tag == TZTToolbar_Fuction_Next
                    || pBtn.tag == TZTToolbar_Fuction_Refresh)
                    continue;
            
                NSString* str = [NSString stringWithFormat:@"%@|%d", [pBtn titleForState:UIControlStateNormal], (int)pBtn.tag];
                [pAy addObject:str];
            }
            else if ([obj isKindOfClass:[NSString class]])
            {
                NSString *str = [NSString stringWithFormat:@"%@", obj];
                [pAy addObject:str];
            }
        }
#else
        tztUIBarButtonItem *pBarItem = (tztUIBarButtonItem*)[_pAyToolBar objectAtIndex:i];
        if (pBarItem.ntztTag == TZTToolbar_Fuction_Detail
            || pBarItem.ntztTag == TZTToolbar_Fuction_Pre
            || pBarItem.ntztTag == TZTToolbar_Fuction_Next
            || pBarItem.ntztTag == TZTToolbar_Fuction_Refresh)
            continue;
        
        NSString* str = [NSString stringWithFormat:@"%@|%ld", pBarItem.nsTitle , (long)pBarItem.ntztTag];
        [pAy addObject:str];
#endif
        
    }
#endif
    
#ifdef tzt_NewVersion // 新版本改变样式 byDBQ20130718
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    DelObject(pAy);
}


-(NSMutableArray*)GetContent
{
    if (_pAyData == NULL || [_pAyData count] <= 0)
        return NULL;
    
    if (_nCurIndex < 0 || _nCurIndex >= [_pAyData count])
        return NULL;
    
     NSMutableArray* pAy = [_pAyData objectAtIndex:_nCurIndex];
    return pAy;
}

-(void)OnBtnPreStock:(id)sender
{
    if (_pDetailView == nil)
        return;
    _nCurIndex--;
    if (_nCurIndex < 0)
    {
        _nCurIndex = 0;
        [self showMessageBox:@"当前页第一条记录!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    _pAyContent = [self GetContent];
    [_pDetailView SetDetailData:_pAyTitle ayContent_:_pAyContent];
    _pDetailView.contentOffset = CGPointMake(0, 0);
}

-(void)OnBtnNextStock:(id)sender
{
    if (_pDetailView == nil)
        return;
    _nCurIndex++;
    if (_nCurIndex >= [_pAyData count])
    {
        _nCurIndex = [_pAyData count] - 1;
        [self showMessageBox:@"当前页最后一条记录!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    _pAyContent = [self GetContent];
    [_pDetailView SetDetailData:_pAyTitle ayContent_:_pAyContent];

//    _pDetailView.contentOffset = CGPointMake(0, 0);
}


-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    
    if (_pDetailView)
        bDeal = [_pDetailView OnToolbarMenuClick:sender];
    
    
    if (!bDeal)
    {
        UIButton *pBtn = (UIButton*)sender;
        switch (pBtn.tag)
        {
            case TZTToolbar_Fuction_Pre:
            {
                [self OnBtnPreStock:nil];
                bDeal = TRUE;
            }
                break;
            case TZTToolbar_Fuction_Next:
            {
                [self OnBtnNextStock:nil];
                bDeal = TRUE;
            }
                break;
            case HQ_MENU_Trend://分时
            {
                NSArray* pAy = [self GetContent];
                int nStockCodeIndex = -1;
                int nStockNameIndex = -1;
                
                NSString* strIndex = [self.pDictIndex tztObjectForKey:@"StockCodeIndex"];
                
                if (ISNSStringValid(strIndex))
                    nStockCodeIndex = [strIndex intValue];
                
                strIndex = [self.pDictIndex tztObjectForKey:@"StockNameIndex"];
                if (ISNSStringValid(strIndex))
                    nStockNameIndex = [strIndex intValue];
                
                if (pAy == NULL || [pAy count] <= 0 || nStockCodeIndex < 0 || nStockCodeIndex >= [pAy count])
                {
                    bDeal = TRUE;//标识已经处理过了
                    return;
                }
                
                NSString* strCode = @"";
                TZTGridData *pGridData = [pAy objectAtIndex:nStockCodeIndex];
                if (pGridData)
                {
                    strCode = pGridData.text;
                }
                
                
                tztStockInfo *pStock = NewObject(tztStockInfo);
                pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
                if (nStockNameIndex >= 0 && nStockNameIndex < [pAy count])
                {
                    pGridData = [pAy objectAtIndex:nStockNameIndex];
                    if (pGridData && pGridData.text)
                    {
                        pStock.stockName = [NSString stringWithFormat:@"%@", pGridData.text];
                    }
                }
                //获取当前的股票代码传递过去
                [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:0];
                [pStock release];
                bDeal = TRUE;
            }
                break;
            case WT_SALE://卖出
            case MENU_JY_PT_Sell:
            {
                NSArray* pAy = [self GetContent];
                
                int nStockCodeIndex = -1;
                int nStockNameIndex = -1;
                
                NSString* strIndex = [self.pDictIndex tztObjectForKey:@"StockCodeIndex"];
                
                if (ISNSStringValid(strIndex))
                    nStockCodeIndex = [strIndex intValue];
                
                strIndex = [self.pDictIndex tztObjectForKey:@"StockNameIndex"];
                if (ISNSStringValid(strIndex))
                    nStockNameIndex = [strIndex intValue];
                
                if (pAy == NULL || [pAy count] <= 0 || nStockCodeIndex < 0 || nStockCodeIndex >= [pAy count])
                {
                    bDeal = TRUE;
                    return;//标识已经处理过了
                }
                
                NSString* strCode = @"";
                TZTGridData *pGridData = [pAy objectAtIndex:nStockCodeIndex];
                if (pGridData)
                {
                    strCode = pGridData.text;
                }
                
                tztStockInfo *pStock = NewObject(tztStockInfo);
                pStock.stockCode = [NSString stringWithFormat:@"%@", strCode];
                //获取当前的股票代码传递过去
                [TZTUIBaseVCMsg OnMsg:WT_SALE wParam:(NSUInteger)pStock lParam:0];
                [pStock release];
                bDeal = TRUE;
                return;
            }
                break;
                
            default:
                break;
        }
    }
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

@end
