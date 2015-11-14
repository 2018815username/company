/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯内容展示view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztInfoContentView.h"
#import "tztInfoTableView.h"

@implementation tztInfoContentView
@synthesize infoBase = _infoBase;
@synthesize infoTextView = _infoTextView;
@synthesize infoWebView = _infoWebView;
@synthesize hsString = _hsString;
@synthesize pFont = _pFont;
@synthesize nsData = _nsData;
@synthesize pListView = _pListView;
@synthesize bRequestList = _bRequestList;

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
    }
    return self;
}

-(void)initdata
{
    //增加手势侦听事件
    UISwipeGestureRecognizer *swipeTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveLeftOrRight:)];
    [swipeTap setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeTap];
    [swipeTap release];
    
    swipeTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnMoveLeftOrRight:)];
    [swipeTap setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipeTap];
    [swipeTap release];
    _bRequestList = TRUE;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_infoBase)
    {
        [[tztMoblieStockComm getSharehqInstance] removeObj:_infoBase];
    }
    DelObject(_infoBase);
    DelObject(_infoTextView);
    DelObject(_infoWebView);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    if (_infoWebView == nil)
    {
        _infoWebView = [[UIWebView alloc] initWithFrame:rcFrame];
        _infoWebView.multipleTouchEnabled = NO;
        _infoWebView.backgroundColor = [UIColor tztThemeBackgroundColorZX];
//        if (g_nThemeColor >= 1 || g_nSkinType >= 1)
//        {
//            _infoWebView.backgroundColor = [UIColor whiteColor];
//        }
//        else
//        {
//            _infoWebView.backgroundColor = [UIColor blackColor];
//        }
////        if (g_nHQBackBlackColor)
////        {
////            _infoWebView.backgroundColor = [UIColor blackColor];
////        }
////        else
////        {
////            _infoWebView.backgroundColor = [UIColor whiteColor];
////        }
        _infoWebView.opaque = NO;
        _infoWebView.scalesPageToFit = YES;
        [_infoWebView loadHTMLString:@"" baseURL:nil];
        [self addSubview:_infoWebView];
    }
    else
    {
        _infoWebView.frame = rcFrame;
    }
}
//将标题跟文本内容的时间获取
-(void)setDate:(NSString*)date
{
    _menuDate=date;
}
//在这里将标题跟文本内容获取
- (void)setMenu:(NSString *)title infoContetn:(NSString *)text
{
    _infoContent=text;
    _menuTitle=title;
}

-(void)setStockInfo:(tztStockInfo*)pStockInfo HsString_:(NSString*)HsString
{
    self.pStockInfo = pStockInfo;
    if (HsString && [HsString length] > 0)
        self.hsString = [NSString stringWithFormat:@"%@", HsString];
    
    if (_infoWebView)
    {
        [_infoWebView loadHTMLString:@"" baseURL:nil];
    }
}
-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest
{
    if (_infoBase == nil)
        _infoBase = NewObject(tztInfoBase);

    
    _infoBase.pDelegate = self;
    _infoBase.nMaxCount = 1;
    _infoBase.pStockInfo = self.pStockInfo;
    _infoBase.hSString = _hsString;
    
    [_infoBase acquireDate:_menuDate];
    _infoBase.nIsMenu = 0;
    _infoBase.bRequestList = _bRequestList;
    [_infoBase setMenu:_menuTitle infoContetn:_infoContent];
    [_infoBase GetMenu:_hsString retStr_:nil];
}

-(void)SetInfoData:(NSMutableArray*)ayData
{
    if (ayData == NULL || [ayData count] < 1)
        return;
    
    tztInfoItem *pItem = [ayData objectAtIndex:0];
    if (pItem == NULL || ![pItem isKindOfClass:[tztInfoItem class]]) 
        return;
    
    NSMutableString *pString = NULL;
    NSString* strPath = @"";
    if (g_nSkinType >= 1 || g_nThemeColor >= 1)
    {
        pString = [[[NSMutableString alloc] initWithString:tztinfocontentmodeWhite] autorelease];
        strPath = GetTztBundlePath(@"tzthtmlwhite",@"html",@"plist");
    }
    else
    {
        pString = [[[NSMutableString alloc] initWithString:tztinfocontentmode] autorelease];
        strPath = GetTztBundlePath(@"tzthtmlblack",@"html",@"plist");
//        if (g_nHQBackBlackColor)
//        {
//        }
//        else
//        {
//            pString = [[[NSMutableString alloc] initWithString:tztinfocontentmodeWhite] autorelease];
//            strPath = GetTztBundlePath(@"tzthtmlwhite",@"html",@"plist");
//        }
    }
    if (pString == NULL)
        return;
  
    NSString* strtztHtml = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    
    [pString replaceOccurrencesOfString:@"[-headInfo-]" withString:pItem.InfoTitle options:NSCaseInsensitiveSearch range:NSMakeRange(0, [pString length])];
    
    [pString replaceOccurrencesOfString:@"[-timeInfo-]" withString:pItem.InfoTime options:NSCaseInsensitiveSearch range:NSMakeRange(0, [pString length])];
    [pString replaceOccurrencesOfString:@"[-sourceInfo-]" withString:pItem.InfoSource options:NSCaseInsensitiveSearch range:NSMakeRange(0, [pString length])];
    
    NSString* strBody = @"";
    if(pItem && pItem.InfoContent)
    {
        strBody = [pItem.InfoContent stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<p/>"];
    }
    [pString replaceOccurrencesOfString:@"[-bodyInfo-]" withString:strBody options:NSCaseInsensitiveSearch range:NSMakeRange(0, [pString length])];
    
     NSString* strHtml = @"";
    if(strtztHtml && [strtztHtml length] > 0)
        strHtml = [NSString stringWithFormat:strtztHtml,@"",pString];
    else
        strHtml = [NSString stringWithFormat:@"%@",pString];
    [_infoWebView loadHTMLString:strHtml baseURL:nil];
}

- (void)onNextInfo
{
    //只有一条，没有翻页
    if (_pListView == NULL && ![_pListView isKindOfClass:[tztInfoTableView class]])
        return;
    
    tztInfoTableView *pTableView = (tztInfoTableView*)_pListView;
    if (pTableView.ayInfoData == NULL || [pTableView.ayInfoData count] <= 1)
        return;
    
    if(pTableView.nSelectRow >= [pTableView.ayInfoData count] - 1)
    {
        [self showMessageBox:@"当前已经是最后一条资讯!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    pTableView.nSelectRow++;
    tztInfoItem* pInfo = [pTableView.ayInfoData objectAtIndex:pTableView.nSelectRow];
    if (pInfo == NULL)
        return;
    
    self.hsString = [NSString stringWithFormat:@"%@", pInfo.IndexID];
    [self setStockInfo:self.pStockInfo HsString_:self.hsString];
    [self setStockInfo:self.pStockInfo Request:1];

}

- (void)onPreInfo
{
    //只有一条，没有翻页
    if (_pListView == NULL && ![_pListView isKindOfClass:[tztInfoTableView class]])
        return;
    
    tztInfoTableView *pTableView = (tztInfoTableView*)_pListView;
    if (pTableView.ayInfoData == NULL || [pTableView.ayInfoData count] <= 1)
        return;
    

    if (pTableView.nSelectRow <= 0)
    {
        pTableView.nSelectRow = 0;
        [self showMessageBox:@"当前已经是第一条资讯!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
    
    pTableView.nSelectRow--;
    tztInfoItem* pInfo = [pTableView.ayInfoData objectAtIndex:pTableView.nSelectRow];
    if (pInfo == NULL)
        return;
    
    self.hsString = [NSString stringWithFormat:@"%@", pInfo.IndexID];
    [self setStockInfo:self.pStockInfo HsString_:self.hsString];
    [self setStockInfo:self.pStockInfo Request:1];

}

//左右滑屏事件处理前后切换
-(void)OnMoveLeftOrRight:(UISwipeGestureRecognizer*)recognsizer
{
    //向左滑动,下一条
    if (recognsizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self onNextInfo];
    }
    //向右滑动上一条
    else if(recognsizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self onPreInfo];
    }
}
@end
