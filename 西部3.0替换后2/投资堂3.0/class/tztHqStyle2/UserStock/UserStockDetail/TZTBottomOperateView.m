//
//  TZTBottomOperateView.m
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 5/5/14.
//
//

#import "TZTBottomOperateView.h"
#define BLUEColor [UIColor colorWithRed:56.0/255 green:117.0/255 blue:197.0/255 alpha:1.0]

#define tztButonTag 0x2234
#define tztBottomImageName    @"tztBottomImageName"
#define tztBottomImageSel     @"tztBottomImageSel"
#define tztBottomButtonView   @"tztBottomButtonView"

@interface tztBottomViewConfig : NSObject
@property(nonatomic,assign)CGFloat  fFixButtonWidth;
@property(nonatomic,retain)NSMutableArray   *ayButtons;
@property(nonatomic,retain)NSMutableArray   *ayButtonsRZRQ;

@property(nonatomic,retain)NSMutableDictionary   *dictButtonWithMarket;

+(tztBottomViewConfig*)getShareInstance;

@end

@implementation tztBottomViewConfig

+(tztBottomViewConfig*)getShareInstance
{
    static dispatch_once_t bottomViewConfigOnce;
    static tztBottomViewConfig *bottomViewConfig;
    dispatch_once(&bottomViewConfigOnce, ^{ bottomViewConfig = [[tztBottomViewConfig alloc] initWithConfig:@"tztBottomOperateConfig"];
    });
    return bottomViewConfig;
}

-(id)initWithConfig:(NSString *)nsFileName
{
    self = [self init];
    if (self)
    {
        _fFixButtonWidth = 0;
        _ayButtons = NewObject(NSMutableArray);
        _ayButtonsRZRQ = NewObject(NSMutableArray);
        _dictButtonWithMarket = NewObject(NSMutableDictionary);
        
        NSDictionary *dict = GetDictByListName(nsFileName);
        if (dict && dict.count > 0)
        {
            NSString* nsFixButtonWidth = [dict tztObjectForKey:@"fixbuttonwidth"];
            if (ISNSStringValid(nsFixButtonWidth))
                _fFixButtonWidth = [nsFixButtonWidth floatValue];
            
            NSArray* ay = [dict tztObjectForKey:@"buttons"];
            for (NSString* strData in ay)
                [_ayButtons addObject:strData];
            
            NSArray* ayRZRQ = [dict tztObjectForKey:@"buttonsrzrq"];
            for (NSString* strData in ayRZRQ)
                [_ayButtonsRZRQ addObject:strData];
        }
        else
        {
            [_ayButtons addObject:@"12310||tztQuickBuy.png|tztQuickBuyOn.png"];
            [_ayButtons addObject:@"12311||tztQuickSell.png|tztQuickSellOn.png"];
            
            [_ayButtonsRZRQ addObject:@"15010||tztQuickRZRQBuy.png|tztQuickRZRQBuyOn.png"];
            [_ayButtonsRZRQ addObject:@"15011||tztQuickRZRQSell.png|tztQuickRZRQSellOn.png"];
            
            BOOL bSupportWarning = FALSE;
            NSString* str = [g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_SupportWarning];
            if (str.length > 0)
                bSupportWarning = ([str intValue] > 0);
            if (bSupportWarning)
            {
                [_ayButtons addObject:@"10419||tztQuickWarning.png|tztQuickWarningOn.png"];
                [_ayButtonsRZRQ addObject:@"10419||tztQuickWarning.png|tztQuickWarningOn.png"];
            }
            
            BOOL bSupportRZRQ = FALSE;
            str = [g_pSystermConfig.pDict tztObjectForKey:tztSystermConfig_FenShiSupportRZRQ];
            if (str.length > 0)
                bSupportRZRQ = ([str intValue] > 0);
            if (bSupportRZRQ)
            {
                [_ayButtons addObject:@"77889||tztQuickSwitch.png|tztQuickSwitchOn.png"];
                [_ayButtonsRZRQ addObject:@"77889||tztQuickSwitchOn.png|tztQuickSwitch.png"];
            }
        }
    }
    return self;
}

@end

@interface TZTBottomOperateView()

@property (nonatomic, retain)NSMutableArray *ayButtonView;
@property (nonatomic, retain)UIButton *btnAddOrDel;
@property (nonatomic, assign)BOOL bAddUserStock;
@end

@implementation TZTBottomOperateView

@synthesize btnAddOrDel = _btnAddOrDel;
@synthesize tztDelegate = _tztDelegate;
@synthesize pStockInfo = _pStockInfo;
@synthesize ayButtonData = _ayButtonData;
@synthesize fFixButtonWidth = _fFixButtonWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // [UIColor colorWithRed:22.0/255 green:25.0/255 blue:30.0/255 alpha:1.0];
        _ayButtonData = NewObject(NSMutableArray);
        _ayButtonView = NewObject(NSMutableArray);
        _fFixButtonWidth = 0;
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [tztBottomViewConfig getShareInstance];
        _ayButtonData = NewObject(NSMutableArray);
        _ayButtonView = NewObject(NSMutableArray);
        _fFixButtonWidth = [tztBottomViewConfig getShareInstance].fFixButtonWidth;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tztChangeShow:)
                                                     name:@"TZTBottomChangeShow"
                                                   object:nil];
    }
    return self;
}

-(void)dealloc
{
    if (self.ayButtonData)
    {
        [self.ayButtonData removeAllObjects];
    }
    if (self.ayButtonView)
    {
        [self.ayButtonView removeAllObjects];
    }
    DelObject(_ayButtonView);
    DelObject(_ayButtonData);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorToolBarTrend];
    
    NSInteger nCount = [self.ayButtonData count];
    if (nCount < 1)
        return;
    float fWidth = self.bounds.size.width / nCount;
    if (_fFixButtonWidth > 0)
    {
        fWidth = (self.bounds.size.width - _fFixButtonWidth) / (nCount);
    }
    CGRect rcFrame = self.bounds;
    rcFrame.size.width = fWidth;
    
    for (int i = 0; i < [self.ayButtonView count]; i++)
    {
        NSDictionary *pDict = [self.ayButtonView objectAtIndex:i];
        UIButton* pBtn = [pDict objectForKey:tztBottomButtonView];
        NSString* strImage = [pDict objectForKey:tztBottomImageName];
        NSString* strImageSel = [pDict objectForKey:tztBottomImageSel];
        
        
        if (pBtn.tag == TZT_MENU_AddUserStock)//自选股操作，判断是否已经是自选
        {
            if (self.pStockInfo && self.pStockInfo.stockCode.length > 0)
            {
                if ([tztUserStock IndexUserStock:self.pStockInfo] >= 0)//
                {
                    if (strImageSel && strImageSel.length > 0)
                        strImage = strImageSel;
                }
            }
        }
        
        if (g_nThemeColor == 0)
            [pBtn setTztTitleColor:BLUEColor];
        else
            [pBtn setTztTitleColor:[UIColor whiteColor]];
        if (strImage.length > 0)
        {
            int nMargin = 0;
            UIImage *image = [UIImage imageTztNamed:strImage];
            if (image && image.size.width < fWidth)
            {
                rcFrame.size.width = image.size.width;
                nMargin = (fWidth - image.size.width ) / 2;
                rcFrame.origin.x += nMargin;
            }
            else
            {
                rcFrame.size.width = fWidth;
                nMargin = 0;// (fWidth - image.size.width ) / 2;
                rcFrame.origin.x += nMargin;
            }
            
//            [pBtn setBackgroundImage:[UIImage imageTztNamed:strImage] forState:UIControlStateNormal];
            
            UIImageView *imageView = (UIImageView*)[pBtn viewWithTag:0x9999];
            if (imageView)
            {
                [imageView setImage:[UIImage imageTztNamed:strImage]];
            }
            
            pBtn.frame = rcFrame;
            rcFrame.origin.x += (fWidth - nMargin);
        }
    }
}

-(void)setAyButtonData:(NSMutableArray *)ayData
{
    if (_ayButtonData == NULL)
        _ayButtonData = NewObject(NSMutableArray);
    
    [_ayButtonData removeAllObjects];
    [_ayButtonView removeAllObjects];
    
    for (int i = 0; i < [ayData count]; i++)
    {
        [_ayButtonData addObject:[ayData objectAtIndex:i]];
    }
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    NSInteger nCount = [self.ayButtonData count];
    //
    float fWidth = self.bounds.size.width / nCount;
    if (_fFixButtonWidth > 0)
    {
        fWidth = (self.bounds.size.width - _fFixButtonWidth) / (nCount-1);
    }
    CGRect rcFrame = self.bounds;
    rcFrame.size.width = fWidth;
    //功能号|标题|图片|
    for (int i = 0; i < nCount; i++)
    {
        NSString* strData = [self.ayButtonData objectAtIndex:i];
        if (strData.length < 1)
            continue;
        NSArray* ay = [strData componentsSeparatedByString:@"|"];
        if ([ay count] < 2)
            return;
        NSString* strFuncID = [ay objectAtIndex:0];
        NSString* strTitle  = [ay objectAtIndex:1];
        NSString* strImage = @"";
        if ([ay count] > 2)
            strImage  = [ay objectAtIndex:2];
        NSString* strImageSel = @"";
        if ([ay count] > 3)
            strImageSel = [ay objectAtIndex:3];
        
        UIButton *pBtn = (UIButton*)[self viewWithTag:[strFuncID intValue]];
        int nMargin = 0;
        if (pBtn == NULL)
        {
            pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pBtn.tag = [strFuncID intValue];
            pBtn.showsTouchWhenHighlighted = YES;
            pBtn.titleLabel.font = tztUIBaseViewTextFont(15);
            [pBtn addTarget:self
                     action:@selector(OnButtonClick:)
           forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:pBtn];
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setObject:strImage forKey:tztBottomImageName];
            if (strImageSel)
                [pDict setObject:strImageSel forKey:tztBottomImageSel];
            [pDict setObject:pBtn forKey:tztBottomButtonView];
            [self.ayButtonView addObject:pDict];
            DelObject(pDict);
            
            
//            if ([strFuncID intValue] == TZT_MENU_AddUserStock)
//                pBtn.backgroundColor = [UIColor colorWithTztRGBStr:@"243,170,62"];
//            else
                pBtn.backgroundColor = self.backgroundColor;
            
            
            UIImage *image = [UIImage imageTztNamed:strImage];
            if ([strFuncID intValue] == TZT_MENU_AddUserStock)//自选股操作，判断是否已经是自选
            {
                if (self.pStockInfo && self.pStockInfo.stockCode.length > 0)
                {
                    if ([tztUserStock IndexUserStock:self.pStockInfo] >= 0)//
                    {
                        if (strImageSel)
                            image = [UIImage imageTztNamed:strImageSel];
                    }
                }
            }
            
            if (image && (image.size.width < fWidth))
            {
                rcFrame.size.width = image.size.width;
                nMargin = (fWidth - image.size.width ) / 2;
                rcFrame.origin.x += nMargin;
            }
            else
            {
                rcFrame.size.width = fWidth;
                nMargin = 0;// (fWidth - image.size.width ) / 2;
                rcFrame.origin.x += nMargin;
            }
            
            CGRect rcImage = rcFrame;
            rcImage.origin.x = nMargin;
            UIImageView *imageView = (UIImageView*)[pBtn viewWithTag:0x9999];
            if (imageView == NULL)
            {
                imageView = [[UIImageView alloc] initWithFrame:rcImage];
                [imageView setImage:image];
                imageView.tag = 0x9999;
                [pBtn addSubview:imageView];
                [imageView release];
            }
            else
                imageView.frame = rcImage;
//            
//            [pBtn setBackgroundImage:[UIImage imageTztNamed:strImage] forState:UIControlStateNormal];
//            if (strImageSel)
//                [pBtn setBackgroundImage:[UIImage imageTztNamed:strImageSel] forState:UIControlStateHighlighted];
        }
        
        [pBtn setTztTitle:strTitle];
        
        if (g_nThemeColor == 0)
            [pBtn setTztTitleColor:BLUEColor];
        else
            [pBtn setTztTitleColor:[UIColor whiteColor]];
        
        
        if (_fFixButtonWidth > 0 && i == nCount - 1)//右对齐
        {
            rcFrame.size.width = _fFixButtonWidth;
        }
        
        pBtn.frame = rcFrame;
        rcFrame.origin.x += (fWidth - nMargin);
    }
}

-(void)OnButtonClick:(id)sender
{
    //判断sender的tag
    UIButton* btn = (UIButton*)sender;
    if (btn.tag == 77889)//融资融券切换按钮
    {
        //获取当前的处理
        int nMenuType = [tztTechSetting getInstance].nMenuType;
        if (nMenuType == 0)
            nMenuType = 1;
        else if (nMenuType == 1)
            nMenuType = 0;
        [tztTechSetting getInstance].nMenuType = nMenuType;
        [[tztTechSetting getInstance] SaveData];
        NSNotification* pNotifi = [NSNotification notificationWithName:@"TZTBottomChangeShow" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        return;
    }
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(OnBottomOperateButtonClick:)])
    {
        [self.tztDelegate OnBottomOperateButtonClick:sender];
    }
}

-(void)tztChangeShow:(NSNotification*)noti
{
    if ([noti.name compare:@"TZTBottomChangeShow"] != NSOrderedSame)
    {
        return;
    }
    int nMenuType = [tztTechSetting getInstance].nMenuType;
    //需要重新处理界面显示的。。。。
    NSMutableArray *ayData = NewObject(NSMutableArray);
    
    if (nMenuType == 1)//融资融券
    {
        for (NSInteger i = 0; i < [tztBottomViewConfig getShareInstance].ayButtonsRZRQ.count; i++)
        {
            [ayData addObject:[[tztBottomViewConfig getShareInstance].ayButtonsRZRQ objectAtIndex:i]];
        }
    }
    else
    {
        for (NSInteger i = 0; i < [tztBottomViewConfig getShareInstance].ayButtons.count; i++)
        {
            [ayData addObject:[[tztBottomViewConfig getShareInstance].ayButtons objectAtIndex:i]];
        }
    }
     for (int i = 0; i < [self.ayButtonView count]; i++)
     {
         NSDictionary *pDict = [self.ayButtonView objectAtIndex:i];
         UIView* pView = [pDict objectForKey:tztBottomButtonView];
         [pView removeFromSuperview];
     }
     self.ayButtonData = ayData;
     [self setFrame: self.frame];
    DelObject(ayData);
}

- (void)addOrDel:(id)sender
{
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(OnBottomOperateButtonClick:)])
    {
        [self.tztDelegate OnBottomOperateButtonClick:sender];
    }
    if (_btnAddOrDel == sender)
    {
        _btnAddOrDel.selected = !_btnAddOrDel.selected;
    }
}


- (void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    BOOL bUserStock = FALSE;
    BOOL bRefresh = TRUE;
    
    if(self.pStockInfo)
    {
        if (self.pStockInfo.stockType == pStockInfo.stockType)//市场类型相同
        {
            bRefresh = FALSE;
        }
        
        bUserStock = ([tztUserStock IndexUserStock:_pStockInfo] >= 0);//是否存在自选股中
        if (bUserStock != _bAddUserStock)
        {
            bRefresh = TRUE;
            _bAddUserStock = bUserStock;
        }
    }
    [_pStockInfo release];
    _pStockInfo = [pStockInfo retain];
    
    if (!bRefresh)
        return;
    NSMutableArray *ayData = NewObject(NSMutableArray);
    
#ifdef tzt_ZSSC
    for (NSInteger i = 0; i < [tztBottomViewConfig getShareInstance].ayButtons.count; i++)
    {
        if (MakeStockMarketStock(self.pStockInfo.stockType))
            [ayData addObject:[[tztBottomViewConfig getShareInstance].ayButtons objectAtIndex:i]];
        else
        {
            NSString* strData = [[tztBottomViewConfig getShareInstance].ayButtons objectAtIndex:i];
            NSArray* ay = [strData componentsSeparatedByString:@"|"];
            NSInteger nAction = 0;
            if (ay.count > 0)
                nAction = [[ay objectAtIndex:0] intValue];
            if (nAction != TZT_MENU_AddUserStock)
            {
                NSString* str = [NSString stringWithFormat:@"%ld| | | | | |", 0x7777+i];
                [ayData addObject:str];
            }
            else
            {
                [ayData addObject:strData];
            }
        }
    }
#else
    int nMenuType = [tztTechSetting getInstance].nMenuType;
    
    if (nMenuType == 1)//融资融券
    {
        for (NSInteger i = 0; i < [tztBottomViewConfig getShareInstance].ayButtonsRZRQ.count; i++)
        {
            [ayData addObject:[[tztBottomViewConfig getShareInstance].ayButtonsRZRQ objectAtIndex:i]];
        }
    }
    else
    {
        for (NSInteger i = 0; i < [tztBottomViewConfig getShareInstance].ayButtons.count; i++)
        {
            [ayData addObject:[[tztBottomViewConfig getShareInstance].ayButtons objectAtIndex:i]];
        }
    }
#endif
    if(bRefresh)
    {
        for (int i = 0; i < [self.ayButtonView count]; i++)
        {
            NSDictionary *pDict = [self.ayButtonView objectAtIndex:i];
            UIView* pView = [pDict objectForKey:tztBottomButtonView];
            [pView removeFromSuperview];
        }
        self.ayButtonData = ayData;
        [self setFrame: self.frame];
    }
    DelObject(ayData);
}

@end
