
/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页-右上交可以滑动的界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import "tztUIHomePageScrollView.h"
#import "tztUIHomePageReportGridView.h"
@implementation tztUIHomePageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
    CGRect rcFrame = CGRectZero;
    rcFrame.size = frame.size;
    if (_pScrollView == NULL)
	{
		_pScrollView = [[tztMutilScrollView alloc] initWithFrame:rcFrame];
		_pScrollView.tztdelegate = self;
        [_pScrollView setBackgroundColor:[UIColor clearColor]];
		[self addSubview:_pScrollView];
        [_pScrollView release];
	}else
        _pScrollView.frame= rcFrame;
    
    if ([_pScrollView.pageViews count] == 0)
    {
        rcFrame.size.height -= 10;
        NSMutableArray  * arrayView = NewObject(NSMutableArray);
        tztUIHomePageReportGridView * HSAView = [[tztUIHomePageReportGridView alloc] init];
        HSAView.pPageType = HomePage_HSAStock;
        HSAView.frame = rcFrame;
        [arrayView addObject:HSAView];
        [HSAView release];
        
        tztUIHomePageReportGridView * GJIndex = [[tztUIHomePageReportGridView alloc] init];
        GJIndex.pPageType = HomePage_GuoJiIndex;
        GJIndex.frame = rcFrame;
        [arrayView addObject:GJIndex];
        [GJIndex release];
        [_pScrollView setPageViews:arrayView];
        [arrayView release];
    }
}
-(void)LoadPage
{
    tztUIHomePageReportGridView * View = NULL;
    for (int i = 0; i< [_pScrollView.pageViews count]; i++) 
    {
        View = (tztUIHomePageReportGridView *)[_pScrollView.pageViews objectAtIndex:i];
        [View LoadPage];
    }
}
@end
