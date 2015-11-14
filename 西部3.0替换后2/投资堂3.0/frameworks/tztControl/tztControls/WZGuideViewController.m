//
//  WZGuideViewController.m
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import "WZGuideViewController.h"

@interface WZGuideViewController ()
{
    BOOL _animating;
    UIPageControl * _pagecontroll;
    UIScrollView *_pageScroll;
    NSMutableArray *imageNameArray;
}

@property(nonatomic)NSInteger  nPreIndex;

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, retain) UIPageControl * pagecontroll;
@property (nonatomic, retain) UIScrollView *pageScroll;
@property (nonatomic, copy) void (^blockcomple)(void);
+ (WZGuideViewController *)sharedGuide;

@end

@implementation WZGuideViewController
@synthesize blockcomple = _blockcomple;
@synthesize nPreIndex = _nPreIndex;
@synthesize animating = _animating;
@synthesize pagecontroll = _pagecontroll;
@synthesize pageScroll = _pageScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark -

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[WZGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[WZGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
    _nPreIndex = -1;
    [self didAnimationShow:0];
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
	//	[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[WZGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[WZGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[WZGuideViewController sharedGuide] showGuide];
    [g_navigationController.topViewController viewDidDisappear:NO];
}

+(void)showWithcompletion_:(void (^)(void))completion
{
    [WZGuideViewController sharedGuide].blockcomple = completion;
    [WZGuideViewController show];
}

+ (void)hide
{
	[[WZGuideViewController sharedGuide] hideGuide];
}

#pragma mark - 

+ (WZGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static WZGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    
    NSString* strSystemVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:strSystemVer forKey:@"lanuchedVersion"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.blockcomple)
    {
        self.blockcomple();
    }
//    UIApplication *app = [UIApplication sharedApplication];
    
    //需要调试
//    [[TZTAppObj getShareInstance] showvc];
    
//    id <StartVC> delegate;
//    delegate = app.delegate;
//    if ([app.delegate respondsToSelector:@selector(showvc)])
//    {
//        [delegate showvc];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_nPreIndex == [imageNameArray count] - 1)
    {
        if (scrollView.contentOffset.x > (scrollView.frame.size.width * _nPreIndex))
        {
            [self pressEnterButton:nil];
        }
    }
//     if (_pagecontroll.currentPage == ([imageNameArray count] -1 ))
//    {
//        if (scrollView.contentOffset.x > (scrollView.frame.size.width * _pagecontroll.currentPage))
//        {
//            [self pressEnterButton:nil];
//        }
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView
{
    NSInteger index = fabs(sView.contentOffset.x) / sView.frame.size.width;
    [_pagecontroll setCurrentPage:index];
    [self didAnimationShow:index];
}

-(void)didAnimationShow:(NSInteger)index
{
    UIImageView* view = (UIImageView*)[self.pageScroll viewWithTag:index+0x1234];
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:g_nsBundlename ofType:@"bundle"]];
//    if (_nPreIndex != index && _nPreIndex > - 1 && _nPreIndex < [imageNameArray count])
//    {
//        UIImageView *preView = (UIImageView*)[self.pageScroll viewWithTag:_nPreIndex + 0x1234];
//        NSString* imgName = [imageNameArray objectAtIndex:_nPreIndex];
//        [preView setImage:nil];
//        [preView setImage:[UIImage imageTztNamed:imgName]];
//    }
    if (_nPreIndex >= index)
        return;
    _nPreIndex = index;
    
    NSString* imgName = [imageNameArray objectAtIndex:index];
    NSArray *ay = [imgName componentsSeparatedByString:@"."];
    if (ay.count > 1)
    {
        NSString* str = [ay objectAtIndex:1];
        if (str && [str caseInsensitiveCompare:@"gif"] == NSOrderedSame)
        {
            NSString * strPath = [bundle pathForResource:[ay objectAtIndex:0] ofType:@"gif" inDirectory:@"image"];
            NSData *gifData = [NSData dataWithContentsOfFile:strPath];
            NSMutableArray *frames = nil;
            
            CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
            double total = 0;
//            NSTimeInterval gifAnimationDuration;
            if (src)
            {
                size_t l = CGImageSourceGetCount(src);
                if (l > 1)
                {
                    frames = [NSMutableArray arrayWithCapacity: l];
                    for (size_t i = 0; i < l; i++)
                    {
                        CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
                        NSDictionary *dict = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
                        CGFloat delayTime = 0;
                        CGFloat pixelHeight = 0;
                        CGFloat pixelWidth = 0;
                        if (dict)
                        {
                            delayTime = [[dict objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] floatValue];
                            pixelHeight = [[dict objectForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
                            pixelWidth = [[dict objectForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
                            
                            NSDictionary *tmpdict = [dict objectForKey: @"{GIF}"];
                            total += [[tmpdict objectForKey: @"DelayTime"] doubleValue] * 30/3;
                            [dict release];
                        }
                        if (img)
                        {
//                            gifAnimationDuration += delayTime/30;
//                            [frames addObject:[UIImage imageWithCGImage:img]];
                            UIImage *image = [UIImage imageWithCGImage:img];
                            NSDictionary *ddd = [NSDictionary dictionaryWithObjectsAndKeys:view, @"imageView", image , @"image", nil];
                            [self performSelector:@selector(show:) withObject:ddd afterDelay:total/30];
                            CGImageRelease(img);
                        }
                    }
                    
//                    view.animationImages = frames;
//                    view.animationDuration = gifAnimationDuration;
//                    view.animationRepeatCount = 1;
//                    [view startAnimating];
                }
             
                
                CFRelease(src);
            }
        }
    }
    _nPreIndex = index;
}

-(void)show:(NSDictionary*)sender
{
    dispatch_block_t block = ^{ @autoreleasepool
        {
            UIImageView *imgV = [sender objectForKey:@"imageView"];
            UIImage     *img = [sender objectForKey:@"image"];
            
            imgV.image = img;
        }};
    
    if (dispatch_get_current_queue() == dispatch_get_main_queue())
        block();
    else
        dispatch_sync(dispatch_get_main_queue(), block);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
     tztStart_step1.png
     tztStart_step2.png
     tztStart_step3.png
     tztStart_step4.png
     tztStart_step5.png
     tztStart_step6.png
     tztStartbtn_nor@2x.png
     tztStartbtn_press@2x.png
     */
    if (imageNameArray == NULL)
        imageNameArray = NewObject(NSMutableArray);
    [imageNameArray removeAllObjects];
    NSString *strImages = @"";
    if (IS_TZTIphone5)
    {
        strImages = @"tztStart_step1-568h,tztStart_step2-568h,tztStart_step3-568h,tztStart_step4-568h,tztStart_step5-568h";
#ifdef tztStartForIPhone5
        strImages = [NSString stringWithFormat:@"%@", tztStartForIPhone5];
#endif
    }
    else
    {
        strImages = @"tztStart_step1,tztStart_step2,tztStart_step3,tztStart_step4,tztStart_step5";
#ifdef tztStartForIPhone
        strImages = [NSString stringWithFormat:@"%@", tztStartForIPhone];
#endif
    }
    NSArray *ay = [strImages componentsSeparatedByString:@","];
    for (int i = 0; i < [ay count]; i++)
    {
        [imageNameArray addObject:[ay objectAtIndex:i]];
    }
    
    CGRect rcFrame = self.view.bounds;
#ifdef __IPHONE_7_0
    if (IS_TZTIOS(7))
    {
//        rcFrame.origin.y += TZTStatuBarHeight;
        rcFrame.size.height -= TZTStatuBarHeight;
    }
#endif
//    rcFrame.size.height -= TZTStatuBarHeight;
    self.view.backgroundColor = [UIColor blackColor];
    _pageScroll = [[UIScrollView alloc] initWithFrame:rcFrame];
    self.pageScroll.pagingEnabled = YES;
    _pageScroll.backgroundColor = [UIColor blackColor];
    self.pageScroll.delegate = self;
    self.pageScroll.contentSize = CGSizeMake(rcFrame.size.width * imageNameArray.count, rcFrame.size.height);
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.pageScroll];
    
#ifndef tzt_HiddenGuidePageControll
    _pagecontroll = [[UIPageControl alloc] initWithFrame:CGRectMake((rcFrame.size.width - 80) / 2, rcFrame.size.height - 30, 80, 10)];
    [_pagecontroll setBackgroundColor:[UIColor clearColor]];
    _pagecontroll.currentPage = 0;
    _pagecontroll.numberOfPages = imageNameArray.count;
    
    if (IS_TZTIOS(6))
    {
#ifdef tzt_StartPageContro_PageIndicatorTintColor
        _pagecontroll.pageIndicatorTintColor = [UIColor colorWithTztRGBStr:tzt_StartPageContro_PageIndicatorTintColor];
#else
        _pagecontroll.pageIndicatorTintColor = [UIColor grayColor];
#endif
        
#ifdef tzt_StartPageContro_CurrentPageIndicatorTintColor
        _pagecontroll.currentPageIndicatorTintColor = [UIColor colorWithTztRGBStr:tzt_StartPageContro_CurrentPageIndicatorTintColor];
#else
        _pagecontroll.currentPageIndicatorTintColor = [UIColor blackColor];
#endif
    }
    
    _pagecontroll.userInteractionEnabled = FALSE;
    [self.view addSubview:_pagecontroll];
#endif
    NSString *imgName = nil;
    UIImageView *view;
    for (int i = 0; i < imageNameArray.count; i++)
    {
        imgName = [imageNameArray objectAtIndex:i];
        view = [[UIImageView alloc] initWithFrame:CGRectMake((rcFrame.size.width * i), 0.f, rcFrame.size.width, rcFrame.size.height)];
        [view setImage:[UIImage imageTztNamed:imgName]];
        view.tag = 0x1234+i;
        view.userInteractionEnabled = YES;
//        view.backgroundColor = [UIColor colorWithPatternImage:];
        [self.pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {            
            UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(80.f, 355.f, 15.f, 15.f)];
            [checkButton setImage:[UIImage imageTztNamed:@"checkBox_selectCheck"] forState:UIControlStateSelected];
            [checkButton setImage:[UIImage imageTztNamed:@"checkBox_blankCheck"] forState:UIControlStateNormal];
            [checkButton addTarget:self action:@selector(pressCheckButton:) forControlEvents:UIControlEventTouchUpInside];
            [checkButton setSelected:YES];
            [view addSubview:checkButton];
            
            UIImage *image = [UIImage imageTztNamed:@"tztStartBtn_nor"];
            CGSize size = image.size;
            if (image == NULL)
            {
                size.width = self.view.bounds.size.width;
                size.height = 130;
            }
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];//
#ifdef tzt_Start_Btn_Offset
            enterButton.frame = CGRectMake((rcFrame.size.width - size.width) / 2, rcFrame.size.height - size.height - _pagecontroll.frame.size.height - tzt_Start_Btn_Offset - 10, size.width, size.height);
#else
            enterButton.frame = CGRectMake((rcFrame.size.width - size.width) / 2, rcFrame.size.height - size.height - _pagecontroll.frame.size.height - 10, size.width, size.height);
#endif
            [enterButton setBackgroundImage:image forState:UIControlStateNormal];
            enterButton.showsTouchWhenHighlighted = YES;
            enterButton.backgroundColor = [UIColor clearColor];
//            [enterButton setTitle:@"开始使用涨乐财富通" forState:UIControlStateNormal];
//            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//            [enterButton setCenter:CGPointMake(self.view.center.x, 417.f)];
//            [enterButton setBackgroundImage:[UIImage imageTztNamed:@"tztStartbtn_nor"] forState:UIControlStateNormal];
//            [enterButton setBackgroundImage:[UIImage imageTztNamed:@"tztStartbtn_press"] forState:UIControlStateHighlighted];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [imageNameArray release];
    [_pagecontroll release];
    [_pageScroll release];
    [super dealloc];
}


@end
