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

#import "TZTUIMenuView.h"
#import "TZTInitReportMarketMenu.h"

@implementation TZTUIMenuView
@synthesize pTableView = _pTableView;
@synthesize pDelegate = _pDelegate;

-(id)init
{
    self = [super init];
    if (self)
    {
        _pTableView = nil;
        _pDelegate = nil;
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.6 alpha:1.0];
    
    CGRect rcFrame = CGRectMake(0, 0, frame.size.width-1, frame.size.height);
    if (_pTableView == NULL)
    {
        _pTableView = [[tztUITableListView alloc] initWithFrame:rcFrame];
        
        [_pTableView setMarketMenu:@"tztMarketMenu"];
        _pTableView.tztdelegate = self;
        _pTableView.bExpandALL = TRUE;
        _pTableView.isMarketMenu = YES;
        
        _pTableView.backgroundColor = [UIColor colorWithTztRGBStr:@"37,37,37"];
        [self addSubview:_pTableView];
        [_pTableView release];
    }
    else
    {
        _pTableView.frame = rcFrame;
        [_pTableView reloadData];
    }
//    [_pTableView setRowShow:NO withRowNum_:8]; // 中信隐藏多余的行情排名-场内基金市场号10 byDBQ20131017
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 1);
    CGContextSaveGState(context);
    UIColor* HideGridColor = [UIColor tztThemeHQHideGridColor];//
    UIColor* BackgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGContextSetStrokeColorWithColor(context, HideGridColor.CGColor);
    CGContextSetFillColorWithColor(context, BackgroundColor.CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextStrokePath(context);
    CGContextSetLineWidth(context,2.0f);
    
    //绘制竖线
    CGContextMoveToPoint(context,  rect.size.width , 0);
    CGContextAddLineToPoint(context, rect.size.width , rect.size.height);
    
}

-(void)DealWithMenu:(NSInteger)nMsgType nsParam_:(NSString*)nsParam pAy_:(NSArray *)pAy
{
    if (_pDelegate && [_pDelegate respondsToSelector:@selector(DealWithMenu:nsParam_:pAy_:)])
    {
        [_pDelegate DealWithMenu:nMsgType nsParam_:nsParam pAy_:pAy];
    }
}

-(BOOL)tztUITableListView:(tztUITableListView *)pMenuView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString *)strMsgValue
{
    if (1)
    {
        
    }
    return TRUE;
}

//设置当前选中菜单，根据菜单名称来进行判断，所以菜单名称不能重复
-(void)setCurrentMenu:(NSString*)nsMenu
{
    if (_pTableView == nil)
        return;
    [_pTableView SetMsgType:[nsMenu intValue]];
}

////获取当前菜单
//-(NSMutableDictionary*)GetCurrentMenu
//{
//    if (self.m_pTableView == nil)
//        return NULL;   
//    return  self.m_pTableView.m_pCurrentSelect;
//    return NULL;
//}

//返回选中菜单的名称
-(NSString*)GetCurrentMenuTitle
{
    if (self.pTableView == nil)
        return nil;
    return _pTableView.nsSelectedTitle;
}
@end
