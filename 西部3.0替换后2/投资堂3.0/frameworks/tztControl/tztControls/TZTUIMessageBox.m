/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUIMessageBox.m
* 文件标识:
* 摘要说明:		自定义对话框控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/

#if TARGET_OS_IPHONE
#import <QuartzCore/QuartzCore.h>
#import "TZTUIMessageBox.h"

#define kBoxMargin 15.0				// Margin between the frame and the visible box. Shadow will be blurred double this value
#define kBoxShadowOffset 6.0		// offset downwards, adjust to kBoxMargin
#define kBorderWidth 2.0			// the width of the border around the box
#define kContentYPadding 5.0		// spacing between top and bottom border and the first and last textbox, respectively
#define kTitleHeight 44.0
#define kSingleRowHeight 44.0
#define kMinSingleRowHeight 44.0

int TZTMessageBoxCount = 0;

NSMutableArray* g_ayMessageBox = NULL;
//对话框显示位置
#define kTZTShowBottom 0
#define kUseDelayDisappear 0

@interface TZTUIMessageBox()
{
    UInt32      _nTitleAligment;    //标题居中方式    默认左对齐
    
    UInt32      _nSeperLineForBottom;//底部分割线     默认0
    NSString    *_nsBtnOK;          //确定按钮背景    默认tztButtonRed命名
    NSString    *_nsBtnOKTitleColor;//确定按钮字体颜色 默认（218，218，218）
    NSString    *_nsBtnCancel;      //取消按钮背景    默认tztDialogCancel命名
    NSString    *_nsBtnCancelTitleColor;//取消按钮背景色 默认黑色
    
    NSString    *_nsBackColor;      //背景颜色
    UIView      *_pBackView;
    
    CGFloat     _fBorderCornerRadius;
    BOOL        _bShowCancelLeft;
}
@property(nonatomic,retain)NSString     *nsBtnOKImg;
@property(nonatomic,retain)NSString     *nsBtnOKTitleColor;
@property(nonatomic,retain)NSString     *nsBtnCancelImg;
@property(nonatomic,retain)NSString     *nsBtnCancelTitleColor;
@property(nonatomic,retain)NSString     *nsBackColor;
@property(nonatomic,retain)UIView       *pBackView;
@property(nonatomic,retain)NSString     *nsTitleBackColor;

-(void) OnButtonClick:(id)sender;
-(void) CreateButton;
//-(CGRect)contentRect;
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end


@implementation TZTUIMessageBox
@synthesize m_nsTitle;
@synthesize m_nsContent;
@synthesize m_fRowHeight;
@synthesize m_nType;
@synthesize m_TitleFont;
@synthesize m_ContentFont;
@synthesize m_pTextView;
@synthesize m_pDelegate;
@synthesize m_tTimer;
@synthesize MacAlertView;
@synthesize bHasClose = _bHasClose;
@synthesize bDismiss = _bDismiss;
@synthesize blockcomple;
@synthesize panRecognizer = _panRecognizer;
@synthesize nsTitleBackColor = _nsTitleBackColor;

- (id)initWithFrame:(CGRect)frame 
{
	self = [super initWithFrame:frame];
    if (self) 
	{
        if (g_ayMessageBox == NULL)
            g_ayMessageBox = NewObject(NSMutableArray);
		//背景色
        if (TZTMessageBoxCount < 1)
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
		self.opaque = NO;
        _bDismiss = FALSE;
		//标题字体
		self.m_TitleFont = tztUIBaseViewTextBoldFont(22.0f);
		//内容字体
		self.m_ContentFont = tztUIBaseViewTextFont(15.0f);
		self.m_pTextView = nil;
		//默认标题文字
		self.m_nsTitle = [NSString stringWithFormat:@"%@", g_nsMessageBoxTitle];
		self.m_nsContent = @"";
		//默认没有按钮
		self.m_nType = TZTBoxTypeButtonBoth;
        self.blockcomple = nil;
		//默认按钮文字
		m_nsOK = [NSString stringWithFormat:@"确定"];
		m_nsCancel = [NSString stringWithFormat:@"取消"];
		//行高
		m_fRowHeight = 30;
        //
        _bHasClose = FALSE;
        if(!IS_TZTIPAD)
        {
//            UIDevice *device = [UIDevice currentDevice];
//            [device beginGeneratingDeviceOrientationNotifications];
//            
//            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//            [center addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:device];
        }
    }
    return self;
}

- (void)deviceOrientationChanged:(NSNotification *)notification
{
//    NSLog(@"%@", @"MessageBox = deviceOrientationChanged");
//    [self removeFromSuperview];
//    _bDismiss = TRUE;
}

//创建
-(id)initWithFrame:(CGRect)frame nBoxType_:(int)nBoxType delegate_:(id)delegate block:(void(^)(NSInteger))block
{
    self = [self initWithFrame:frame];
	if (self)
	{
		self.m_nType = nBoxType;
		self.m_pDelegate = delegate;
        self.blockcomple = block;
        if (!IS_TZTIPAD)
        {
            //添加手势处理，点击的时候让界面自动消失（有按钮的不处理）
            _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:nil];
            [self addGestureRecognizer:_panRecognizer];
            _panRecognizer.maximumNumberOfTouches = 1;
            _panRecognizer.delegate = self;
//            [_panRecognizer release];
        }
		//增加定时处理，定时消失提示对话框
	}
	return self;
}

//创建
-(id)initWithFrame:(CGRect)frame nBoxType_:(int)nBoxType delegate_:(id)delegate 
{
    return [self initWithFrame:frame nBoxType_:nBoxType delegate_:delegate block:nil];
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    NilObject(self.panRecognizer);
    DelObject(_panRecognizer);
    _bDismiss = TRUE;
	self.m_TitleFont = nil;
	self.m_ContentFont = nil;
	self.m_nsTitle = nil;
	self.m_nsContent = nil;
	self.m_pTextView = nil;
    self.blockcomple = nil;
    self.m_pDelegate = nil;
	if (self.m_tTimer)
	{
		[self.m_tTimer invalidate];
		self.m_tTimer = nil;
	}
    [super dealloc];
}

//设置按钮文字
-(void)setButtonText:(NSString*)nsOK cancel_:(NSString*)nsCancel
{
	m_nsOK = [NSString stringWithFormat:@"%@",nsOK];
	m_nsCancel = [NSString stringWithFormat:@"%@",nsCancel];
}

//创建对话框上的按钮
-(void)CreateButton
{	
	CGRect rc = self.m_pTextView.frame;
    //回调上层处理,包括标题字体，居中方式，指定按钮底图等
    NSMutableDictionary* pDict = NULL;
    if ([self respondsToSelector:@selector(tztMsgBoxSetProperties:)])
    {
        pDict = (NSMutableDictionary*)[self tztperformSelector:@"tztMsgBoxSetProperties:" withObject:self];
    }
    
    CGFloat fXMargin = 0;
    if (pDict)
    {
        fXMargin = [[pDict tztObjectForKey:tztMsgBoxXMargin] floatValue];
    }
    rc.origin.x -= fXMargin;
    rc.size.width += 2*fXMargin;
	int nBottom = rc.origin.y + rc.size.height;
    if(_ButtonOK == nil)
    {
        _ButtonOK = [UIButton buttonWithType:UIButtonTypeCustom];
        _ButtonOK.tag = 0;
        _ButtonOK.showsTouchWhenHighlighted = YES;
        [_ButtonOK addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_ButtonOK];
    }
    
    if(_ButtonCancel == nil)
    {
        _ButtonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _ButtonCancel.tag = 0;
        _ButtonCancel.showsTouchWhenHighlighted = YES;
        [_ButtonCancel addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_ButtonCancel];
    }
	switch (m_nType)//类型
	{
		case TZTBoxTypeButtonOK://只有确定键:
		{
            _ButtonOK.hidden = NO;
			_ButtonOK.tag = 0;
            
            int nType = 0;
            BOOL bHaveImage = FALSE;
            if (self.nsBtnOKImg && self.nsBtnOKImg.length > 0)
            {
                UIImage* image = [UIImage imageTztNamed:self.nsBtnOKImg];
                if (image && image.size.width > 0 && image.size.height > 0)
                {
                    [_ButtonOK setBackgroundImage:image forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                }
                nType = 1;
            }
            if (nType == 0)
            {
                UIImage *image = [UIImage imageTztNamed:@"tztButtonRed.png"];
                if (image && image.size.width > 0 && image.size.height > 0)
                {
                    [_ButtonOK setBackgroundImage:image forState:UIControlStateNormal];
                    nType = 2;
                    bHaveImage = TRUE;
                }
                else
                {
                    [_ButtonOK setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBack.png"] forState:UIControlStateNormal];
                    nType = 3;
                    bHaveImage = TRUE;
                }
            }
            
            if (self.nsBtnOKTitleColor && self.nsBtnOKTitleColor.length > 0)
            {
                [_ButtonOK setTitleColor:[UIColor colorWithTztRGBStr:self.nsBtnOKTitleColor] forState:UIControlStateNormal];
            }
            else
            {
                if (nType == 2)
                    [_ButtonOK setTitleColor:[UIColor colorWithTztRGBStr:@"218,218,218"] forState:UIControlStateNormal];
                if (nType == 3)
                    [_ButtonOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
            }
            
			[_ButtonOK setTitle:m_nsOK forState:UIControlStateNormal];
            if (!bHaveImage)
                _ButtonOK.frame = CGRectMake(rc.origin.x + (rc.size.width - 120) / 2, nBottom + 20, 120, 35);
            else
                _ButtonOK.frame = CGRectMake(rc.origin.x + (rc.size.width - 120) / 2, nBottom + 10, 120, 35);
    
            CGRect rcFrame = _ButtonOK.frame;
            if (m_fBoxHeight >= TZTScreenHeight - TZTStatuBarHeight - 2 * TZTToolBarHeight)
            {
                if (rcFrame.origin.y + rcFrame.size.height >= m_fBoxHeight)
                {
                    rcFrame.origin.y = m_fBoxHeight - kBoxMargin / 2 - rcFrame.size.height / 2;
                    rcFrame.size.height = 30;
                    _ButtonOK.frame = rcFrame;
                }
            }
            //
            if (!bHaveImage)
            {
                UIView *pViewLine = (UIView*)[self viewWithTag:0x4321];
                if (pViewLine == NULL)
                {
                    pViewLine = [[UIView alloc] initWithFrame:CGRectMake(rc.origin.x, nBottom + 10, rc.size.width, 1)];
                    pViewLine.backgroundColor = [UIColor colorWithTztRGBStr:@"204,204,204"];
                    pViewLine.tag = 0x4321;
                    [self addSubview:pViewLine];
                    [pViewLine release];
                }
                else
                {
                    pViewLine.frame = CGRectMake(rc.origin.x, nBottom + 10, rc.size.width, 1);
                }
                
                _nSeperLineForBottom = 1;
            }
		}
			break;
		case TZTBoxTypeButtonCancel://只有取消键
		{
             _ButtonCancel.hidden = NO;
            
            BOOL bHaveImage = FALSE;
            int nType = 0;
            if (self.nsBtnCancelImg && self.nsBtnCancelImg.length > 0)
            {
                UIImage *image = [UIImage imageTztNamed:self.nsBtnCancelImg];
                if (image && image.size.width > 0 && image.size.height > 0)
                {
                    [_ButtonCancel setBackgroundImage:image forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                }
                nType = 1;
            }
            
            if (nType == 0)
            {
                UIImage *image = [UIImage imageTztNamed:@"tztDialogCancel.png"];
                if (image && image.size.width > 0 && image.size.height > 0)
                {
                    [_ButtonCancel setBackgroundImage:image forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                }
                else
                {
                    [_ButtonCancel setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBack.png"] forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                }
            }
			_ButtonCancel.tag = 0;
			[_ButtonCancel setTitle:m_nsCancel forState:UIControlStateNormal];
            if (self.nsBtnCancelTitleColor && self.nsBtnCancelTitleColor.length > 0)
                [_ButtonCancel setTitleColor:[UIColor colorWithTztRGBStr:self.nsBtnCancelTitleColor] forState:UIControlStateNormal];
            else
                [_ButtonCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (!bHaveImage)
                _ButtonCancel.frame = CGRectMake(rc.origin.x + 20, nBottom + 20, rc.size.width - 40, 35);
            else
                _ButtonCancel.frame = CGRectMake(rc.origin.x + 20, nBottom + 10, rc.size.width - 40, 35);
            
            
            CGRect rcFrame = _ButtonCancel.frame;
            if (m_fBoxHeight >= TZTScreenHeight - TZTStatuBarHeight - 2 * TZTToolBarHeight)
            {
                if (rcFrame.origin.y + rcFrame.size.height >= m_fBoxHeight)
                {
                    rcFrame.origin.y = m_fBoxHeight - kBoxMargin / 2 - rcFrame.size.height / 2;
                    rcFrame.size.height = 30;
                    _ButtonCancel.frame = rcFrame;
                }
            }
            //
            if (!bHaveImage)
            {
                UIView *pViewLine = (UIView*)[self viewWithTag:0x4321];
                if (pViewLine == NULL)
                {
                    pViewLine = [[UIView alloc] initWithFrame:CGRectMake(rc.origin.x, nBottom+10, rc.size.width, 1)];
                    pViewLine.backgroundColor = [UIColor colorWithTztRGBStr:@"204,204,204"];
                    pViewLine.tag = 0x4321;
                    [self addSubview:pViewLine];
                    [pViewLine release];
                }
                else
                {
                    pViewLine.frame = CGRectMake(rc.origin.x, nBottom+10, rc.size.width, 1);
                }
                _nSeperLineForBottom = 1;
            }
		}
			break;
		case TZTBoxTypeButtonBoth://同时包含确定取消
		{
            _ButtonOK.hidden = NO;
            _ButtonCancel.hidden = NO;
			int nWidth = rc.size.width;
			nWidth = (nWidth - 60) / 2;
            
            BOOL bHaveImage = FALSE;
            int nType = 0;
            if (self.nsBtnOKImg && self.nsBtnOKImg.length > 0)
            {
                UIImage* image = [UIImage imageTztNamed:self.nsBtnOKImg];
                if (image && image.size.width > 0 && image.size.height > 0)
                {
                    [_ButtonOK setBackgroundImage:image forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                }
                nType = 1;
            }
            if (nType == 0)
            {
                UIImage *image = [UIImage imageTztNamed:@"tztButtonRed.png"];
                if (image && image.size.width > 0 && image.size.height > 0)
                {
                    [_ButtonOK setBackgroundImage:image forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                    nType = 2;
                }
                else
                {
                    [_ButtonOK setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBackMiddle.png"] forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                    nType = 3;
                }
            }
            
            if (self.nsBtnOKTitleColor && self.nsBtnOKTitleColor.length > 0)
            {
                [_ButtonOK setTitleColor:[UIColor colorWithTztRGBStr:self.nsBtnOKTitleColor] forState:UIControlStateNormal];
            }
            else
            {
                if (nType == 2)
                    [_ButtonOK setTitleColor:[UIColor colorWithTztRGBStr:@"218,218,218"] forState:UIControlStateNormal];
                if (nType == 3)
                    [_ButtonOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
			[_ButtonOK setTitle:m_nsOK forState:UIControlStateNormal];
            if (_bShowCancelLeft)
            {
                if (!bHaveImage)
                    _ButtonOK.frame = CGRectMake(rc.origin.x + 20 + nWidth + 20, nBottom + 20, nWidth, 35);
                else
                    _ButtonOK.frame = CGRectMake(rc.origin.x + 20 + nWidth + 20, nBottom + 10, nWidth, 35);
            }
            else
            {
                if (!bHaveImage)
                    _ButtonOK.frame = CGRectMake(rc.origin.x + 20, nBottom + 20, nWidth, 35);
                else
                    _ButtonOK.frame = CGRectMake(rc.origin.x + 20, nBottom + 10, nWidth, 35);
            }
			
            
            CGRect rcFrame = _ButtonOK.frame;
            if (m_fBoxHeight >= TZTScreenHeight - TZTStatuBarHeight - 2 * TZTToolBarHeight)
            {
                if (rcFrame.origin.y + rcFrame.size.height >= m_fBoxHeight)
                {
                    rcFrame.origin.y = m_fBoxHeight - kBoxMargin / 2 - rcFrame.size.height / 2;
                    rcFrame.size.height = 30;
                    _ButtonOK.frame = rcFrame;
                }
            }
            
            nType = 0;
            
			_ButtonCancel.tag = 1;
            if (self.nsBtnCancelImg && self.nsBtnCancelImg.length > 0)
            {
                UIImage *image = [UIImage imageTztNamed:self.nsBtnCancelImg];
                if (image && image.size.width > 0 && image.size.height > 0)
                {
                    [_ButtonCancel setBackgroundImage:image forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                }
                nType = 1;
            }
            if (nType == 0)
            {
                UIImage* image  = [UIImage imageTztNamed:@"tztDialogCancel.png"];
                if (image && image.size.width > 0 && image.size.height > 0)
                {
                    [_ButtonCancel setBackgroundImage:image forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                }
                else
                {
                    [_ButtonCancel setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBackMiddle.png"] forState:UIControlStateNormal];
                    bHaveImage = TRUE;
                }
            }
            if (self.nsBtnCancelTitleColor && self.nsBtnCancelTitleColor.length > 0)
                [_ButtonCancel setTitleColor:[UIColor colorWithTztRGBStr:self.nsBtnCancelTitleColor] forState:UIControlStateNormal];
            else
                [_ButtonCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
			[_ButtonCancel setTitle:m_nsCancel forState:UIControlStateNormal];
            if (_bShowCancelLeft)
            {
                if (!bHaveImage)
                    _ButtonCancel.frame = CGRectMake(rc.origin.x + 20, nBottom + 20, nWidth, 35);
                else
                    _ButtonCancel.frame = CGRectMake(rc.origin.x + 20, nBottom + 10, nWidth, 35);
            }
            else
            {
                if (!bHaveImage)
                    _ButtonCancel.frame = CGRectMake(rc.origin.x + 20 + nWidth + 20, nBottom + 20, nWidth, 35);
                else
                    _ButtonCancel.frame = CGRectMake(rc.origin.x + 20 + nWidth + 20, nBottom + 10, nWidth, 35);
            }
            
            rcFrame = _ButtonCancel.frame;
            if (m_fBoxHeight >= TZTScreenHeight - TZTStatuBarHeight - 2 * TZTToolBarHeight)
            {
                if (rcFrame.origin.y + rcFrame.size.height >= m_fBoxHeight)
                {
                    rcFrame.origin.y = m_fBoxHeight - kBoxMargin / 2 - rcFrame.size.height / 2;
                    rcFrame.size.height = 30;
                    _ButtonCancel.frame = rcFrame;
                }
            }
            
            //
            if (!bHaveImage)
            {
                UIView *pViewLine = (UIView*)[self viewWithTag:0x4321];
                if (pViewLine == NULL)
                {
                    pViewLine = [[UIView alloc] initWithFrame:CGRectMake(rc.origin.x, nBottom+10, rc.size.width, 1)];
                    pViewLine.backgroundColor = [UIColor colorWithTztRGBStr:@"204,204,204"];
                    pViewLine.tag = 0x4321;
                    [self addSubview:pViewLine];
                    [pViewLine release];
                }
                else
                {
                    pViewLine.frame = CGRectMake(rc.origin.x, nBottom+10, rc.size.width, 1);
                }
                
                UIView *pLine = (UIView*)[self viewWithTag:0x4322];
                if (pLine == NULL)
                {
                    pLine = [[UIView alloc] initWithFrame:CGRectMake(rc.origin.x+rc.size.width / 2, nBottom+10, 1, 45)];
                    pLine.backgroundColor = [UIColor colorWithTztRGBStr:@"204,204,204"];
                    pLine.tag = 0x4322;
                    [self addSubview:pLine];
                    [pLine release];
                }
                else
                {
                    pLine.frame = CGRectMake(rc.origin.x+rc.size.width / 2, nBottom+10, 1, 45);
                }
                
                _nSeperLineForBottom = 1;
            }
		}
			break;
		case TZTBoxTypeNoButton://没有按钮
        {
            _ButtonOK.hidden = YES;
            _ButtonCancel.hidden = YES;
        }
		default:
			break;
	}
}

-(void)showForView:(UIView*)view
{
    [self showForView:view animated:NO];
}

//显示对话框
-(void)showForView:(UIView *)view animated:(BOOL)animated
{
    if ([self.m_nsTitle length] < 1)
    {
        self.m_nsTitle = [NSString stringWithFormat:@"%@", g_nsMessageBoxTitle];
    }
    _bDismiss = FALSE;
    if (IS_TZTIPAD)
    {
        MacAlertView =
        [[UIAlertView alloc] initWithTitle:self.m_nsTitle
                                      message:self.m_nsContent
                                     delegate:m_pDelegate
                            cancelButtonTitle:m_nsOK
                            otherButtonTitles:nil];
        if (m_nType == TZTBoxTypeButtonBoth)
            [MacAlertView addButtonWithTitle:@"取消"];
        
        //传入Tag
        MacAlertView.tag = self.tag;
        
        // Name field
        NSArray *subviews = MacAlertView.subviews;
        for(int i = 1 ; i < [subviews count]; i++)
        {
            UIView* pView = [subviews objectAtIndex:i];
            if ( [pView isKindOfClass:[UILabel class]])
                ((UILabel *)pView).textAlignment = UITextAlignmentCenter;
        }
        [MacAlertView show];
        [MacAlertView release];
        
        [self setNeedsDisplay];        
        return;
    }    
    
    TZTMessageBoxCount++;
	//得到当前view窗体，在当前view的窗体上进行显示
	UIWindow *viewWindow;// = view.window;
    //保证提示信息显示在最前面
    viewWindow = [[UIApplication sharedApplication] keyWindow];
    CGFloat angle;
//    NSString *subtype = kCATransitionFromTop;
//    有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
    switch ([[UIApplication sharedApplication] statusBarOrientation])
    {
		case UIDeviceOrientationLandscapeLeft:
			angle = 0.5 * M_PI;
//            subtype = kCATransitionFromLeft;
			break;
		case UIDeviceOrientationLandscapeRight:
			angle = -0.5 * M_PI;
//            subtype = kCATransitionFromRight;
			break;
		case UIDeviceOrientationPortraitUpsideDown:
//            subtype = kCATransitionFromBottom;
			angle = M_PI;
			break;
		case UIDeviceOrientationPortrait:
//            subtype = kCATransitionFromTop;
			angle = 0;
			break;
		default:
			return;
	}
	self.transform = CGAffineTransformMakeRotation(angle);
    CGRect frame = viewWindow.frame;
	self.frame = frame;
    //回调上层处理,包括标题字体，居中方式，指定按钮底图等
    NSMutableDictionary* pDict = NULL;
    if ([self respondsToSelector:@selector(tztMsgBoxSetProperties:)])
    {
        pDict = (NSMutableDictionary*)[self tztperformSelector:@"tztMsgBoxSetProperties:" withObject:self];
    }
    
    CGFloat fXMargin = 0;
    if (pDict)
    {
        fXMargin = [[pDict tztObjectForKey:tztMsgBoxXMargin] floatValue];
    }
    
   self.window.windowLevel = UIWindowLevelAlert+1.0; 
	//得到位置
	CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	CGFloat topMargin = kBoxMargin + kBorderWidth + ((nil != self.m_nsTitle) ? kTitleHeight : 0.0) + kContentYPadding;
	CGFloat viewElementsHeight = topMargin + kContentYPadding + kBorderWidth + kBoxMargin + kBoxShadowOffset;
	
    int nLine = 0;
	//创建内容文本显示
	if (self.m_pTextView == NULL && !IS_TZTIPAD)
    {
        self.m_pTextView = [[[UITextView alloc] init] autorelease];
        [self addSubview:self.m_pTextView];
    }
    
	{
		//最大宽度
		CGFloat maxWidth = self.bounds.size.width - 2*kBoxMargin - 2*kBorderWidth - 2 * fXMargin;
		//最小高度
		CGFloat minHeight = 30.0;
		//最大高度
		CGFloat maxHeight = self.frame.size.height - statusBarHeight - viewElementsHeight;
		CGRect scrollMaxRect = CGRectMake(kBoxMargin + kBorderWidth + fXMargin, topMargin, maxWidth, maxHeight);
		
		//计算行数
		//首先通过\r\n分割有几行
		int nLineHeight = self.m_ContentFont.lineHeight;
		CGSize sz = [self.m_nsContent sizeWithFont:self.m_ContentFont
					 					constrainedToSize:scrollMaxRect.size
					 					lineBreakMode:NSLineBreakByCharWrapping];
		nLine = sz.height / nLineHeight;
		if (((int)sz.height) % nLineHeight != 0)
		{
			nLine++;
		}
        else
        {
            if (sz.width + kBoxMargin > scrollMaxRect.size.width)
                nLine++;
        }
		int nHeight;// = minHeight;
		if (nLine <= 1)
			nHeight = minHeight;
		else
		{
			if (nLine <= 4)
			{
				nLine++;
                nLineHeight += 3;
			}
			else if (nLine >= 5)
			{
				m_fRowHeight = 25;
                nLineHeight = 20;
			}
			else
			{
				m_fRowHeight = 30;
//                nLineHeight = 30;
			}

			nHeight = nLine * nLineHeight;
		}
		
		scrollMaxRect.origin.y += (scrollMaxRect.size.height - nHeight)/2;
		CGRect rcText = CGRectMake(scrollMaxRect.origin.x, scrollMaxRect.origin.y, scrollMaxRect.size.width, nHeight);
		self.m_pTextView.frame = rcText;
		if (nLine == 1)
		{
			//只有一行，居中显示
			self.m_pTextView.textAlignment = UITextAlignmentCenter;
		}
		else
		{
			//否则，左对齐显示
			self.m_pTextView.textAlignment = UITextAlignmentLeft;
		}

		//背景色
		self.m_pTextView.backgroundColor = [UIColor clearColor];
		//字体设置
		self.m_pTextView.font = self.m_ContentFont;
		self.m_pTextView.delegate = self;
		//文本颜色
		self.m_pTextView.textColor = [UIColor blackColor];
		//不允许编辑
		self.m_pTextView.editable = NO;
		//设置内容
        //修改内容
        
//        
//        NSAttributedString *attributedString = self.m_pTextView.attributedText;
//        if (!attributedString)
//            attributedString = [[NSAttributedString alloc]initWithString:self.m_nsContent];
//        
//        NSRange allTextRange;
//        allTextRange.location = 0;
//        allTextRange.length = self.m_nsContent.length;
//        
        
		self.m_pTextView.text = self.m_nsContent;
		//计算对话框高度
		m_fBoxHeight = (nil != m_pTextView) ? m_pTextView.bounds.size.height + viewElementsHeight : minHeight + viewElementsHeight;
	}

	
	CGRect rc = self.m_pTextView.frame;
	//判断对话框高度，若超过350，则需要重新设置
	if (m_fBoxHeight > TZTScreenHeight - TZTStatuBarHeight - 2 * TZTToolBarHeight)
	{
		m_fBoxHeight = TZTScreenHeight - TZTStatuBarHeight - 2 * TZTToolBarHeight;
		rc.size.height = TZTScreenHeight - TZTStatuBarHeight - 2 * TZTToolBarHeight - 70;
	}
    
    
    if (pDict)
    {
        NSString* str = [pDict tztObjectForKey:tztMsgBoxBackColor];
        if (ISNSStringValid(str))
            self.nsBackColor = [NSString stringWithFormat:@"%@", str];
        
        str = [pDict tztObjectForKey:tztMsgBoxTitleBackColor];
        if (ISNSStringValid(str))
            self.nsTitleBackColor = [NSString stringWithFormat:@"%@", str];
        
        str = [pDict tztObjectForKey:tztMsgBoxCornRadius];
        if (ISNSStringValid(str))
            _fBorderCornerRadius = [str floatValue];
        
        str = [pDict tztObjectForKey:tztMsgBoxBtnOKImg];
        if (ISNSStringValid(str))
            self.nsBtnOKImg = [NSString stringWithFormat:@"%@",str];
        
        str = [pDict tztObjectForKey:tztMsgBoxBtnOKTitleColor];
        if (ISNSStringValid(str))
            self.nsBtnOKTitleColor = [NSString stringWithFormat:@"%@", str];
        
        str = [pDict tztObjectForKey:tztMsgBoxBtnCancelImg];
        if (ISNSStringValid(str))
            self.nsBtnCancelImg = [NSString stringWithFormat:@"%@", str];
        
        str = [pDict tztObjectForKey:tztMsgBoxBtnCancelTitleColor];
        if (ISNSStringValid(str))
            self.nsBtnCancelTitleColor = [NSString stringWithFormat:@"%@", str];
        
        str = [pDict tztObjectForKey:tztMsgBoxTitleAlignment];
        if (ISNSStringValid(str))
        {
            if ([str caseInsensitiveCompare:@"right"] == NSOrderedSame)
            {
                _nTitleAligment = UITextAlignmentRight;
            }
            else if ([str caseInsensitiveCompare:@"center"] == NSOrderedSame)
            {
                _nTitleAligment = UITextAlignmentCenter;
            }
            else
            {
                _nTitleAligment = UITextAlignmentLeft;
            }
        }
        
        str = [pDict tztObjectForKey:tztMsgBoxSepLinePos];
        if (ISNSStringValid(str))
        {
            if ([str caseInsensitiveCompare:@"bottom"] == NSOrderedSame)
            {
                _nSeperLineForBottom = 1;
            }
            else
            {
                _nSeperLineForBottom = 0;
            }
        }
        
        str = [pDict tztObjectForKey:tztMsgBoxLeftCancel];
        if (ISNSStringValid(str))
        {
            _bShowCancelLeft = [str intValue] > 0;
        }
    }
	
	//加上按钮的高度
	if (m_nType != TZTBoxTypeNoButton)
		m_fBoxHeight += 50;
	
	if(kTZTShowBottom)
	{
        CGRect rcF = self.bounds;
        if (nLine == 1 && m_nType == TZTBoxTypeNoButton)
        {
            rc.origin.y = rcF.size.height - m_fBoxHeight + topMargin/2;
        }
        else
        {
            rc.origin.y = rcF.size.height - m_fBoxHeight + topMargin;
        }
	}
	else
	{
		rc.origin.y = topMargin + self.center.y - roundf(m_fBoxHeight / 2);
	}
	//得到新的区域，重新设置
	self.m_pTextView.frame = rc;
    
	//创建按钮
    if (_bHasClose)//创建右上角d的关闭按钮
    {
        if(_ButtonClose == nil)
        {
            _ButtonClose = [UIButton buttonWithType:UIButtonTypeCustom];
            [_ButtonClose setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonClose.png"] forState:UIControlStateNormal];
            _ButtonClose.tag = 0x9876;
            [_ButtonClose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _ButtonClose.frame = CGRectMake(rc.origin.x + rc.size.width - 30, rc.origin.y - ((nil != self.m_nsTitle) ? kTitleHeight : 0.0), 20, 20);
            [_ButtonClose addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _ButtonClose.showsTouchWhenHighlighted = YES;
            [self addSubview:_ButtonClose];
        }
    }
    
    if(_ButtonClose)
    {
        _ButtonClose.hidden = !_bHasClose;
    }
    
       
	[self CreateButton];
	
	self.center = viewWindow.center;
    
    //先关闭其他的
    for (int i = 0; i < [g_ayMessageBox count]; i++)
    {
        UIView *pView = [g_ayMessageBox objectAtIndex:i];
        [self showWithAnimated:pView bShow_:NO];
    }
    
    UIView *pBack = [viewWindow viewWithTag:0x99999];
    if (pBack == NULL)
    {
        pBack = [[UIView alloc] initWithFrame:self.bounds];
        pBack.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        pBack.tag = 0x99999;
        [viewWindow addSubview:pBack];
        [pBack release];
        self.pBackView = pBack;
    }
    
	[viewWindow addSubview:self];
	[self setNeedsDisplay];
    [g_ayMessageBox addObject:self];
	
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
//	//加上动画效果，从底部弹出来
//	CATransition *animation = [CATransition animation];//初始化动画
//	animation.duration = 0.2f;//间隔的时间
//	animation.timingFunction = UIViewAnimationCurveEaseInOut;//过渡效果
//	animation.type = kCATransitionPush;//设置上面4种动画效果
//	animation.subtype = subtype;//设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
//	[self.layer addAnimation:animation forKey:@"animationID"];
//
    
    if (animated)
    {
        self.backgroundColor = [UIColor clearColor];
        [self showWithAnimated:self bShow_:YES];
    }
    
	if (kUseDelayDisappear && (m_nType == TZTBoxTypeNoButton))
	{
		self.m_tTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
													 target:self
												   selector:@selector(hide)
												   userInfo:nil
													repeats:NO];
	}
}

-(void)showWithAnimated:(UIView*)pView bShow_:(BOOL)bShow
{
    //增加动画效果
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.delegate = self;
    if (bShow)
    {
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    }
    else
    {
        popAnimation.values = @[
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    }
        popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f,@1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
    [pView.layer addAnimation:popAnimation forKey:nil];
    pView.hidden = !bShow;
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
}
//隐藏对话框
-(void) hide
{
    TZTMessageBoxCount--;
    if (TZTMessageBoxCount < 0)
        TZTMessageBoxCount = 0;
    TZTLogInfo(@"%@", @"MessageBox = hide");
    NilObject(self.m_pDelegate);
    _bDismiss = TRUE;
    if (self.panRecognizer)
    {
        [self removeGestureRecognizer:self.panRecognizer];
    }
    if (TZTMessageBoxCount <= 1)
    {
        [self.pBackView removeFromSuperview];
    }
    [g_ayMessageBox removeObject:self];
    //取最近的显示
    [self showWithAnimated:[g_ayMessageBox lastObject] bShow_:YES];
	[self removeFromSuperview];
    return;
	//移除当前view
	[UIView beginAnimations:@"hideSelectionView" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	self.center = CGPointMake(self.center.x, self.bounds.size.height + m_fBoxHeight / 2);
	[UIView commitAnimations];
}

//
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    TZTLogInfo(@"%@", @"MessageBox = animationDidStop");
    
    if (TZTMessageBoxCount <= 1)
    {
        [self.pBackView removeFromSuperview];
    }
    
	[self removeFromSuperview];
    _bDismiss = TRUE;
}

//绘制
-(void) drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	//圆角
    if (_fBorderCornerRadius <= 0)
        _fBorderCornerRadius = 5.0f;
	CGFloat borderRadius = _fBorderCornerRadius;
	CGRect  fullRect = self.bounds;
	fullRect.size.height = m_fBoxHeight;
	
	CGRect boxRect = fullRect;
	boxRect.size.height -= kBoxShadowOffset;
	CGFloat arcOriginOffset = kBoxMargin + borderRadius;
	
	if (kTZTShowBottom)
	{
		CGFloat topMargin = kBoxMargin + kBorderWidth + ((nil != self.m_nsTitle) ? kTitleHeight : 0.0) + kContentYPadding;
		int nPos = topMargin + self.frame.size.height-m_fBoxHeight;
		if ((nPos + TZTToolBarHeight) > (TZTScreenHeight-TZTToolBarHeight-TZTStatuBarHeight))
		{
			CGContextTranslateCTM(context, 0.0, rect.size.height - m_fBoxHeight - TZTToolBarHeight/2);
		}
		else
		{
			CGContextTranslateCTM(context, 0.0, rect.size.height - m_fBoxHeight);
		}

	}
	else
	{
		CGContextTranslateCTM(context, 0.0, self.center.y - roundf(m_fBoxHeight / 2));
	}

	
	//颜色通道
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	
    float r = 212.0f;
    float g = 212.0f;
    float b = 212.0f;
    float alpha = 1.0f;
    
    if (self.nsBackColor && self.nsBackColor.length > 0)
    {
        NSArray *ay = [self.nsBackColor componentsSeparatedByString:@","];
        if (ay)
        {
            if ([ay count] > 0)
                r = [[ay objectAtIndex:0] floatValue];
            if ([ay count] > 1)
                g = [[ay objectAtIndex:1] floatValue];
            if ([ay count] > 2)
                b = [[ay objectAtIndex:2] floatValue];
            if ([ay count] > 3)
                alpha = [[ay objectAtIndex:3] floatValue];
        }
    }
    
	CGFloat backgroundColorComponents[4] =	{ r/255, g/255.0, b/255.0, alpha };
//	CGFloat blackColorComponents[4] =		{ 0.0, 0.0, 0.0, 1.0 };
//	CGFloat boxShadowColorComponents[4] =	{ 0.0, 0.0, 0.0, 0.75 };
	
//	CGColorRef boxShadowColor = CGColorCreate(rgbColorSpace, boxShadowColorComponents);
	
	CGContextSaveGState(context);
	
	
	// create our outline path. Will be used multiple times
	CGMutablePathRef outlinePath = CGPathCreateMutable();
	
	CGPathAddArc(outlinePath, NULL, arcOriginOffset,						arcOriginOffset,						borderRadius, 1.0 * M_PI, 1.5 * M_PI, 0);
	CGPathAddArc(outlinePath, NULL, boxRect.size.width - arcOriginOffset,	arcOriginOffset,						borderRadius, 1.5 * M_PI, 0.0, 0);
	CGPathAddArc(outlinePath, NULL, boxRect.size.width - arcOriginOffset,	boxRect.size.height - arcOriginOffset,	borderRadius, 0.0, 0.5 * M_PI, 0);
	CGPathAddArc(outlinePath, NULL, arcOriginOffset,						boxRect.size.height - arcOriginOffset,	borderRadius, 0.5 * M_PI, 1.0 * M_PI, 0);
	CGPathCloseSubpath(outlinePath);
	
	// draw the main background
	CGContextAddPath(context, outlinePath);
	CGContextClip(context);
	CGContextSaveGState(context);
	
	CGContextSetFillColor(context, backgroundColorComponents);
	CGContextFillRect(context, boxRect);
    
#if 0
	// Gloss
	CGFloat glossBow = 12.0;
	CGFloat glossHeight = 30.0;									// DON'T go lower than 10.0!
	CGFloat glossComponents[8] = {	1.0, 1.0, 1.0, 0.5,			// Top color
		1.0, 1.0, 1.0, 0.1 };		// Bottom color
	CGFloat locations[2] = { 0.0, 1.0 };
	CGGradientRef glossGradient = CGGradientCreateWithColorComponents(rgbColorSpace, glossComponents, locations, 2);
	
	CGPoint startPoint = CGPointMake(0.0, kBoxMargin);
	CGPoint endPoint = CGPointMake(0.0, kBoxMargin + glossHeight);
	
	// calculate the radius of the bow
	CGFloat tangensA = (boxRect.size.width / 2) / (2 * glossBow);
	CGFloat radAlpha = (M_PI / 2) - atanf(tangensA);
	CGFloat bowRadius = (boxRect.size.width / 2) / sinf(radAlpha);
	
	// create the path
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0.0, 0.0);
	CGContextAddLineToPoint(context, boxRect.size.width, 0.0);
	CGContextAddLineToPoint(context, boxRect.size.width, kBoxMargin + glossHeight - glossBow);
	CGContextAddArcToPoint(context, boxRect.size.width / 2, kBoxMargin + glossHeight + glossBow, 0.0, kBoxMargin + glossHeight - glossBow, bowRadius);
	CGContextAddLineToPoint(context, 0.0, kBoxMargin + glossHeight - glossBow);
	CGContextClosePath(context);
	
	CGContextClip(context);					// old clipping is still active, this now clips to the old area plus the bottom bow
	CGContextDrawLinearGradient(context, glossGradient, startPoint, endPoint, 0);
	CGGradientRelease(glossGradient);
	
	CGContextRestoreGState(context);		// restore to the clipping before clipping to the gloss region
	CGContextSaveGState(context);
	
#endif
	// title (draw title _over_ the gloss for better readability)
	//绘制标题
	if(m_nsTitle) 
	{
		CGPoint titlePoint = CGPointMake(0.0, kBoxMargin + kContentYPadding);
        CGSize szTitle = [m_nsTitle sizeWithFont:m_TitleFont];
        if (_nTitleAligment == UITextAlignmentCenter)
        {
            titlePoint.x = (boxRect.size.width - szTitle.width) / 2;
        }
        else if(_nTitleAligment == UITextAlignmentRight)
        {
            titlePoint.x = (boxRect.size.width -szTitle.width - 20);
        }
        else
            titlePoint.x = 20;//(boxRect.size.width - titleSize.width) / 2;
		
        CGPoint drawPt = CGPointMake(titlePoint.x, titlePoint.y + (((nil != self.m_nsTitle) ? kTitleHeight : 0.0) - szTitle.height) / 2);
        
		titlePoint.x = kBoxMargin;
		titlePoint.y = (titlePoint.y + ((nil != self.m_nsTitle) ? kTitleHeight : 0.0));
        
        //绘制
        // create the path
        
//		CGFloat sepColorComponents[4] =		{ 214.0/255.0, 214.0/255.0, 214.0/255.0, 1.0 };
//		CGContextSetFillColor(context, sepColorComponents);
//        CGContextBeginPath(context);
//        CGContextMoveToPoint(context, 0.0, titlePoint.y-1);
//        CGContextAddLineToPoint(context, boxRect.size.width, titlePoint.y-1);
//        CGContextClosePath(context);
        
        if (_nSeperLineForBottom == 0)
        {
            CGContextSetLineWidth(context, 1);
            CGFloat sepColorComponents1[4] =		{ 204.0/255.0, 204.0/255.0, 204.0/255.0, 0.8f };
            CGContextSetStrokeColor(context, sepColorComponents1);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, 0.0, titlePoint.y);
            CGContextAddLineToPoint(context, boxRect.size.width, titlePoint.y);
            CGContextClosePath(context);
            CGContextStrokePath(context);
            
            if (ISNSStringValid(self.nsTitleBackColor))
            {
                alpha = 1.f;
                NSArray *ay = [self.nsTitleBackColor componentsSeparatedByString:@","];
                if (ay)
                {
                    if ([ay count] > 0)
                        r = [[ay objectAtIndex:0] floatValue];
                    if ([ay count] > 1)
                        g = [[ay objectAtIndex:1] floatValue];
                    if ([ay count] > 2)
                        b = [[ay objectAtIndex:2] floatValue];
                    if ([ay count] > 3)
                        alpha = [[ay objectAtIndex:3] floatValue];
                }
                UIColor *pColor = [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:alpha];
                CGRect rcTitle = CGRectMake(0, 0, boxRect.size.width, titlePoint.y);
                CGContextSetFillColorWithColor(context, pColor.CGColor);
                CGContextFillRect(context, rcTitle);
            }
        }
        
		CGFloat titleColorComponents[4] =		{ 0.0, 0.0, 0.0, 1.0 };
		CGContextSetFillColor(context, titleColorComponents);
		[m_nsTitle drawAtPoint:drawPt withFont:m_TitleFont];
	}
	
	CGContextRestoreGState(context);
	
	//绘制边框
    
	CGFloat borderColorComponents[4] =		{ r/255.0, g/255.0, b/255.0, alpha };
	CGContextSetStrokeColor(context, borderColorComponents);
	CGContextSetLineWidth(context, (2 * kBorderWidth));					// width will be half of this setting due to the clipping
	CGContextAddPath(context, outlinePath);
	CGContextStrokePath(context);
	
	
	// 清理释放
	CGColorSpaceRelease(rgbColorSpace);
	CGPathRelease(outlinePath);
//	CGColorRelease(boxShadowColor);
}

//对话框按钮点击事件处理
-(void) OnButtonClick:(id)sender
{
	UIButton *pButton = (UIButton*)sender;
	if (pButton == NULL || ![pButton isKindOfClass:[UIButton class]]) 
	{
		return;
	}
    
    if (pButton.tag == 0x9876)
    {
        [self hide];
        return;
    }
    if(self.blockcomple)
    {
        TZTMessageBoxCount--;
        self.blockcomple(pButton.tag);
        TZTMessageBoxCount++;
    }
	//调用上层处理
	if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(TZTUIMessageBox:clickedButtonAtIndex:)])
	{
		[m_pDelegate TZTUIMessageBox:self clickedButtonAtIndex:pButton.tag];
	}
	//隐藏自身
	[self hide];
}

#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.blockcomple)
        self.blockcomple(buttonIndex);
    //调用上层处理
    if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(TZTUIMessageBox:clickedButtonAtIndex:)])
    {
        [m_pDelegate TZTUIMessageBox:self clickedButtonAtIndex:buttonIndex];
    }
    [self hide];
}

//手势事件处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch 
{	
	//当前显示的没有按钮，直接隐藏对话框显示，否则需要相应按钮事件才行
	if (self.m_nType == TZTBoxTypeNoButton)
	{
		[self hide];
	}
    return NO;
	
}

-(void)setTextArrtibutes:(NSMutableDictionary*)dict forString:(NSString*)string
{
    //6.0以上才支持
    if (IS_TZTIOS(6))
    {
        if (self.m_pTextView == NULL || string.length < 1)
            return;
        NSAttributedString *attributedString = self.m_pTextView.attributedText;
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:attributedString];
        [mutableAttributedString beginEditing];
        NSRange rangeOfString = [self.m_nsContent rangeOfString:string];
        if (rangeOfString.length && dict)
        {
            [mutableAttributedString addAttributes:dict range:rangeOfString];
        }
        [mutableAttributedString endEditing];
        self.m_pTextView.attributedText = mutableAttributedString;
        [mutableAttributedString release];
    }
}
@end

@implementation UIView(tztblock)
const char oldDelegateKey;
const char completionHandlerKey;
#pragma -mark UIAlerView
-(void)tztshowWithCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIAlertView *alert = (UIAlertView *)self;
    if(completionHandler != nil)
    {
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
        if(oldDelegate == nil)
        {
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        oldDelegate = alert.delegate;
        alert.delegate = self;
        objc_setAssociatedObject(self, &completionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertView *alert = (UIAlertView *)self;
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if(theCompletionHandler == nil)
        return;
    
    theCompletionHandler(buttonIndex);
    alert.delegate = objc_getAssociatedObject(self, &oldDelegateKey);
}

#pragma -mark UIActionSheet
- (void)tztactionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &completionHandlerKey);
    
    if(theCompletionHandler == nil)
        return;
    
    theCompletionHandler(buttonIndex);
    UIActionSheet *sheet = (UIActionSheet *)self;
    
    sheet.delegate = objc_getAssociatedObject(self, &oldDelegateKey);
}


-(void)tztconfig:(void(^)(NSInteger buttonIndex))completionHandler
{
    if(completionHandler != nil)
    {
        
        id oldDelegate = objc_getAssociatedObject(self, &oldDelegateKey);
        if(oldDelegate == nil)
        {
            objc_setAssociatedObject(self, &oldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        UIActionSheet *sheet = (UIActionSheet *)self;
        oldDelegate = sheet.delegate;
        sheet.delegate = self;
        objc_setAssociatedObject(self, &completionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
}
-(void)tztshowInView:(UIView *)view
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self tztconfig:completionHandler];
    [sheet showInView:view];
}

-(void)tztshowFromToolbar:(UIToolbar *)view
 withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self tztconfig:completionHandler];
    [sheet showFromToolbar:view];
}

-(void)tztshowFromTabBar:(UITabBar *)view
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self tztconfig:completionHandler];
    [sheet showFromTabBar:view];
}

-(void)tztshowFromRect:(CGRect)rect
             inView:(UIView *)view
           animated:(BOOL)animated
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self tztconfig:completionHandler];
    [sheet showFromRect:rect inView:view animated:animated];
}

-(void)tztshowFromBarButtonItem:(UIBarButtonItem *)item
                    animated:(BOOL)animated
       withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self tztconfig:completionHandler];
    [sheet showFromBarButtonItem:item animated:animated];
}
@end


TZTUIMessageBox* tztAfxMessageBox(NSString* strMsg)
{
    return tztAfxMessageBoxAnimated(strMsg, YES);
    //tztAfxMessageTitle(strMsg,nil);;
}

TZTUIMessageBox* tztAfxMessageBoxAnimated(NSString* strMsg, BOOL bUseAnimated)
{
    return tztAfxMessageTitleAnimated(strMsg, nil, bUseAnimated);
}

TZTUIMessageBox* tztAfxMessageTitle(NSString* strMsg, NSString* strTitle)
{
    return tztAfxMessageTitleAnimated(strMsg, strTitle, YES);
    //    if (g_ntztHaveBtnOK)
    //        return tztAfxMessageBlock(strMsg,strTitle,nil,TZTBoxTypeButtonOK,nil);
    //    else
    //        return tztAfxMessageBlock(strMsg,strTitle,nil,0,nil);
}

TZTUIMessageBox* tztAfxMessageTitleAnimated(NSString* strMsg, NSString* strTitle, BOOL bUseAnimated)
{
    if (g_ntztHaveBtnOK)
        return tztAfxMessageBlockAnimated(strMsg, strTitle, nil, TZTBoxTypeButtonOK, nil, bUseAnimated);
    else
        return tztAfxMessageBlockAnimated(strMsg,strTitle,nil,0,nil,bUseAnimated);
}

TZTUIMessageBox* tztAfxMessageBlock(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType,void (^block)(NSInteger))
{
    return tztAfxMessageBlockAnimated(strMsg, strTitle, ayBtn, nType, block, YES);
}

TZTUIMessageBox* tztAfxMessageBlockAnimated(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType,void (^block)(NSInteger), BOOL bUseAnimated)
{
    return tztAfxMessageBlockWithDelegateAnimated(strMsg, strTitle, ayBtn, nType, nil, block, bUseAnimated);
}

FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlockWithDelegate(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType, id delegate, void (^block)(NSInteger))
{
    return tztAfxMessageBlockWithDelegateAnimated(strMsg, strTitle, ayBtn, nType, delegate, block, YES);
}

FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlockWithDelegateAnimated(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType, id delegate, void (^block)(NSInteger), BOOL bUseAnimated)
{
    return tztAfxMessageBlockAndCloseAnimated(strMsg, strTitle, ayBtn, nType, delegate, FALSE, block, bUseAnimated);
}

FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlockAndClose(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType, id delegate, BOOL bHasClose, void (^block)(NSInteger))
{
    return tztAfxMessageBlockAndCloseAnimated(strMsg, strTitle, ayBtn, nType, delegate, bHasClose, block, YES);
}

FOUNDATION_EXPORT TZTUIMessageBox* tztAfxMessageBlockAndCloseAnimated(NSString* strMsg,NSString* strTitle, NSArray* ayBtn, int nType, id delegate, BOOL bHasClose, void (^block)(NSInteger), BOOL bUseAnimated)
{
    if (strMsg == NULL || [strMsg length] < 1)
        return nil;
    
    if (strTitle == nil || [strTitle length] < 1)
    {
        strTitle = [NSString stringWithFormat:@"%@", g_nsMessageBoxTitle];
    }
    NSString* nsOk = @"确定";
    NSString* nsCancel = @"取消";
    if(ayBtn)
    {
        if([ayBtn count] > 0)
        {
            nsOk = [ayBtn objectAtIndex:0];
        }
        if([ayBtn count] > 1)
        {
            nsCancel = [ayBtn objectAtIndex:1];
        }
    }
    
    if(IS_TZTIPAD)
    {
        if(nType != TZTBoxTypeButtonBoth)
            nsCancel = nil;
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:strTitle
                                                         message:strMsg
                                                        delegate:nil
                                               cancelButtonTitle:nsOk
                                               otherButtonTitles:nsCancel,nil] autorelease];
        [alert tztshowWithCompletionHandler:block];
        return (id)alert;
    }
    
    CGRect appRect = [[UIScreen mainScreen] bounds];
    TZTUIMessageBox *pMessage = [[[TZTUIMessageBox alloc] initWithFrame:appRect nBoxType_:nType delegate_:delegate block:block] autorelease];
    pMessage.m_nsContent = [NSString stringWithString:strMsg];
    [pMessage setButtonText:nsOk cancel_:nsCancel];
    pMessage.m_nsTitle = strTitle;
    pMessage.bHasClose = bHasClose;
    [pMessage showForView:[UIApplication sharedApplication].keyWindow animated:bUseAnimated];
    return pMessage;
}

#endif
