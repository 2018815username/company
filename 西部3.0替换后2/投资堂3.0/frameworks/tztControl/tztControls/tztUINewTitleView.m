/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUINewTitleView
 * 文件标识：
 * 摘    要：   新的标题栏
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

#import "tztUINewTitleView.h"

@implementation tztUINewTitleView
@synthesize pLeftBtn = _pLeftBtn;
@synthesize pRightBtn = _pRightBtn;
@synthesize pSwitch = _pSwitch;

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
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    self.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
    CGRect rcLeft = self.bounds;
    rcLeft.origin.x = 0;
    rcLeft.size.width = 45;
    if (IS_TZTIOS(7))
        rcLeft.origin.y += TZTStatuBarHeight;
    
    
    CGSize sz = frame.size;
    UIImage *image = [_pLeftBtn backgroundImageForState:UIControlStateNormal];
    if (image && image.size.width > 0 && image.size.height > 0)
    {
        sz = image.size;
    }
    else
    {
        sz = CGSizeMake(45, 44);
    }
//    rcLeft.size.width = 44;
//    rcLeft.size.height = frame.size.height;
    rcLeft.size = sz;
    rcLeft.origin.y += (frame.size.height - (IS_TZTIOS(7) ? TZTStatuBarHeight : 0) - rcLeft.size.height) / 2;
    if (_pLeftBtn == NULL)
    {
        _pLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pLeftBtn.frame = rcLeft;
        _pLeftBtn.contentMode = UIViewContentModeCenter;
        _pLeftBtn.showsTouchWhenHighlighted = YES;
        [self addSubview:_pLeftBtn];
    }
    else
    {
        _pLeftBtn.frame = rcLeft;
    }
    
    
    UIImage *imageR = [_pRightBtn backgroundImageForState:UIControlStateNormal];
    if (imageR && imageR.size.width > 0 && imageR.size.height > 0)
    {
        sz = imageR.size;
    }
    CGRect rcRight = self.bounds;
//    rcRight.size.width = 44;
    rcRight.size = sz;
    rcRight.origin.x = self.bounds.size.width - sz.width - 5;
    //    rcRight.size.height = frame.size.height;
    if (IS_TZTIOS(7))
        rcRight.origin.y += TZTStatuBarHeight;
    rcRight.origin.y += (frame.size.height - (IS_TZTIOS(7) ? TZTStatuBarHeight : 0) - sz.height) / 2;
    if (_pRightBtn == NULL)
    {
        _pRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pRightBtn.frame = rcRight;
        _pRightBtn.contentMode = UIViewContentModeCenter;
        _pRightBtn.showsTouchWhenHighlighted = YES;
       
        [self addSubview:_pRightBtn];
    }
    else
    {
        _pRightBtn.frame = rcRight;
    }
    
    CGRect rcSeg = self.bounds;
//    rcSeg.size.height = 30;
    rcSeg.size.width = rcSeg.size.width - rcLeft.size.width - rcRight.size.width;
    
    CGFloat fLeft = (self.bounds.size.width - rcLeft.size.width - rcRight.size.width - rcSeg.size.width - 10) / 2;
    
    rcSeg.origin.x = rcLeft.origin.x + rcLeft.size.width + fLeft;
//    rcSeg.size.width = self.bounds.size.width - rcSeg.origin.x - rcLeft.size.width - 10;
//    rcSeg.origin.y = (self.bounds.size.height - 30) / 2;
    if (IS_TZTIOS(7))
    {
        rcSeg.origin.y += TZTStatuBarHeight;
        rcSeg.size.height -= TZTStatuBarHeight;
    }

    
    if (_pSwitch == nil)
    {
        _pSwitch = [[tztUISegment alloc] initWithFrame:rcSeg];
        [_pSwitch setSliderTextColor:[UIColor colorWithRGBULong:0xF3B2B2]];
        [_pSwitch setTextColor:[UIColor colorWithRGBULong:0xFAFAFA]];
        [_pSwitch addTarget:self action:@selector(doSelect:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pSwitch];
        [_pSwitch release];
    }
    else
    {
        _pSwitch.frame = rcSeg;
    }
}

-(void)setSegControlItems:(NSMutableArray *)ayItems
{
    if (ayItems == NULL || [ayItems count] < 1)
        _pSwitch.hidden = YES;
    
    if (_aySegItem == NULL)
        _aySegItem = NewObject(NSMutableArray);
    [_aySegItem removeAllObjects];
    int nFlag = 0;
    for (int i = 0; i < [ayItems count]; i++)
    {
        //功能号｜显示名称
        NSString* strData = [ayItems objectAtIndex:i];
        if (strData == NULL || [strData length] < 1)
            continue;
        NSArray *ay = [strData componentsSeparatedByString:@"|"];
        if ([ay count] < 2)
            continue;
        
        if (nFlag == 0)
            _pSwitch.onText = [ay objectAtIndex:1];
        else
            _pSwitch.offText = [ay objectAtIndex:1];
        [_aySegItem addObject:strData];
        nFlag++;
    }
    _pSwitch.hidden = (nFlag > 0 ? NO : YES);
}

-(void)ChangeSegmentFont:(UIView *)aView
{
    if ([aView isKindOfClass:[UILabel class]])
    {
        UILabel *lb = (UILabel*)aView;
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setFont:tztUIBaseViewTextFont(12.0f)];
    }
    NSArray *na = [aView subviews];
    NSEnumerator *ne = [na objectEnumerator];
    UIView *subView;
    while (subView = [ne nextObject])
    {
        [self ChangeSegmentFont:subView];
    }
}

-(void)setSelectSegmentIndex:(NSInteger)nIndex
{
    if (_pSwitch)
        _pSwitch.on = (nIndex == 0 ? FALSE : TRUE);
}

-(int)getFunctionIDInSegControl
{
    if (_pSwitch)
    {
        int nIndex = (_pSwitch.on ? 1 : 0);
        if (nIndex >= [_aySegItem count])
            return -1;
        
        NSString* strData = [_aySegItem objectAtIndex:nIndex];
        NSArray *ay = [strData componentsSeparatedByString:@"|"];
        if ([ay count] < 2)
            return -1;
        
        return [[ay objectAtIndex:0] intValue];
    }
    else
        return -1;
}
//自选 页面的选择
-(void)doSelect:(id)sender
{
    if (sender == _pSwitch)
    {
        int nIndex = (_pSwitch.on ? 1 : 0);
        if (nIndex >= [_aySegItem count])
            return;
        
        NSString* strData = [_aySegItem objectAtIndex:nIndex];
        NSArray *ay = [strData componentsSeparatedByString:@"|"];
        if ([ay count] < 2)
            return;
        if (_pDelegate && [_pDelegate respondsToSelector:@selector(tztNewTitleClick:FuncionID_:withParams_:)])
        {
            [_pDelegate tztNewTitleClick:_pSwitch FuncionID_:[[ay objectAtIndex:0] intValue] withParams_:strData];
        }
    }
}

@end
