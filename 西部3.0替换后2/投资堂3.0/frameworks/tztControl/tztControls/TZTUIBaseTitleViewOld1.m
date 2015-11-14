/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        标题显示view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseTitleView.h"
#define tztStockName    0x9876
#define tztStockCode    0x9875

#define tztStockImageIcon   0x9898
#define tztStockStatus      0x9899
#define tztStockStatusBack  0x9900

@interface TZTUIBaseTitleViewOld()

/*市场类型*/
@property(nonatomic)int  nStockType;
/*买卖状态 1-可买 2-可卖 3-可买卖 */
@property(nonatomic)int  nStatus;


-(void)DealWithReportTitle:(CGRect)rcFrame;
-(void)DealWithDetailTitle:(CGRect)rcFrame;
-(void)DealWithDefaultTitle:(CGRect)rcFrame;
-(void)DealSearchBar:(CGRect)rcFrame;
-(void)setFrame_iphone:(CGRect)frame;
-(void)DealWithReportTitle_iphone:(CGRect)rcFrame;
//详情标题，有股票切换功能
-(void)DealWithDetailTitle_iphone:(CGRect)rcFrame;
-(void)initdata;
@end

@implementation TZTUIBaseTitleViewOld
@synthesize nType = _nType;
@synthesize nsTitle = _nsTitle;
@synthesize pSearchBar = _pSearchBar;
@synthesize nLeftViewWidth = _nLeftViewWidth;
@synthesize nsStockName = _nsStockName;
@synthesize bShowSearchBar = _bShowSearchBar;
@synthesize bHasCloseBtn = _bHasCloseBtn;
@synthesize fourthBtn = _fourthBtn;
@synthesize firstBtn = _firstBtn;
@synthesize nsType = _nsType;
@synthesize titlelabel = _titlelabel;
-(id)initWithFrame:(CGRect)frame andType_:(int)nType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _nType = nType;
        [self initdata];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _nType = 0;
        [self initdata];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        _nType = 1;
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    self.nsType = @"";
    self.nsTitle = @"";
    self.pSearchBar = nil;
    _nLeftViewWidth = 0;
    self.nsStockCode = @"";
    self.nsStockName = @"";
    _bShowSearchBar = TRUE;
//    [self.layer setShadowOffset:CGSizeMake(0, 0.5)];
//    [self.layer setShadowColor:[UIColor darkTextColor].CGColor];
//    [self.layer setShadowOpacity:0.8];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    if(IS_TZTIPAD || self.nsType == nil || self.nsType.length <= 0)
    {
        [self setTitleFrame:frame];
    }
}

- (void)setTitleFrame:(CGRect)frame
{
    if (_bHasCloseBtn)
    {
        CGRect rcClose = self.bounds;
        if (IS_TZTIOS(7))
        {
            rcClose.origin.y += TZTStatuBarHeight;
            rcClose.size.height -= TZTStatuBarHeight;
        }
        rcClose.origin.x = self.bounds.size.width - 32;
        rcClose.origin.y += 6;
        rcClose.size = CGSizeMake(32, 32);
        UIButton *pBtnClose = (UIButton*)[self viewWithTag:TZTTitleBtnClose];
        if (pBtnClose == NULL)
        {
            pBtnClose = [UIButton buttonWithType:UIButtonTypeCustom];
            pBtnClose.frame = rcClose;
            pBtnClose.tag = TZTTitleBtnClose;
            pBtnClose.showsTouchWhenHighlighted = YES;
            pBtnClose.contentMode = UIViewContentModeCenter;
            [pBtnClose setTztImage:[UIImage imageTztNamed:@"TZTButtonClose.png"]];
            [pBtnClose addTarget:self action:@selector(OnBtnClose) forControlEvents:UIControlEventAllTouchEvents];
            [self addSubview:pBtnClose];
        }
        else
        {
            pBtnClose.frame = rcClose;
        }
    }
    
    if (!IS_TZTIPAD)
    {
        [self setFrame_iphone:self.bounds];
        UIButton *pBtnClose = (UIButton*)[self viewWithTag:TZTTitleBtnClose];
        if (pBtnClose)
        {
            [self bringSubviewToFront:pBtnClose];
        }
        return;
    }
    self.backgroundColor = [UIColor tztThemeBackgroundColorTitle];// [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTnavbarbg.png"]];
    [self setTitleType_iPad:_nType];
    UIButton *pBtnClose = (UIButton*)[self viewWithTag:TZTTitleBtnClose];
    if (pBtnClose)
    {
        [self bringSubviewToFront:pBtnClose];
    }
}

-(void)setTitle:(NSString*)nsTitle
{
    self.nsTitle = nsTitle;
    if (IS_TZTIPAD) //修改标题
    {
        //排名界面时候
        if (_leftTitlelabel == NULL || _leftTitlelabel.hidden)
        {
            if(_titlelabel)
            {
                _titlelabel.text = nsTitle;
            }
        }
        else
        {
            if(_leftTitlelabel)
            {
                _leftTitlelabel.text = nsTitle;
            }
        }
    }
    else
    {
        if ( (_nType == TZTTitlePic || _nType == TZTTitleHomePage) && _imageView)
        {
            UIImage *image =[UIImage imageTztNamed:@"TZTMainTitleEx.png"];
            if (image)
            {
                CGSize sz = image.size;
                CGRect rcFrame = _imageView.frame;
                _imageView.frame = CGRectMake(rcFrame.origin.x + (rcFrame.size.width - sz.width)/2, rcFrame.origin.y + (rcFrame.size.height - sz.height)/ 2, sz.width, sz.height);
                [_imageView setImage:image];
            }
        }
        
        NSArray *ay = [nsTitle componentsSeparatedByString:@"\\r\\n"];
        if ([ay count] >= 2 && _titlelabel != NULL)
        {
            
            UILabel *pLabelName = (UILabel*)[_titlelabel viewWithTag:tztStockName];
            if (pLabelName == nil)
            {
                pLabelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _titlelabel.frame.size.width, _titlelabel.frame.size.height * 2 / 3 )];
                pLabelName.backgroundColor = [UIColor clearColor];
                pLabelName.textAlignment = NSTextAlignmentCenter;
                pLabelName.adjustsFontSizeToFitWidth = YES;
                pLabelName.tag = tztStockName;
                pLabelName.textColor = [UIColor whiteColor];
                pLabelName.font = tztUIBaseViewTextFont(17.0f);
                [_titlelabel addSubview:pLabelName];
                [pLabelName release];
            }
            else
            {
                pLabelName.frame = CGRectMake(0, 0, _titlelabel.frame.size.width, _titlelabel.frame.size.height * 2 / 3 );
            }
            
            UILabel *pLabelCode = (UILabel*)[_titlelabel viewWithTag:tztStockCode];
            if (pLabelCode == nil)
            {
                pLabelCode = [[UILabel alloc] initWithFrame:CGRectMake(0, _titlelabel.frame.size.height *2 / 3, _titlelabel.frame.size.width, _titlelabel.frame.size.height / 3 )];
                pLabelCode.backgroundColor = [UIColor clearColor];
                pLabelCode.textAlignment = NSTextAlignmentCenter;
                pLabelCode.adjustsFontSizeToFitWidth = YES;
                pLabelCode.tag = tztStockCode;
                pLabelCode.textColor = [UIColor lightTextColor];
                pLabelCode.font = tztUIBaseViewTextFont(11.0f);
                [_titlelabel addSubview:pLabelCode];
                [pLabelCode release];
            }
            else
            {
                pLabelCode.frame = CGRectMake(0, _titlelabel.frame.size.height *2 / 3, _titlelabel.frame.size.width, _titlelabel.frame.size.height / 3 );
            }
            pLabelName.text = [NSString stringWithFormat:@"%@", [ay objectAtIndex:0]];
            pLabelCode.text = [NSString stringWithFormat:@"%@", [ay objectAtIndex:1]];
            pLabelName.hidden = NO;
            pLabelCode.hidden = NO;
        }
        else
        {
            if(_titlelabel)
            {
                _titlelabel.text = nsTitle;
            }
        }
    }
//    UILabel *pLabel = (UILabel*)[self viewWithTag:TZTTitleLabelTag];
//    if (pLabel)
//    {
//        pLabel.text = nsTitle;
//    }
}

-(void)DealWithReportTitle:(CGRect)rcFrame
{
    [self DealSearchBar:rcFrame];
    
    CGRect rcLabel = rcFrame;
    rcLabel.size.width = 150;
    rcLabel.size.height = 30;
    rcLabel.origin.x = (rcFrame.size.width - 150) / 2 + rcFrame.origin.x;
    rcLabel.origin.y = (rcFrame.size.height - 30) / 2 + rcFrame.origin.y;
    //居中标题
    UILabel *pLabel = (UILabel*)[self viewWithTag:TZTTitleLabelTag];
    if (pLabel == nil)
    {
        pLabel = [[UILabel alloc] initWithFrame:rcLabel];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.text = self.nsTitle;
        pLabel.textAlignment = NSTextAlignmentCenter;
        pLabel.textColor = [UIColor whiteColor];
        pLabel.tag = TZTTitleLabelTag;
        [self addSubview:pLabel];
        [pLabel release];
    }
    else
    {
        pLabel.frame = rcLabel;
    }
}

//详情标题，有股票切换功能
-(void)DealWithDetailTitle:(CGRect)rcFrame
{
    [self DealSearchBar:rcFrame];
    
    //若是自选，左侧还有编辑按钮
    CGRect rcEditBtn = rcFrame;
    rcEditBtn.origin.x += 5;
    rcEditBtn.size.width = 50;
    rcEditBtn.origin.y += 6;
    rcEditBtn.size.height = 32;
    if (_nType == TZTTitleDetail_User)
    {
        UIButton *pBtn = (UIButton*)[self viewWithTag:TZTTitleBtnEdit];
        if (pBtn == NULL)
        {
            pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            pBtn.frame = rcEditBtn;
            pBtn.tag = TZTTitleBtnEdit;
            [pBtn setTztBackgroundImage:[UIImage imageTztNamed:@"TZTNavButtonBG.png"]];
            [pBtn.titleLabel setFont:tztUIBaseViewTextFont(14.0f)];
            [pBtn setTztTitle:@"编辑"];
            [pBtn setTztTitleColor:[UIColor whiteColor]];
            [pBtn addTarget:self action:@selector(OnEditUserStock:) forControlEvents:UIControlEventTouchUpInside];
            pBtn.contentMode = UIViewContentModeCenter;
            pBtn.showsTouchWhenHighlighted = YES;
            [self addSubview:pBtn];
        }
        else
        {
            pBtn.frame = rcEditBtn;
        }
    }
    //左侧标题
    CGRect rcLeftTitle = rcFrame;
//    rcLeftTitle.origin.x += rcEditBtn.size.width;
    rcLeftTitle.size.width = _nLeftViewWidth;
    UILabel *pLabel = (UILabel*)[self viewWithTag:TZTTitleLabelTag];
    if (pLabel == NULL)
    {
        pLabel = [[UILabel alloc] initWithFrame:rcLeftTitle];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.text = self.nsTitle;
        pLabel.textAlignment = NSTextAlignmentCenter;
        pLabel.tag = TZTTitleLabelTag;
        pLabel.textColor = [UIColor whiteColor];
        [self addSubview:pLabel];
        [pLabel release];
    }
    else
    {
        pLabel.frame = rcLeftTitle;
    }
    
    //全屏按钮
    UIButton *pBtnFull = (UIButton*)[self viewWithTag:TZTTitleBtnFull];
    if (pBtnFull == NULL)
    {
        pBtnFull = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtnFull setShowsTouchWhenHighlighted:YES];
        [pBtnFull setContentMode:UIViewContentModeCenter];
        pBtnFull.tag = TZTTitleBtnFull;
        //增加事件
        if(_pDelegate)
            [pBtnFull addTarget:_pDelegate action:@selector(OnBtnFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pBtnFull];
    }
    CGRect rcFullScreen = rcLeftTitle;
    rcFullScreen.origin.x =  rcLeftTitle.origin.x + rcLeftTitle.size.width - 40;
    rcFullScreen.size.width = 44;
//    rcFullScreen.origin.y = rcLeftTitle.origin.y + (rcLeftTitle.size.height - 32) / 2;
    //加载全屏图片
    UIImage *pImage = [UIImage imageTztNamed:@"TZTFullScreenBtn.png"];
    if (pImage == NULL)//图片不存在，直接用颜色
    {
        pBtnFull.frame = rcFullScreen;
    }
    else
    {
        rcFullScreen.origin.x = rcLeftTitle.origin.x + rcLeftTitle.size.width - pImage.size.width - 10;
        rcFullScreen.origin.y = rcLeftTitle.origin.y + (rcLeftTitle.size.height - pImage.size.height) / 2;
        rcFullScreen.size = pImage.size;
        pBtnFull.frame = rcFullScreen;
    }
    [pBtnFull setImage:pImage forState:UIControlStateNormal];
    
    //中间是股票切换显示
    CGRect rcLabelStock = rcFrame;
    rcLabelStock.size.width = 200;
    rcLabelStock.size.height = 35;
    rcLabelStock.origin.x = (rcFrame.size.width - 200) / 2 + rcFrame.origin.x;
    rcLabelStock.origin.y = (rcFrame.size.height - 35) / 2 + rcFrame.origin.y;
    //居中标题
    UILabel *pLabelStock = (UILabel*)[self viewWithTag:TZTTitleStockTag];
    if (pLabelStock == nil)
    {
        pLabelStock = [[UILabel alloc] initWithFrame:rcLabelStock];
        pLabelStock.backgroundColor = [UIColor clearColor];
        pLabelStock.textAlignment = NSTextAlignmentCenter;
        pLabelStock.adjustsFontSizeToFitWidth = YES;
        pLabelStock.textColor = [UIColor whiteColor];
        pLabelStock.font = tztUIBaseViewTextBoldFont(18.0f);
        pLabelStock.tag = TZTTitleStockTag;
        [self addSubview:pLabelStock];
        [pLabelStock release];
    }
    else
    {
        pLabelStock.frame = rcLabelStock;
    }
    pLabelStock.text = [NSString stringWithFormat:@"%@ %@", self.nsStockName, self.nsStockCode];
    
    //左侧增加前一只股票切换按钮
    UIButton *pBtnPre = (UIButton*)[self viewWithTag:TZTTitleBtnPre];
    UIImage *pImagePre = [UIImage imageTztNamed:@"TZTArrow_Left.png"];
    CGRect rcBtnPre = rcLabelStock;
    rcBtnPre.origin.x -= pImagePre.size.width + 5;
    
    rcBtnPre.size.width = pImagePre.size.width * 2;
    
    if (pBtnPre == nil)
    {
        pBtnPre = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtnPre setShowsTouchWhenHighlighted:YES];
        [pBtnPre setContentMode:UIViewContentModeCenter];
        [pBtnPre setImage:pImagePre forState:UIControlStateNormal];
        pBtnPre.tag = TZTTitleBtnPre;
        if (_pDelegate)
            [pBtnPre addTarget:_pDelegate action:@selector(OnBtnPreStock:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pBtnPre];
    }
    pBtnPre.frame = rcBtnPre;
    
    //右侧加下一只股票切换按钮
    UIButton *pBtnNext = (UIButton*)[self viewWithTag:TZTTitleBtnNext];
    UIImage *pImageNext = [UIImage imageTztNamed:@"TZTArrow_Right.png"];
    CGRect rcBtnNext = rcLabelStock;
    rcBtnNext.origin.x += rcLabelStock.size.width /*+ pImageNext.size.width*/ + 5;
    rcBtnNext.size.width = pImageNext.size.width * 2;
    if (pBtnNext == nil)
    {
        pBtnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtnNext setShowsTouchWhenHighlighted:YES];
        [pBtnNext setContentMode:UIViewContentModeCenter];
        [pBtnNext setImage:pImageNext forState:UIControlStateNormal];
        pBtnNext.tag = TZTTitleBtnNext;
        if (_pDelegate)
            [pBtnNext addTarget:_pDelegate action:@selector(OnBtnNextStock:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pBtnNext];
    }
    pBtnNext.frame = rcBtnNext;
}

-(void)DealWithDefaultTitle:(CGRect)rcFrame
{
    rcFrame.origin.x += 20;
    UILabel *pLabel = (UILabel*)[self viewWithTag:TZTTitleLabelTag];
    if (pLabel == nil)
    {
        pLabel = [[UILabel alloc] initWithFrame:rcFrame];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.text = self.nsTitle;
        pLabel.textAlignment = NSTextAlignmentLeft;
        pLabel.tag = TZTTitleLabelTag;
        pLabel.textColor = [UIColor whiteColor];
        [self addSubview:pLabel];
        [pLabel release];
    }
    else
    {
        pLabel.frame = rcFrame;
    }
}

-(void)DealSearchBar:(CGRect)rcFrame
{
    if (!_bShowSearchBar)
        return;
    //最右侧的查询
    CGRect rcSearchBar = rcFrame;
    rcSearchBar.size.width = 160;
    rcSearchBar.size.height = 28;
    if (_bHasCloseBtn)
    {
        rcSearchBar.origin.x = rcFrame.size.width - 160 - 15 - 40;
    }
    else
    {
        rcSearchBar.origin.x = rcFrame.size.width - 160 - 15;
    }
    rcSearchBar.origin.y = (rcFrame.size.height - 28) / 2 + rcFrame.origin.y;
    if (self.pSearchBar == nil)
    {
        self.pSearchBar = [[[UISearchBar alloc] initWithFrame:rcSearchBar] autorelease];
		self.pSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
		self.pSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
		self.pSearchBar.placeholder = @"代码或拼音";
        self.pSearchBar.delegate = self;
//		self.pSearchBar.keyboardType =  UIKeyboardTypeDefault;
#ifdef __IPHONE_7_0
        if (IS_TZTIOS(7))
        {
            [self.pSearchBar setTintColor:[UIColor clearColor]];
            [self.pSearchBar setBarTintColor:[UIColor clearColor]];//zxl 20140109 背景设置函数用错了
            self.pSearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor]];
        }
        else
            [[self.pSearchBar.subviews objectAtIndex:0]removeFromSuperview];
#else
        [[self.pSearchBar.subviews objectAtIndex:0]removeFromSuperview];
#endif
        [self addSubview:self.pSearchBar];
    }
    else
    {
        self.pSearchBar.frame = rcSearchBar;
    }
}

-(void)setCurrentStockInfo:(NSString*)nsCode nsName_:(NSString*)nsName
{
    self.nsStockCode = nsCode;
    if (nsName && [nsName length] > 0)
    {
        NSArray* pAy = [nsName componentsSeparatedByString:@"."];
        if ([pAy count] > 1)
        {
            self.nsStockName = [NSString stringWithFormat:@"%@", [pAy objectAtIndex:1]];
        }
        else
        {
            self.nsStockName = [NSString stringWithFormat:@"%@", nsName];
        }
    }
//    self.nsStockName = nsName;
    [self setFrame:self.frame];//刷新下界面显示
}

-(void)setStockDetailInfo:(int)nStockType nStatus:(int)nStatus
{
    _nStockType = nStockType;
    _nStatus = nStatus;
    [self setFrame:self.frame];
}

- (void)setTitleType:(int)nType
{
    CGRect rcFrame = self.bounds;
    if(CGRectIsNull(rcFrame) || CGRectIsEmpty(rcFrame))
        return;
    if (IS_TZTIOS(7))
    {
        rcFrame.origin.y += TZTStatuBarHeight;
        rcFrame.size.height -= TZTStatuBarHeight;
    }
    int nFirstType = (nType & 0x000F);//问题 1 为什么要在这里 与运算
    
    if(nFirstType > 0)
    {
        if (_firstBtn == NULL)
        {
            _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _firstBtn.showsTouchWhenHighlighted = YES;
            [self addSubview:_firstBtn];
        }
        _firstBtn.hidden = NO;
    }
    
    switch (nFirstType)
    {
        case TZTTitleReturn:
        case TZTTitleLogo:
        {
            CGRect rcBtnBack = rcFrame;
            if (nFirstType != TZTTitleLogo)
                rcBtnBack.origin.x += 5;
            rcBtnBack.size = CGSizeMake(51, 30);
            UIImage* backimage = nil;
            if(nFirstType == TZTTitleReturn)
            {
                backimage = [UIImage imageTztNamed:@"TZTnavbarbackbg.png"];
            }
            else
            {
                if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0)
                    backimage = [UIImage imageTztNamed:@"TZTLogo+1.png"];
                else
                    backimage = [UIImage imageTztNamed:@"TZTLogo.png"];
            }
            if (backimage)
            {
                rcBtnBack.size = backimage.size;
                if(rcBtnBack.size.height > rcFrame.size.height)
                {
                    rcBtnBack.size.width = rcBtnBack.size.width * rcFrame.size.height / rcBtnBack.size.height;
                    rcBtnBack.size.height = rcFrame.size.height;
                }
            }
            rcBtnBack.origin.y += (rcFrame.size.height - rcBtnBack.size.height) / 2;
            //在这里设置title的字体和样式，背景
            [_firstBtn setBackgroundImage:backimage forState:UIControlStateNormal];
            [_firstBtn.titleLabel setFont:tztUIBaseViewTextFont(14.0f)];
            if(nFirstType == TZTTitleReturn)
            {
                _firstBtn.tag = TZTTitleBtnFull;
//                [_firstBtn setTztTitle:@"返回"];
                if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnReturnBack)])
                {
                    //问题2 先removetarget 什么意思，有什么意义
                    [_firstBtn removeTarget:_pDelegate action:NULL forControlEvents:UIControlEventAllEvents];
                    [_firstBtn addTarget:_pDelegate action:@selector(OnReturnBack) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            else
            {
                [_firstBtn removeTarget:_pDelegate action:NULL forControlEvents:UIControlEventAllEvents];
                [_firstBtn setTztTitle:@""];
                [_firstBtn addTarget:self action:@selector(OnContactUS:) forControlEvents:UIControlEventTouchUpInside];
            }
            _firstBtn.frame = rcBtnBack;
        }
            break;
        case TZTTitleEdit:
        {
            CGRect rcEditBtn = rcFrame;
            rcEditBtn.origin.x += 5;
            rcEditBtn.size.width = 50;
            rcEditBtn.origin.y += 6;
            rcEditBtn.size.height = 32;
            
            [_firstBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTNavButtonBG.png"] forState:UIControlStateNormal];
            [_firstBtn.titleLabel setFont:tztUIBaseViewTextFont(14.0f)];
            [_firstBtn setTztTitle:@"编辑"];
            [_firstBtn setTztTitleColor:[UIColor whiteColor]];
            [_firstBtn removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
            [_firstBtn removeTarget:_pDelegate action:NULL forControlEvents:UIControlEventAllEvents];
            [_firstBtn addTarget:self action:@selector(OnEditUserStock:) forControlEvents:UIControlEventTouchUpInside];
            _firstBtn.contentMode = UIViewContentModeCenter;
            _firstBtn.showsTouchWhenHighlighted = YES;
            _firstBtn.frame = rcEditBtn;
        }
            break;
        case TZTTitleMarket:
        {
            CGRect rcEditBtn = rcFrame;
            rcEditBtn.origin.x += 5;
            rcEditBtn.size.width = 50;
            rcEditBtn.origin.y += 6;
            rcEditBtn.size.height = 32;
            
            [_firstBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTNavButtonBG.png"] forState:UIControlStateNormal];
            [_firstBtn.titleLabel setFont:tztUIBaseViewTextFont(14.0f)];
            [_firstBtn setTztTitle:@"市场"];
            [_firstBtn setTztTitleColor:[UIColor whiteColor]];
            [_firstBtn addTarget:self action:@selector(OnReportMarket:) forControlEvents:UIControlEventTouchUpInside];
            _firstBtn.contentMode = UIViewContentModeCenter;
            _firstBtn.showsTouchWhenHighlighted = YES;
            _firstBtn.frame = rcEditBtn;
        }
            break;
        default:
        {
            _firstBtn.hidden = YES;
        }
            break;
    }
    
    int nTitleType = (nType & 0xF000);  //问题3 这边做什么
    
    if (nTitleType == TZTTitleImage)
    {
        if (_imageView == NULL) 
        {
            _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            [self addSubview:_imageView];
        }
        else
            _imageView.frame = self.bounds;
    }
    else
    {
        CGRect rcLabelStock = rcFrame;
        rcLabelStock.size.width = 140;
        rcLabelStock.size.height = 35;
        rcLabelStock.origin.x = (rcFrame.size.width - 140) / 2 + rcFrame.origin.x;
        rcLabelStock.origin.y = (rcFrame.size.height - 35) / 2 + rcFrame.origin.y;
        //居中标题
        if (_titlelabel == nil)
        {
            //在这里设置居中title的文字的样式和大小 颜色
            _titlelabel = [[UILabel alloc] initWithFrame:rcLabelStock];
            _titlelabel.backgroundColor = [UIColor clearColor];
            _titlelabel.textAlignment = NSTextAlignmentCenter;
            _titlelabel.adjustsFontSizeToFitWidth = YES;
            _titlelabel.textColor = [UIColor whiteColor];
            _titlelabel.font = tztUIBaseViewTextBoldFont(19.0f);
            [self addSubview:_titlelabel];
            [_titlelabel release];
        }
        else
        {
            _titlelabel.frame = rcLabelStock;
        }
        _titlelabel.hidden = NO;
        if(nTitleType == TZTTitleStock)
        {
            UILabel *pLabelName = (UILabel*)[_titlelabel viewWithTag:tztStockName];
            if (pLabelName == nil)
            {
                pLabelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _titlelabel.frame.size.width, _titlelabel.frame.size.height * 2 / 3 )];
                pLabelName.backgroundColor = [UIColor clearColor];
                pLabelName.textAlignment = NSTextAlignmentCenter;
                pLabelName.adjustsFontSizeToFitWidth = YES;
                pLabelName.tag = tztStockName;
                pLabelName.textColor = [UIColor whiteColor];
                pLabelName.font = tztUIBaseViewTextFont(17.0f);
                [_titlelabel addSubview:pLabelName];
                [pLabelName release];
            }
            else
            {
                pLabelName.frame = CGRectMake(0, 0, _titlelabel.frame.size.width, _titlelabel.frame.size.height * 2 / 3 );
            }
            
            //
            //
            int nIcoWidth = 0;
            int nStatusWidth = 0;
            NSString* strImageName = @"";
            if (_nStockType > 0)//显示市场类型图片
            {
#ifdef Support_HKTrade
                if (MakeHKMarket(_nStockType))
                {
                    strImageName = @"TZTHKIcon.png";
                    nIcoWidth = MIN(12,_titlelabel.frame.size.height / 3);
                }
                else
#endif
                {
                    if (_nStatus & 0xF000 || _nStatus & 0x0F00)
                    {
                        strImageName = @"TZTRZRQIcon.png";
                        nIcoWidth = MIN(12,_titlelabel.frame.size.height / 3);
                    }
                    _nStatus = 0;
                }
                
            }
            if (_nStatus > 0)//显示可买卖标示
                nStatusWidth = 30;
            UILabel *pLabelCode = (UILabel*)[_titlelabel viewWithTag:tztStockCode];
            
            UIFont *font = tztUIBaseViewTextFont(11.f);
            
            int nCodeWidth = [self.nsStockCode sizeWithFont:font].width;
            int nWidth = nCodeWidth;
            if (nIcoWidth > 0 || nStatusWidth > 0)
                nWidth = nCodeWidth + 5 + nIcoWidth + 5 + nStatusWidth;
    ///////DGZQ_2  修改标题居中问题
            CGRect rcCode = CGRectMake((_titlelabel.frame.size.width - nCodeWidth)/2, _titlelabel.frame.size.height *2 / 3, nCodeWidth, _titlelabel.frame.size.height / 3);

            
//            CGRect rcCode = CGRectMake((_titlelabel.frame.size.width - nWidth)/2 + nWidth, _titlelabel.frame.size.height *2 / 3, nCodeWidth, _titlelabel.frame.size.height / 3);
            if (pLabelCode == nil)
            {
                pLabelCode = [[UILabel alloc] initWithFrame:rcCode];
                pLabelCode.backgroundColor = [UIColor clearColor];
                pLabelCode.textAlignment = NSTextAlignmentCenter;
                pLabelCode.adjustsFontSizeToFitWidth = YES;
                pLabelCode.tag = tztStockCode;
                pLabelCode.textColor = [UIColor lightTextColor];
                pLabelCode.font = tztUIBaseViewTextFont(11.0f);
                [_titlelabel addSubview:pLabelCode];
                [pLabelCode release];
            }
            else
            {
                pLabelCode.frame = rcCode;
            }
            
            UIImageView *imageView = (UIImageView*)[_titlelabel viewWithTag:tztStockImageIcon];
            UILabel *pLabel = (UILabel*)[_titlelabel viewWithTag:tztStockStatus];
            UIView  *pViewBack = [_titlelabel viewWithTag:tztStockStatusBack];
            if (_nStockType > 0)
            {
                /*icon －港股，美股等显示相应图片*/
                CGRect rcImg = rcCode;
                rcImg.size = CGSizeMake(MIN(nIcoWidth,12), MIN(nIcoWidth, 9));
                rcImg.origin.x -= (nWidth + 5);
                rcImg.origin.y += (rcCode.size.height - rcImg.size.height)/2;
//                rcImg.size = CGSizeMake(nIcoWidth, nIcoWidth);
                
                if (imageView == NULL)
                {
                    imageView = [[UIImageView alloc] initWithFrame:rcImg];
                    imageView.tag = tztStockImageIcon;
                    [_titlelabel addSubview:imageView];
                    [imageView release];
                }
                else
                {
                    imageView.frame = rcImg;
                }
                [imageView setImage:[UIImage imageTztNamed:strImageName]];
                
                if (_nStatus > 0)
                {
                    /*可买卖标示*/
                    CGRect rcBuy = rcCode;
                    rcBuy.origin.x = rcImg.origin.x + rcImg.size.width + 5;
                    rcBuy.size.width = nStatusWidth;
                    rcBuy.size.height = rcImg.size.height;
                    rcBuy.origin.y = rcImg.origin.y;
                    
                    UIFont *drawfont = tztUIBaseViewTextBoldFont(9);
                    CGRect rcBuyEx = rcBuy;
                    rcBuyEx.origin.y += (rcBuyEx.size.height - drawfont.lineHeight) / 2;
                    if (pViewBack == NULL)
                    {
                        pViewBack = [[UIView alloc] initWithFrame:rcBuy];
                        pViewBack.tag = tztStockStatusBack;
                        pViewBack.backgroundColor = [UIColor colorWithTztRGBStr:@"241,63,75"];
                        [_titlelabel addSubview:pViewBack];
                        [pViewBack release];
                    }
                    else
                        pViewBack.frame = rcBuy;
                    
                    if (pLabel == NULL)
                    {
                        pLabel = [[UILabel alloc] initWithFrame:rcBuyEx];
                        pLabel.tag = tztStockStatus;
                        pLabel.layer.cornerRadius = 2;
                        pLabel.backgroundColor = [UIColor clearColor];
                        pLabel.adjustsFontSizeToFitWidth = YES;
                        pLabel.font = drawfont;
                        pLabel.textColor = [UIColor whiteColor];
                        pLabel.textAlignment = NSTextAlignmentCenter;
                        pLabel.text = @"可买卖";
                        [_titlelabel addSubview:pLabel];
                        [pLabel release];
                    }
                    else
                    {
                        pLabel.frame = rcBuyEx;
                    }
                    
                    if (_nStatus & 0x00FF)
                        pLabel.text = @"可买卖";
                    else if(_nStatus & 0x000F)
                        pLabel.text = @"可买";
                    else if (_nStatus & 0x00F0)
                        pLabel.text = @"可卖";
                    else if(_nStatus & 0xF00 || _nStatus & 0x0F00)
                        pLabel.text = @"";
                }
            }
            
            imageView.hidden = (_nStockType <= 0);
            pLabel.hidden = (_nStatus <= 0);
            pViewBack.hidden = pLabel.hidden;
            
            if ((self.nsStockName == NULL || [self.nsStockName length] < 1) &&
                (self.nsStockCode == NULL || [self.nsStockCode length] < 1))
            {
                _titlelabel.text = [NSString stringWithFormat:@"%@", self.nsTitle];
                pLabelName.hidden = YES;
                pLabelCode.hidden = YES;
                _titlelabel.hidden = NO;
            }
            else
            {
                pLabelName.text = [NSString stringWithFormat:@"%@", self.nsStockName];
                pLabelCode.text = [NSString stringWithFormat:@"%@", self.nsStockCode];
                pLabelName.hidden = NO;
                pLabelCode.hidden = NO;
            }
        }
        else
        {
            [self setTitleNormal];
        }
    }
    
    int nSecondType = (nType & 0x00F0);
    switch (nSecondType)
    {
        case TZTTitlePreNext:
        {
            //左侧增加前一只股票切换按钮
            CGRect rcBtnPre = _titlelabel.frame;
            UIButton *pBtnPre = (UIButton *)[self viewWithTag:TZTTitleBtnPre];
            if(pBtnPre == nil)
            {
                UIImage *pImagePre = [UIImage imageTztNamed:@"TZTArrow_Left.png"];
                rcBtnPre.size.width = pImagePre.size.width/* * 2*/;
                pBtnPre = [UIButton buttonWithType:UIButtonTypeCustom];
                [pBtnPre setImage:pImagePre forState:UIControlStateNormal];
                pBtnPre.tag = TZTTitleBtnPre;
                [pBtnPre setShowsTouchWhenHighlighted:YES];
                [self addSubview:pBtnPre];
            }
            else
            {
                rcBtnPre.size.width = pBtnPre.frame.size.width;
            }
            rcBtnPre.origin.x -= rcBtnPre.size.width ;
            pBtnPre.frame = rcBtnPre;
            
            if (_secondBtn == nil)
            {
                _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_secondBtn setShowsTouchWhenHighlighted:YES];
                [_secondBtn setContentMode:UIViewContentModeCenter];
                if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnBtnPreStock:)])
                {
                    [_secondBtn addTarget:_pDelegate action:@selector(OnBtnPreStock:) forControlEvents:UIControlEventTouchUpInside];
                    [pBtnPre addTarget:_pDelegate action:@selector(OnBtnPreStock:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self addSubview:_secondBtn];
            }
            rcBtnPre.size.width += _titlelabel.frame.size.width / 2;
            _secondBtn.frame = rcBtnPre;
            _secondBtn.hidden = NO;
            
            CGRect rcBtnNext = _titlelabel.frame;
            UIButton *pBtnNext = (UIButton *)[self viewWithTag:TZTTitleBtnNext];
            if(pBtnNext == nil)
            {
                UIImage *pImageNext = [UIImage imageTztNamed:@"TZTArrow_Right.png"];
                rcBtnNext.size.width = pImageNext.size.width/* * 2*/;
                pBtnNext = [UIButton buttonWithType:UIButtonTypeCustom];
                [pBtnNext setImage:pImageNext forState:UIControlStateNormal];
                [pBtnNext setShowsTouchWhenHighlighted:YES];
                pBtnNext.tag = TZTTitleBtnNext;
                [self addSubview:pBtnNext];
            }
            else
            {
                rcBtnNext.size.width = pBtnNext.frame.size.width;
            }
            rcBtnNext.origin.x += _titlelabel.frame.size.width ;
            pBtnNext.frame = rcBtnNext;
            
            if (_thirdBtn == nil)
            {
                _thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_thirdBtn setShowsTouchWhenHighlighted:YES];
                [_thirdBtn setContentMode:UIViewContentModeCenter];
                if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnBtnNextStock:)])
                {
                    [_thirdBtn addTarget:_pDelegate action:@selector(OnBtnNextStock:) forControlEvents:UIControlEventTouchUpInside];
                    [pBtnNext addTarget:_pDelegate action:@selector(OnBtnNextStock:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self addSubview:_thirdBtn];
            }
            rcBtnNext.size.width += _titlelabel.frame.size.width / 2;
            rcBtnNext.origin.x -= _titlelabel.frame.size.width / 2;
            _thirdBtn.frame = rcBtnNext;
            _thirdBtn.hidden = NO;
        }
            break;
        case TZTTitleEditor:
        {
            CGRect rcBtnNext = _titlelabel.frame;
            UIButton *pBtnNext = (UIButton *)[self viewWithTag:TZTTitleBtnNext];
            
            UIImage *pImageNext = [UIImage imageTztNamed:@"TZTEditUserStock.png"];
            if (pImageNext && pImageNext.size.height > 0)
            {
                rcBtnNext.origin.y += (rcBtnNext.size.height - pImageNext.size.height) / 2;
                rcBtnNext.size = pImageNext.size;
            }
            if(pBtnNext == nil)
            {
                
                rcBtnNext.size.width = pImageNext.size.width;
                pBtnNext = [UIButton buttonWithType:UIButtonTypeCustom];
                [pBtnNext setImage:pImageNext forState:UIControlStateNormal];
                [pBtnNext setShowsTouchWhenHighlighted:YES];
                pBtnNext.tag = TZTTitleBtnNext;
                [self addSubview:pBtnNext];
            }
            else
            {
                rcBtnNext.size.width = pBtnNext.frame.size.width;
            }
            
            if (g_pSystermConfig && g_pSystermConfig.bNSearchFunc)
                rcBtnNext.origin.x = rcFrame.size.width - rcBtnNext.size.width - 5;
            else
                rcBtnNext.origin.x += _titlelabel.frame.size.width - 15 ;
            pBtnNext.frame = rcBtnNext;
            if (_thirdBtn == nil)
            {
                _thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_thirdBtn setShowsTouchWhenHighlighted:YES];
                [_thirdBtn setContentMode:UIViewContentModeCenter];
                if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnBtnEditUserStock:)])
                {
                    [_thirdBtn addTarget:_pDelegate action:@selector(OnBtnEditUserStock:) forControlEvents:UIControlEventTouchUpInside];
                    [pBtnNext addTarget:_pDelegate action:@selector(OnBtnEditUserStock:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self addSubview:_thirdBtn];
            }
//            rcBtnNext.size.width += _titlelabel.frame.size.width / 2;
//            rcBtnNext.origin.x -= _titlelabel.frame.size.width / 2;
            _thirdBtn.frame = rcBtnNext;
            _thirdBtn.hidden = NO;
        }
            break;
        default:
        {
            if(_secondBtn)
            {
                _secondBtn.hidden = YES;
            }
            if(_thirdBtn)
            {
                _thirdBtn.hidden = YES;
            }
        }
            break;
    }
    
    
    int nFourtType = (nType & 0x0F00); //怎么通过这能够判断右边的title
    
    switch (nFourtType) 
    {
        case TZTTitleBack:
        {
            //右侧的查询
            CGRect rcSearch = rcFrame;
            rcSearch.size = CGSizeMake(48, 30);
            UIImage* image = nil;
            image = [UIImage imageTztNamed:@"TZTReturnBack.png"];
            
            if (image)
                rcSearch.size = image.size;
            
            rcSearch.origin.x = rcFrame.size.width - rcSearch.size.width - 5;
            rcSearch.origin.y = rcFrame.origin.y + (rcFrame.size.height - rcSearch.size.height) / 2;
            
            if (_fourthBtn == NULL)
            {
                _fourthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_fourthBtn setBackgroundImage:image forState:UIControlStateNormal];
                _fourthBtn.frame = rcSearch;
                _fourthBtn.showsTouchWhenHighlighted = YES;
                _fourthBtn.tag = HQ_MENU_SearchStock;
                
                if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnReturnBack)])
                    [_fourthBtn addTarget:_pDelegate action:@selector(OnReturnBack) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:_fourthBtn];
            }
            else
            {
                _fourthBtn.frame = rcSearch;
            }
            _fourthBtn.hidden = NO;
        }
            break;
        case TZTTitleSearch:
        {
            if (g_pSystermConfig.bNSearchFunc) {
                break;
            }
            //右侧的查询
            CGRect rcSearch = rcFrame;
            rcSearch.size = CGSizeMake(48, 30);
            UIImage* image = nil;
            if (nFourtType == TZTTitleAddBtn)
                image = [UIImage imageTztNamed:@"TZTAddButton.png"];
            else
                image = [UIImage imageTztNamed:@"TZTnavbarsearch.png"];
            
            if (image)
                rcSearch.size = image.size;
            
            rcSearch.origin.x = rcFrame.size.width - rcSearch.size.width - 5;
            rcSearch.origin.y = rcFrame.origin.y + (rcFrame.size.height - rcSearch.size.height) / 2;
            
            if (_fourthBtn == NULL)
            {
                _fourthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_fourthBtn setShowsTouchWhenHighlighted:YES];
                [_fourthBtn setBackgroundImage:image forState:UIControlStateNormal];
                _fourthBtn.frame = rcSearch;
                _fourthBtn.tag = HQ_MENU_SearchStock;
                if (nFourtType == TZTTitleSearch)
                    [_fourthBtn addTarget:self action:@selector(OnBtnSearch:) forControlEvents:UIControlEventTouchUpInside];
                else
                    [_fourthBtn addTarget:self action:@selector(OnBtnAddStock:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_fourthBtn];
            }
            else
            {
                _fourthBtn.frame = rcSearch;
            }
            _fourthBtn.hidden = NO;
        }
            break;
            
        //设置 TZTTitleSetButton 右边的的设置
        case TZTTitleSetBtn:
        {
            CGRect rcSearch = rcFrame;
            rcSearch.size = CGSizeMake(48, 30);
            UIImage* image = [UIImage imageTztNamed:@"TZTTabButtonBg.png"];
            rcSearch.origin.x = rcFrame.size.width - rcSearch.size.width - 5;
            rcSearch.origin.y = rcFrame.origin.y + (rcFrame.size.height - rcSearch.size.height) / 2;
            
            if (_fourthBtn)
            {
                [_fourthBtn removeFromSuperview];
                _fourthBtn = NULL;
            }
            
            if (_fourthBtn == NULL)
            {
                _fourthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_fourthBtn setShowsTouchWhenHighlighted:YES];
                [_fourthBtn setBackgroundImage:image forState:UIControlStateNormal];
                [_fourthBtn setTztTitle:@"设置"];
                _fourthBtn.frame = rcSearch;
                [_fourthBtn addTarget:self action:@selector(OnSetButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_fourthBtn];
            }
            else
            {
                _fourthBtn.frame = rcSearch;
            }
            _fourthBtn.hidden = NO;
        }
            break;
        case TZTTitleDKRYBtn:
        {
            CGRect rcSearch = rcFrame;
            rcSearch.size = CGSizeMake(45, 44);
            UIImage* image = [UIImage imageTztNamed:@"TZTFuncButtonBg.png"];
            rcSearch.origin.x = rcFrame.size.width - rcSearch.size.width - 5;
            rcSearch.origin.y = rcFrame.origin.y + (rcFrame.size.height - rcSearch.size.height) / 2;
            
            if (_fourthBtn)
            {
                [_fourthBtn removeFromSuperview];
                _fourthBtn = NULL;
            }
            
            if (_fourthBtn == NULL)
            {
                _fourthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_fourthBtn setShowsTouchWhenHighlighted:YES];
                [_fourthBtn setBackgroundImage:image forState:UIControlStateNormal];
                [_fourthBtn setTztTitle:@"功能"];
                _fourthBtn.titleLabel.font = tztUIBaseViewTextFont(13);
                _fourthBtn.frame = rcSearch;
                [_fourthBtn addTarget:self action:@selector(onFunction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_fourthBtn];
            }
            else
            {
                _fourthBtn.frame = rcSearch;
            }
            _fourthBtn.hidden = NO;
        }
            break;
        //zxl 20130719 添加右边用户信息按钮
        case TZTTitleUser:
        {
            CGRect rcUser = rcFrame;
            rcUser.size = CGSizeMake(48, 30);
            UIImage* image = nil;
            if (nFourtType == TZTTitleAddBtn)
                image = [UIImage imageTztNamed:@"TZTAddButton.png"];
            else
                image = [UIImage imageTztNamed:@"TZTNoAccount.png"];
            
            if (image)
                rcUser.size = image.size;
            
            rcUser.origin.x = rcFrame.size.width - rcUser.size.width - 5;
            rcUser.origin.y = rcFrame.origin.y + (rcFrame.size.height - rcUser.size.height) / 2;
            
            if (_fourthBtn == NULL)
            {
                _fourthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_fourthBtn setShowsTouchWhenHighlighted:YES];
                [_fourthBtn setBackgroundImage:image forState:UIControlStateNormal];
                _fourthBtn.frame = rcUser;
                [_fourthBtn.titleLabel setFont:tztUIBaseViewTextFont(14.0f)];
                if (nFourtType == TZTTitleUser)
                {
                    _fourthBtn.tag = HQ_MENU_UserInfo;
                    [_fourthBtn removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                    [_fourthBtn addTarget:self action:@selector(OnBtnUserInfo:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    [_fourthBtn removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
                    [_fourthBtn addTarget:self action:@selector(OnBtnAddStock:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self addSubview:_fourthBtn];
            }
            else
            {
                _fourthBtn.frame = rcUser;
            }
            _fourthBtn.hidden = NO;
        }
            break;
        default:
        {
            if(_fourthBtn)
                _fourthBtn.hidden = YES;
        }
            break;
    }
}

-(void)setTitleNormal
{
    NSArray *ay = [self.nsTitle componentsSeparatedByString:@"\\r\\n"];
    if ([ay count] >= 2 && _titlelabel != NULL)
    {
        
        UILabel *pLabelName = (UILabel*)[_titlelabel viewWithTag:tztStockName];
        if (pLabelName == nil)
        {
            pLabelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _titlelabel.frame.size.width, _titlelabel.frame.size.height * 2 / 3 )];
            pLabelName.backgroundColor = [UIColor clearColor];
            pLabelName.textAlignment = NSTextAlignmentCenter;
            pLabelName.adjustsFontSizeToFitWidth = YES;
            pLabelName.tag = tztStockName;
            pLabelName.textColor = [UIColor whiteColor];
            pLabelName.font = tztUIBaseViewTextFont(17.0f);
            [_titlelabel addSubview:pLabelName];
            [pLabelName release];
        }
        else
        {
            pLabelName.frame = CGRectMake(0, 0, _titlelabel.frame.size.width, _titlelabel.frame.size.height * 2 / 3 );
        }
        
        UILabel *pLabelCode = (UILabel*)[_titlelabel viewWithTag:tztStockCode];
        if (pLabelCode == nil)
        {
            pLabelCode = [[UILabel alloc] initWithFrame:CGRectMake(0, _titlelabel.frame.size.height *2 / 3, _titlelabel.frame.size.width, _titlelabel.frame.size.height / 3 )];
            pLabelCode.backgroundColor = [UIColor clearColor];
            pLabelCode.textAlignment = NSTextAlignmentCenter;
            pLabelCode.adjustsFontSizeToFitWidth = YES;
            pLabelCode.tag = tztStockCode;
            pLabelCode.textColor = [UIColor lightTextColor];
            pLabelCode.font = tztUIBaseViewTextFont(11.0f);
            [_titlelabel addSubview:pLabelCode];
            [pLabelCode release];
        }
        else
        {
            pLabelCode.frame = CGRectMake(0, _titlelabel.frame.size.height *2 / 3, _titlelabel.frame.size.width, _titlelabel.frame.size.height / 3 );
        }
        pLabelName.text = [NSString stringWithFormat:@"%@", [ay objectAtIndex:0]];
        pLabelCode.text = [NSString stringWithFormat:@"%@", [ay objectAtIndex:1]];
        pLabelName.hidden = NO;
        pLabelCode.hidden = NO;
    }
    else
        _titlelabel.text = [NSString stringWithFormat:@"%@", self.nsTitle];
}

-(void)setTitleType_iPad:(int)nType
{
    CGRect rcFrame = self.bounds;
    if(CGRectIsNull(rcFrame) || CGRectIsEmpty(rcFrame))
        return;
    
    if (IS_TZTIOS(7))
    {
        rcFrame.origin.y += TZTStatuBarHeight;
        rcFrame.size.height -= TZTStatuBarHeight;
    }
    int nFirstType = (nType & 0x000F);
    if(nFirstType > 0)
    {
        if (_firstBtn == NULL)
        {
            _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:_firstBtn];
        }
        _firstBtn.hidden = NO;
    }
    
    CGRect rcFirst = rcFrame;
    rcFirst.origin.x = 5;
    rcFirst.origin.y += 6;
    rcFirst.size = CGSizeMake(51, 30);
    switch (nFirstType)
    {
        case TZTTitleReturn:
        case TZTTitleLogo:
        {
            rcFirst.origin.y -= 6;
            UIImage* backimage = nil;
            if(nFirstType == TZTTitleReturn)
                backimage = [UIImage imageTztNamed:@"TZTnavbarbackbg.png"];
            else
                backimage = [UIImage imageTztNamed:@"TZTLogo.png"];
            if (backimage)
            {
                rcFirst.size = backimage.size;
            }
            rcFirst.origin.y += (rcFrame.size.height - rcFirst.size.height) / 2;
            
            [_firstBtn setBackgroundImage:backimage forState:UIControlStateNormal];
            if(nFirstType == TZTTitleReturn)
            {
                _firstBtn.tag = TZTTitleBtnFull;
//                [_firstBtn setTztTitle:@"返回"];
                if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnReturnBack)])
                    [_firstBtn addTarget:_pDelegate action:@selector(OnReturnBack) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [_firstBtn setTztTitle:@""];
                [_firstBtn addTarget:self action:@selector(OnContactUS:) forControlEvents:UIControlEventTouchUpInside];
            }
            _firstBtn.frame = rcFirst;
        }
            break;
        case TZTTitleEdit:
        {
            [_firstBtn setBackgroundImage:[UIImage imageTztNamed:@"TZTNavButtonBG.png"] forState:UIControlStateNormal];
            [_firstBtn.titleLabel setFont:tztUIBaseViewTextFont(14.0f)];
            [_firstBtn setTztTitle:@"编辑"];
            [_firstBtn setTztTitleColor:[UIColor whiteColor]];
            [_firstBtn addTarget:self action:@selector(OnEditUserStock:) forControlEvents:UIControlEventTouchUpInside];
            _firstBtn.contentMode = UIViewContentModeCenter;
            _firstBtn.showsTouchWhenHighlighted = YES;
            _firstBtn.frame = rcFirst;
        }
            break;
        default:
        {
            if (_firstBtn)
                _firstBtn.hidden = YES;
        }
            break;
    }
    
    //左侧标题
    CGRect rcLeftTitle = rcFrame;
//    rcLeftTitle.origin.x += rcFirst.size.width;
    rcLeftTitle.size.width = _nLeftViewWidth;
    if (_leftTitlelabel == NULL && _nLeftViewWidth > 0)
    {
        _leftTitlelabel = [[UILabel alloc] initWithFrame:rcLeftTitle];
        //_leftTitlelabel = [[UILabel alloc] initWithFrame:rcLeftTitle];
        _leftTitlelabel.backgroundColor = [UIColor clearColor];
        _leftTitlelabel.text = self.nsTitle;
        _leftTitlelabel.textAlignment = NSTextAlignmentCenter;
        _leftTitlelabel.textColor = [UIColor whiteColor];
        [self addSubview:_leftTitlelabel];
        [_leftTitlelabel release];
    }
    else
    {
        _leftTitlelabel.frame = rcLeftTitle;
    }
    _leftTitlelabel.hidden = NO;
    _leftTitlelabel.text = [NSString stringWithFormat:@"%@", self.nsTitle];
    
    int nFullType = (nType & 0xF0000);
    if (nFullType > 0)
    {
        if (_fullBtn == NULL)
        {
            _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:_fullBtn];
        }
        _fullBtn.hidden = NO;
    }
    //全屏按钮
    switch (nFullType)
    {
        case TZTTitleFull:
        {
            [_fullBtn setShowsTouchWhenHighlighted:YES];
            [_fullBtn setContentMode:UIViewContentModeCenter];
            //增加事件
            if(_pDelegate)
                [_fullBtn addTarget:_pDelegate action:@selector(OnBtnFullScreen:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_fullBtn];
            
            CGRect rcFullScreen = rcLeftTitle;
            rcFullScreen.origin.x =  rcLeftTitle.origin.x + rcLeftTitle.size.width - 40;
            rcFullScreen.size.width = 44;
            //加载全屏图片
            UIImage *pImage = [UIImage imageTztNamed:@"TZTFullScreenBtn.png"];
            if (pImage == nil)
            {
                _fullBtn.frame = rcFullScreen;
            }
            else
            {
                rcFullScreen.origin.x = rcLeftTitle.origin.x + rcLeftTitle.size.width - pImage.size.width - 10;
                rcFullScreen.origin.y = rcLeftTitle.origin.y + (rcLeftTitle.size.height - pImage.size.height) / 2;
                rcFullScreen.size = pImage.size;
                _fullBtn.frame = rcFullScreen;
            }
            [_fullBtn setImage:pImage forState:UIControlStateNormal];
            _fullBtn.frame = rcFullScreen;
            _fullBtn.hidden = NO;
        }
            break;
            
        default:
        {
            //左边按钮和标题 一起不显示
            if (_fullBtn)
                _fullBtn.hidden = YES;
            _leftTitlelabel.hidden = YES;
        }
            break;
    }
    
    int nTitleType = (nType & 0xF000);
    CGRect rcLabelStock = rcFrame;
    rcLabelStock.size.width = 160;
    rcLabelStock.size.height = 35;
    rcLabelStock.origin.x = (rcFrame.size.width - 160) / 2 + rcFrame.origin.x;
    rcLabelStock.origin.y = (rcFrame.size.height - 35) / 2 + rcFrame.origin.y;
    //中间是股票切换显示
    switch (nTitleType)
    {
        case TZTTitleStock:
        case TZTTitleNormal:
        {
            //居中标题
            if (_titlelabel == nil)
            {
                _titlelabel = [[UILabel alloc] initWithFrame:rcLabelStock];
                _titlelabel.backgroundColor = [UIColor clearColor];
                _titlelabel.textAlignment = NSTextAlignmentCenter;
                _titlelabel.adjustsFontSizeToFitWidth = YES;
                _titlelabel.textColor = [UIColor whiteColor];
                _titlelabel.font = tztUIBaseViewTextBoldFont(18.0f);
                [self addSubview:_titlelabel];
                [_titlelabel release];
            }
            else
            {
                _titlelabel.frame = rcLabelStock;
            }
            _titlelabel.hidden = NO;
            if(nTitleType == TZTTitleStock)
            {
                if ((self.nsStockName == NULL || [self.nsStockName length] < 1) &&
                    (self.nsStockCode == NULL || [self.nsStockCode length] < 1))
                {
                    _titlelabel.text = [NSString stringWithFormat:@"%@", self.nsTitle];
                }
                else
                {
                    _titlelabel.text = [NSString stringWithFormat:@"%@ %@", self.nsStockName, self.nsStockCode];
                }
            }
            else
                _titlelabel.text = [NSString stringWithFormat:@"%@", self.nsTitle];
        }
            break;
        default:
        {
            if(_titlelabel)
                _titlelabel.hidden = YES;
        }
            break;
    }
    
    int nSecondType = (nType & 0x00F0);
    switch (nSecondType)
    {
        case TZTTitlePreNext:
        {
            //左侧增加前一只股票切换按钮
            UIImage *pImagePre = [UIImage imageTztNamed:@"TZTArrow_Left.png"];
            CGRect rcBtnPre = _titlelabel.frame;
            rcBtnPre.origin.x -= pImagePre.size.width + 5;
            rcBtnPre.size.width = pImagePre.size.width * 2;
            
            if (_secondBtn == nil)
            {
                _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_secondBtn setShowsTouchWhenHighlighted:YES];
                [_secondBtn setContentMode:UIViewContentModeCenter];
                [_secondBtn setImage:pImagePre forState:UIControlStateNormal];
                if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnBtnPreStock:)])
                    [_secondBtn addTarget:_pDelegate action:@selector(OnBtnPreStock:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_secondBtn];
            }
            _secondBtn.frame = rcBtnPre;
            _secondBtn.hidden = NO;
            //右侧加下一只股票切换按钮
            UIImage *pImageNext = [UIImage imageTztNamed:@"TZTArrow_Right.png"];
            CGRect rcBtnNext = _titlelabel.frame;
            rcBtnNext.origin.x += rcBtnNext.size.width /*+ pImageNext.size.width*/ + 5;
            rcBtnNext.size.width = pImageNext.size.width * 2;
            if (_thirdBtn == nil)
            {
                _thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_thirdBtn setShowsTouchWhenHighlighted:YES];
                [_thirdBtn setContentMode:UIViewContentModeCenter];
                [_thirdBtn setImage:pImageNext forState:UIControlStateNormal];
                if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnBtnNextStock:)])
                    [_thirdBtn addTarget:_pDelegate action:@selector(OnBtnNextStock:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_thirdBtn];
            }
            _thirdBtn.frame = rcBtnNext;
            _thirdBtn.hidden = NO;
        }
            break;
        default:
        {
            if(_secondBtn)
            {
                _secondBtn.hidden = YES;
            }
            if(_thirdBtn)
            {
                _thirdBtn.hidden = YES;
            }
        }
            break;
    }
    
    
    int nFourtType = (nType & 0x0F00);
    switch (nFourtType)
    {
        case TZTTitleSearch:
        case TZTTitleAddBtn:
        {
            if (!_bShowSearchBar)
                return;
            //右侧的查询
            CGRect rcSearch = rcFrame;
            //rcSearch.size = CGSizeMake(48, 30);
            rcSearch.size.width = 160;
            rcSearch.size.height = 28;
            if (_bHasCloseBtn)
            {
                rcSearch.origin.x = rcFrame.size.width - 160 - 15 - 40;
            }
            else
            {
                rcSearch.origin.x = rcFrame.size.width - 160 - 15;
            }
            rcSearch.origin.y = (rcFrame.size.height - 28) / 2 + rcFrame.origin.y;
            
            if (self.pSearchBar == nil)
            {
                self.pSearchBar = [[[UISearchBar alloc] initWithFrame:rcSearch] autorelease];
                self.pSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
                self.pSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
                self.pSearchBar.placeholder = @"代码或拼音";
                self.pSearchBar.delegate = self;
                //self.pSearchBar.keyboardType =  UIKeyboardTypeDefault;
#ifdef __IPHONE_7_0
                if (IS_TZTIOS(7))
                {
                    self.pSearchBar.translucent = YES;
                    [self.pSearchBar setTintColor:[UIColor clearColor]];
                    [self.pSearchBar setBarTintColor:[UIColor clearColor]];//zxl 20140109 背景设置函数用错了
                    self.pSearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor]];
                }
                else
                    [[self.pSearchBar.subviews objectAtIndex:0]removeFromSuperview];
#else
                [[self.pSearchBar.subviews objectAtIndex:0]removeFromSuperview];
#endif
                [self addSubview:self.pSearchBar];
            }
            else
            {
                self.pSearchBar.frame = rcSearch;
            }
            self.pSearchBar.hidden = NO;
        }
            break;
        default:
        {
            if (self.pSearchBar && _bShowSearchBar)
                self.pSearchBar.hidden = NO;
            else
                self.pSearchBar.hidden = YES;
        }
            break;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)setNType:(int)nType
{
    _nType = nType;
    if (IS_TZTIPAD)
    {
        //[self setTitleType:_nType];
        [self setTitleType_iPad:_nType];
        return;
    }
    //获取界面所有控件
    
    //全屏按钮
    UIButton *pBtnFull = (UIButton*)[self viewWithTag:TZTTitleBtnFull];
//    UILabel *pLabel = (UILabel*)[self viewWithTag:TZTTitleLabelTag];    //居中标题
    UILabel *pLabelStock = (UILabel*)[self viewWithTag:TZTTitleStockTag];
    //左侧增加前一只股票切换按钮
    UIButton *pBtnPre = (UIButton*)[self viewWithTag:TZTTitleBtnPre];
    UIButton *pBtnNext = (UIButton*)[self viewWithTag:TZTTitleBtnNext];
    //
    UIButton *pBtnEdit = (UIButton*)[self viewWithTag:TZTTitleBtnEdit];
    switch (_nType)
    {
        case TZTTitleTrendNew:
        {
            pBtnFull.hidden = YES;
            pLabelStock.hidden = NO;
            pBtnNext.hidden = YES;
            pBtnPre.hidden = YES;
            pBtnEdit.hidden = YES;
        }
            break;
        case TZTTitleReport:
        {
            pBtnFull.hidden = YES;
            pLabelStock.hidden = YES;
            pBtnNext.hidden = YES;
            pBtnPre.hidden = YES;
            pBtnEdit.hidden = YES;
        }
            break;
        case TZTTitleDetail:
        {
            pBtnFull.hidden = NO;
            pLabelStock.hidden = NO;
            pBtnNext.hidden = NO;
            pBtnPre.hidden = NO;
            pBtnEdit.hidden = YES;
        }
            break;
        case TZTTitleDetail_User:
        {
            pBtnFull.hidden = NO;
            pLabelStock.hidden = NO;
            pBtnNext.hidden = NO;
            pBtnPre.hidden = NO;
            pBtnEdit.hidden = NO;
        }
            break;
        case TZTTitleDKRY:
        {
            pBtnFull.hidden = YES;
            pLabelStock.hidden = YES;
            pBtnNext.hidden = YES;
            pBtnPre.hidden = YES;
            pBtnEdit.hidden = YES;
        }
            
        default:
            break;
    }
}


//iphone标题设置
-(void)setFrame_iphone:(CGRect)frame
{
    //背景图
    self.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
//    UIImage* image = [UIImage imageTztNamed:@"TZTnavbarbg.png"];
//    if (image != NULL)
//        self.backgroundColor = [UIColor colorWithPatternImage:image];
//    else
//        self.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
    [self setTitleType:_nType];
//    switch (_nType)
//    {
//        default://默认
//        case TZTTitleReport://左侧返回，中间标题，右侧查询
//        case TZTTitleIcon://左侧图标，中间标题
//        case TZTTitleAdd:
//        {
//            [self DealWithReportTitle_iphone:frame];
//        }
//            break;
//        case TZTTitleDetail://左侧返回，中间股票代码名称，右侧查询
//        {
//            [self DealWithDetailTitle_iphone:frame];
//        }
//            break;
//    }
}


-(void)DealWithReportTitle_iphone:(CGRect)rcFrame
{
    CGRect rcBtnBack = rcFrame;
    rcBtnBack.origin.x += 5;
    rcBtnBack.size = CGSizeMake(51, 30);
    
    UIImage *image = [UIImage imageTztNamed:@"TZTnavbarbackbg.png"];
    
    if (_nType == TZTTitleIcon)
    {
        image = [UIImage imageTztNamed:@"TZTLogo.png"];
    }
    if (image)
    {
        rcBtnBack.size = image.size;
    }
    rcBtnBack.origin.y += (rcFrame.size.height - rcBtnBack.size.height) / 2;
    
    UIButton *pBtn = (UIButton*)[self viewWithTag:TZTTitleBtnFull];
    if (pBtn == NULL)
    {
        pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtn setBackgroundImage:image forState:UIControlStateNormal];
        pBtn.frame = rcBtnBack;
        pBtn.tag = TZTTitleBtnFull;
        if (_nType != TZTTitleIcon)
        {
//            [pBtn setTztTitle:@"返回"];
            if (_pDelegate)
                [pBtn addTarget:_pDelegate action:@selector(OnReturnBack) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:pBtn];
    }
    else
    {
        pBtn.frame = rcBtnBack;
    }
    
    CGRect rcLabel = rcFrame;
    rcLabel.size.width = 150;
    rcLabel.size.height = 30;
    rcLabel.origin.x = (rcFrame.size.width - 150) / 2 + rcFrame.origin.x;
    rcLabel.origin.y = (rcFrame.size.height - 30) / 2 + rcFrame.origin.y;
    //居中标题
    UILabel *pLabel = (UILabel*)[self viewWithTag:TZTTitleLabelTag];
    if (pLabel == nil)
    {
        pLabel = [[UILabel alloc] initWithFrame:rcLabel];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.text = self.nsTitle;
        pLabel.textAlignment = NSTextAlignmentCenter;
        pLabel.textColor = [UIColor whiteColor];
        pLabel.adjustsFontSizeToFitWidth = YES;
        pLabel.font = tztUIBaseViewTextBoldFont(18.0f);
        pLabel.tag = TZTTitleLabelTag;
        [self addSubview:pLabel];
        [pLabel release];
    }
    else
    {
        pLabel.frame = rcLabel;
    }
    
    if (!_bShowSearchBar)
        return;
    //右侧的查询
    CGRect rcSearch = rcFrame;
    rcSearch.size = CGSizeMake(48, 30);
    
    if (_nType == TZTTitleAdd)
    {
        image = [UIImage imageTztNamed:@"TZTAddButton.png"];
    }
    else
    {
        image = [UIImage imageTztNamed:@"TZTnavbarsearch.png"];
    }
    if (image)
        rcSearch.size = image.size;
    
    rcSearch.origin.x = rcFrame.size.width - rcSearch.size.width - 5;
    rcSearch.origin.y = rcFrame.origin.y + (rcFrame.size.height - rcSearch.size.height) / 2;
    
    UIButton *pSearch = (UIButton*)[self viewWithTag:HQ_MENU_SearchStock];
    if (pSearch == NULL)
    {
        pSearch = [UIButton buttonWithType:UIButtonTypeCustom];
        pSearch.tag = HQ_MENU_SearchStock;
        [pSearch setBackgroundImage:image forState:UIControlStateNormal];
        pSearch.frame = rcSearch;
        
        if (_nType == TZTTitleAdd)
        {
            if (_pDelegate)
                [pSearch addTarget:_pDelegate action:@selector(OnBtnAddStock:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [pSearch addTarget:self action:@selector(OnBtnSearch:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:pSearch];
    }
    else
    {
        pSearch.frame = rcSearch;
    }
}

//详情标题，有股票切换功能
-(void)DealWithDetailTitle_iphone:(CGRect)rcFrame
{
    CGRect rcBtnBack = rcFrame;
    rcBtnBack.origin.x += 5;
    rcBtnBack.size = CGSizeMake(51, 30);
    
    UIImage *image = [UIImage imageTztNamed:@"TZTnavbarbackbg.png"];
    
    if (_nType == TZTTitleIcon)
    {
        image = [UIImage imageTztNamed:@"TZTLogo.png"];
    }
    if (image)
    {
        rcBtnBack.size = image.size;
    }
    rcBtnBack.origin.y += (rcFrame.size.height - rcBtnBack.size.height) / 2;
    
    UIButton *pBtn = (UIButton*)[self viewWithTag:TZTTitleBtnFull];
    if (pBtn == NULL)
    {
        pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [pBtn setBackgroundImage:image forState:UIControlStateNormal];
        pBtn.frame = rcBtnBack;
        pBtn.tag = TZTTitleBtnFull;
        if (_nType != TZTTitleIcon)
        {
//            [pBtn setTztTitle:@"返回"];
            if (_pDelegate)
                [pBtn addTarget:_pDelegate action:@selector(OnReturnBack) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:pBtn];
    }
    else
    {
        pBtn.frame = rcBtnBack;
    }
    
    if (_nType == TZTTitleDetail)
    {
        //中间是股票切换显示
        CGRect rcLabelStock = rcFrame;
        rcLabelStock.size.width = 160;
        rcLabelStock.size.height = 35;
        rcLabelStock.origin.x = (rcFrame.size.width - 160) / 2 + rcFrame.origin.x;
        rcLabelStock.origin.y = (rcFrame.size.height - 35) / 2 + rcFrame.origin.y;
        //居中标题
        UILabel *pLabelStock = (UILabel*)[self viewWithTag:TZTTitleStockTag];
        if (pLabelStock == nil)
        {
            pLabelStock = [[UILabel alloc] initWithFrame:rcLabelStock];
            pLabelStock.backgroundColor = [UIColor clearColor];
            pLabelStock.textAlignment = NSTextAlignmentCenter;
            pLabelStock.adjustsFontSizeToFitWidth = YES;
            pLabelStock.textColor = [UIColor whiteColor];
            pLabelStock.font = tztUIBaseViewTextBoldFont(19.0f);
            pLabelStock.tag = TZTTitleStockTag;
            [self addSubview:pLabelStock];
            [pLabelStock release];
        }
        else
        {
            pLabelStock.frame = rcLabelStock;
        }
        pLabelStock.text = [NSString stringWithFormat:@"%@ %@", self.nsStockName, self.nsStockCode];
        
        //左侧增加前一只股票切换按钮
        UIButton *pBtnPre = (UIButton*)[self viewWithTag:TZTTitleBtnPre];
        UIImage *pImagePre = [UIImage imageTztNamed:@"TZTArrow_Left.png"];
        CGRect rcBtnPre = rcLabelStock;
        rcBtnPre.origin.x -= pImagePre.size.width + 5;
        
        rcBtnPre.size.width = pImagePre.size.width * 2;
        
        if (pBtnPre == nil)
        {
            pBtnPre = [UIButton buttonWithType:UIButtonTypeCustom];
            [pBtnPre setShowsTouchWhenHighlighted:YES];
            [pBtnPre setContentMode:UIViewContentModeCenter];
            [pBtnPre setImage:pImagePre forState:UIControlStateNormal];
            pBtnPre.tag = TZTTitleBtnPre;
            if (_pDelegate)
                [pBtnPre addTarget:_pDelegate action:@selector(OnBtnPreStock:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:pBtnPre];
        }
        pBtnPre.frame = rcBtnPre;
        
        //右侧加下一只股票切换按钮
        UIButton *pBtnNext = (UIButton*)[self viewWithTag:TZTTitleBtnNext];
        UIImage *pImageNext = [UIImage imageTztNamed:@"TZTArrow_Right.png"];
        CGRect rcBtnNext = rcLabelStock;
        rcBtnNext.origin.x += rcLabelStock.size.width /*+ pImageNext.size.width*/ + 5;
        rcBtnNext.size.width = pImageNext.size.width * 2;
        if (pBtnNext == nil)
        {
            pBtnNext = [UIButton buttonWithType:UIButtonTypeCustom];
            [pBtnNext setShowsTouchWhenHighlighted:YES];
            [pBtnNext setContentMode:UIViewContentModeCenter];
            [pBtnNext setImage:pImageNext forState:UIControlStateNormal];
            pBtnNext.tag = TZTTitleBtnNext;
            if (_pDelegate)
                [pBtnNext addTarget:_pDelegate action:@selector(OnBtnNextStock:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:pBtnNext];
        }
        pBtnNext.frame = rcBtnNext;
    }
    
    if (!_bShowSearchBar)
        return;
    //右侧的查询
    CGRect rcSearch = rcFrame;
    rcSearch.size = CGSizeMake(48, 30);
    
    image = [UIImage imageTztNamed:@"TZTnavbarsearch.png"];
    if (image)
        rcSearch.size = image.size;
    
    rcSearch.origin.x = rcFrame.size.width - rcSearch.size.width - 5;
    rcSearch.origin.y = rcFrame.origin.y + (rcFrame.size.height - rcSearch.size.height) / 2;
    
    UIButton *pSearch = (UIButton*)[self viewWithTag:HQ_MENU_SearchStock];
    if (pSearch == NULL)
    {
        pSearch = [UIButton buttonWithType:UIButtonTypeCustom];
        pSearch.tag = HQ_MENU_SearchStock;
        [pSearch setBackgroundImage:image forState:UIControlStateNormal];
        pSearch.frame = rcSearch;
        [pSearch addTarget:self action:@selector(OnBtnSearch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pSearch];
    }
    else
    {
        pSearch.frame = rcSearch;
    }

}

//
-(void)OnSetButton:(id)sender
{
    if (!IS_TZTIPAD)
    {
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnSetButton:)])
        {
            [_pDelegate OnSetButton:sender];
        }
    }
}

-(void)onFunction:(id)sender
{
    if (!IS_TZTIPAD)
    {
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnToolbarMenuClick:)])
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = MENU_JY_DKRY_List;
            [_pDelegate tztperformSelector:@"OnToolbarMenuClick:" withObject:btn];
        }
//        [TZTUIBaseVCMsg OnMsg:MENU_JY_DKRY_List wParam:0 lParam:0];
    }
}

//编辑自选
-(void)OnEditUserStock:(id)sender
{
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnToolbarMenuClick:)])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = HQ_MENU_EditUserStock;
        [_pDelegate tztperformSelector:@"OnToolbarMenuClick:" withObject:btn];
    }
//    [TZTUIBaseVCMsg OnMsg:HQ_MENU_EditUserStock wParam:0 lParam:0];
}

//市场类型选择
-(void)OnReportMarket:(id)sender
{
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnToolbarMenuClick:)])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = HQ_MENU_MarketMenu;
        [_pDelegate tztperformSelector:@"OnToolbarMenuClick:" withObject:btn];
    }
//    [TZTUIBaseVCMsg OnMsg:HQ_MENU_MarketMenu wParam:0 lParam:0];
}

-(void)OnBtnSearch:(id)sender
{
    if (!IS_TZTIPAD)
    {
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnToolbarMenuClick:)])
        {
            [_pDelegate tztperformSelector:@"OnToolbarMenuClick:" withObject:sender];
        }
//        
//        if (_pDelegate && [_pDelegate isKindOfClass:[TZTUIBaseViewController class]])
//        {
//            [(TZTUIBaseViewController*)_pDelegate OnToolbarMenuClick:sender];
//        }
//        else
//        {
//            [TZTUIBaseVCMsg OnMsg:HQ_MENU_SearchStock wParam:0 lParam:0];
//        }
    }
}
/*函数功能：用户信息按钮响应函数
 入参：按钮
 出参：无
 */
-(void)OnBtnUserInfo:(id)sender
{
    if (!IS_TZTIPAD)
    {
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnToolbarMenuClick:)])
        {
            [_pDelegate tztperformSelector:@"OnToolbarMenuClick:" withObject:sender];
        }
//        if (_pDelegate && [_pDelegate isKindOfClass:[TZTUIBaseViewController class]])
//        {
//            [(TZTUIBaseViewController*)_pDelegate OnToolbarMenuClick:sender];
//        }
    }
}

-(void)OnBtnAddStock:(id)sender
{
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnBtnAddStock:)])
    {
        [_pDelegate OnBtnAddStock:sender];
    }
}

-(void)OnBtnClose
{
    if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(OnBtnClose)])
    {
        [self.pDelegate tztperformSelector:@"OnBtnClose"];
    }
}

-(void)OnContactUS:(id)sender
{
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnContactUS:)])
    {
        [_pDelegate OnContactUS:sender];
    }
    else
    {
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnToolbarMenuClick:)])
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = Sys_Menu_Contact;
            [_pDelegate tztperformSelector:@"OnToolbarMenuClick:" withObject:btn];
        }
        
//        [TZTUIBaseVCMsg OnMsg:Sys_Menu_Contact wParam:(NSUInteger)sender lParam:0];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnToolbarMenuClick:)])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = HQ_MENU_SearchStock;
        [_pDelegate tztperformSelector:@"OnIpadSearchStock:" withObject:searchBar];
    }
//    [TZTUIBaseVCMsg OnMsg:HQ_MENU_SearchStock wParam:(NSUInteger)searchBar lParam:0];
    return NO;
}

@end







