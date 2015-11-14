/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		tztUIProgressView.m
* 文件标识:
* 摘要说明:		进度条view
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import "tztUIProgressView.h"

tztUIProgressView *g_tztUIProgressView = NULL;
#define tztProgressMargin 5
@interface tztUIProgressView(TZTPrivate)
- (void)setTransformForCurrentOrientation:(BOOL)animated;
@end


@implementation tztUIProgressView
@synthesize pIndicator = _pIndicator;
@synthesize szSize = _szSize;
@synthesize nsShowMsg = _nsShowMsg;
@synthesize nCount = _nCount;
@synthesize tztdelegate = _tztdelegate;
@synthesize pLabel = _pLabel;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    if (self) 
	{
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin 
								| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.alpha = 0.0f;
        self.tztdelegate = nil;
		_nMargin = 20;
        _nCount = 0;
		_rotationTransform = CGAffineTransformIdentity;
        self.nsShowMsg = @"请稍候...";
        if (_pLabel == NULL)
        {
            _pLabel = [[UILabel alloc] initWithFrame:self.bounds];
            _pLabel.adjustsFontSizeToFitWidth = NO;
            _pLabel.textAlignment = NSTextAlignmentCenter;
            _pLabel.numberOfLines = 2;
            _pLabel.opaque = NO;
            _pLabel.backgroundColor = [UIColor clearColor];
            _pLabel.textColor = [UIColor whiteColor];
            _pLabel.font = tztUIBaseViewTextFont(12.0f);
            [self addSubview:_pLabel];
            [_pLabel release];
        }
        _pLabel.text = self.nsShowMsg;
        
		if(_pIndicator == NULL)
        {
            _pIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [self addSubview:_pIndicator];
            [_pIndicator release];
        }
        [_pIndicator startAnimating];
        
        [self setTransformForCurrentOrientation:NO];
    }
    return self;
}


- (void)dealloc 
{
    NilObject(self.tztdelegate);
    [super dealloc];
}

-(void)layoutSubviews
{
	UIView *parent = self.superview;
	if (parent)
	{
		self.frame = parent.bounds;
	}
	
	CGRect bounds = self.bounds;
	CGFloat maxWidth = bounds.size.width - 4 * _nMargin;
	CGSize  totalSize = CGSizeZero;
	
	CGRect rcIndicator = _pIndicator.bounds;
	rcIndicator.size.width = MIN(rcIndicator.size.width, maxWidth);
	totalSize.width = MAX(totalSize.width, rcIndicator.size.width);
	totalSize.height += rcIndicator.size.height;
	
	if (_pLabel == NULL || _pLabel.text == NULL || [_pLabel.text length] < 1)
		return;
	CGSize labelSize;// = CGSizeMake(0, 0);
    NSString *labelString = [NSString stringWithFormat:@"%@",self.nsShowMsg];
    labelSize = [labelString sizeWithFont:tztUIBaseViewTextFont(12.0f)];
    labelSize.height *= 2;
	labelSize.width = MIN(labelSize.width, maxWidth);
	totalSize.width = MAX(totalSize.width, labelSize.width);
	totalSize.height += labelSize.height;
	if (labelSize.height > 0 && rcIndicator.size.height > 0) //中间加上间隔
		totalSize.height += tztProgressMargin;	
	
	totalSize.width += 2*_nMargin;
	totalSize.height += 2*_nMargin;
	
	CGFloat yPos = roundf((bounds.size.height - totalSize.height) / 2) + _nMargin;
	CGFloat xPos = 0;
	rcIndicator.origin.y = yPos;
	rcIndicator.origin.x = roundf((bounds.size.width - rcIndicator.size.width) / 2) + xPos;
	_pIndicator.frame = rcIndicator;
	
	yPos += rcIndicator.size.height;
    if (labelSize.height > 0 && rcIndicator.size.height > 0)
		yPos += tztProgressMargin;
	
	CGRect rcLabel;
	rcLabel.origin.y = yPos;
	rcLabel.origin.x = roundf((bounds.size.width - labelSize.width) / 2) + xPos;
	rcLabel.size = labelSize;
	_pLabel.frame = rcLabel;
    _pLabel.text = labelString;
	
	self.szSize = totalSize;
}

-(void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetGrayFillColor(context, 0.2f, 0.8f);
//	CGContextSetRGBFillColor(context, 0.23, 0.50, 0.82, 0.8f);
	
	CGRect allRect = self.bounds;
	// Draw rounded HUD backgroud rect
	CGRect boxRect = CGRectMake(roundf((allRect.size.width - _szSize.width) / 2),
								roundf((allRect.size.height - _szSize.height) / 2), _szSize.width, _szSize.height);
	float radius = 10.0f;
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
	CGContextClosePath(context);
	CGContextFillPath(context);
}
+ (void)showWithMsg:(NSString *)strMsg
{
    [tztUIProgressView showWithMsg:strMsg withdelegate:nil];
}

+ (void)showWithMsg:(NSString *)strMsg withdelegate:(id)delegate
{
    dispatch_async (dispatch_get_main_queue(), ^
    {
        if (g_tztUIProgressView == NULL)
        {
            //获取全局的window作为进度条显示的窗口
            UIWindow *pWindow = [UIApplication sharedApplication].keyWindow;
            g_tztUIProgressView = [[tztUIProgressView alloc] initWithFrame:pWindow.bounds];
            [pWindow addSubview:g_tztUIProgressView];
//            [g_tztUIProgressView release];
        }
        g_tztUIProgressView.tztdelegate = delegate;
        g_tztUIProgressView.nsShowMsg = [NSString stringWithFormat:@"%@",strMsg];
        g_tztUIProgressView.alpha = 1.0f;
        [g_tztUIProgressView layoutSubviews];
        [g_tztUIProgressView setNeedsDisplay];
    });
}

+ (void)hidden
{
    dispatch_async (dispatch_get_main_queue(), ^
    {
        if(g_tztUIProgressView)
        {
            g_tztUIProgressView.alpha = 0.0f;
            NilObject(g_tztUIProgressView.tztdelegate);
            DelObject(g_tztUIProgressView);
        }
    });
}

- (void)setTransformForCurrentOrientation:(BOOL)animated
{
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	float radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation))
    {
#ifdef __IPHONE_8_0
        if (IS_TZTIOS(8))
            radians = 0;
        else
        {
            if (orientation == UIInterfaceOrientationLandscapeLeft)
            {
                radians = -M_PI_2;
            }
            else
            {
                radians = M_PI_2;
            }
        }
#else
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            radians = -M_PI_2;
        }
        else
        {
            radians = M_PI_2;
        }
#endif
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	}
    else
    {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            radians = M_PI;
        }
		else
        {
            radians = 0;
        }
	}
	
	_rotationTransform = CGAffineTransformMakeRotation(radians);
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:_rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 0.0f;
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIProgressViewCancel:)])
    {
        [_tztdelegate tztUIProgressViewCancel:self];
        self.tztdelegate = nil;
    }
}

@end
