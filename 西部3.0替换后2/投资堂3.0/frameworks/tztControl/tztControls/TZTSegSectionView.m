/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    带分段的SectionView
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTSegSectionView.h"

#define HeightGap 5.0
#define SegHeight 34.0

@interface TZTSegSectionView()
@property(nonatomic,assign)id<tztSegmentViewDelegate>tztID;
@property(nonatomic,retain)NSMutableArray   *ayItems;
@property(nonatomic,assign)id tztdelegate;
@end

@implementation TZTSegSectionView
@synthesize tztDelegate = _tztDelegate;
@synthesize tztID = _tztID;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)dealloc
{
    if (_ayItems)
        [_ayItems removeAllObjects];
    DelObject(_ayItems);
    [super dealloc];
}

-(void)setBSepLine:(BOOL)bSepLine
{
    _bSepLine = bSepLine;
    if (_segControl)
        _segControl.bSepLine = bSepLine;
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    CGRect segRect = CGRectMake(0, 0 , frame.size.width, frame.size.height);
    if (_segControl == nil)
    {
        _segControl = [[TZTSegmentView alloc] initWithFrame:segRect titles:self.ayItems];
        _segControl.borderWidth=0.5f;
        _segControl.textFont = tztUIBaseViewTextFont(13);
        _segControl.backgroundColor = [UIColor clearColor];
        
        _segControl.color = [UIColor tztThemeBackgroundColorSection];//  tztSegBackColor;
        _segControl.selectedColor = [UIColor tztThemeBackgroundColorSectionSel];// tztSegBackColorSel;
        _segControl.textColor = [UIColor tztThemeTextColorForSection];// tztSegTextColor;
        _segControl.selTextolor = [UIColor tztThemeTextColorForSectionSel];// tztSegTextColorSel;
        if (self.pBordColor)
            _segControl.borderColor = self.pBordColor;
        else
            _segControl.borderColor = [UIColor tztThemeBorderColorGrid];
        self.tztDelegate = self.tztdelegate;
        _segControl.tztDelegate = self;
        _segControl.currentSelected = 0;
        [self addSubview:_segControl];
        [_segControl release];
    }
    _segControl.frame = segRect;
    _segControl.color = [UIColor tztThemeBackgroundColorSection];//  tztSegBackColor;
    _segControl.selectedColor = [UIColor tztThemeBackgroundColorSectionSel];// tztSegBackColorSel;
    _segControl.textColor = [UIColor tztThemeTextColorForSection];// tztSegTextColor;
    _segControl.selTextolor = [UIColor tztThemeTextColorForSectionSel];// tztSegTextColorSel;
}

- (id)initWithFrame:(CGRect)frame andItems:(NSArray *)items andDelegate:(id)delegate //andSelectionBlock:(selectionBlock)block
{
    if (_ayItems == NULL)
        _ayItems = NewObject(NSMutableArray);
    [_ayItems removeAllObjects];
    for (id data in items)
        [_ayItems addObject:data];
    self.tztdelegate = delegate;
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)SetSegmentViewItems:(NSArray*)ayItems
{
    if (_ayItems == NULL)
        _ayItems = NewObject(NSMutableArray);
    [_ayItems removeAllObjects];
    for (id data in ayItems)
        [_ayItems addObject:data];
    if (_segControl)
    {
        if (self.pBordColor)
            _segControl.borderColor = self.pBordColor;
        [_segControl SetSegmentViewItems:ayItems];
    }
}

-(NSInteger)getCurrentIndex
{
    if (_segControl)
    {
        return _segControl.currentSelected;
    }
    
    return -1;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _segControl.color = [UIColor tztThemeBackgroundColorSection];//  tztSegBackColor;
    _segControl.selectedColor = [UIColor tztThemeBackgroundColorSectionSel];// tztSegBackColorSel;
    _segControl.textColor = [UIColor tztThemeTextColorForSection];// tztSegTextColor;
    _segControl.selTextolor = [UIColor tztThemeTextColorForSectionSel];// tztSegTextColorSel;
    if (self.pBordColor)
        _segControl.borderColor = self.pBordColor;
    else
        _segControl.borderColor = [UIColor tztThemeBorderColorGrid];
}

-(void)tztSegmentView:(id)segView didSelectAtIndex:(NSInteger)nIndex
{
    if (segView == _segControl)
    {
        if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztSegmentView:didSelectAtIndex:)])
        {
            [self.tztDelegate tztSegmentView:self didSelectAtIndex:nIndex];
        }
    }
}

- (void)setCurrentSelect:(NSInteger)nIndex
{
    if (self.segControl)
    {
        self.segControl.selTextolor = [UIColor tztThemeTextColorForSectionSel];// tztSegTextColorSel;
        [self.segControl setCurrentSelected:nIndex];
    }
}

-(UIButton*)GetCurrentSelBtn
{
    if (self.segControl)
        return [self.segControl GetCurrentSelBtn];
    else
        return nil;
}
@end
