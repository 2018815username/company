/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        现券还券
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztRZRQXQHQView.h"

@implementation tztRZRQXQHQView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    rcFrame.origin = CGPointZero;
    
    if (_tztTradeTable == NULL)
    {
        _tztTradeTable = [[tztUIVCBaseView alloc] initWithFrame:rcFrame];
        _tztTradeTable.tztDelegate = self;
        [_tztTradeTable setTableConfig:@"tztRZRQXQHQ"];
        [self addSubview:_tztTradeTable];
        [_tztTradeTable release];
    }
    else
    {
        _tztTradeTable.frame = rcFrame;
    }
}

-(void)OnRefresh
{
    if (_tztTradeTable == NULL)
        return;
    
    NSString* strCode = [_tztTradeTable GetEidtorText:2000];
    if (strCode == NULL || [strCode length] < 6)
        return;
    
    
}


@end
