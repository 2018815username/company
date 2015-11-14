/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        基金历史成交,历史委托等  带日期的查询界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztFundSearchDateView.h"

#define tztDateViewHeight  40

@implementation tztFundSearchDateView
@synthesize pDateView = _pDateView;
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
    if (_pDateView == NULL)
    {
        _pDateView = NewObject(tztUIBaseDateView);
        _pDateView.frame = rcFrame;
        _pDateView.pDelegate = self;
        [self addSubview:_pDateView];
        [_pDateView release];
    }
    else
    {
        _pDateView.frame = rcFrame;
    }
    
    rcFrame = self.bounds;
    rcFrame.origin.x = 0;
    rcFrame.origin.y = _pDateView.frame.origin.y + _pDateView.frame.size.height;
    rcFrame.size.height -= tztDateViewHeight;
    if (_pSearchView == NULL)
    {
        _pSearchView = NewObject(tztUIFundSearchView);
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

-(void)OnRequestData
{
    _pSearchView.nsBeginDate = [_pDateView GetBegDate];
	_pSearchView.nsEndDate = [_pDateView GetEndDate];
	[_pSearchView OnRequestData];
}
-(void)OnSetData:(NSString *)PreData NextData:(NSString *)nextdata
{
	_pSearchView.nsBeginDate = [NSString stringWithFormat:@"%@",PreData];
	_pSearchView.nsEndDate = [NSString stringWithFormat:@"%@",nextdata];
	[_pSearchView OnRequestData];
}


@end
