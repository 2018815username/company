/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUINewMarketView
 * 文件标识：
 * 摘    要：   对原先的UIMarketView派生处理
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-04
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/


#import "tztUINewMarketView.h"

@implementation tztUINewMarketView
@synthesize nsNormalImage = _nsNormalImage;
@synthesize nsHightLightImage = _nsHightLightImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _nWidth = 80;
        self.nsHightLightImage = @"TZTMarketButtonBackSmallH.png";
        self.nsNormalImage = @"TZTMarketButtonBackSmall.png";
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        _nWidth = 80;
        self.nsHightLightImage = @"TZTMarketButtonBackSmallH.png";
        self.nsNormalImage = @"TZTMarketButtonBackSmall.png";
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
//    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
//        return;
//    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    
    if (self.clBackColor)
        self.backgroundColor = self.clBackColor;
    
//    self.backgroundColor = [UIColor colorWithTztRGBStr:@"35,23,24"];
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
    
    _pScrollView.showsVerticalScrollIndicator = NO;
    _pScrollView.showsHorizontalScrollIndicator = YES;
    _pScrollView.alwaysBounceHorizontal = YES;
    _pScrollView.alwaysBounceVertical = NO;
    _nWidth = 80;
    int nSep = 5;
    
    NSUInteger nCount = _ayBtn.count;
    if (nCount > 0 && _nWidth * [_ayBtn count] < self.frame.size.width)
    {
        _nWidth = (self.frame.size.width - nSep *(nCount+1)) / _ayBtn.count;
    }
    
    float fTop = MAX(2, (self.frame.size.height - 30));
    CGRect rcBtn = CGRectMake(2, fTop, _nWidth, 30);
    for (int i = 0; i < [_ayBtn count]; i++)
    {   
        UIButton* pBtn = (UIButton*)[_ayBtn objectAtIndex:i];
        rcBtn.size.width = _nWidth;
        rcBtn.origin.x += (i == 0 ? 2 : _nWidth + nSep);
        NSUInteger nCount = pBtn.tag;
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
    int nTotalWidth = MAX((_nWidth+nSep) * [_ayBtn count]+4, rcFrame.size.width);
    [_pScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_pScrollView setContentSize:CGSizeMake(nTotalWidth, rcFrame.size.height)];
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
        tztUISwitch *pBtn = [tztUISwitch buttonWithType:UIButtonTypeCustom];
        pBtn.switched = NO;
        pBtn.yestitle = strTitle;
        pBtn.notitle = strTitle;
        pBtn.bUnderLine = FALSE;
        pBtn.yesImage = [UIImage imageTztNamed:self.nsHightLightImage];
        pBtn.noImage = [UIImage imageTztNamed:self.nsNormalImage];
//        pBtn.yesImage = [UIImage imageTztNamed:@"tztMenuSelect.png"];
        [pBtn setChecked:FALSE];
        [pBtn setShowsTouchWhenHighlighted:YES];
        pBtn.fontSize = 13.0f;
        pBtn.titleLabel.font = tztUIBaseViewTextFont(13.0f);
//        [pBtn setTztTitleColor:[UIColor whiteColor]];
        
        nCount++;
        
        pBtn.tag = nCount+1024;
        
        [_ayBtn addObject:pBtn];
        [_ayMarketData addObject:pDict];
    }
}
@end
