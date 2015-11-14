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

#import "tztUIMarketView.h"


@implementation tztUIMarketView
@synthesize pSrcollView = _pScrollView;
@synthesize ayMarketData = _ayMarketData;
@synthesize ayBtn = _ayBtn;
@synthesize nWidth = _nWidth;
@synthesize nsCurSel = _nsCurSel;

-(id)init
{
    if (self = [super init])
    {
        _ayMarketData = NewObject(NSMutableArray);
        _ayBtn = NewObject(NSMutableArray);
        perBtTag = -1;
        self.nsCurSel = @"";
        _nWidth = 90;
    }
    return self;
}

-(void)dealloc
{
    DelObject(_ayMarketData);
    DelObject(_ayBtn);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
//    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
//        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
//    if (g_nThemeColor == 1 || g_nSkinType == 1)
//        self.backgroundColor = [UIColor colorWithTztRGBStr:@"237,237,237"];
//    else
//        self.backgroundColor = [UIColor colorWithTztRGBStr:@"41,41,41"];
//    self.alpha = 0.5f;
    
    if (_pScrollView == NULL)
    {
        _pScrollView = [[UIScrollView alloc] initWithFrame:rcFrame];
        _pScrollView.delegate = self;
        _pScrollView.directionalLockEnabled = YES;//只能一个方向滑动
        _pScrollView.backgroundColor = [UIColor clearColor];
        [_pScrollView setContentSize:rcFrame.size];
        [self addSubview:_pScrollView];
        [_pScrollView release];
    }
    else
        _pScrollView.frame = rcFrame;
    
    int nHeight = 0;
    
    if (TZT_MarketView_SP)
    {
        _pScrollView.showsVerticalScrollIndicator = YES;
        _pScrollView.showsHorizontalScrollIndicator = NO;
        _pScrollView.alwaysBounceHorizontal = NO;
        _pScrollView.alwaysBounceVertical = YES;
        _nWidth = rcFrame.size.width - 10;//宽度
        nHeight = 40;                   //高度
        
        CGRect rcBtn = CGRectMake(5, 2, _nWidth, 30);
        for (int i = 0; i < [_ayBtn count]; i++) 
        {
            UIButton* pBtn = (UIButton*)[_ayBtn objectAtIndex:i];
            rcBtn.size.height = [self sizeToContent:pBtn.titleLabel.text].height < (nHeight - 10)?(nHeight - 10):[self sizeToContent:pBtn.titleLabel.text].height;
            nHeight = rcBtn.size.height + 10;
            rcBtn.origin.y += (i == 0 ? 10 : nHeight);
            int nCount = pBtn.tag;
            if (![_pScrollView viewWithTag:nCount]) //已经存在，不添加，只调整位置
            {
                pBtn.frame = rcBtn;
                [pBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
                [_pScrollView addSubview:pBtn];
            }
            else
            {
                pBtn.frame = rcBtn;
            }
        }
        nHeight = rcBtn.size.height + 10;
        int nTotalHeight = MAX(nHeight * [_ayBtn count], rcFrame.size.height);
        [_pScrollView setContentSize:CGSizeMake(rcFrame.size.width, nTotalHeight)];
    }
    else
    {
        _pScrollView.showsVerticalScrollIndicator = NO;
        _pScrollView.showsHorizontalScrollIndicator = YES;
        _pScrollView.alwaysBounceHorizontal = YES;
        _pScrollView.alwaysBounceVertical = NO;
        if (_nWidth < 10)
            _nWidth = 90;
//        nHeight = rcFrame.size.height - 4;                   //高度
//
        
        CGRect rcBtn = CGRectMake(2, 0, _nWidth - 2, 30);
        rcBtn.origin.y += (self.bounds.size.height - 30) / 2;
        NSUInteger nCount = [_ayBtn count];
        NSInteger nMax = nCount * _nWidth;
        if (nCount > 0 && (nMax < rcFrame.size.width))
        {
            _nWidth = rcFrame.size.width / nCount;
            rcBtn.size.width = _nWidth - 2;
        }
        
        for (int i = 0; i < [_ayBtn count]; i++) 
        {
            
            rcBtn.origin.x += (i == 0 ? 2 : _nWidth);
            UIButton* pBtn = (UIButton*)[_ayBtn objectAtIndex:i];
            rcBtn.size.width = [self sizeToContent:pBtn.titleLabel.text].width < (_nWidth - 2)?(_nWidth - 2):[self sizeToContent:pBtn.titleLabel.text].width; // 如果文字过多则进一步调整btn的宽度 byDBQ20130731
            _nWidth = rcBtn.size.width + 2;
            NSInteger nCount = pBtn.tag;
            if (![_pScrollView viewWithTag:nCount]) //已经存在，不添加，只调整位置
            {
                pBtn.frame = rcBtn;
                [pBtn addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
                [_pScrollView addSubview:pBtn];
            }
            else
            {
                pBtn.frame = rcBtn;
            }
        }   
        _nWidth = rcBtn.size.width + 2;
        int nTotalWidth = MAX(_nWidth * [_ayBtn count]+4, rcFrame.size.width);
        [_pScrollView setContentSize:CGSizeMake(nTotalWidth, rcFrame.size.height)];
    }
}

-(void)SetMarketData:(NSMutableDictionary *)ayData
{
    if (_ayMarketData == NULL)
        _ayMarketData = NewObject(NSMutableArray);
    
    [_ayMarketData removeAllObjects];
    
    NSMutableArray *pData = [ayData objectForKey:@"tradelist"];
    if (_ayBtn == NULL)
        _ayBtn = NewObject(NSMutableArray);
    
    for (int i = 0; i < [_ayBtn count]; i++)
    {
        UIButton* pBtn = (UIButton*)[_ayBtn objectAtIndex:i];
//        int nCount = pBtn.tag;
        [pBtn removeFromSuperview];
    }
    
    [_ayBtn removeAllObjects];
    
    int nCount = 0;
    for (int i = 0 ; i < [pData count]; i++)
    {
        NSDictionary *pDict = [pData objectAtIndex:i];
        if (pDict == NULL)
            continue;
        NSString* strMenuData = [pDict objectForKey:@"MenuData"];
        if (strMenuData == NULL || [strMenuData length] < 1)
            continue;
        NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
        if (pAy == NULL || [pAy count] < 10)
            continue;
        
        NSString *strLast = [pAy lastObject];
        if (strLast && [strLast caseInsensitiveCompare:@"F"] == NSOrderedSame)
            continue;
        
        NSString* strTitle = [pAy objectAtIndex:1];
//        NSString* strParam = [pAy objectAtIndex:3];
//        int nMsgType = [[pAy objectAtIndex:2] intValue];
        tztUISwitch *pBtn =  [tztUISwitch buttonWithType:UIButtonTypeCustom];
        pBtn.switched = NO;
        pBtn.yestitle = strTitle;
        pBtn.notitle = strTitle;
        pBtn.yesImage = [UIImage imageTztNamed:@"TZTMarketButtonBackSmallH.png"];
        pBtn.noImage = [UIImage imageTztNamed:@"TZTMarketButtonBackSmall.png"];;
        [pBtn setTztTitleColor:[UIColor whiteColor]];
        [pBtn setChecked:FALSE];
        [pBtn setShowsTouchWhenHighlighted:YES];
        pBtn.fontSize = 12.0f;
        pBtn.titleLabel.font = tztUIBaseViewTextFont(12.0f);
//        [pBtn setTztTitleColor:[UIColor whiteColor]];
    
        nCount++;
        
        pBtn.tag = nCount+1024;
        
        [_ayBtn addObject:pBtn];
        [_ayMarketData addObject:pDict];
    }
}

/*
 入参：UIView上的文字内容
 出参：UIView的size
 功能：根据文字内容调整UIView的size
 byDBQ20130731
 */
-(CGSize) sizeToContent:(NSString *)theContent
{
    UIFont *font = tztUIBaseViewTextFont(12.0f);
    CGSize size = [theContent sizeWithFont:font constrainedToSize:CGSizeMake(1500, 1500) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(void)OnDefaultMenu:(NSInteger)nIndex
{
    if (nIndex < 0 || _ayMarketData == NULL || nIndex >= [_ayMarketData count])
        return;
    NSDictionary *pDict = [_ayMarketData objectAtIndex:nIndex];
    if (pDict == NULL)
        return;
    NSString* strMenuData = [pDict objectForKey:@"MenuData"];
    if (strMenuData == NULL || [strMenuData length] < 1)
        return;
    NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
    if (pAy == NULL || [pAy count] < 10)
        return;
    NSString* strTitle = [pAy objectAtIndex:1];
    NSString* strParam = [pAy objectAtIndex:3];
    NSString* strMsgType = [pAy objectAtIndex:2];
    
    NSMutableDictionary *retDict = NewObject(NSMutableDictionary);
    [retDict setTztValue:strTitle forKey:@"tztTitle"];
    [retDict setTztValue:strParam forKey:@"tztParam"];
    [retDict setTztValue:strMsgType forKey:@"tztMsgType"];
    [retDict setTztValue:strMenuData forKey:@"tztMenuData"];
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(tztUIMarket:DidSelectMarket:marketMenu:)])
    {
        [_pDelegate tztUIMarket:self DidSelectMarket:retDict marketMenu:pDict];
    }
    DelObject(retDict);
}

-(void)OnButton:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    NSInteger nTag = pBtn.tag - 1024 - 1;
    
    [self OnDefaultMenu:nTag];
}

//选中市场
-(void)tztUIMarket:(id)self DidSelectMarket:(NSDictionary*)pDict marketMenu:(NSDictionary *)pMenu
{
    
}


-(int)setSelBtIndex:(NSString*)nsData
{
    if (nsData && nsData.length > 0)
        self.nsCurSel = [NSString stringWithFormat:@"%@", nsData];
    if ([_ayMarketData count] < 1 || [_ayBtn count] < 1 || nsData == NULL || [nsData length] < 1)
    {
        return 0;
    }
    int nIndex = -1;
    
    for (int i = 0; i < [_ayMarketData count]; i++)
    {
        NSDictionary *pDict = [_ayMarketData objectAtIndex:i];
        if (pDict == NULL)
            return 0;
        NSString* strMenuData = [pDict objectForKey:@"MenuData"];
        if (strMenuData == NULL || [strMenuData length] < 1)
            return 0;
        NSArray *pAy = [strMenuData componentsSeparatedByString:@"|"];
        if (pAy == NULL || [pAy count] < 3)
            return 0;
        NSString* strAction = [pAy objectAtIndex:0];
        NSString* strParam = [pAy objectAtIndex:3];
        NSString* str = [NSString stringWithFormat:@"%@#%@",strParam,strAction];
        if ([nsData compare:str] == NSOrderedSame && [nsData length] == [str length])
        {
            nIndex = i;
            break;
        }
    }
    
    if (nIndex >= 0 && nIndex < [_ayBtn count]) 
    {
        tztUISwitch *pBtn = [_ayBtn objectAtIndex:nIndex];
        [self setBtHImage:pBtn];
    }
    
    CGPoint pt = CGPointZero;
    if (nIndex * _nWidth >= self.frame.size.width)
    {
        pt.x = (int)(nIndex*_nWidth) - (self.frame.size.width / 2); //- (int)self.frame.size.width;
    }
    [_pScrollView setContentOffset:pt animated:YES];
    return nIndex;
}

-(void)setBtHImage:(tztUISwitch *)pBtn
{
    if(pBtn.tag == perBtTag)
    {
        [pBtn setChecked:TRUE];
        return;
    }
    else if(perBtTag == -1)
    {
        perBtTag = pBtn.tag;
        [pBtn setChecked:TRUE];
    }
    else
    {
        tztUISwitch *perBtn = (tztUISwitch *)[self viewWithTag:perBtTag];
        [perBtn setChecked:FALSE];
        [pBtn setChecked:TRUE];
        perBtTag = pBtn.tag;
    }
    
    for (int i = 0; i < [_ayBtn count]; i++)
    {
        tztUISwitch *perBtn = (tztUISwitch *)[_ayBtn objectAtIndex:i];
        if (perBtn != pBtn)
            [perBtn setChecked:FALSE];
    }
}
@end
