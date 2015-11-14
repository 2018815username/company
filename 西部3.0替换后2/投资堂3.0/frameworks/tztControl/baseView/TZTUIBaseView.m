/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        TZTUIBaseView
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseView.h"

int g_nUsePNGInTableGrid = 0;//表格中是否使用图片作为背景

@implementation tztBaseViewUIView
- (id)init
{
    if(self = [super init])
    {
        _ayToolBar = NewObject(NSMutableArray);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _ayToolBar = NewObject(NSMutableArray);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        _ayToolBar = NewObject(NSMutableArray);
    }
    return self;
}

- (void)addToolBar:(UIView *)pView
{
    [_ayToolBar addObject:pView];
}

- (NSMutableArray*)GetAyToolBar
{
    return _ayToolBar;
}

- (void)removeAllToolBar
{
    for (int i = 0; i < [_ayToolBar count]; i++)
    {
        UIView* pView = (UIView *)[_ayToolBar objectAtIndex:i];
        if(pView)
        {
            [pView removeFromSuperview];
        }
    }
    [_ayToolBar removeAllObjects];
}

- (void)dealloc
{
    if(_ayToolBar)
    {
        [_ayToolBar removeAllObjects];
    }
    DelObject(_ayToolBar);
    [super dealloc];
}
@end

@implementation TZTUIBaseView
@synthesize pDelegate = _pDelegate;
@synthesize cBeSending = _cBeSending;
@synthesize nsStockCode = _nsStockCode;
@synthesize ntztReqNo = _ntztReqNo;
@synthesize pStockInfo = _pStockInfo;
@synthesize nMsgType = _nMsgType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.nsStockCode = @"";
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        self.pDelegate = nil;
        self.nsStockCode = @"";
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setFrame:(CGRect)frame //
{
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTNiceBack.png"]];
    //加边框
    CGRect rcFrame = frame;
    
    [super setFrame:rcFrame];
#if 0 //这里相当于注释
    self.layer.cornerRadius = 6.0f;
    self.layer.shadowColor = [UIColor colorWithRed:163.0/255 green:163.0/255 blue:163.0/255 alpha:1].CGColor;  
    self.layer.shadowOffset = CGSizeMake(4, 4);
    self.layer.shadowRadius = 0.6f;
    self.layer.masksToBounds = YES;
//    self.layer.borderWidth = 1.0f;
//    self.layer.borderColor=[[UIColor colorWithRed:163.0/255 green:163.0/255 blue:163.0/255 alpha:1] CGColor];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:0].CGPath;
#endif
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self OnCloseKeybord:self];
}

-(BOOL) OnCloseKeybord:(UIView*)pView
{
	if(pView && [pView isKindOfClass:[UIResponder class]] )
	{
		[pView resignFirstResponder];		
	}
	NSArray* pAyView = [pView subviews];
	for(int i = 0; i< [pAyView count]; i++)
	{
		UIView* pSubView = [pAyView objectAtIndex:i];
		if(pSubView)
		{
			[self OnCloseKeybord:pSubView];
		}
	}
	return FALSE;
}

//菜单点击
-(BOOL)OnToolbarMenuClick:(id)sender
{
    return FALSE;
}

-(void)OnReturnBack
{
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(OnReturnBack)])
    {
        [_pDelegate tztperformSelector:@"OnReturnBack"];
//        [_pDelegate OnReturnBack];
    }
}
@end



//在这个方法里面 将nMsgID转换成 文字 比如 12701转换成“基金交易”
NSString* GetTitleByID(NSInteger nMsgID)
{
    NSString* nsID = [NSString stringWithFormat:@"Fuction:%ld", (long)nMsgID];
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:g_nsBundlename ofType:@"bundle"]];
    if (bundle == nil)//指定bundle下没有，到通用里面去查
    {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tzt" ofType:@"bundle"]];
        if (bundle == nil)
            return nsID;
    }
    
    NSString *bundlePath = [bundle pathForResource:@"tztLocalizable" ofType:@"strings" inDirectory:nil forLocalization:nil];
    NSBundle *spanishBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
    
//    NSString* nsTitleOne =  NSLocalizedStringFromTable(@"Fuction:12384", @"tztLocalizable", nil);
//    NSLog(@"%@",nsTitleOne);
    NSString * xx =    NSLocalizedStringWithDefaultValue(nsID, @"tztLocalizable", spanishBundle, nil, nsID);
    NSLog(@"%@",xx);
    NSString* nsTitle = NSLocalizedStringFromTableInBundle(nsID, @"tztLocalizable", spanishBundle, nsID);
    if ([nsTitle compare:nsID] == NSOrderedSame)
        nsTitle = nil;
    else
        nsTitle = [NSString stringWithFormat:@"%@",nsTitle];
    [spanishBundle release];
    
    if (nsTitle == nil)//到通用里面查找
    {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tzt" ofType:@"bundle"]];
        if (bundle == nil)
            return nsID;
        
        NSString *bundlePath = [bundle pathForResource:@"tztLocalizable" ofType:@"strings" inDirectory:nil forLocalization:nil];
        
        NSBundle *spanishBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
        
        nsTitle = NSLocalizedStringFromTableInBundle(nsID, @"tztLocalizable", spanishBundle, nsID);
        if ([nsTitle compare:nsID] == NSOrderedSame)
            nsTitle = nil;
        else
            nsTitle = [NSString stringWithFormat:@"%@",nsTitle];
        [spanishBundle release];
    }
    return nsTitle;
}

NSString* GetActionByID(NSInteger nMsgID)
{
    NSString* nsID = [NSString stringWithFormat:@"Action:%ld", (long)nMsgID];
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:g_nsBundlename ofType:@"bundle"]];
    if (bundle == nil)//指定bundle下没有，到通用里面去查
    {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tzt" ofType:@"bundle"]];
        if (bundle == nil)
            return nsID;
    }
    

    
    NSString *bundlePath = [bundle pathForResource:@"tztLocalizable" ofType:@"strings" inDirectory:nil forLocalization:nil];
    NSBundle *spanishBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
    
    NSString* nsTitle = NSLocalizedStringFromTableInBundle(nsID, @"tztLocalizable", spanishBundle, nsID);
    if ([nsTitle compare:nsID] == NSOrderedSame)
        nsTitle = nil;
    else
        nsTitle = [NSString stringWithFormat:@"%@",nsTitle];
    [spanishBundle release];
    
    if (nsTitle == nil)//到通用里面查找
    {
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tzt" ofType:@"bundle"]];
        if (bundle == nil)
            return nsID;
        
        NSString *bundlePath = [bundle pathForResource:@"tztLocalizable" ofType:@"strings" inDirectory:nil forLocalization:nil];
        NSBundle *spanishBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
        
        nsTitle = NSLocalizedStringFromTableInBundle(nsID, @"tztLocalizable", spanishBundle, nsID);
        if ([nsTitle compare:nsID] == NSOrderedSame)
            nsTitle = nil;
        else
            nsTitle = [NSString stringWithFormat:@"%@",nsTitle];
        [spanishBundle release];
    }
    return nsTitle;
}
