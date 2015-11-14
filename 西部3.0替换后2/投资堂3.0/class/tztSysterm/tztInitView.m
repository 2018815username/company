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

#import "tztInitView.h"
#import "TZTAppObj.h"
@interface tztInitView(tztPrivate)
-(void) InitAllControl;
@end

@implementation tztInitView
@synthesize imageview = _imageview;
@synthesize tipinfo = _tipinfo;
@synthesize tztdelegate = _tztdelegate; //回调接口

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
    {
        [self InitAllControl];
    }
    return self;
}

-(void) InitAllControl
{
    NSString* strUrl = [TZTCSystermConfig getShareClass].tztiniturl;
    if(_imageview == nil)
    {
        _imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageview];
        [_imageview release];
    }
#ifndef tzt_GJSC
    self.tipinfo = [NSString stringWithFormat:@"%@",@"正在加载数据,请稍候..."];
#else
    self.tipinfo = @"";
#endif
    if (IS_TZTIPAD)
    {
        strUrl = [strUrl stringByAppendingString:@"640x1136.png"];
        if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
            [_imageview setImageFromUrlEx:strUrl atFile:@"Default.png"];

        }
        else{
            
            [_imageview setImageFromUrlEx:strUrl atFile:@"Default-Landscape.png"];

        }
    }
    else
    {
          //iphone5
        if (IS_TZTIphone5)
        {
            strUrl = [strUrl stringByAppendingString:@"640x1136.png"];
            [_imageview setImageFromUrlEx:strUrl atFile:@"Default-568h@2x.png"];
        }
        else{
            strUrl = [strUrl stringByAppendingString:@"320x480.png"];
            [_imageview setImageFromUrlEx:strUrl atFile:@"Default.png"];
        }
      }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(_imageview)
    {
        if (!IS_TZTIPAD)
            _imageview.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
        else
            _imageview.frame = CGRectMake(0, 0, g_nScreenWidth, g_nScreenHeight);
    }
}

- (void)dealloc 
{
    [self endInitTimer];
    NilObject(self.tztdelegate);
    [super dealloc];
}

- (void)endInitTimer
{
    [tztUIProgressView hidden];
	if (_initTimer)
	{
		dispatch_source_cancel(_initTimer);
		_initTimer = NULL;
	}
}

- (void)initTimeOut
{
    dispatch_block_t block = ^{ @autoreleasepool
        {
            if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztInitViewTimeOut:)])
            {
                [_tztdelegate tztInitViewTimeOut:self];
            }
        }};
    
    if (dispatch_get_current_queue() == dispatch_get_main_queue())
        block();
    else
        dispatch_sync(dispatch_get_main_queue(), block);
}

//进度取消
- (void)tztUIProgressViewCancel:(tztUIProgressView *)tztProgressView
{
    [self endInitTimer];
    [self initTimeOut];
}

- (void)setupInitTimerWithTimeout:(NSTimeInterval)timeout
{
    [self endInitTimer];
#ifndef Support_HTSC
#ifndef tzt_GJSC
    [tztUIProgressView showWithMsg:self.tipinfo withdelegate:self];
#endif
#endif
	if (timeout >= 0.0)
	{
		_initTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
		dispatch_source_set_event_handler(_initTimer, ^{ @autoreleasepool {
            //超时----------------------------------------
            TZTLogInfo(@"超时:%@",self.tipinfo);
            [self initTimeOut];
            //------------------------------- --------------------
                        
		}});
		
		dispatch_source_t theInitTimer = _initTimer;
		dispatch_source_set_cancel_handler(_initTimer, ^{
			dispatch_release(theInitTimer);
		});
		
		dispatch_time_t tt = dispatch_time(DISPATCH_TIME_NOW, (timeout * NSEC_PER_SEC));
		
		dispatch_source_set_timer(_initTimer, tt, DISPATCH_TIME_FOREVER, timeout/10);
		dispatch_resume(_initTimer);
	}
}

-(void)setTipText:(NSString*)strTip
{
    TZTLogInfo(@"%@",strTip);
    self.tipinfo = [NSString stringWithFormat:@"%@\r\n点击取消",strTip];
}

@end
