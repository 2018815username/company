//
//  tztStatusBar.m
//  tztbase
//
//  Created by King on 14-3-7.
//  Copyright (c) 2014年 yangares. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "tztStatusBar.h"

@interface tztUITextViewStatusBar : UITextView
@property (nonatomic,assign)id<tztStatusBarDelegate> tztDelegate;

@end

@implementation tztUITextViewStatusBar
@synthesize tztDelegate = _tztDelegate;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 取这个点点击的位置是在左边还是右边，并向delegate发出事件
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztStatusBarClicked:)])
    {
        [self.tztDelegate tztStatusBarClicked:nil];
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

@end

@interface tztStatusBar()

@property(nonatomic, retain, readonly) UIWindow *overlayWindow;
@property(nonatomic, retain, readonly) UIView   *topBar;
@property(nonatomic, retain) tztUITextViewStatusBar            *stringLabel;
@property(nonatomic, assign)id                  tztDelegate;
@property(nonatomic, assign)UIButton            *pBtnClick;
@property(nonatomic)int  nPosition;
@property(nonatomic, retain)NSDictionary *tztUserInfo;

@end

@implementation tztStatusBar
@synthesize overlayWindow = _overlayWindow;
@synthesize topBar = _topBar;
@synthesize stringLabel = _stringLabel;
@synthesize tztDelegate = _tztDelegate;
@synthesize pBtnClick = _pBtnClick;
@synthesize nPosition = _nPosition;
@synthesize tztUserInfo = _tztUserInfo;
+(tztStatusBar*)sharedView
{
    static dispatch_once_t once;
    static tztStatusBar *sharedView;
    dispatch_once(&once, ^{ sharedView = [[tztStatusBar alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedView;
}

+(void)tztShowMessageInStatus:(NSString *)nsStatus
{
    [tztStatusBar sharedView].nPosition = 0;
    [[tztStatusBar sharedView] showWithStatus:nsStatus barColor:[UIColor blackColor] textColor:[UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0]];
}

+(void)tztShowMessageInStatusBar:(NSString*)nsString    //显示内容
                        bgColor_:(UIColor*)bgColor      //背景色
                       txtColor_:(UIColor*)txtColor     //文本色
                       fTimeOut_:(CGFloat)fTime         //显示时间
                       delegate_:(id)delegate;          //回调处理使用
{
    [tztStatusBar tztShowMessageInStatusBar:nsString
                                   bgColor_:bgColor
                                  txtColor_:txtColor
                                  fTimeOut_:fTime
                                  delegate_:delegate
                                 nPosition_:0];
}

+(void)tztShowPushInfoInStatusBar:(NSDictionary *)userInfo bgColor_:(UIColor *)bgColor txtColor_:(UIColor *)txtColor fTimeOut_:(CGFloat)fTime delegate_:(id)delegate nPosition_:(int)nPosition
{
    [tztStatusBar sharedView].tztDelegate = delegate;
    [tztStatusBar sharedView].nPosition = nPosition;
    [tztStatusBar sharedView].tztUserInfo = userInfo;
    NSString* strMsg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    [[tztStatusBar sharedView] showWithStatus:strMsg barColor:bgColor textColor:txtColor];
    if (fTime > 0)
    {
        [tztStatusBar performSelector:@selector(dismiss) withObject:self afterDelay:fTime ];
    }
}

+(void)tztShowMessageInStatusBar:(NSString *)nsString bgColor_:(UIColor *)bgColor txtColor_:(UIColor *)txtColor fTimeOut_:(CGFloat)fTime delegate_:(id)delegate nPosition_:(int)nPosition
{
    [tztStatusBar sharedView].tztDelegate = delegate;
    [tztStatusBar sharedView].nPosition = nPosition;
    [[tztStatusBar sharedView] showWithStatus:nsString barColor:bgColor textColor:txtColor];
    if (fTime > 0)
    {
        [tztStatusBar performSelector:@selector(dismiss) withObject:self afterDelay:fTime ];
    }
}

+ (void)dismiss {
    [[tztStatusBar sharedView] tztDismiss];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

-(void)showWithStatus:(NSString*)status barColor:(UIColor*)barColor textColor:(UIColor*)textColor
{
    if (status == NULL)
        return;
    if (!self.superview)
        [self.overlayWindow addSubview:self];
    
    [self.overlayWindow setHidden:NO];
    [self.topBar setHidden:NO];
    [self.pBtnClick setHidden:NO];
    self.topBar.backgroundColor = barColor;
    NSString *labelText = [NSString stringWithFormat:@"%@",status];
    
    int nMargin = 0;
    if (_nPosition != 1)
    {
        _pBtnClick.hidden = YES;
    }
    if (labelText)
    {
        /*CGSize stringSize = */[labelText sizeWithFont:self.stringLabel.font
         constrainedToSize:CGSizeMake([self rotatedSize].width - nMargin , MAXFLOAT)
             lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    self.stringLabel.frame = CGRectMake(0, (self.topBar.bounds.size.height - self.stringLabel.font.lineHeight) / 2, self.topBar.bounds.size.width - nMargin, self.stringLabel.font.lineHeight);
    self.stringLabel.contentOffset = CGPointMake(0, 0);
    self.stringLabel.contentInset = UIEdgeInsetsZero;
    self.stringLabel.contentInset = UIEdgeInsetsMake(-8,0,0,0);
    self.stringLabel.alpha = 1.0;
    self.stringLabel.hidden = NO;
    self.stringLabel.text = labelText;
    self.stringLabel.textColor = [UIColor whiteColor];// textColor;
    
    [self.stringLabel.layer removeAllAnimations];
    [NSTimer scheduledTimerWithTimeInterval: 5.0f
                                     target: self
                                   selector:@selector(onTick)
                                   userInfo: nil repeats:NO];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.stringLabel.alpha = 1.0;
    }];
    [self setNeedsDisplay];
}

-(void)onTick
{
    //计算高度
    NSString *strText = self.stringLabel.text;
    NSString *labelText = [NSString stringWithFormat:@"%@",strText];
    if (labelText)
    {
        /*CGSize stringSize = */[labelText sizeWithFont:self.stringLabel.font
                                  constrainedToSize:CGSizeMake([self rotatedSize].width , MAXFLOAT)
                                      lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    int nOffset = self.stringLabel.font.lineHeight;// self.topBar.frame.size.height;
    CGPoint p = [self.stringLabel contentOffset];
    CGFloat f = p.y + nOffset;
    if (fabs(f) >= self.stringLabel.contentSize.height
        || (fabs(fabs(f) - self.stringLabel.contentSize.height)) < nOffset)
    {
        //自动关闭
        [tztStatusBar dismiss];
        return;
    }
    [self.stringLabel setContentOffset:CGPointMake(p.x, f) animated:YES];
    
    [self performSelector:@selector(onTick) withObject:nil afterDelay:5.0f];
}



- (void) tztDismiss
{
    self.tztDelegate = nil;
    [UIView animateWithDuration:0.4 animations:^{
        self.stringLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_topBar removeFromSuperview];
        DelObject(_topBar);
        
        [_pBtnClick removeFromSuperview];
        _pBtnClick = nil;
        
        [_overlayWindow removeFromSuperview];
        DelObject(_overlayWindow);
        
        self.tztDelegate = nil;
    }];
}

- (UIWindow *)overlayWindow {
    if(!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
        
        // Transform depending on interafce orientation
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation([self rotation]);
        self.overlayWindow.transform = rotationTransform;
        self.overlayWindow.bounds = CGRectMake(0.f, 0.f, [self rotatedSize].width, [self rotatedSize].height);
        
        // Register for orientation changes
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleRoration:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return _overlayWindow;
}

- (UIView *)topBar {
    if(!_topBar)
    {
        CGFloat fY = 0;
        CGFloat fHeight = 20.0f;
        if ([tztStatusBar sharedView].nPosition == 1)
        {
            UIViewController *pVC = g_navigationController.topViewController;
            CGRect rcFrame = pVC.view.frame;
            rcFrame.origin.y += rcFrame.size.height;
            fHeight = 35.0f;
            rcFrame.origin.y -= fHeight;
            if (!IS_TZTIOS(7))
                rcFrame.origin.y += TZTStatuBarHeight;
            fY = rcFrame.origin.y;
        }
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0.f, fY, [self rotatedSize].width, fHeight)];
        [_overlayWindow addSubview:_topBar];
    }
    return _topBar;
}

- (UITextView *)stringLabel {
    if (_stringLabel == nil) {
        _stringLabel = [[tztUITextViewStatusBar alloc] initWithFrame:CGRectZero];
        _stringLabel.tztDelegate = self;
        _stringLabel.editable = NO;
		_stringLabel.textColor = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
		_stringLabel.backgroundColor = [UIColor clearColor];
//		_stringLabel.adjustsFontSizeToFitWidth = YES;
//        _stringLabel.numberOfLines = 0;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        _stringLabel.textAlignment = UITextAlignmentLeft;
#else
        _stringLabel.textAlignment = NSTextAlignmentLeft;
#endif
//		_stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        if (_nPosition == 1)
            _stringLabel.font = tztUIBaseViewTextFont(15.0f);// [UIFont boldSystemFontOfSize:15.0];
        else
            _stringLabel.font = tztUIBaseViewTextFont(14.0f);
//		_stringLabel.shadowColor = [UIColor blackColor];
//		_stringLabel.shadowOffset = CGSizeMake(0, -1);
//        _stringLabel.numberOfLines = 0;
//        _stringLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    
    if(!_stringLabel.superview)
        [self.topBar addSubview:_stringLabel];
    
    return _stringLabel;
}

-(UIButton*)pBtnClick
{
    if (_nPosition != 1)
        return NULL;
    if (_pBtnClick == NULL)
    {
        _pBtnClick = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _pBtnClick.frame = CGRectMake([self rotatedSize].width - 35,
                                      self.topBar.frame.origin.y - 35,
                                      35,
                                      35);
        [_pBtnClick setBackgroundImage:[UIImage imageTztNamed:@"tztPushCloseBtn.png"] forState:UIControlStateNormal];
        _pBtnClick.showsTouchWhenHighlighted = YES;
        [_pBtnClick addTarget:self action:@selector(tztDismiss) forControlEvents:UIControlEventTouchUpInside];
        [_overlayWindow addSubview:_pBtnClick];
    }
    
    return _pBtnClick;
}

#pragma mark - Handle Rotation

- (CGFloat)rotation
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat rotation = 0.f;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft: { rotation = -M_PI_2; } break;
        case UIInterfaceOrientationLandscapeRight: { rotation = M_PI_2; } break;
        case UIInterfaceOrientationPortraitUpsideDown: { rotation = M_PI; } break;
        case UIInterfaceOrientationPortrait: { } break;
        default: break;
    }
    return rotation;
}

- (CGSize)rotatedSize
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize rotatedSize = screenSize;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft: { rotatedSize = CGSizeMake(screenSize.height, screenSize.width); } break;
        case UIInterfaceOrientationLandscapeRight: { rotatedSize = CGSizeMake(screenSize.height, screenSize.width); } break;
        case UIInterfaceOrientationPortraitUpsideDown: { } break;
        case UIInterfaceOrientationPortrait: { } break;
        default: break;
    }
    return rotatedSize;
}

- (void)handleRoration:(id)sender
{
    // Based on http://stackoverflow.com/questions/8774495/view-on-top-of-everything-uiwindow-subview-vs-uiviewcontroller-subview
    
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation([self rotation]);
    [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration]
                     animations:^{
                         self.overlayWindow.transform = rotationTransform;
                         // Transform invalidates the frame, so use bounds/center
                         self.overlayWindow.bounds = CGRectMake(0.f, 0.f, [self rotatedSize].width, [self rotatedSize].height);
                         
                         CGFloat fY = 0;
                         CGFloat fHeight = 20;
                         if ([tztStatusBar sharedView].nPosition == 1)
                         {
                             fHeight = 35;
                             UIViewController *pVC = g_navigationController.topViewController;
                             CGRect rcFrame = pVC.view.frame;
                             rcFrame.origin.y += rcFrame.size.height;
                             rcFrame.origin.y -= fHeight;
                             if (!IS_TZTIOS(7))
                                 rcFrame.origin.y += TZTStatuBarHeight;
                             fY = rcFrame.origin.y;
                         }
                         self.topBar.frame = CGRectMake(0.f, fY, [self rotatedSize].width, fHeight);
                         
                         self.pBtnClick.frame = CGRectMake([self rotatedSize].width - 35,
                                                       self.topBar.frame.origin.y - 35,
                                                       35,
                                                       35);
                     }];
}

-(void)tztStatusBarClicked:(tztStatusBar *)statusBar
{
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztStatusBarClicked:)])
    {
        [self.tztDelegate tztStatusBarClicked:self];
    }
    [self tztDismiss];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self OnClick:nil];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([_stringLabel pointInside:point withEvent:event])
    {
        return [super hitTest:point withEvent:event];
    }
    return [[UIApplication sharedApplication].keyWindow hitTest:point withEvent:event];
}
@end
