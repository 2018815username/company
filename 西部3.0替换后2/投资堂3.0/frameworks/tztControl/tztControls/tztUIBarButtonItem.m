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

#import "tztUIBarButtonItem.h"
#import "TZTSystermConfig.h"

#define BarButtonItemWidth 45.7
#define BarButtonItemHeight TZTToolBarHeight
#define BarButtonItemLeft (0)

#define tztTradeBottomButtonSpace 6
#define tztTradeBottomButtonHeight 44

@interface tztUIBarButtonItem (tztPrivate)
+(SEL)GetToolbarItemAction:(int)nID;
@end

@implementation tztUIBarButtonItem
@synthesize nsTitle = _nsTitle;
@synthesize ntztTag = _ntztTag;

-(id)initWithTitle:(NSString *)title tag:(NSInteger)tag target:(id)target nMsgID_:(NSInteger)nMsgID nTotalWidth_:(int)nTotalWidth
{
    if (tag == 0)
    {
        NSString *strTitle = @"";
        if (g_pSystermConfig)
            strTitle = g_pSystermConfig.strCompanyName;
        
        if (self = [super initWithTitle:strTitle style:UIBarButtonItemStylePlain target:nil action:nil])
        {
            _ntztTag = nMsgID;
            self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
            self.width = BarButtonItemLeft * 2 + TZTScreenWidth;
            [self setEnabled:FALSE];
            _pDelegate = nil;
        }
        return self;
    }
    else if(self = [super initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil])
    {
        _pDelegate = nil;
        int iCount = (tag & 0xF0);
        int iTitleWidth = BarButtonItemWidth;
//        int iLength = 2;
//        if (title)
//            iLength = title.length;
        
        if (iCount == 0)
            iCount = 0x70;
        
        iCount = iCount / 16;
        tag = (tag & 0x0F);
        if (iCount <= 4)
            iTitleWidth = 80;
        
        self.width = iTitleWidth;
        
        nTotalWidth = (nTotalWidth > 0 ? nTotalWidth :TZTScreenWidth);
        
        int nMargin = (nTotalWidth - (iCount * iTitleWidth)) / (iCount + 1);
        
        float fItemLeft = nMargin + (nMargin + iTitleWidth) * (tag  - 1);
//        float fItemLeft = nMargin +  nTotalWidth* (tag - 1) / iCount;
        if (tag == iCount)
        {
            if (fItemLeft + iTitleWidth > nTotalWidth + 20)
            {
                fItemLeft = nTotalWidth + 20 - iTitleWidth;
            }
        }
        
        UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(fItemLeft, 0, iTitleWidth, BarButtonItemHeight)] autorelease];
		[btn setBackgroundImage:[UIImage imageTztNamed:@"TZTtoolbarBG.png"] forState:UIControlStateHighlighted];
		[btn setTitle:title forState:UIControlStateNormal];
		[btn setTitle:title forState:UIControlStateHighlighted];
        [btn setTztTitleColor:[UIColor whiteColor]];
		[btn addTarget:target action:@selector(OnToolbarMenuClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setShowsTouchWhenHighlighted:YES];
		btn.tag = nMsgID;//功能号做为tag
		self.customView = btn;
        self.nsTitle = title;
        _ntztTag = nMsgID;
		_pDelegate = target;
    }
    return  self;
}

-(void)dealloc
{
    _pDelegate = nil;
    _nsTitle = nil;
    [super dealloc];
}



//根据数组创建底部工具栏（用户自定义）
+(void)GetToolBarItemByArray:(NSArray*)pAy delegate_:(id)delegate forToolbar_:(UIToolbar*)toolbar
{
    if (toolbar == NULL || g_pSystermConfig == NULL)
        return;
    if (pAy == NULL || [pAy count] <= 0)
        return;
    
    
    NSMutableArray *ayItems = NewObject(NSMutableArray);
    tztUIBarButtonItem *barBtnItem = nil;
    
    NSInteger nCount = [pAy count];
    BOOL bFlag = FALSE;
    if (nCount < 3)
    {
        bFlag = TRUE;
        nCount = 3;
    }
    nCount = nCount * 16;
    
    for (int i = 0; i < nCount / 16; i++)
    {
        if (i >= [pAy count]) 
        {
            break;
        }
        
        NSString* strLine = [pAy objectAtIndex:i];
        if (strLine == nil || [strLine length] < 1)
            continue;
        
        NSArray* pSubAy = [strLine componentsSeparatedByString:@"|"];
        if (pSubAy == NULL || [pSubAy count] < 2)
            continue;
        
        NSString* nsName = [pSubAy objectAtIndex:0];
        int nAction = [[pSubAy objectAtIndex:1] intValue];
        
        if (bFlag &&  i == ([pAy count] - 1)) 
        {
            barBtnItem = [[tztUIBarButtonItem alloc] initWithTitle:nsName
                                                               tag:nCount|(nCount/16)
                                                            target:delegate
                                                           nMsgID_:nAction
                                                      nTotalWidth_:toolbar.frame.size.width];
        }
        else
        {
            barBtnItem = [[tztUIBarButtonItem alloc] initWithTitle:nsName
                                                           tag:nCount|(i+1)
                                                        target:delegate
                                                           nMsgID_:nAction
                                                      nTotalWidth_:toolbar.frame.size.width];
        }
        
        [ayItems addObject:barBtnItem];
        [barBtnItem release];
        
    }
    [toolbar setItems:ayItems];
    [ayItems release];
}

//根据传入的key创建底部工具栏（读取配置文件）
+(void)GetToolBarItemByKey:(NSString *)nsKey delegate_:(id)delegate forToolbar_:(UIToolbar *)toolbar
{
    if (toolbar == NULL || g_pSystermConfig == NULL)
        return;
    if (nsKey == NULL || [nsKey length] < 1)
        nsKey = @"TZTToolbarDefault";
    
    NSArray *pAy = [g_pSystermConfig.pDict objectForKey:nsKey];
    
    if (pAy == NULL || [pAy count] < 1)
        return;
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:delegate forToolbar_:toolbar];
}

//重新布局toolbar
+(void)ToolBarItemLayout:(UIToolbar*)toolbar
{
    if (toolbar == nil)
        return;
    NSArray *pAyItems = toolbar.items;
    if (pAyItems == NULL || [pAyItems count] < 1)
        return;
    
    NSInteger iCount = [pAyItems count];
    int iTitleWidth = BarButtonItemWidth;
    if (iCount <= 4)
        iTitleWidth = 80;
    int nTotalWidth = (toolbar.frame.size.width > 0 ? toolbar.frame.size.width : TZTScreenWidth);
    NSInteger nMargin = (nTotalWidth - (iCount * iTitleWidth)) / (iCount + 1);
    for (int i = 0; i < iCount; i++)
    {
        UIBarButtonItem *pBarItem = [pAyItems objectAtIndex:i];
        if (pBarItem == NULL)
            continue;
        pBarItem.width = iTitleWidth;
        float fItemLeft = nMargin + (nMargin + iTitleWidth) * (i  - 1);
//        float fItemLeft = nMargin + nTotalWidth * (i - 1) / iCount;
        if (i == iCount - 1)
        {
            if (fItemLeft + iTitleWidth > nTotalWidth + 20)
            {
                fItemLeft = nTotalWidth + 20 - iTitleWidth;
            }
        }
        
        pBarItem.customView.frame = CGRectMake(fItemLeft, 0, iTitleWidth, BarButtonItemHeight);
    }
}

+(NSMutableArray *)GetValidButton:(NSArray*)pAy
{
    NSMutableArray *pReturn = NewObjectAutoD(NSMutableArray);
    for (int i = 0; i < [pAy count]; i++)
    {
        NSString* strLine = [pAy objectAtIndex:i];
        if (strLine == nil || [strLine length] < 1)
            continue;
        if ([strLine caseInsensitiveCompare:@"首页|3200"] == NSOrderedSame
            || [strLine hasPrefix:@"首页|3200"])
        {
            continue;
        }
        
        [pReturn addObject:strLine];
    }
    return pReturn;
}
/*
 功能：配置底部操作样式，如：详细、刷新、撤单
 入参：1.操作项数组，名称|功能号
 2.显示底部样式的view
 输出：无
 byDBQ20130718
 */
+(void)getTradeBottomItemByArray:(NSArray*)pAy target:(id)delegate withSEL:(SEL)sel forView : (tztBaseViewUIView *)view BtnImage_:(UIImage*)btnBgImg btnSelImage_:(UIImage*)btnSelImg
{
    NSMutableArray *pValidAy = [tztUIBarButtonItem GetValidButton:pAy];
    NSInteger nCount = pValidAy.count;
    
    [view removeAllToolBar];
    UIView *pViewBg = [view viewWithTag:0x3344];
    if (pViewBg)
    {
        [pViewBg removeFromSuperview];
        pViewBg = nil;
    }
    btnBgImg = nil;
    btnSelImg = nil;
    
    UIImage *pImage = btnBgImg;// [UIImage imageTztNamed:@"TZTTabButtonBg.png"];
    UIImage *pImageSel = btnSelImg;//[UIImage imageTztNamed:@"TZTTabButtonSelBg.png"];
    
    CGRect rcBtn = CGRectZero;
    rcBtn.origin.y = view.frame.size.height-44;
    rcBtn.size.height = tztTradeBottomButtonHeight;
    
    pViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, rcBtn.origin.y, view.frame.size.width, rcBtn.size.height)];
    pViewBg.tag = 0x3344;
    pViewBg.backgroundColor = [UIColor tztThemeJYToolbarBgColor];
//    pViewBg.backgroundColor = [UIColor colorWithTztRGBStr:@"68,68,68"];
//    if (!g_nJYBackBlackColor) {
//        pViewBg.backgroundColor = [UIColor colorWithTztRGBStr:@"157, 157, 157"];
//    }
    [view addSubview:pViewBg];
    [pViewBg release];
    
    int nWidth = (view.frame.size.width-(nCount+1)*tztTradeBottomButtonSpace)/nCount;
    int nSpace = tztTradeBottomButtonSpace;
    //zxl 20131012 修改了ipad无法显示出按钮的位置
    if (IS_TZTIPAD)
    {
        UIView *lastView = (UIView *) [view.subviews lastObject];
        CGRect lastrect = lastView.frame;
        rcBtn.origin.y = lastrect.origin.y + lastView.frame.size.height + 5;
        nWidth = (lastrect.size.width-(nCount+1)*tztTradeBottomButtonSpace)/nCount;
    }
    
    CGRect rcFrame = rcBtn;
    rcFrame.origin.x += nSpace;
    rcFrame.origin.y += nSpace/2;
    rcFrame.size.height -= nSpace;
    rcFrame.size.width = nWidth;
    
    for (int i = 0; i< nCount ; i++) {
        
        NSString* strLine = [pValidAy objectAtIndex:i];
        if (strLine == nil || [strLine length] < 1)
            continue;
        
        NSArray* pSubAy = [strLine componentsSeparatedByString:@"|"];
        if (pSubAy == NULL || [pSubAy count] < 2)
            continue;
        
        NSString* nsName = [pSubAy objectAtIndex:0]; // 名字
        int nAction = [[pSubAy objectAtIndex:1] intValue]; // 功能号
        
        UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pBtn.tag = nAction;
        [pBtn setBackgroundImage:pImage forState:UIControlStateNormal];
        [pBtn setBackgroundImage:pImageSel forState:UIControlStateHighlighted];
        pBtn.titleLabel.font = tztUIBaseViewTextFont(15.0f);
        pBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [pBtn setTztTitle:nsName];
        [pBtn setTztTitleColor:[UIColor tztThemeTextColorButton]];
        pBtn.showsTouchWhenHighlighted = YES;
        [pBtn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
        pBtn.frame = rcFrame;
        [view addToolBar:pBtn];
        [view addSubview:pBtn];
        
        rcFrame.origin.x +=nWidth + nSpace;
    }
}
+(void)getTradeBottomItemByArray:(NSArray*)pAy target:(id)delegate withSEL:(SEL)sel forView : (tztBaseViewUIView *)view // 新版本底部操作样式配置 byDBQ20130718
{
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy
                                           target:delegate
                                          withSEL:sel
                                          forView:view
                                        BtnImage_:[UIImage imageTztNamed:@"TZTTabButtonBg.png"]
                                     btnSelImage_:[UIImage imageTztNamed:@"TZTTabButtonSelBg.png"]];    
}


+(void)getTradeBottomItemByArray:(NSArray*)pAy
                          target:(id)delegate
                         withSEL:(SEL)sel
                        forView : (UIView *)view
                         height_:(CGFloat)height
                          width_:(CGFloat)width
{
    NSMutableArray *pValidAy = [tztUIBarButtonItem GetValidButton:pAy];
    NSInteger nCount = pValidAy.count;
    
    if ([view respondsToSelector:@selector(removeAllToolBar)])
        [(id)view removeAllToolBar];
    if (height < 0)
        height = 49;
    
    CGRect rcBtn = CGRectZero;
    rcBtn.origin.y = view.frame.size.height-height;
    rcBtn.size.height = height;
    
    int nWidth = (width)/nCount;
    int nSpace = 0;
    
    
    CGRect rcFrame = rcBtn;
    rcFrame.origin.x += nSpace;
    rcFrame.origin.y += nSpace/2;
    rcFrame.size.height -= nSpace;
    rcFrame.size.width = nWidth;
    
    for (int i = 0; i< nCount ; i++) {
        
        NSString* strLine = [pValidAy objectAtIndex:i];
        if (strLine == nil || [strLine length] < 1)
            continue;
        
        NSArray* pSubAy = [strLine componentsSeparatedByString:@"|"];
        if (pSubAy == NULL || [pSubAy count] < 2)
            continue;
        
        NSString* strBtnImg = @"TZTTabButtonBg.png";
        
        if ([pSubAy count] > 2)
            strBtnImg = [pSubAy objectAtIndex:2];
        
        NSString* nsName = [pSubAy objectAtIndex:0]; // 名字
        int nAction = [[pSubAy objectAtIndex:1] intValue]; // 功能号
        
        UIButton *pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pBtn.tag = nAction;
        [pBtn setBackgroundImage:[UIImage imageTztNamed:strBtnImg] forState:UIControlStateNormal];
        pBtn.titleLabel.font = tztUIBaseViewTextFont(18.0f);
        pBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [pBtn setTztTitle:nsName];
        [pBtn setTztTitleColor:[UIColor tztThemeTextColorButton]];
        [pBtn addTarget:delegate action:sel forControlEvents:UIControlEventTouchUpInside];
        pBtn.frame = rcFrame;
        
        
        if ([pSubAy count] > 3)
        {
            NSString *strArrow = [pSubAy objectAtIndex:3];
            //计算位置
            CGSize sz = [nsName sizeWithFont:pBtn.titleLabel.font];
            UIImage *image = [UIImage imageTztNamed:strArrow];
            if (image && image.size.width > 0 && image.size.height > 0)
            {
                CGRect rc = pBtn.bounds;
                if (sz.width > 0)
                    rc.origin.x += (rc.size.width - sz.width) / 2 + sz.width-3;
                else
                    rc.origin.x += (rc.size.width - image.size.width) / 2;
                
                if (image.size.width >= (rc.size.width - sz.width) / 2)
                {
                    CGFloat s = (rc.size.width - sz.width) / 2;
                    rc.size = CGSizeMake(s, s);
                }
                else
                    rc.size = image.size;
                
                
                rc.origin.y += (pBtn.bounds.size.height - rc.size.height) / 2;
                
                UIImageView *pImage = [[UIImageView alloc] initWithFrame:rc];
                pImage.userInteractionEnabled = NO;
                pImage.tag = 0x6765;
                [pImage setImage:[UIImage imageTztNamed:strArrow]];
                [pBtn addSubview:pImage];
                [pImage release];
            }
        }
        
        
        if ([view respondsToSelector:@selector(addToolBar:)])
            [(id)view addToolBar:pBtn];
        [view addSubview:pBtn];
        
        rcFrame.origin.x +=nWidth + nSpace;
    }
}

+(void)getTradeBottomItemByArray:(NSArray*)pAy
                          target:(id)delegate
                         withSEL:(SEL)sel
                        forView : (UIView *)view
                         height_:(CGFloat)height
{
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy
                                           target:delegate
                                          withSEL:sel
                                          forView:view
                                          height_:height
                                           width_:view.frame.size.width];
}

@end
