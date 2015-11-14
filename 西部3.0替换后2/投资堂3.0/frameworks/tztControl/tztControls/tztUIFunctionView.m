/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUIFunctionView
 * 文件标识：
 * 摘    要：   功能btn展示view
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-03
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/


#import "tztUIFunctionView.h"

#define tztSeperatorWidth (1)
#define tztSeperatorTag   (1024)

@implementation tztUIFunctionView
@synthesize ayBtnData = _ayBtnData;
@synthesize nBtnWidth = _nBtnWidth;
@synthesize fixBtn  = _fixBtn;
@synthesize nFixBtnWidth = _nFixBtnWidth;
@synthesize fixArrow = _fixArrow;
@synthesize nArrowWidth = _nArrowWidth;
@synthesize bNeedSepLine = _bNeedSepLine;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    _ayBtnData = NewObject(NSMutableArray);
    _nBtnWidth = 60;
    _nFixBtnWidth = 40;
    _nArrowWidth = 8;
    _bNeedSepLine = TRUE;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger nCount = [_ayBtnData count];
    for (int i = 0; i < nCount; i++)
    {
        UIButton *pBtn = (UIButton*)[_ayBtnData objectAtIndex:i];
        if ([pBtn isKindOfClass:[tztUISwitch class]])
        {
            [(tztUISwitch*)pBtn setChecked:((tztUISwitch*)pBtn).checked];
        }
        
        if (_bNeedSepLine)
        {
            UIView* pView = (UIView*)[self viewWithTag:i+tztSeperatorTag];
            pView.backgroundColor = [UIColor tztThemeBorderColorGrid];
        }
        else
        {
            if (i == (nCount - 1))
            {
                UIView* pView = (UIView*)[self viewWithTag:i+tztSeperatorTag];
                pView.backgroundColor = [UIColor tztThemeBorderColorGrid];
            }
        }
    }

}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    if (_bNeedSepLine)
        rcFrame.size.height -= tztSeperatorWidth;
    
    CGFloat nValidWidth = rcFrame.size.width - _nFixBtnWidth - _nArrowWidth;//8为
    NSInteger nCount = [_ayBtnData count];
    float nWidth = (nCount > 0 ?  nValidWidth / nCount : 55.f);
    if (_bNeedSepLine)
        nWidth -= tztSeperatorWidth;
    
    {
        UIView *pLineView = (UIView*)[self viewWithTag:tztSeperatorTag-1];
        if (pLineView)
            pLineView.hidden = YES;
    }
    
    CGRect rcBtn = rcFrame;
    rcBtn.origin.x = 0;
    rcBtn.size.width = nWidth +.5f;
    for (int i = 0; i < nCount; i++)
    {
        UIButton *pBtn = (UIButton*)[_ayBtnData objectAtIndex:i];
        pBtn.frame = rcBtn;
        if ([pBtn isKindOfClass:[tztUISwitch class]])
        {
            [(tztUISwitch*)pBtn setChecked:((tztUISwitch*)pBtn).checked];
        }
//        if ([self viewWithTag:pBtn.tag] == NULL)
        {
            [self addSubview:pBtn];
        }
        
        if (_bNeedSepLine)
        {
            CGRect rcSep = CGRectMake(rcBtn.origin.x + nWidth, rcBtn.origin.y, tztSeperatorWidth, rcBtn.size.height);
            UIView* pView = (UIView*)[self viewWithTag:i+tztSeperatorTag];
            if (pView == NULL)
            {
                pView = [[UIView alloc] initWithFrame:rcSep];
                pView.tag = i+tztSeperatorTag;
                pView.backgroundColor = [UIColor tztThemeBorderColorGrid];
                [self addSubview:pView];
                [pView release];
            }
            else
            {
                pView.frame = rcSep;
            }
            rcBtn.origin.x += nWidth + tztSeperatorWidth;
        }
        else
        {
            if (i == (nCount - 1))
            {
                int nHeight = 18;
                CGRect rcSep = CGRectMake(rcBtn.origin.x + nWidth, rcBtn.origin.y + (rcBtn.size.height - nHeight) / 2, tztSeperatorWidth, nHeight);
                UIView* pView = (UIView*)[self viewWithTag:i+tztSeperatorTag];
                if (pView == NULL)
                {
                    pView = [[UIView alloc] initWithFrame:rcSep];
                    pView.tag = i+tztSeperatorTag;
                    pView.backgroundColor = [UIColor tztThemeBorderColorGrid];
                    [self addSubview:pView];
                    [pView release];
                }
                else
                {
                    pView.frame = rcSep;
                }
                rcBtn.origin.x += nWidth + tztSeperatorWidth;
            }
            else
                rcBtn.origin.x += nWidth;
        }
    }
    
    CGRect rcFix = self.bounds;
    rcFix.size.width = _nFixBtnWidth + _nArrowWidth;
    rcFix.origin.x = self.bounds.size.width - _nFixBtnWidth - _nArrowWidth;
    if (_bNeedSepLine)
        rcFix.size.height -= tztSeperatorWidth;
    _fixBtn.frame = rcFix;
    _fixBtn.showsTouchWhenHighlighted = YES;
    _fixBtn.backgroundColor = [UIColor redColor];
    [_fixBtn setChecked:_fixBtn.checked];
    if ([self viewWithTag:_fixBtn.tag] == NULL)
    {
        [self addSubview:_fixBtn];
    }
    
    CGRect rcArrow = self.bounds;
    rcArrow.origin.x = self.bounds.size.width - _nArrowWidth- _nFixBtnWidth / 2;
    rcArrow.size.width = _nArrowWidth;
    rcArrow.size.height = 12;
    rcArrow.origin.y += (self.bounds.size.height - 12) / 2;
    if (_fixArrow == NULL)
    {
        _fixArrow = [[tztUISwitch alloc] init];
//      _fixArrow.userInteractionEnabled = YES;
        _fixArrow.yesImage = [UIImage imageTztNamed:@"2.png"];
        _fixArrow.noImage = [UIImage imageTztNamed:@"tztFixArrow.png"];
        _fixArrow.frame = rcArrow;
        [self addSubview:_fixArrow];
        
//        [_fixArrow addTarget:_fixBtn.tzttarget action:_fixBtn.tztaction forControlEvents:UIControlEventTouchUpInside];
        [_fixArrow setChecked:NO];
        _fixArrow.userInteractionEnabled = NO;
        [_fixArrow release];
    }
    
    CGAffineTransform transform = _fixArrow.transform;
    
    if (CGAffineTransformEqualToTransform(transform, CGAffineTransformMakeRotation(M_PI / 2)))
    {
        _fixArrow.frame = CGRectMake(rcArrow.origin.x, rcArrow.origin.y, rcArrow.size.height, rcArrow.size.width);
    }
    else if (CGAffineTransformEqualToTransform(transform, CGAffineTransformMakeRotation(-M_PI/2)))
    {
        _fixArrow.frame = CGRectMake(rcArrow.origin.x, rcArrow.origin.y, rcArrow.size.height, rcArrow.size.width);
    }
    else
    {
        _fixArrow.frame = rcArrow;
    }
    
    [self bringSubviewToFront:_fixArrow];
    
}

-(void)setAyBtnData:(NSMutableArray *)ayData
{
    for (int i = 0; i < [_ayBtnData count]; i++)
    {
        UIView *pView = [_ayBtnData objectAtIndex:i];
        [pView removeFromSuperview];
    }
    
    if (_fixBtn)
    {
        [_fixBtn removeFromSuperview];
    }
    
    [_ayBtnData removeAllObjects];
    
    for (int i = 0; i < [ayData count]; i++)
    {
        [_ayBtnData addObject:[ayData objectAtIndex:i]];
    }
}


-(void)setBtnState:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn && [pBtn isKindOfClass:[tztUISwitch class]])
    {
        tztUISwitch *pSwitch = (tztUISwitch*)pBtn;
        [pSwitch setChecked:YES];
    }
    
    for (int i = 0; i < [_ayBtnData count]; i++)
    {
        UIButton *pBtn = (UIButton*)[_ayBtnData objectAtIndex:i];
        if (pBtn == sender)
            continue;
        if (pBtn && [pBtn isKindOfClass:[tztUISwitch class]])
        {
            [(tztUISwitch*)pBtn setChecked:NO];
        }
    }
}

-(id)setBtnSelectWithFunctionID:(NSInteger)nFunctionID
{
    for (int i = 0; i < [_ayBtnData count]; i++)
    {
        UIButton *pBtn = [_ayBtnData objectAtIndex:i];
        if (pBtn && pBtn.tag == nFunctionID)
        {
            return pBtn;
        }
    }
    return nil;
}

@end
