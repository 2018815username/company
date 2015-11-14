
#import "tztMessageLabel.h"

@interface tztMessageLabel()

@property(nonatomic,retain)UILabel  *pLabel;
@property(nonatomic,retain)UIFont   *pContentFont;
@property(nonatomic,retain)UIFont   *pTitleFont;
@property(nonatomic,retain)NSString *nsContent;
@property(nonatomic,retain)UIView   *pBackView;
@property(nonatomic,retain)UIColor  *pBackColor;
@property(nonatomic,retain)UIColor  *pTextColor;

@property(nonatomic)int             nTextAlignment;
@property(nonatomic)float           fCornRadius;
@property int                       nShowPosition;
@property(nonatomic)CGFloat         fTime;
@end

 /**
 *	@brief	定时显示label提示信息
 */
@implementation tztMessageLabel
@synthesize pLabel = _pLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pContentFont = tztUIBaseViewTextFont(14);
        _pTitleFont = tztUIBaseViewTextBoldFont(18);
        _pBackColor = [UIColor grayColor];
        _pTextColor = [UIColor blackColor];
        _nTextAlignment = -1;
        _fCornRadius = 2.5;
        _nShowPosition = 0;
    }
    return self;
}

-(void)setArrtibuteForShow:(NSDictionary *)dictArr
{
    if (dictArr == NULL || dictArr.count < 1)
        return;
    
    if ([dictArr objectForKey:tztLabelContentFont])
    {
        self.pContentFont = [dictArr objectForKey:tztLabelContentFont];
    }
    if ([dictArr objectForKey:tztLabelTextColor])
    {
        self.pTextColor = [dictArr objectForKey:tztLabelTextColor];
    }
    if ([dictArr objectForKey:tztLabelBackgroundColor])
    {
        self.pBackColor = [dictArr objectForKey:tztLabelBackgroundColor];
    }
    if ([dictArr objectForKey:tztLabelTextAligment])
    {
        self.nTextAlignment = [[dictArr objectForKey:tztLabelTextAligment] intValue];
    }
    if ([dictArr objectForKey:tztLabelCornRadius])
    {
        self.fCornRadius = [[dictArr objectForKey:tztLabelCornRadius] floatValue];
    }
    if ([dictArr objectForKey:tztLabelShowPosition])
    {
        self.nShowPosition = [[dictArr objectForKey:tztLabelShowPosition] intValue];
    }
}

-(void)ShowForView:(UIView*)pView
{
    if (self.nsContent == NULL || self.nsContent.length <= 0)
        return;
    
	UIWindow *viewWindow;// = view.window;
    //保证提示信息显示在最前面
    viewWindow = [[UIApplication sharedApplication] keyWindow];
    CGFloat angle;
    switch ([[UIApplication sharedApplication] statusBarOrientation])
    {
		case UIDeviceOrientationLandscapeLeft:
			angle = 0.5 * M_PI;
			break;
		case UIDeviceOrientationLandscapeRight:
			angle = -0.5 * M_PI;
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			angle = M_PI;
			break;
		case UIDeviceOrientationPortrait:
			angle = 0;
			break;
		default:
			return;
	}
	self.transform = CGAffineTransformMakeRotation(angle);
    CGRect frame = viewWindow.frame;
	self.frame = frame;
    
    self.window.windowLevel = UIWindowLevelAlert+1.0;
    
	CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	CGFloat topMargin = 32.0 + 2.0 + 5.0;
	CGFloat viewElementsHeight = topMargin + 5.0 + 2.0 + 32.0 + 6.0;
    //最大宽度
    CGFloat maxWidth = self.bounds.size.width - 2*32.0 - 2*2.0;
    //最小高度
    CGFloat minHeight = 62.0;
    //最大高度
    CGFloat maxHeight = self.frame.size.height - statusBarHeight - viewElementsHeight;
    CGRect scrollMaxRect = CGRectMake(32.0 + 2.0, topMargin, maxWidth, maxHeight);
    
    //计算行数
    //首先通过\r\n分割有几行
    int nLine = 0;
    int nLineHeight = self.pContentFont.lineHeight;
    CGSize sz = [self.nsContent sizeWithFont:self.pContentFont
                             constrainedToSize:scrollMaxRect.size
                               lineBreakMode:NSLineBreakByCharWrapping];
    minHeight = MAX(nLineHeight + topMargin, minHeight);
    nLine = sz.height / nLineHeight;
    if (((int)sz.height) % nLineHeight != 0)
    {
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
            nLineHeight = 20;
        }
        else
        {
        }
        
        nHeight = nLine * nLineHeight;
    }

    if (self.nShowPosition == 1)//底部
    {
        scrollMaxRect.origin.y = (scrollMaxRect.size.height - nHeight);
    }
    else if (self.nShowPosition == 2)//顶部
    {
        scrollMaxRect.origin.y += 44;
    }
    else
    {
        scrollMaxRect.origin.y += (scrollMaxRect.size.height - nHeight)/2;
    }
    
    CGRect rcText = CGRectMake(scrollMaxRect.origin.x, scrollMaxRect.origin.y, scrollMaxRect.size.width, nHeight);
    
    if (_pLabel == NULL)
    {
        _pLabel = [[[UILabel alloc] initWithFrame:rcText] autorelease];
        _pLabel.font = self.pContentFont;
        _pLabel.numberOfLines = 0;
        _pLabel.clipsToBounds = YES;
        _pLabel.layer.cornerRadius = self.fCornRadius;
        _pLabel.textAlignment = NSTextAlignmentCenter;
        self.pLabel.textColor = self.pTextColor;
        self.pLabel.backgroundColor = self.pBackColor;
        [self addSubview:_pLabel];
    
        self.layer.cornerRadius = self.fCornRadius;
    }
//    self.pLabel.frame = rcText;
    self.pLabel.text = self.nsContent;
    if (self.nTextAlignment > 0)
    {
        self.pLabel.textAlignment = self.nTextAlignment;
    }
    else
    {
        if (nLine <= 1)
        {
            self.pLabel.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            self.pLabel.textAlignment = NSTextAlignmentLeft;
        }
    }
    self.center = viewWindow.center;
    
    
    
    UIView *pBack = [viewWindow viewWithTag:0x99999];
    if (pBack == NULL)
    {
        pBack = [[UIView alloc] initWithFrame:self.bounds];
        pBack.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        pBack.tag = 0x99999;
        [viewWindow addSubview:pBack];
        pBack.userInteractionEnabled = YES;
        [pBack release];
        self.pBackView = pBack;
    }
    
    
	[viewWindow addSubview:self];
    
    self.alpha = 0.f;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 1.0f;
    }];
    
	[self setNeedsDisplay];
    
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(hide)
                                   userInfo:nil
                                    repeats:NO];
}


-(void) hide
{
    TZTLogInfo(@"%@", @"MessageLabel = hide");
    [self.pBackView removeFromSuperview];
//    //取最近的显示
//    [self showWithAnimated:[g_ayMessageBox lastObject] bShow_:YES];
//	[self removeFromSuperview];
//    return;
	//移除当前view
	[UIView beginAnimations:@"hideSelectionView" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    self.alpha = 0.1f;
//	self.center = CGPointMake(self.center.x, self.bounds.size.height + m_fBoxHeight / 2);
	[UIView commitAnimations];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    TZTLogInfo(@"%@", @"MessageBox = animationDidStop");
    [self.pBackView removeFromSuperview];
	[self removeFromSuperview];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

tztMessageLabel* tztAfxMessageLabel(NSString* strMsg)
{
    return tztAfxMessageLabelWithArrtibutes(strMsg, NULL);
}

tztMessageLabel* tztAfxMessageLabelWithArrtibutes(NSString* strMsg, NSDictionary* dictArr)
{
    CGRect appRect = [[UIScreen mainScreen] bounds];
    tztMessageLabel *pMsgLabel = [[tztMessageLabel alloc] initWithFrame:appRect];
    pMsgLabel.nsContent = strMsg;
    if (dictArr)
    {
        [pMsgLabel setArrtibuteForShow:dictArr];
    }
    [pMsgLabel ShowForView:[UIApplication sharedApplication].keyWindow];
    return [pMsgLabel autorelease];
}
