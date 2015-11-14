

#import "TZTUIToolBarView.h"
#import "TZTPageInfoItem.h"
#import "TZTTabBarProfile.h"


#define TZTPageInfoItemLG 1023
#define TZTPageInfoItemTag 1024
TZTUIToolBarView *g_pToolBarView = NULL;   //最下边的标题栏

@interface TZTUIToolBarView (tztPrivate)

@end

@implementation TZTUIToolBarView
@synthesize pSelectedView = _pSelectedView;
@synthesize pBackGroundView = _pBackGroundView;
@synthesize nSelected = _nSelected;
@synthesize nPreSelectd = _nPreSelectd;
-(id)init
{
    self = [super init];
    if (self)
    {
        _nPreSelectd = -1;
        if (g_pSystermConfig && g_pSystermConfig.nDefaultIndex)
            _nSelected = g_pSystermConfig.nDefaultIndex;
        else
            _nSelected = 0;
        //判断配置文件是否已经加载，没有加载重新加载
        if (g_pTZTTabBarProfile == NULL)
        {
            g_pTZTTabBarProfile = NewObject(TZTTabBarProfile);
            [g_pTZTTabBarProfile LoadTabBarItem];
        }
        
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(OnHiddenMoreView:)
													 name:TZTNotifi_HiddenMoreView
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(OnChangeTheme)
                                                     name:TZTNotifi_ChangeTheme
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ReloadToolBar:)
                                                     name:TZTNotifi_ChangeTabBarStatus
                                                   object:nil];
    }
    return self;
}

-(void)OnChangeTheme
{
    //重新加载配置文件
    [g_pTZTTabBarProfile LoadTabBarItem];
    [self setFrame:self.frame];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    if (_pBackGroundView == NULL)
    {
        _pBackGroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_pBackGroundView];
        [_pBackGroundView release];
    }
    _pBackGroundView.backgroundColor = [UIColor tztThemeBackgroundColorToolBar];
//    [_pBackGroundView setImage:[UIImage imageTztNamed:@"TZTTabBarBG.png"]];
    _pBackGroundView.frame = self.bounds;
    
    if (g_pTZTTabBarProfile == NULL)
        return;
    
    
    if (IS_TZTIPAD)
    {
        CGRect rcLogo = frame;
        rcLogo.origin.y = 0;
        UIImage *pImageLogo = [UIImage imageTztNamed:@"TZTLogo.png"];
        if (pImageLogo)
        {
            rcLogo.origin.x = 10;
            rcLogo.size = pImageLogo.size;
            if (rcLogo.size.height > pImageLogo.size.height)
                rcLogo.origin.y += (rcLogo.size.height - pImageLogo.size.height) / 2;
            else
                rcLogo.size.height = frame.size.height;
            
            UIButton *pBtnLogo = (UIButton*)[self viewWithTag:TZTPageInfoItemLG];
            if (pBtnLogo == NULL)
            {
                pBtnLogo = [UIButton buttonWithType:UIButtonTypeCustom];
                [pBtnLogo setImage:pImageLogo forState:UIControlStateNormal];
                [pBtnLogo setContentMode:UIViewContentModeCenter];
                [pBtnLogo setShowsTouchWhenHighlighted:YES];
                pBtnLogo.frame = rcLogo;
                pBtnLogo.tag = TZTPageInfoItemLG;
                [self addSubview:pBtnLogo];
            }
            else
            {
                pBtnLogo.frame = rcLogo;
            }
        }
    }
    
    //左侧预留宽度
    int nLeft = g_pTZTTabBarProfile.nMarginHead;
    //右侧预留宽度
    int nRight = g_pTZTTabBarProfile.nMarginTail;
    //需要显示的个数
    NSInteger nCount = [g_pTZTTabBarProfile.ayTabBarItem count];
    if (g_pTZTTabBarProfile.nMaxDisplay > 0)
        nCount = g_pTZTTabBarProfile.nMaxDisplay;
    
    if (nCount <= 0)
        return;
    
    int nBaseWidth = 0;
    int nMaxDrawWidth = (frame.size.width - nLeft - nRight);
    
    if (IS_TZTIPAD)
        nBaseWidth = (nMaxDrawWidth / nCount + 2);
    else
        nBaseWidth = (nMaxDrawWidth / nCount );
    
    NSInteger nSpace = (frame.size.width - (nCount*nBaseWidth)) / 2;
//    if (nSpace < 0 )
        nSpace = 0;
//    int nPerWidth = / nCount;
    
    CGRect rcFrame = CGRectMake(nLeft + nSpace, 0, nBaseWidth, frame.size.height);
    //创建按钮
    for (int i = 0; i < nCount; i++)
    {
        TZTPageInfoItem *pageInfoItem = [g_pTZTTabBarProfile.ayTabBarItem objectAtIndex:i];
        if (pageInfoItem == NULL)
            continue;
        
        tztUISwitch *pButton = (tztUISwitch*)[self viewWithTag:i + TZTPageInfoItemTag];
        
        CGSize sz = pageInfoItem.ImgNormal.size;
        
        CGRect rcTemp = rcFrame;
        if (!g_pTZTTabBarProfile.nDrawName && !IS_TZTIPAD)
        {
            rcTemp.origin.x += (rcFrame.size.width - sz.width) / 2;
            rcTemp.origin.y += (rcFrame.size.height - sz.height) / 2;
            rcTemp.size = sz;
        }
        
        if (pButton == NULL)
        {
            pButton = [self CreateButton:pageInfoItem rcFrame_:rcTemp nTag_:i + TZTPageInfoItemTag];
            [self addSubview:pButton];
        }
        else
        {
            pButton = [self CreateButton:pageInfoItem rcFrame_:rcTemp nTag_:i + TZTPageInfoItemTag];
            pButton.frame = rcTemp;
            [self setSwitch:pButton withInfo:pageInfoItem];
        }
        
        if (g_pTZTTabBarProfile.nSeperator)
        {
            CGRect rc = CGRectMake(rcFrame.origin.x + rcFrame.size.width - 1, rcFrame.origin.y + 5, 1, rcFrame.size.height - 10);
            UIView *pSepView = [self viewWithTag:i + (TZTPageInfoItemTag * 2)];
            if (pSepView == NULL)
            {
                pSepView = [[UIView alloc] initWithFrame:rc];
                pSepView.tag = i + (TZTPageInfoItemTag * 2);
                pSepView.backgroundColor = [UIColor colorWithRGBULong:g_pTZTTabBarProfile.nSeperatorColor];
                [self addSubview:pSepView];
                [pSepView release];
            }
            else
            {
                pSepView.frame = rc;
            }
        }
        
        if (i == _nSelected)
        {
            [pButton setChecked:YES];
            _nPreSelectd = _nSelected;
        }
        rcFrame.origin.x += nBaseWidth;
        
        if (rcFrame.origin.x + nBaseWidth > frame.size.width)
        {
            rcFrame.size.width = frame.size.width - rcFrame.origin.x;
        }
    }
}

- (void)reload
{
    [self setFrame:self.frame];
}

//重新加载toolbar图片，用于图片切换
-(void)ReloadToolBar:(NSString *)strData
{
    //读取上次保存的最新的状态数据
    NSString *strFilePath = [tztTabbarStatusFile tztHttpfilepath];
    NSDictionary *pDict = [NSDictionary dictionaryWithContentsOfFile:strFilePath];
    for (int i = 0; i < [g_pTZTTabBarProfile.ayTabBarItem count]; i++)
    {
        TZTPageInfoItem* pItem = [g_pTZTTabBarProfile.ayTabBarItem objectAtIndex:i];
        if (pItem == NULL)
            return;
        
        NSString *strKey = [NSString stringWithFormat:@"tab%d", (i+1)];
        NSString *strValue = [pDict objectForKey:strKey];
        pItem.nStatus = [strValue intValue];
    }
    [self reload];
    
}
//在这里创建下标栏的首页 行情 自选等
-(tztUISwitch*)CreateButton:(TZTPageInfoItem*)pageInfoItem
                rcFrame_:(CGRect)rcFrame
                   nTag_:(int)nTag
{
    tztUISwitch *pBtn = (tztUISwitch*)[self viewWithTag:nTag];
    if (pBtn == NULL)
    {
        pBtn = [[[tztUISwitch alloc] initWithFrame:rcFrame] autorelease];
        [pBtn addTarget:self action:@selector(OnPageInfoItem:) forControlEvents:UIControlEventTouchUpInside];
        pBtn.tag = nTag;
    }
    
    pBtn.frame = rcFrame;
    
    if (pageInfoItem.ImgSelected == NULL || IS_TZTIPAD)
        pBtn.yesImage = [UIImage imageTztNamed:@"tzt_footbarselectbg.png"];
    else
    {
        NSString *strImage = pageInfoItem.nsImgSelected;
        
        if (pageInfoItem.nStatus > 0)
        {
            NSArray *ay = [strImage componentsSeparatedByString:@"."];
            if ([ay count] > 0)
                strImage = [NSString stringWithFormat:@"%@+%d", [ay objectAtIndex:0], pageInfoItem.nStatus];
        }
        UIImage *image = [UIImage imageTztNamed:strImage];
        pBtn.yesImage = image;
    }

    NSString *strImageNormal = pageInfoItem.nsImgNormal;
    NSArray *ayNormal = [strImageNormal componentsSeparatedByString:@"."];
    if ([ayNormal count] < 1)
        return pBtn;
    
    if (pageInfoItem.nStatus > 0)
        strImageNormal = [NSString stringWithFormat:@"%@+%d", [ayNormal objectAtIndex:0], pageInfoItem.nStatus];
    
    UIImage *image = [UIImage imageTztNamed:strImageNormal];
    
    if (!g_pTZTTabBarProfile.nDrawName && !IS_TZTIPAD)
    {
        pBtn.noImage = image;// pageInfoItem.ImgNormal;
        [pBtn setChecked:FALSE];
        return pBtn;
    }
    [pBtn setChecked:FALSE];
    pBtn.showsTouchWhenHighlighted = YES;
    
//    UIImage *image = pageInfoItem.ImgNormal;
    CGSize sz = image.size;
    CGFloat fHeight = (rcFrame.size.height - 4) / 3;
    if (g_pTZTTabBarProfile.nDrawName)
        fHeight = (rcFrame.size.height - 4) / 4;
    
    CGFloat fWidth = MIN(sz.width * fHeight * 3 / sz.height,rcFrame.size.width);
    
    fWidth = MIN(fWidth, sz.width);
    
    CGFloat fImageHeight = MIN(fHeight * 3, sz.height);
    CGFloat fOriginY = 2;
    fOriginY = (fHeight*3 - fImageHeight) / 2;
    if (fOriginY <= 0)
        fOriginY = 2;
    
    CGRect rcImgView = CGRectMake((rcFrame.size.width - fWidth) / 2, fOriginY, fWidth , fImageHeight);
    
    UIImageView *pImageView = (UIImageView*)[self viewWithTag:2*TZTPageInfoItemTag + nTag];
    if (pImageView == NULL)
    {
        pImageView = [[UIImageView alloc] initWithImage:image];
        pImageView.backgroundColor = [UIColor clearColor];
        pImageView.tag = 2* TZTPageInfoItemTag + nTag;
        [pBtn addSubview:pImageView];
        [pImageView release];
    }
    pImageView.image = image;
    pImageView.frame = rcImgView;
    
    if (!g_pTZTTabBarProfile.nDrawName || IS_TZTIPAD)
        return pBtn;
    CGFloat fH = MAX(fHeight*3, fOriginY+fImageHeight);
    CGRect rcLabel = CGRectMake(0, fH, rcFrame.size.width, fHeight);
    UILabel *pLabel = (UILabel*)[self viewWithTag:3*TZTPageInfoItemTag + nTag];//
    if (pLabel == NULL)
    {
        pLabel = [[UILabel alloc] initWithFrame:rcLabel];
        pLabel.text = pageInfoItem.nsPageName;
        pLabel.textAlignment = NSTextAlignmentCenter;
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.font = tztUIBaseViewTextBoldFont(12.0f);
        pLabel.tag = 3 * TZTPageInfoItemTag + nTag;
        pLabel.adjustsFontSizeToFitWidth= YES;
        [pBtn addSubview:pLabel];
        pLabel.textColor = [UIColor colorWithRGBULong:0xB7B7B7];
        [pLabel release];
    }
    return pBtn;
}

// 重新加载里面的图片，用于替换主题 byDBQ
- (void)setSwitch:(tztUISwitch *)pBtn withInfo:(TZTPageInfoItem*)pageInfoItem
{
    return;
//    if (pageInfoItem.ImgSelected == NULL || IS_TZTIPAD)
//        pBtn.yesImage = [UIImage imageTztNamed:@"tzt_footbarselectbg.png"];
//    else
//        pBtn.yesImage = pageInfoItem.ImgSelected;
//    if (!g_pTZTTabBarProfile.nDrawName && !IS_TZTIPAD)
//    {
//        pBtn.noImage = pageInfoItem.ImgNormal;
//        [pBtn setChecked:FALSE];
//    }
}

-(void)OnDealToolBarByName:(NSString*)nsName
{
    int nIndex = [self GetTabItemIndexByName:nsName];
    
    [self OnDealToolBarAtIndex:nIndex options_:NULL];
}

//根据配置的名称获取对应的索引，用于跳转
-(int)GetTabItemIndexByName:(NSString*)nsName
{
    if (g_pTZTTabBarProfile)
        return [g_pTZTTabBarProfile GetTabItemIndexByName:nsName];
    else
        return -1;
}

//根据配置的ID获取对应的索引，用于跳转
-(int)GetTabItemIndexByID:(unsigned int)intID
{
    if (g_pTZTTabBarProfile)
        return [g_pTZTTabBarProfile GetTabItemIndexByID:intID];
    else
        return -1;
}
//切换 行情 交易 自选 资讯 首页
-(void) OnDealToolBarAtIndex:(NSInteger)nIndex options_:(NSDictionary *)options
{
    if (nIndex < 0)
        return;
    
    
    BOOL bSucc = TRUE;
    //处理具体的事件
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(didSelectItemAtIndex:options_:)])
    {
        bSucc = [_pDelegate didSelectItemAtIndex:nIndex options_:options];
    }
    //zxl  20130927 失败取消选中状态
    tztUISwitch *pButtonPre = NULL;
    if (nIndex > -1 && nIndex < [g_pTZTTabBarProfile.ayTabBarItem count])
    {
        pButtonPre = (tztUISwitch*)[self viewWithTag:nIndex +TZTPageInfoItemTag];
    }
    
    if (!bSucc)
    {
        if (pButtonPre)
        {
            [pButtonPre setChecked:FALSE];
        }
        return;
    }
    
    if (nIndex == _nPreSelectd)
    {
        if (pButtonPre)
        {
            [pButtonPre setChecked:TRUE];
        }
        return;
    }
    
    _nSelected = nIndex;
    //取消前一个的选中状态
    if (_nPreSelectd > -1 && _nPreSelectd < [g_pTZTTabBarProfile.ayTabBarItem count])
    {
        tztUISwitch *pButtonPre = (tztUISwitch*)[self viewWithTag:_nPreSelectd +TZTPageInfoItemTag];
        if (pButtonPre)
        {
            [pButtonPre setChecked:FALSE];
        }
    }
    
    if (_nSelected >= 0 && _nSelected < [g_pTZTTabBarProfile.ayTabBarItem count])
    {
        tztUISwitch *pButtonSel = (tztUISwitch*)[self viewWithTag:_nSelected +TZTPageInfoItemTag];
        if (pButtonSel)
        {
            [pButtonSel setChecked:YES];
        }
    }
    //记录位置
    _nPreSelectd = nIndex;
}

-(void)OnPageInfoItem:(id)sender
{
    UIButton *pButton = (UIButton*)sender;
    NSInteger nTag = pButton.tag; // 当自选的时候  ntag 为1027
    
    [g_ayPushedViewController removeAllObjects];
    int nPageID = -1;
    if (nTag - TZTPageInfoItemTag >= 0 && nTag - TZTPageInfoItemTag < [g_pTZTTabBarProfile.ayTabBarItem count])
    {
        TZTPageInfoItem* pItem = [g_pTZTTabBarProfile.ayTabBarItem objectAtIndex:nTag - TZTPageInfoItemTag];
        
        if (pItem)
            nPageID = pItem.nPageID;
        
        if (pItem && pItem.nPageID == tztMorePage)//更多
        {
            //转交上层处理
            if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(didSelectMoreView)])
            {
                tztUISwitch *pButtonSel = (tztUISwitch*)[self viewWithTag:_nPreSelectd +TZTPageInfoItemTag];
                if (pButtonSel)
                {
                    [pButtonSel setChecked:NO];
                }
                _nSelected = nTag - TZTPageInfoItemTag;
                [self.pDelegate didSelectMoreView];
            }
            return;
        }
    }
    
    [self OnDealToolBarAtIndex:nTag - TZTPageInfoItemTag options_:NULL];
#ifdef tzt_XBSC
    if (nPageID == tztHomePage || nPageID == tztServicePage || nPageID == tztServicePageLocal || nPageID == tztMarketPage)
#else
        if (nPageID == tztHomePage /*|| nPageID == tztServicePage*/ || nPageID == tztServicePageLocal)
#endif
    {
        [g_navigationController popToRootViewControllerAnimated:YES];
    }
    NSArray* ayVC = g_navigationController.viewControllers; //将当前vc列加入操作列
    for (int i = 0; i < [ayVC count]; i++)
    {
        [g_ayPushedViewController addObject:[ayVC objectAtIndex:i]];
    }
}

//更多界面隐藏，回到上个界面的选中
-(void)OnHiddenMoreView:(NSNotification*)notification
{
    if(notification && [notification.name compare:TZTNotifi_HiddenMoreView]== NSOrderedSame)
    {
        if (_nPreSelectd == _nSelected)
            return;
        tztUISwitch *pButtonSel = (tztUISwitch*)[self viewWithTag:_nPreSelectd +TZTPageInfoItemTag];
        if (pButtonSel)
        {
            [pButtonSel setChecked:YES];
        }
        pButtonSel = (tztUISwitch*)[self viewWithTag:_nSelected +TZTPageInfoItemTag];
        if (pButtonSel)
        {
            [pButtonSel setChecked:NO];
        }
    }
}
@end
