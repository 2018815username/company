//
//  TZTSegmentView.m
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 5/9/14.
//
//

#import "TZTSegmentView.h"

#define btnTag 100
#define sepLineTag 1000

@interface TZTSegmentView()

@property (nonatomic, retain) NSMutableArray *btnArray;
@property (nonatomic, retain) NSMutableArray *sepArray;
@property (nonatomic, retain) NSMutableArray *ayTitle;
@property (nonatomic, retain) UIView *selView;

@property (nonatomic, retain) UIFont    *normalFont;
@property (nonatomic, retain) UIFont    *selectedFont;

@end

@implementation TZTSegmentView
@synthesize tztDelegate = _tztDelegate;
@synthesize selView = _selView;
@synthesize normalFont = _normalFont;
@synthesize selectedFont = _selectedFont;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _sepArray = [[NSMutableArray alloc] init];
        _btnArray = [[NSMutableArray alloc] init];
        _ayTitle = [[NSMutableArray alloc] init];
        // Initialization code
        float width = frame.size.width/titleArray.count;
        for (int i = 0; i < titleArray.count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*width, 0, width, frame.size.height);
            btn.tag = i + btnTag;
            [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnArray addObject:btn];
            [self.ayTitle addObject:[titleArray objectAtIndex:i]];
            [self addSubview: btn];
        }
        
        
        if (_selView == NULL)
        {
            _selView = [[UIView alloc] init];
            [self addSubview:_selView];
            [_selView release];
        }
    }
    return self;
}

-(void)SetSegmentViewItems:(NSArray*)ayItems
{
    if (ayItems.count <= 0)
        return;
    for (UIView* pView in self.btnArray)
    {
        [pView removeFromSuperview];
    }
    
    [self.btnArray removeAllObjects];
    [self.ayTitle removeAllObjects];
    
    if (_btnArray == NULL)
        _btnArray = [[NSMutableArray alloc] init];
    if (_ayTitle == NULL)
        _ayTitle = [[NSMutableArray alloc] init];
    float width = self.frame.size.width/ayItems.count;
    for (int i = 0; i < ayItems.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width, 0, width, self.frame.size.height);
        btn.tag = i + btnTag;
        [btn setTitle:[ayItems objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:btn];
        [self.ayTitle addObject:[ayItems objectAtIndex:i]];
        [self addSubview: btn];
        
        if (_bSepLine)
        {
            btn.layer.borderWidth = .5f;
            btn.layer.borderColor = self.borderColor.CGColor;
        }
    }
    
    if (_selView)
    {
        [self bringSubviewToFront:_selView];
    }
    [self setCurrentSelected:0];//回到第一个选中
}

-(void)dealloc
{
    self.tztDelegate = nil;
    if (self.sepArray)
        [self.sepArray removeAllObjects];
    DelObject(_sepArray);
    if (self.btnArray)
        [self.btnArray removeAllObjects];
    DelObject(_btnArray);
    
    [_borderColor release];
    [super dealloc];
}

- (void)btnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.currentSelected = btn.tag - btnTag;
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(tztSegmentView:didSelectAtIndex:)])
    {
        [self.tztDelegate tztSegmentView:self didSelectAtIndex:self.currentSelected];
    }
}

-(void)reducedTitle
{
    for (int i = 0; i < self.btnArray.count; i++)
    {
        UIButton *btn = [self.btnArray objectAtIndex:i];
        if (i < self.ayTitle.count)
        {
            [btn setTztTitle:[self.ayTitle objectAtIndex:i]];
        }
    }
}


- (void)updateBtnStates:(NSUInteger)index
{
    for (int i = 0; i < self.btnArray.count; i++)
    {
        UIButton *btn = [self.btnArray objectAtIndex:i];
        if (i == index)
        {
            btn.selected = YES;
            if (self.selectedColor)
            {
                [btn setBackgroundColor:self.selectedColor];
            }
            [btn.titleLabel setFont:self.selectedFont];
            CGRect rcFrame = btn.frame;
            
            CGSize sz = [[btn titleForState:UIControlStateSelected] sizeWithFont:self.selectedFont];
            
            int nSizeWidth = sz.width;
            if (nSizeWidth < 30)
                nSizeWidth = 30;
            nSizeWidth += 10;
            sz.width += (btn.frame.size.width - sz.width * self.btnArray.count) / (self.btnArray.count + 1);
            if (sz.width < nSizeWidth)
                sz.width = nSizeWidth;
            
            rcFrame.origin.x += (btn.frame.size.width - sz.width) / 2;
            rcFrame.size.width -= (btn.frame.size.width -sz.width);
            rcFrame.size.height = 2;
            rcFrame.origin.y += btn.frame.size.height - 2 - btn.layer.borderWidth;
            if (rcFrame.size.width > btn.frame.size.width)
            {
                rcFrame.size.width = btn.frame.size.width - 5;
                rcFrame.origin.x += (5 / 2);
            }
            
            if (_selView)
            {
                [UIView animateWithDuration:0.2f
                                 animations:^(void){
                                     _selView.frame = rcFrame;
                                 }];
                _selView.backgroundColor = self.selTextolor;// [btn titleColorForState:UIControlStateSelected];
            }
            
        }
        else
        {
            [btn.titleLabel setFont:self.normalFont];
            btn.selected = NO;
            if (self.color) {
                [btn setBackgroundColor:self.color];
            }
        }
    }
}

- (void)setCurrentSelected:(NSUInteger)currentSelected
{
    _currentSelected = currentSelected;
    [self updateBtnStates:currentSelected];
}

-(UIButton*)GetCurrentSelBtn
{
    if (_currentSelected >= [self.btnArray count])
        return nil;
    UIButton *btn = [self.btnArray objectAtIndex:_currentSelected];
    return btn;
}

- (void)setColor:(UIColor *)color
{
    [_color release];
    _color = [color retain];
    for (int i = 0; i < [self.btnArray count]; i++)
    {
        UIButton *btn = [self.btnArray objectAtIndex:i];
        if (i != _currentSelected)
            [btn setBackgroundColor:color];
        else
            [btn setBackgroundColor:self.selectedColor];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    [_selectedColor release];
    _selectedColor = [selectedColor retain];
}

- (void)setTextColor:(UIColor *)textColor
{
    for (UIButton *btn in self.btnArray)
    {
        [btn setTitleColor:textColor forState:UIControlStateNormal];
    }
}

- (void)setSelTextolor:(UIColor *)selTextolor
{
    [_selTextolor release];
    _selTextolor = [selTextolor retain];
    for (UIButton *btn in self.btnArray)
    {
        [btn setTitleColor:selTextolor forState:UIControlStateSelected];
    }
    if (_selView)
        _selView.backgroundColor = self.selTextolor;
}

- (void)setTextFont:(UIFont *)textFont
{
    self.normalFont = textFont;
    CGFloat size = [textFont pointSize];
    self.selectedFont = tztUIBaseViewTextFont(size + 2);
    for (UIButton *btn in self.btnArray)
    {
        [btn.titleLabel setFont:textFont];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    for (CALayer *layer in self.sepArray)
    {
        layer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, borderWidth, layer.frame.size.height);
    }
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    [_borderColor release];
    _borderColor = [borderColor retain];
    for (CALayer *layer in self.sepArray)
    {
        layer.backgroundColor = borderColor.CGColor;
    }
    self.layer.borderColor = borderColor.CGColor;
}

@end
