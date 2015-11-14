/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    自选股/沪深 的切换View
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTTagView.h"
@interface TZTTagView ()

@property (nonatomic, retain) NSMutableArray *ayButton;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UIImageView *botImgView;
@property (nonatomic, strong) UIImageView *selectedSegmentLayer;
@property (nonatomic, assign) BOOL isMarKet;
@property (nonatomic)float fFontSize;
@end

@implementation TZTTagView

@synthesize imgView = _imgView;
@synthesize botImgView = _botImgView;
@synthesize isMarKet = _isMarKet;
@synthesize selectedSegmentLayer = _selectedSegmentLayer;
@synthesize ayData = _ayData;
@synthesize ayButton = _ayButton;
@synthesize fFontSize = _fFontSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _fFontSize = 14.0f;
        _ayButton = NewObject(NSMutableArray);
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        _fFontSize = 14.0f;
        _ayButton = NewObject(NSMutableArray);
    }
    return self;
}

-(void)dealloc
{
    if (_ayButton)
    {
        [_ayButton removeAllObjects];
        DelObject(_ayButton);
    }
    [super dealloc];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor tztThemeBackgroundColorTagView];
    NSInteger nCount = [self.ayData count];
    
    self.selectedSegmentLayer.image = [UIImage imageTztNamed:@"triangled.png"];
    
    for (int i = 0; i < nCount; i++)
    {
        NSString* strParams = [self.ayData objectAtIndex:i];
        if (strParams.length < 1)
            continue;
        NSArray *ay = [strParams componentsSeparatedByString:@"|"];
        if ([ay count] < 2)//名称｜功能号 ，少于2个，认为无效
            continue;
        
        int nFuctionID = [[ay objectAtIndex:1] intValue];
        
        UIButton *btn = (UIButton*)[self viewWithTag:nFuctionID];
        if (btn)
        {
            [btn setTitleColor:[UIColor tztThemeTextColorTag] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor tztThemeTextColorTagSel] forState:UIControlStateSelected];
        }
    }
    
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    self.backgroundColor = [UIColor tztThemeBackgroundColorTagView];
    
    CGRect imagFrame = CGRectZero;
    imagFrame.size.width = frame.size.width;
    imagFrame.size.height = 1;
    
    NSInteger nCount = [self.ayData count];
    if (nCount < 1)
        return;
    
    UIImage* image = [UIImage imageTztNamed:@"triangled.png"];
    CGSize sz = image.size;
    
    CGRect userFrame = CGRectZero;
    userFrame.size.width = frame.size.width/nCount;
    if (sz.width > userFrame.size.width)
        sz.width = userFrame.size.width;
    userFrame.size.height = frame.size.height - sz.height;
    userFrame.origin.y += imagFrame.size.height;
    
    for (int i = 0; i < nCount; i++)
    {
        NSString* strParams = [self.ayData objectAtIndex:i];
        if (strParams.length < 1)
            continue;
        NSArray *ay = [strParams componentsSeparatedByString:@"|"];
        if ([ay count] < 2)//名称｜功能号 ，少于2个，认为无效
            continue;
        
        NSString* strName = [NSString stringWithFormat:@"%@", [ay objectAtIndex:0]];
        if (!ISNSStringValid(strName))
            strName = @"";
        int nFuctionID = [[ay objectAtIndex:1] intValue];
        
        UIButton *btn = (UIButton*)[self viewWithTag:nFuctionID];
        if (btn == nil)
        {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = tztUIBaseViewTextFont(_fFontSize);
            [btn addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            btn.tag = nFuctionID;
            [_ayButton addObject:btn];
        }
        
        btn.selected = (i == _nDefaultSelectIndex);
        if (i == _nDefaultSelectIndex)
        {
            btn.titleLabel.font = tztUIBaseViewTextFont(_fFontSize+2);
        }
        [btn setTztTitle:strName];
        btn.frame = userFrame;
        
        [btn setTitleColor:[UIColor tztThemeTextColorTag] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor tztThemeTextColorTagSel] forState:UIControlStateSelected];
        
        userFrame.origin.x += userFrame.size.width;
    }
   
    
    imagFrame.origin.y += userFrame.size.height + imagFrame.size.height;
    
    if (_selectedSegmentLayer == nil)
    {
        _selectedSegmentLayer = [[UIImageView alloc] init];
        self.selectedSegmentLayer.image = image;
        [self addSubview:self.selectedSegmentLayer];
        [_selectedSegmentLayer release];
    }
    
    self.selectedSegmentLayer.frame = CGRectMake(userFrame.size.width*(_nDefaultSelectIndex) + (userFrame.size.width - sz.width )/ 2.0,
                                                 self.frame.size.height - sz.height,
                                                 sz.width,
                                                 sz.height);
}

-(void)OnButtonClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return;
    
    for (int i = 0; i < [self.ayButton count]; i++)
    {
        UIButton *button = [self.ayButton objectAtIndex:i];
        if (button == pBtn)
        {
            _nDefaultSelectIndex = i;
            button.selected = YES;
            button.titleLabel.font = tztUIBaseViewTextFont(_fFontSize+2);
        }
        else
        {
            button.selected = FALSE;
            button.titleLabel.font = tztUIBaseViewTextFont(_fFontSize);
        }
    }
    
    NSInteger nCount = [self.ayButton count];
    CGRect userFrame = self.bounds;
    userFrame.size.width = self.bounds.size.width/nCount;
    
    [UIView animateWithDuration:.2f
                     animations:^{
                         
                         UIImage* image = [UIImage imageTztNamed:@"triangled.png"];
                         
                         CGSize sz = image.size;
                         if (sz.width > userFrame.size.width)
                             sz.width = userFrame.size.width;
                         
                         self.selectedSegmentLayer.frame = CGRectMake(userFrame.size.width*(_nDefaultSelectIndex) + (userFrame.size.width - sz.width )/ 2.f,
                                                                      self.frame.size.height - sz.height,
                                                                      sz.width,
                                                                      sz.height);
                     }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tztTagView:OnButtonClick:AtIndex:)])
    {
        [self.delegate tztTagView:self OnButtonClick:sender AtIndex:_nDefaultSelectIndex];
    }
    
}

- (void)tztTagView:(TZTTagView *)tagView setSelectIndex:(int)nIndex
{
    id sender = nil;
    for (int i = 0; i < [self.ayButton count]; i++)
    {
        UIButton *button = [self.ayButton objectAtIndex:i];
        if (i == nIndex)
        {
            _nDefaultSelectIndex = nIndex;
            button.selected = YES;
            button.titleLabel.font = tztUIBaseViewTextFont(_fFontSize+2);
            sender = button;
        }
        else
        {
            button.selected = FALSE;
            button.titleLabel.font = tztUIBaseViewTextFont(_fFontSize);
        }
    }
    
    NSInteger nCount = [self.ayButton count];
    CGRect userFrame = self.bounds;
    userFrame.size.width = self.bounds.size.width/nCount;
    
    [UIView animateWithDuration:.2f
                     animations:^{
                         
                         UIImage* image = [UIImage imageTztNamed:@"triangled.png"];
                         
                         CGSize sz = image.size;
                         if (sz.width > userFrame.size.width)
                             sz.width = userFrame.size.width;
                         
                         self.selectedSegmentLayer.frame = CGRectMake(userFrame.size.width*(_nDefaultSelectIndex) + (userFrame.size.width - sz.width )/ 2.f,
                                                                      self.frame.size.height - sz.height,
                                                                      sz.width,
                                                                      sz.height);
                     }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tztTagView:OnButtonClick:AtIndex:)])
    {
        [self.delegate tztTagView:self OnButtonClick:sender AtIndex:_nDefaultSelectIndex];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
