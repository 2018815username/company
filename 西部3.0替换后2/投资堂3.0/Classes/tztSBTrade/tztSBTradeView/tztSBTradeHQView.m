/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        ipad三板行情
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztSBTradeHQView.h"

#define tztDateViewHeight  50

@implementation tztSBTradeHQView
@synthesize pHQView = _pHQView;
@synthesize pSearchView = _pSearchView;

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
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin.x = 0;
    rcFrame.origin.y = 0;
    rcFrame.size.height = tztDateViewHeight;
    if (_pHQView == NULL) 
    {
        _pHQView = [[tztSBTradeTopHQSelectView alloc] initWithFrame:rcFrame];
		_pHQView.pDelegate = self;
        [self addSubview:_pHQView];
        [_pHQView release];
    }
    else
    {
        _pHQView.frame = rcFrame;
    }
    
    rcFrame = self.bounds;
    rcFrame.origin.x = 0;
    rcFrame.origin.y = _pHQView.frame.origin.y + _pHQView.frame.size.height;
    rcFrame.size.height -= tztDateViewHeight;
    if (_pSearchView == NULL)
    {
        _pSearchView = [[tztSBTradeSearchView alloc] init];
        _pSearchView.nMsgType = _nMsgType;
        _pSearchView.frame = rcFrame;
        _pSearchView.delegate = self;
        [self addSubview:_pSearchView];
        [_pSearchView release];
    }
    else
    {
        _pSearchView.frame = rcFrame;
    }
    _pSearchView.nMsgType = _nMsgType;
}

-(void)SetSelectType:(NSString*)nsStock _nsType:(NSString*)nsType
{
    _pSearchView.nsStock = nsStock;
    _pSearchView.nsHQType = nsType;
    _pSearchView.nMsgType = _nMsgType;
    [_pSearchView OnRequestData];
}

@end
