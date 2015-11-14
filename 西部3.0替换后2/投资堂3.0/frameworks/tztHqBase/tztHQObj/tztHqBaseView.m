/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztHqBaseView.m
 * 文件标识：
 * 摘    要：行情基类视图 通讯 通用参数定义
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import "tztHqBaseView.h"

int g_nHQBackBlackColor = 1;
int g_nHKShowTenPrice = 0;
int g_nHKHasRight = 0;//港股强制拥有权限
BOOL g_bUseHQAutoPush = FALSE;
@interface tztHqBaseView ()<UIGestureRecognizerDelegate>
@property(nonatomic,retain)UISwipeGestureRecognizer *swipeLeft;
@property(nonatomic,retain)UISwipeGestureRecognizer *swipeRight;

@end

@implementation tztHqBaseView
@synthesize tztdelegate = _tztdelegate;
@synthesize pStockInfo = _pStockInfo;
@synthesize nsBackColor = _nsBackColor;
@synthesize bRequest = _bRequest;
@synthesize bAddSwipe = _bAddSwipe;
@synthesize swipeLeft = _swipeLeft;
@synthesize swipeRight = _swipeRight;
@synthesize bAutoPush = _bAutoPush;
- (id)init
{
    self = [super init];
    if (self) {
        [self initdata];
    }
    return self; 
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        [self initdata];
    }
    return self; 
} 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initdata];
    }
    return self;
}

- (void)dealloc
{
    DelObject(_pStockInfo);
    _tztdelegate = nil;
    [super dealloc];
}

- (void)removeFromSuperview
{
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    
    [super removeFromSuperview];
}


#pragma tztSocketData Delegate
- (NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    return 0;
}

-(NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    if (!_bAutoPush)
        [self onRequestData:FALSE];
    return 1;
}

-(void)setBAddSwipe:(BOOL)bSwipe
{
    _bAddSwipe = bSwipe;
    if (_bAddSwipe)
    {
        
        if (_swipeLeft == NULL)
        {
            _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(SwipeLeftOrRight:)];
            _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
            _swipeLeft.delegate = self;
            [self addGestureRecognizer:_swipeLeft];
            [_swipeLeft release];
        }
        if (_swipeRight == NULL)
        {
            _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(SwipeLeftOrRight:)];
            _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
            _swipeRight.delegate = self;
            [self addGestureRecognizer:_swipeRight];
            [_swipeRight release];
        }
    }
}
-(void)SwipeLeftOrRight:(UISwipeGestureRecognizer*)recognsizer
{
    if (self.tztdelegate && [self.tztdelegate respondsToSelector:@selector(tztOnSwipe:andView_:)])
    {
        [self.tztdelegate tztOnSwipe:recognsizer andView_:self];
    }
    
}

//初始化数据
- (void)initdata
{
    _ntztHqReq = 0;
    if (g_nHQBackBlackColor)
    {
        _nsBackColor = @"0";//默认黑色
    }
    else
    {
        _nsBackColor = @"1";
    }
    _bRequest = TRUE;
    self.backgroundColor = [UIColor tztThemeBackgroundColor];
//    if (g_nThemeColor == 0)
//    {
//        self.backgroundColor = [UIColor colorWithTztRGBStr:@"34,35,36"];
//    }
//    else if (g_nThemeColor == 1)
//    {
//        self.backgroundColor = [UIColor colorWithTztRGBStr:@"240,240"];
//    }
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
//    _bRequest = !hidden;
}

//设置是否自动刷新
- (void)onSetViewRequest:(BOOL)bRequest;
{
    _bRequest = bRequest;
    if (!_bRequest)//不请求数据，从通讯数组中移除当前句柄
    {
        [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    }
    else//请求数据，则添加
    {
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
    }
}

//设置代码并请求数据
-(void)setStockInfo:(tztStockInfo*)pStockInfo Request:(int)nRequest
{
    if (pStockInfo && pStockInfo.stockCode)
    {
        self.pStockInfo = pStockInfo;
    }
    if(nRequest)
    {
        [self onClearData];
        _bRequest = TRUE;
        [self onRequestData:TRUE];	 
    }
}

-(void)setStockCode:(NSString *)strStockCode Request:(int)nRequest
{
    if (strStockCode == NULL || [strStockCode length] <= 0)
        return;
    tztStockInfo* pStockInfo = NewObject(tztStockInfo);
    pStockInfo.stockCode = [NSString stringWithFormat:@"%@", strStockCode];
    [self setStockInfo:pStockInfo Request:nRequest];
    [pStockInfo release];
}

-(tztStockInfo*)GetCurrentStock
{
    return self.pStockInfo;
}

//清空数据
- (void)onClearData
{
   
}

//发送请求 设置定时器
- (void)onRequestData:(BOOL)bShowProcess
{

}

//收到主推，重新请求数据
- (void)onRequestDataAutoPush
{
    
}
//菜单点击
-(BOOL)OnToolbarMenuClick:(id)sender
{
    return FALSE;
}

#pragma 主推
-(void)didReceiveAutoPushData:(id)sender
{
    NSLog(@"收到主推数据请求:%@", NSStringFromClass(self.class));
    [self onRequestDataAutoPush];
}
@end
