//
//  tztUIBaseTitleViewNew.m
//  tztMobileApp_HTSC
//
//  Created by yangares on 13-12-15.
//
//

#import "TZTUIBaseTitleView.h"
@interface TZTUIBaseTitleView ()
{
    NSDictionary* _dicttitle;
    UIButton* _preHideBtn; //不可见前一个按钮
    UIButton* _nextHideBtn; //不可见后一个按钮
    UIView  * _pSepLineView1;
    UIView  * _pSepLineView2;
}
@property (nonatomic,retain) NSDictionary* dicttitle;
@property (nonatomic,retain) UIView     * pSepLineView1;
@property (nonatomic,retain) UIView     * pSepLineView2;
@end

@implementation TZTUIBaseTitleView
@synthesize dicttitle = _dicttitle;
@synthesize firstTitleBtn = _firstTitleBtn;
@synthesize secondTitleBtn = _secondTitleBtn;
@synthesize preTitleBtn = _preTitleBtn;
@synthesize nextTitleBtn = _nextTitleBtn;
@synthesize titleImage = _titleImage;
@synthesize titleLab = _titleLab;
@synthesize topLab = _topLab;
@synthesize bottomLab = _bottomLab;
@synthesize pSepLineView1 = _pSepLineView1;
@synthesize pSepLineView2 = _pSepLineView2;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self inittitledata];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self inittitledata];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self inittitledata];
    }
    return self;
}

- (void)inittitledata
{
    self.dicttitle = GetDictByListName(@"tztUINavTitleSetting");
    //    self.nsType = @"10|09|00|09|00";
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (IS_TZTIPAD)
    {
        return;
    }
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTnavbarbg.png"]];
    if(self.nsType && [self.nsType length] > 0)//没有设置nsType不处理新类型
        [self setNewTitleView];
    
}

- (void)setNewTitleView
{
    if (IS_TZTIPAD) //IPAD不处理新类型
    {
        return;
    }
    if(self.nsType == nil || [self.nsType length] <= 0)
    {
        self.nsType = @"10|09|00|09|00"; //返回|无|通用标题|无|个股搜索|
    }
    NSArray* ayType = [self.nsType componentsSeparatedByString:@"|"];
    NSString* strfirsttype = ([ayType count] > 0 ? [ayType objectAtIndex:0] : @"10" );
    NSString* strPretype = ([ayType count] > 1 ? [ayType objectAtIndex:1] : @"09" );
    NSString* strTitletype = ([ayType count] > 2 ? [ayType objectAtIndex:2] : @"00" );
    NSString* strNexttype = ([ayType count] > 3 ? [ayType objectAtIndex:3] : @"09" );
    NSString* strSecondtype = ([ayType count] > 4 ? [ayType objectAtIndex:4] : @"00" );
    if(strfirsttype.length <= 0)
    {
        strfirsttype = @"10";
    }
    
    if(strPretype.length <= 0)
    {
        strPretype = @"09";
    }
    
    if(strTitletype.length <= 0)
    {
        strTitletype = @"00";
    }
    
    if(strNexttype.length <= 0)
    {
        strNexttype = @"09";
    }
    
    if(strSecondtype.length <= 0)
    {
        strSecondtype = @"00";
    }
    //处理左侧按钮
    if([self setTitleBtnView:[NSString stringWithFormat:@"%@",strfirsttype] with:0])
    {
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnReturnBack)])
            [_firstTitleBtn addTarget:_pDelegate action:@selector(OnReturnBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //处理右侧按钮
    if([self setTitleBtnView:[NSString stringWithFormat:@"%@",strSecondtype] with:1])
    {
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnBtnSearch:)])
            [_secondTitleBtn addTarget:_pDelegate action:@selector(OnBtnSearch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //处理左侧第2按钮 （默认前一股票）
    if([self setTitleBtnView:[NSString stringWithFormat:@"%@",strPretype] with:2])
    {
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnBtnPreStock:)])
        {
            if(_preHideBtn == NULL)
            {
                _preHideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_preHideBtn setShowsTouchWhenHighlighted:YES];
                [_preHideBtn setContentMode:UIViewContentModeCenter];
                _preHideBtn.userInteractionEnabled = NO;
                [self addSubview:_preHideBtn];
                [_preHideBtn addTarget:_pDelegate action:@selector(OnBtnPreStock:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [_preTitleBtn addTarget:_pDelegate action:@selector(OnBtnPreStock:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //处理右侧第2按钮 (默认后一股票)
    if([self setTitleBtnView:[NSString stringWithFormat:@"%@",strNexttype] with:3])
    {
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnBtnNextStock:)])
        {
            if(_nextHideBtn == NULL)
            {
                _nextHideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_nextHideBtn setShowsTouchWhenHighlighted:YES];
                [_nextHideBtn setContentMode:UIViewContentModeCenter];
                _nextHideBtn.userInteractionEnabled = NO;
                [self addSubview:_nextHideBtn];
                [_nextHideBtn addTarget:_pDelegate action:@selector(OnBtnNextStock:) forControlEvents:UIControlEventTouchUpInside];
            }
            [_nextTitleBtn addTarget:_pDelegate action:@selector(OnBtnNextStock:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //设置title
    [self setTitleTitleView:[NSString stringWithFormat:@"%@",strTitletype]];
    [self setTitleViewFrame];
}

- (void)setTitleViewFrame
{
    CGRect frame = self.bounds;
    if(_firstTitleBtn && (!_firstTitleBtn.hidden))
    {
        CGFloat fHeight = _firstTitleBtn.frame.size.height;
        CGFloat fWidth = _firstTitleBtn.frame.size.width;
        CGFloat fTop = (frame.size.height - fHeight) / 2.0f;
        [_firstTitleBtn setFrame:CGRectMake(2, fTop, fWidth, fHeight)];
    }
    
    if(_secondTitleBtn && (!_secondTitleBtn.hidden))
    {
        CGFloat fHeight = _secondTitleBtn.frame.size.height;
        CGFloat fWidth = _secondTitleBtn.frame.size.width;
        CGFloat fTop = (frame.size.height - fHeight) / 2.0f;
        [_secondTitleBtn setFrame:CGRectMake(frame.size.width - 2 - fWidth, fTop, fWidth, fHeight)];
    }
    
    if(_preTitleBtn && (!_preTitleBtn.hidden))
    {
        CGFloat fHeight = _preTitleBtn.frame.size.height;
        CGFloat fWidth = _preTitleBtn.frame.size.width;
        CGFloat fTop = (frame.size.height - fHeight) / 2.0f;
        [_preTitleBtn setFrame:CGRectMake(CGRectGetMaxX(_firstTitleBtn.frame) + 10, fTop, fWidth, fHeight)];
        [_preHideBtn setFrame:CGRectMake(CGRectGetMaxX(_firstTitleBtn.frame) + 5, 0,frame.size.width / 2 -  (CGRectGetMaxX(_firstTitleBtn.frame) + 5), frame.size.height)];
        
    }
    
    if(_nextTitleBtn && (!_nextTitleBtn.hidden))
    {
        CGFloat fHeight = _preTitleBtn.frame.size.height;
        CGFloat fWidth = _preTitleBtn.frame.size.width;
        CGFloat fTop = (frame.size.height - fHeight) / 2.0f;
        [_nextTitleBtn setFrame:CGRectMake(CGRectGetMinX(_secondTitleBtn.frame) - 10 - fWidth, fTop, fWidth, fHeight)];
        
        [_nextHideBtn setFrame:CGRectMake(frame.size.width / 2, 0,CGRectGetMinX(_secondTitleBtn.frame) - frame.size.width / 2, frame.size.height)];
    }
    
    if(_titleLab)
    {
        CGFloat fx = MAX(CGRectGetMaxX(_firstTitleBtn.frame),CGRectGetMaxX(_preTitleBtn.frame));
        CGFloat fheight = 35;
        CGFloat fTop = (frame.size.height - fheight)/ 2.0f;
        [_titleLab setFrame:CGRectMake(fx, fTop, frame.size.width - fx*2, fheight)];
        if(_topLab)
        {
            [_topLab setFrame:CGRectMake(0, 0, _titleLab.frame.size.width, fheight * 2 / 3)];
        }
        
        if(_bottomLab)
        {
            [_bottomLab setFrame:CGRectMake(0, fheight * 2 / 3, _titleLab.frame.size.width, fheight / 3)];
        }
    }
    
    if(_titleImage)
    {
        CGFloat fx = MAX(CGRectGetMaxX(_firstTitleBtn.frame),CGRectGetMaxX(_preTitleBtn.frame));
        CGFloat fheight = frame.size.height;
        [_titleImage setFrame:CGRectMake(fx, 0, frame.size.width - fx*2, fheight)];
    }
}

//设置标题
- (void)setTitleTitleView:(NSString*)strType
{
    if(_titleLab == NULL)
    {
        _titleLab = NewObject(UILabel);
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.adjustsFontSizeToFitWidth = YES;
        _titleLab.tag = [strType intValue];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.font = tztUIBaseViewTextFont(17.0f);
        
        [self addSubview:_titleLab];
        [_titleLab release];
        
        if(_topLab == NULL)
        {
            _topLab = NewObject(UILabel);
            _topLab.backgroundColor = [UIColor clearColor];
            _topLab.textAlignment = NSTextAlignmentCenter;
            _topLab.adjustsFontSizeToFitWidth = YES;
            _topLab.textColor = [UIColor whiteColor];
            _topLab.font = tztUIBaseViewTextFont(17.0f);
            [_titleLab addSubview:_topLab];
            [_topLab release];
        }
        
        if(_bottomLab == NULL)
        {
            _bottomLab = NewObject(UILabel);
            _bottomLab.backgroundColor = [UIColor clearColor];
            _bottomLab.textAlignment = NSTextAlignmentCenter;
            _bottomLab.adjustsFontSizeToFitWidth = YES;
            _bottomLab.textColor = [UIColor lightTextColor];
            _bottomLab.font = tztUIBaseViewTextFont(11.0f);
            [_titleLab addSubview:_bottomLab];
            [_bottomLab release];
        }
    }
    switch ([strType intValue])
    {
        case 0://通用
        {
            _topLab.hidden = YES;
            _bottomLab.hidden = YES;
            _titleLab.hidden = NO;
            _preHideBtn.hidden = YES;
            _nextHideBtn.hidden = YES;
            _preHideBtn.userInteractionEnabled = NO;
            _nextHideBtn.userInteractionEnabled = NO;
        }
            break;
        case 1: //股票
        {
            _titleLab.hidden = NO;
            _topLab.hidden = NO;
            _bottomLab.hidden = NO;
        }
            break;
        case 2:
        {
            if(_titleLab)
            {
                _titleLab.hidden = YES;
            }
            
            if(_preHideBtn)
            {
                _preHideBtn.hidden = YES;
                _preHideBtn.userInteractionEnabled = NO;
            }
            
            if(_nextHideBtn)
            {
                _nextHideBtn.hidden = YES;
                _nextHideBtn.userInteractionEnabled = NO;
            }
            
            if (_titleImage == NULL)
            {
                _titleImage = NewObject(UIImageView);
                [self addSubview:_titleImage];
                [_titleImage release];
            }
        }
            break;
        default:
            break;
    }
}

//设置按钮
- (BOOL)setTitleBtnView:(NSString*)strType with:(int)nBtn
{
    BOOL bCreate = FALSE;
    UIButton* btn= nil;
    switch (nBtn)
    {
        case 0:
            btn = _firstTitleBtn;
            break;
        case 1:
            btn = _secondTitleBtn;
            break;
        case 2:
            btn = _preTitleBtn;
            break;
        case 3:
            btn = _nextTitleBtn;
            break;
        default:
            btn = _firstTitleBtn;
            break;
    }
    if(strType && [strType compare:@"09"] != NSOrderedSame)
    {
        NSDictionary* dictfirst = [self.dicttitle objectForKey:strType];
        NSString* strTitle = @"";
        NSString* strBkImage = @"";
        NSString* strImage = @"";
        if (dictfirst)
        {
            strTitle = [dictfirst objectForKey:@"title"];
            strBkImage = [dictfirst objectForKey:@"bkimage"];
            strImage = [dictfirst objectForKey:@"image"];
        }
        if(btn == NULL)
        {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setShowsTouchWhenHighlighted:YES];
            [btn setContentMode:UIViewContentModeCenter];
            [btn.titleLabel setFont:tztUIBaseViewTextFont(14.0f)];
            [btn setTztTitleColor:[UIColor whiteColor]];
            
            btn.tag = [strType intValue];
            [self addSubview:btn];
            bCreate = TRUE;
            switch (nBtn)
            {
                case 0:
                    self.firstTitleBtn = btn;
                    break;
                case 1:
                    self.secondTitleBtn = btn;
                    break;
                case 2:
                    self.preTitleBtn = btn;
                    break;
                case 3:
                    self.nextTitleBtn = btn;
                    break;
                default:
                    self.firstTitleBtn = btn;
                    break;
            }
            
        }
        btn.hidden = NO;
        if(strTitle && [strTitle length] > 0)
        {
            [btn setAllStateTitle:strTitle];
        }
        
        UIImage* image = nil;
        if(strImage && [strImage length] > 0)
        {
            image = [UIImage imageTztNamed:strImage];
            [btn setTztImage:image];
        }
        
        if(strBkImage && [strBkImage length] > 0)
        {
            image = [UIImage imageTztNamed:strBkImage];
            [btn setTztBackgroundImage:image];
        }
        
        CGRect frame = btn.frame;
        if(image)
        {
            CGFloat fDiv = (image.size.height > 44 ? 2.0f : 1.0f);
            frame.size.height = image.size.height / fDiv;
            frame.size.width = image.size.width / fDiv;
            [btn setFrame:frame];
        }
    }
    else
    {
        if(btn)
        {
            btn.frame = CGRectZero;
            btn.hidden = YES;
        }
    }
    return bCreate;
}

//设置通用标题
-(void)setTitle:(NSString*)nsTitle
{
//    XINLAN 防止iOS 8 又重新设置title 为什么iOS8又重新设置？
    
    if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
    {

        if([self.nsTitle isEqualToString:@"行情登录"])
            {
                return;
            }
    }
    if(IS_TZTIPAD || self.nsType == nil || [self.nsType length] <= 0)
    {
        [super setTitle:nsTitle];
        return;
    }
    
    if(_preHideBtn)
        _preHideBtn.userInteractionEnabled = NO;
    
    if(_nextHideBtn)
        _nextHideBtn.userInteractionEnabled = NO;
    
    if(_titleLab)
    {
        [_titleLab setText:nsTitle];
    }
}

//设置股票标题
-(void)setCurrentStockInfo:(NSString*)nsCode nsName_:(NSString*)nsName
{
    if(IS_TZTIPAD || self.nsType == nil || [self.nsType length] <= 0)
    {
        [super setCurrentStockInfo:nsCode nsName_:nsName];
        return;
    }
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
    
    if(_titlelabel)
    {
        _titlelabel.hidden = YES;
    }
    
    if(_preHideBtn)
    {
        _preHideBtn.hidden = NO;
        _preHideBtn.userInteractionEnabled = YES;
    }
    
    if (_nextHideBtn)
    {
        _nextHideBtn.hidden = NO;
        _nextHideBtn.userInteractionEnabled = YES;
    }
    
    if(_topLab)
    {
        _topLab.hidden = NO;
        [_topLab setText:self.nsStockName];
    }
    
    if(_bottomLab)
    {
        _bottomLab.hidden = NO;
        [_bottomLab setText:self.nsStockCode];
    }
}


//设置Image标题
-(void)setTitleWithImage:(UIImage*)image
{
    if(_preHideBtn)
    {
        _preHideBtn.hidden = YES;
        _preHideBtn.userInteractionEnabled = NO;
    }
    
    if(_nextHideBtn)
    {
        _nextHideBtn.hidden = YES;
        _nextHideBtn.userInteractionEnabled = NO;
    }
    
    if(_titleLab)
        _titleLab.hidden = YES;
    
    if(_titleImage)
    {
        [_titleImage setImage:image];
    }
}
@end
