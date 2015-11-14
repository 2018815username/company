/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztScrollIndexViewEx
 * 文件标识：
 * 摘    要：   指数跑马灯扩展
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2014－08-05
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import "tztScrollIndexViewEx.h"

#define tztScrollInfoNameWidth 50
#define tztScrollInfoPriceWidth 100
@interface tztScrollInfoCell : UIView
{
}
@property(nonatomic,retain)UILabel     *nameLabel;
@property(nonatomic,retain)UILabel     *newpriceLabel;
@property(nonatomic,retain)UILabel     *ratioLabel;
@property(nonatomic,retain)UILabel     *rangeLabel;
@property(nonatomic,retain)UILabel     *volumeLabel;

-(void)SetData:(NSMutableDictionary*)pDict;
@end

@implementation tztScrollInfoCell

-(void)layoutSubviews
{
    CGRect rcFrame = self.bounds;
    UIColor *titleColor = [UIColor tztThemeHQBalanceColor];
    UIFont  *titleFont = tztUIBaseViewTextFont(15.f);
    UIFont  *labFont = tztUIBaseViewTextFont(12.f);
    
    CGRect rcName = rcFrame;
    rcName.size.width = tztScrollInfoNameWidth;
    if (_nameLabel == NULL)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:rcName];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.textColor = titleColor;
        _nameLabel.font = titleFont;
        _nameLabel.text = @"--";
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_nameLabel];
        [_nameLabel release];
    }
    else
        _nameLabel.frame = rcName;
    
    CGRect rcPrice = rcFrame;
    rcPrice.origin.x = rcName.origin.x + rcName.size.width;
    rcPrice.size.width = tztScrollInfoPriceWidth;
    if (_newpriceLabel == NULL)
    {
        _newpriceLabel = [[UILabel alloc] initWithFrame:rcPrice];
        _newpriceLabel.backgroundColor = [UIColor clearColor];
        _newpriceLabel.textAlignment = NSTextAlignmentCenter;
        _newpriceLabel.textColor = titleColor;
        _newpriceLabel.font = titleFont;
        _newpriceLabel.text = @"-.-";
        _newpriceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_newpriceLabel];
        [_newpriceLabel release];
    }
    else
    {
        _newpriceLabel.frame = rcPrice;
    }
    
    float fWidth = (rcFrame.size.width - rcName.size.width - rcPrice.size.width) / 3;
    CGRect rcRatio = rcFrame;
    rcRatio.origin.x = rcPrice.origin.x + rcPrice.size.width;
    rcRatio.size.width = fWidth;
    if (_ratioLabel == NULL)
    {
        _ratioLabel = [[UILabel alloc] initWithFrame:rcRatio];
        _ratioLabel.backgroundColor = [UIColor clearColor];
        _ratioLabel.textAlignment = NSTextAlignmentCenter;
        _ratioLabel.textColor = titleColor;
        _ratioLabel.font = labFont;
        _ratioLabel.text = @"-.-";
        [self addSubview:_ratioLabel];
        [_ratioLabel release];
    }
    else
    {
        _ratioLabel.frame = rcRatio;
    }
    
    CGRect rcRange = rcFrame;
    rcRange.origin.x = rcRatio.origin.x + rcRatio.size.width;
    rcRatio.size.width = fWidth;
    if (_rangeLabel == NULL)
    {
        _rangeLabel = [[UILabel alloc] initWithFrame:rcRange];
        _rangeLabel.backgroundColor = [UIColor clearColor];
        _rangeLabel.textAlignment = NSTextAlignmentCenter;
        _rangeLabel.textColor = titleColor;
        _rangeLabel.font = labFont;
        _rangeLabel.text = @"-.-";
        [self addSubview:_rangeLabel];
        [_rangeLabel release];
    }
    else
    {
        _rangeLabel.frame = rcRange;
    }
    
    CGRect rcVolume = rcFrame;
    rcVolume.origin.x = rcRange.origin.x + rcRange.size.width;
    rcVolume.size.width = fWidth;
    if (_volumeLabel == NULL)
    {
        _volumeLabel = [[UILabel alloc] initWithFrame:rcVolume];
        _volumeLabel.backgroundColor = [UIColor clearColor];
        _volumeLabel.textAlignment = NSTextAlignmentCenter;
        _volumeLabel.textColor = titleColor;
        _volumeLabel.font = labFont;
        _volumeLabel.text = @"--";
        [self addSubview:_volumeLabel];
        [_volumeLabel release];
    }
    else
    {
        _volumeLabel.frame = rcVolume;
    }
}

-(void)SetData:(NSMutableDictionary *)pDict
{
    if (pDict == NULL || pDict.count < 1)
        return;
    
    //
    float fClose = [[pDict objectForKey:tztYesTodayPrice] floatValue];
    float fNewPrice = [[pDict objectForKey:tztNewPrice] floatValue];
    UIColor *textColor = [UIColor tztThemeHQBalanceColor];
    
    if (fClose > fNewPrice)
        textColor = [UIColor tztThemeHQDownColor];
    else if(fClose < fNewPrice)
        textColor = [UIColor tztThemeHQUpColor];
    
    _newpriceLabel.text = [pDict objectForKey:tztNewPrice];
    _newpriceLabel.textColor = textColor;
    _ratioLabel.text = [pDict objectForKey:tztUpDown];
    _ratioLabel.textColor = textColor;
    _rangeLabel.text = [pDict objectForKey:tztPriceRange];
    _rangeLabel.textColor = textColor;
    
    _volumeLabel.textColor = [pDict objectForKey:tztTradingVolume];
    _volumeLabel.textColor = [UIColor tztThemeHQBalanceColor];
}
@end


@interface tztScrollIndexViewEx()<tztMutilScrollViewDelegate>

@property(nonatomic,retain)tztMutilScrollView   *pMutilScrollView;
@property(nonatomic,retain)NSMutableArray       *pAyViews;
@property(nonatomic)int                  nPageIndex;

@end


@implementation tztScrollIndexViewEx
@synthesize pMutilScrollView = _pMutilScrollView;
@synthesize pAyViews = _pAyViews;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    if (_pMutilScrollView == NULL)
    {
        _pMutilScrollView = [[tztMutilScrollView alloc] init];
        _pMutilScrollView.bSupportLoop = YES;
        _pMutilScrollView.tztdelegate = self;
        _pMutilScrollView.backgroundColor = [UIColor clearColor];
        _pMutilScrollView.bUseSysPageControl = YES;
        _pMutilScrollView.bounces = YES;
        [self addSubview:_pMutilScrollView];
        [_pMutilScrollView release];
        
        if (_pAyViews == nil)
            _pAyViews = NewObject(NSMutableArray);
        [_pAyViews removeAllObjects];
        
        UIView *pView1 = [[UIView alloc] initWithFrame:self.bounds];
        pView1.backgroundColor = [UIColor clearColor];
        
        CGRect rcCell1 = self.bounds;
        rcCell1.size.height = 44;
        tztScrollInfoCell *pCell1 = [[tztScrollInfoCell alloc] initWithFrame:rcCell1];
        [pView1 addSubview:pCell1];
    }
}

@end
