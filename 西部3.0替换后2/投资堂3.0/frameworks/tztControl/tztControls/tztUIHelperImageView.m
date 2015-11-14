//
//  tztUIHelperImage.m
//  tztbase
//
//  Created by King on 14-3-20.
//  Copyright (c) 2014年 yangares. All rights reserved.
//

#define tztUIHelperRecord       @"tztUIHelperRcord.plist"

#import "tztUIHelperImageView.h"

@interface tztUIHelperImageView ()
@property(nonatomic, retain, readonly) UIWindow *overlaywindow;
@property(nonatomic, retain)NSString    *nsImageName;
@property(nonatomic, retain)NSString    *nsClassName;
@property(nonatomic, retain)UIImageView *pImageView;
@end

@implementation tztUIHelperImageView
@synthesize nsImageName = _nsImageName;
@synthesize nsClassName = _nsClassName;
@synthesize overlaywindow = _overlaywindow;
@synthesize pImageView = _pImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.8f;
        
        //读取当前配置文件信息
        NSMutableDictionary* pDict = GetDictByListName(tztUIHelperRecord);
        //判断版本号
        if (pDict)
        {
            NSString *nsVersion = [pDict tztObjectForKey:@"tztVersion"];
            //当前版本
            NSString* strSystemVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            
            //判断不同版本，取消原先的纪录
            if (nsVersion && [nsVersion caseInsensitiveCompare:strSystemVer] != NSOrderedSame)
            {
                [pDict removeAllObjects];
                SetDictByListName(pDict, tztUIHelperRecord);
            }
        }
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self tztDismiss];
}

-(void)tztDismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        self.pImageView.alpha = 0.0;
        self.overlaywindow.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [_pImageView removeFromSuperview];
        DelObject(_pImageView);
        [_overlaywindow removeFromSuperview];
        DelObject(_overlaywindow);
    }];
}

-(UIWindow*)overlaywindow
{
    if (!_overlaywindow)
    {
        _overlaywindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlaywindow.backgroundColor = [UIColor clearColor];
        _overlaywindow.userInteractionEnabled = YES;
        _overlaywindow.windowLevel = UIWindowLevelAlert;
        
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation([self rotation]);
        self.overlaywindow.transform = rotationTransform;
        self.overlaywindow.bounds = CGRectMake(0.f, 0.f, [self rotatedSize].width, [self rotatedSize].height);
        
        // Register for orientation changes
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleRoration:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return _overlaywindow;
}

-(UIImageView*)pImageView
{
    if (!_pImageView)
    {
        CGRect rcFrame = [UIScreen mainScreen].bounds;
//        rcFrame.origin.y += TZTStatuBarHeight;
//        rcFrame.size.height -= TZTStatuBarHeight;
        _pImageView = [[UIImageView alloc] initWithFrame:rcFrame];
        [_overlaywindow addSubview:_pImageView];
    }
    return _pImageView;
}

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
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation([self rotation]);
    [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration]
                     animations:^{
                         self.overlaywindow.transform = rotationTransform;
                         // Transform invalidates the frame, so use bounds/center
                         self.overlaywindow.bounds = CGRectMake(0.f, 0.f, [self rotatedSize].width, [self rotatedSize].height);
                     }];
}


+(tztUIHelperImageView*)getShareInstance
{   
    static dispatch_once_t once;
    static tztUIHelperImageView *sharedView;
    dispatch_once(&once, ^{ sharedView = [[tztUIHelperImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedView;
}

+(void)tztShowHelperView:(NSString*)nsImageName forClass_:(NSString*)nsClassName
{
    //先判断有效性
    if (!ISNSStringValid(nsClassName) || !ISNSStringValid(nsImageName))
        return;
    //读取当前配置文件信息
    NSMutableDictionary* pDict = GetDictByListName(tztUIHelperRecord);
    if (pDict == NULL || [pDict count] < 1)
    {
        if (pDict == NULL)
        {
            pDict = NewObjectAutoD(NSMutableDictionary);
        }
        NSString* strSystemVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        [pDict setTztObject:strSystemVer forKey:@"tztVersion"];
    }
    
    //已经存在，不提示，直接return
    if ([pDict tztObjectForKey:nsClassName] != NULL)
    {
        return;
    }
    
    [pDict setTztObject:@"1" forKey:nsClassName];
    SetDictByListName(pDict, tztUIHelperRecord);
    [[tztUIHelperImageView getShareInstance] tztShowHelperView:nsImageName forClass_:nsClassName];
}

-(void)tztShowHelperView:(NSString*)nsImageName forClass_:(NSString*)nsClassName
{
    UIImage* image = [UIImage imageTztNamed:nsImageName];
    if (image == nil)
        return;
    if (!self.superview)
        [self.overlaywindow addSubview:self];
    [self.overlaywindow setHidden:NO];
    [self.pImageView setHidden:NO];
   
    //重新设置区域
    CGSize szImage = image.size;
    CGRect rcImage = [UIScreen mainScreen].bounds;
    if (szImage.width != self.pImageView.frame.size.width)//宽度不同，进行缩放操作
    {
        self.overlaywindow.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
        rcImage.size.height = ([UIScreen mainScreen].bounds.size.width/szImage.width)*(szImage.height);
        rcImage.origin.x = ([UIScreen mainScreen].bounds.size.width - szImage.width) / 2;
        rcImage.origin.y += ([UIScreen mainScreen].bounds.size.height - szImage.height) / 2;
        rcImage.size = szImage;
        self.pImageView.frame = rcImage;
        self.pImageView.center = self.overlaywindow.center;
    }
    else
    {
        self.overlaywindow.backgroundColor = [UIColor clearColor];
        rcImage.size = image.size;
    }
    
    [self.pImageView setImage:image];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        self.pImageView.alpha = 1.0;
    }];
    [self setNeedsDisplay];
}

+(void)tztHelperViewDismiss
{
    [[tztUIHelperImageView getShareInstance] tztDismiss];
}
@end
