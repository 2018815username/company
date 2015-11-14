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

#import "tztUIStockInfoView.h"
#import "TZTUIBaseVCMsg.h"


#define tztInfoButtonHeight 28
#define tztInfoButtonWidth (98)
#define tztInfoSpace 6

@interface tztUIStockInfoView()
{
    BOOL    _bIndexStock;
    UIButton    *_pCurSelBtn;
}
@property(nonatomic,retain)UIButton *pCurSelBtn;

-(void)setBtnFrame:(CGRect)rcFrame;
@end

@implementation tztUIStockInfoView
@synthesize pFinanceView = _pFinanceView;
@synthesize pInfoTableView = _pInfoTableView;
@synthesize pAyButton = _pAyButton;
@synthesize pBtnF10 = _pBtnF10;
@synthesize pBtnXXDL = _pBtnXXDL;
@synthesize pBtnFinance = _pBtnFinance;
@synthesize pCurSelBtn = _pCurSelBtn;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)onSetViewRequest:(BOOL)bRequest
{
    if (_pFinanceView)
        [_pFinanceView onSetViewRequest:bRequest];
}

-(void)dealloc
{
    DelObject(_pAyButton);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGRect rcBtn = rcFrame;
    rcBtn.origin.y += 2;
    rcBtn.size.height = tztInfoButtonHeight;
    
    if (_pAyButton == NULL)
        _pAyButton = NewObject(NSMutableArray);
    
    [self setBtnFrame:rcBtn];
    
    CGRect rcInfo = rcFrame;
    rcInfo.origin.y =0;//+= rcBtn.size.height + rcBtn.origin.y + 3;
//    rcInfo.size.height -= (rcBtn.size.height + rcBtn.origin.y + 3);
    
    if (_pInfoTableView == nil)
    {
        _pInfoTableView = [[tztInfoTableView alloc] initWithFrame:rcInfo];
        _pInfoTableView.nCellRow = 2;
        _pInfoTableView.nsBackImage = @"TZTReportContentBG.png";
        if (g_pSystermConfig && g_pSystermConfig.bNSupportInfoMine) // 没有信息地雷的情况 byDBQ20130805
        {
            _pInfoTableView.HsString = @"";
        }
        else
        {
            _pInfoTableView.HsString = @"000";
        }
        
        _pInfoTableView.tztdelegate = self;
        _pInfoTableView.tztinfodelegate = self;
        [self addSubview:_pInfoTableView];
        [_pInfoTableView release];
    }
    else
    {
        _pInfoTableView.frame = rcInfo;
    }
    
    if (_pFinanceView == nil)
    {
        _pFinanceView = [[tztFinanceView alloc] initWithFrame:rcInfo];
        [self addSubview:_pFinanceView];
        _pFinanceView.hidden = YES;
        [_pFinanceView release];
    }
    else
    {
        _pFinanceView.frame = rcInfo;
    }
    
    if (_pF10View == nil)
    {
        _pF10View = [[tztWebView alloc] init];
        _pF10View.hidden = YES;
        _pF10View.frame = rcInfo;
        [self addSubview:_pF10View];
        [_pF10View release];
    }
    else
    {
        _pF10View.frame = rcInfo;
    }
}

-(void)setBtnFrame:(CGRect)frame
{
    UIImage *pImage = [UIImage imageTztNamed:@"TZTTabButtonBg.png"];
    UIImage *pImageSel = [UIImage imageTztNamed:@"TZTTabButtonSelBg.png"];

    int nCount = 3;
    if (g_pSystermConfig && g_pSystermConfig.bSupportTBF10)
    {
        nCount = 4;
    }
    if (g_pSystermConfig && g_pSystermConfig.bNSupportInfoMine) // 没有信息地雷的情况 byDBQ20130805
    {
        nCount = 2;
    }
 
    int nSpace = tztInfoSpace;//(frame.size.width - nCount*nWidth)/(nCount+1);
    int nWidth = (frame.size.width-(nCount+1)*nSpace)/nCount;
//    int nWidth = MAX(tztInfoButtonWidth, pImage.size.width);

    //默认个股操作
    CGRect rcFrame = frame;
    rcFrame.origin.x += nSpace;
    rcFrame.size.width = nWidth;
    if (g_pSystermConfig && !g_pSystermConfig.bNSupportInfoMine) // 有信息地雷的情况 byDBQ20130805
    {
        _pBtnXXDL = (UIButton*)[self viewWithTag:tztInfoBtnTag + 1];
        if (_pBtnXXDL == NULL)
        {
            _pBtnXXDL = [UIButton buttonWithType:UIButtonTypeCustom];
            _pBtnXXDL.tag = tztInfoBtnTag+1;
            [_pBtnXXDL setBackgroundImage:pImageSel forState:UIControlStateNormal];
            [_pBtnXXDL setBackgroundImage:pImage forState:UIControlStateHighlighted];
            [_pBtnXXDL setTztTitle:@"信息地雷"];
            _pBtnXXDL.titleLabel.font = tztUIBaseViewTextFont(15.f);
            _pBtnXXDL.titleLabel.adjustsFontSizeToFitWidth = YES;
            [_pBtnXXDL addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            _pBtnXXDL.frame = rcFrame;
            [self addSubview:_pBtnXXDL];
            [_pAyButton addObject:_pBtnXXDL];
            _pBtnXXDL.hidden = YES;
        }
        else
        {
            _pBtnXXDL.frame = rcFrame;
        }
        
        rcFrame.origin.x +=nWidth + nSpace;
    }
    
    //F10
    _pBtnF10 = (UIButton*)[self viewWithTag:tztInfoBtnTag];
    if (_pBtnF10 == NULL)
    {
        _pBtnF10 = [UIButton buttonWithType:UIButtonTypeCustom];
        _pBtnF10.tag = tztInfoBtnTag;
        _pBtnF10.hidden  = YES;
        if (g_pSystermConfig && g_pSystermConfig.bNSupportInfoMine) // 没有信息地雷的情况 byDBQ20130805
        {
            [_pBtnF10 setBackgroundImage:pImage forState:UIControlStateHighlighted];
            [_pBtnF10 setBackgroundImage:pImageSel forState:UIControlStateNormal];
        }
        else
        {
            [_pBtnF10 setBackgroundImage:pImage forState:UIControlStateNormal];
            [_pBtnF10 setBackgroundImage:pImageSel forState:UIControlStateHighlighted];
        }
        
        _pBtnF10.titleLabel.font = tztUIBaseViewTextFont(15.f);
        _pBtnF10.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_pBtnF10 setTztTitle:@"F10"];
        [_pBtnF10 addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pBtnF10];
        [_pAyButton addObject:_pBtnF10];
        _pBtnF10.hidden = YES;
    }
    else
    {
        _pBtnF10.frame = rcFrame;
    }


    
    if (g_pSystermConfig && g_pSystermConfig.bSupportTBF10)
    {
        //龙虎(暂时先改为图表F10)
        rcFrame.origin.x += nWidth + nSpace;
        _pBtnTBF10 = (UIButton*)[self viewWithTag:tztInfoBtnTag + 3];
        if (_pBtnTBF10 == nil)
        {
            _pBtnTBF10 = [UIButton buttonWithType:UIButtonTypeCustom];
            _pBtnTBF10.tag = tztInfoBtnTag+3;
            [_pBtnTBF10 setBackgroundImage:pImage forState:UIControlStateNormal];
            [_pBtnTBF10 setBackgroundImage:pImageSel forState:UIControlStateHighlighted];
            [_pBtnTBF10 setTztTitle:@"图表F10"];
            _pBtnTBF10.titleLabel.font = tztUIBaseViewTextFont(15.0f);
            _pBtnTBF10.titleLabel.adjustsFontSizeToFitWidth = YES;
            [_pBtnTBF10 addTarget:self action:@selector(OnBtnF10:) forControlEvents:UIControlEventTouchUpInside];
            _pBtnTBF10.frame = rcFrame;
            [self addSubview:_pBtnTBF10];
            [_pAyButton addObject:_pBtnTBF10];
            _pBtnTBF10.hidden = YES;
        }
        else
        {
            _pBtnTBF10.frame = rcFrame;
        }
    }
    
    //财务
    rcFrame.origin.x += nWidth + nSpace;
 
    _pBtnFinance = (UIButton*)[self viewWithTag:tztInfoBtnTag + 2];
    if (_pBtnFinance == nil)
    {
        _pBtnFinance = [UIButton buttonWithType:UIButtonTypeCustom];
        _pBtnFinance.tag = tztInfoBtnTag+2;
        [_pBtnFinance setBackgroundImage:pImage forState:UIControlStateNormal];
        [_pBtnFinance setBackgroundImage:pImageSel forState:UIControlStateHighlighted];
        [_pBtnFinance setTztTitle:@"财务"];
        _pBtnFinance.titleLabel.font = tztUIBaseViewTextFont(15.f);
        _pBtnFinance.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_pBtnFinance addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _pBtnFinance.frame = rcFrame;
        _pBtnFinance.hidden = YES;
        [self addSubview:_pBtnFinance];
        [_pAyButton addObject:_pBtnFinance];
    }
    else
    {
        _pBtnFinance.frame = rcFrame;
    }
    
    
    if (MakeStockMarketStock(self.pStockInfo.stockType))
    {
        if (self.pCurSelBtn == _pBtnXXDL)
            [_pBtnXXDL setBackgroundImage:pImageSel forState:UIControlStateNormal];
        else
            [_pBtnXXDL setBackgroundImage:pImage forState:UIControlStateNormal];
        [_pBtnXXDL setTztTitleColor:[UIColor whiteColor]];
        _pBtnF10.hidden = NO;
        _pBtnTBF10.hidden = NO;
        _pBtnFinance.hidden = NO;
    }
    else
    {
        [_pBtnXXDL setBackgroundImage:nil forState:UIControlStateNormal];
        [_pBtnXXDL setTztTitleColor:[UIColor colorWithTztRGBStr:@"181,117,37"]];
        _pBtnF10.hidden = YES;
        _pBtnTBF10.hidden = YES;
        _pBtnFinance.hidden = YES;
    }
}

-(void)OnBtnF10:(id)sender
{
    [self OnBtnClick:sender];
    [self setStockInfo:self.pStockInfo Request:TRUE];
}


-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    self.pStockInfo = pStockInfo;

    ///add
    [self OnBtnClick:_pBtnFinance];
//    CGRect re = self.frame;
//    re.origin.y-=60;
//    self.frame = re;
    
    if (MakeIndexMarket(self.pStockInfo.stockType))
    {
        if (!_bIndexStock)
        {
            _bIndexStock = TRUE;
//            [self OnBtnClick:_pBtnXXDL];
            [self setFrame:self.frame];
        }
    }
    else
    {
        if (_bIndexStock)
        {
            _bIndexStock = FALSE;
            [self setFrame:self.frame];
        }
    }
    
    if (nRequest)
    {
        if (_pInfoTableView && !_pInfoTableView.hidden) 
        {
            if (MakeStockMarketStock(self.pStockInfo.stockType))
            {
                [_pInfoTableView setStockInfo:pStockInfo Request:1];
            }
            else
            {
                _pInfoTableView.HsString = @"000";
                tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
                pStock.stockCode = @"1A0001";
                pStock.stockName = @"上证指数";
                pStock.stockType = 4352;
                [_pInfoTableView setStockInfo:pStock Request:1];
            }
        }
        if (_pFinanceView && !_pFinanceView.hidden)
        {
            [_pFinanceView setStockInfo:pStockInfo Request:1];
        }
        if (_pF10View && !_pF10View.hidden)
        {
            BOOL bSucc = TRUE;
            if (self.pStockInfo == NULL || self.pStockInfo.stockCode == NULL)
            {
                bSucc = FALSE;
            }
            else if(MakeIndexMarket(self.pStockInfo.stockType) || !MakeStockMarket(self.pStockInfo.stockType))
            {
                bSucc = FALSE;
            }
            
            if(bSucc)
            {
                NSString *strURL = [g_pSystermConfig.pDict objectForKey:@"tztWebF10"];
                strURL = [NSString stringWithFormat:strURL,self.pStockInfo.stockCode];
                [_pF10View setWebURL:strURL];
            }
            else
            {
                NSString* strURL = @"暂无资讯内容";
                NSString* strPath = GetTztBundlePath(@"tzthtmlblack",@"html",@"plist");
                if(strPath && [strPath length] > 0)
                {
                    NSString* strtztHtml = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
                    if(strtztHtml && [strtztHtml length] > 0)
                        strURL = [NSString stringWithFormat:strtztHtml,@"提示信息", strURL];
                }
                [_pF10View LoadHtmlData:strURL];
            }
        }
    }

    _pBtnF10.hidden = YES;
    _pBtnTBF10.hidden = YES;
    _pBtnXXDL.hidden = YES;
    _pBtnFinance.hidden = YES;
}

-(tztStockInfo*)GetCurrentStock
{
//    return self.pStock;
    if (_pInfoTableView)
        return [_pInfoTableView GetCurrentStock];
    return NULL;
}

-(void)OnBtnClick:(id)sender
{
    UIImage *pImage = [UIImage imageTztNamed:@"TZTTabButtonBg.png"];
    UIImage *pImageSel = [UIImage imageTztNamed:@"TZTTabButtonSelBg.png"];
    for (int i = 0; i < [_pAyButton count]; i++)
    {
        UIButton* pBtn = [_pAyButton objectAtIndex:i];
        if (pBtn == sender)
        {
            [pBtn setBackgroundImage:pImageSel forState:UIControlStateNormal];
            self.pCurSelBtn = pBtn;
        }
        else
        {
            [pBtn setBackgroundImage:pImage forState:UIControlStateNormal];
        }
    }
    
    UIButton* pBtn = (UIButton*)sender;
    
    _pInfoTableView.hidden = (pBtn != _pBtnF10 && pBtn != _pBtnXXDL);
    _pFinanceView.hidden = (pBtn != _pBtnFinance);
    _pF10View.hidden = (pBtn != _pBtnTBF10);
    if (pBtn == _pBtnF10)
    {
        _pInfoTableView.HsString = @"";
        [_pInfoTableView setStockInfo:self.pStockInfo Request:1];
        [_pInfoTableView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:FALSE];
    }
    else if(pBtn == _pBtnXXDL)
    {
        _pInfoTableView.HsString = @"000";
        if (MakeStockMarketStock(self.pStockInfo.stockType))
        {
            [_pInfoTableView setStockInfo:self.pStockInfo Request:1];
        }
        else
        {
            tztStockInfo *pStock = NewObjectAutoD(tztStockInfo);
            pStock.stockCode = @"1A0001";
            pStock.stockName = @"上证指数";
            pStock.stockType = 4352;
            [_pInfoTableView setStockInfo:pStock Request:1];
        }
    }
    else if(pBtn == _pBtnFinance)
    {
        [_pFinanceView setStockInfo: self.pStockInfo Request:1];
    }
}

#pragma tztInfoDelegate
-(void)SetInfoData:(NSMutableArray*)ayData
{
    
}

-(void)SetInfoItem:(id)delegate pItem_:(tztInfoItem *)pItem
{
    if(pItem == NULL)
        return;
    if (delegate == _pInfoTableView)
    {
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Info_Content wParam:(NSUInteger)pItem lParam:(NSUInteger)_pInfoTableView];
    }
}
@end
