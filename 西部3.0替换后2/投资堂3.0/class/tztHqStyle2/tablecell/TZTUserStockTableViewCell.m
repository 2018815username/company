/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    自选股表Cell
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUserStockTableViewCell.h"
#define kUtilityButtonsWidthMax 260
#define kUtilityButtonWidthDefault 60

//static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

#pragma mark - SWUtilityButtonView

@interface SWUtilityButtonView : UIView

@property (nonatomic)BOOL   bShow;
@property (nonatomic, strong) NSArray *utilityButtons;
@property (nonatomic) CGFloat utilityButtonWidth;
@property (nonatomic, strong) TZTUserStockTableViewCell *parentCell;
@property (nonatomic) SEL utilityButtonSelector;
@property (nonatomic,retain)UIView *backView;
@property (nonatomic,retain)UIColor *clBackColor;
@property (nonatomic) CGFloat fButtonWidth;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(TZTUserStockTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(TZTUserStockTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector andCellWidth:(CGFloat)fWidth;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(TZTUserStockTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(TZTUserStockTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector andCellWidth:(CGFloat)fWidth;

-(void)setShow:(BOOL)bShow;
@end

@implementation SWUtilityButtonView
@synthesize backView = _backView;
@synthesize clBackColor = _clBackColor;
#pragma mark - SWUtilityButonView initializers

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(TZTUserStockTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector
{
    return [self initWithUtilityButtons:utilityButtons parentCell:parentCell utilityButtonSelector:utilityButtonSelector andCellWidth:60];
}

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(TZTUserStockTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector andCellWidth:(CGFloat)fWidth;
{
    self = [super init];
    if (self)
    {
        self.fButtonWidth = fWidth;
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(TZTUserStockTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector
{
    return [self initWithFrame:frame utilityButtons:utilityButtons parentCell:parentCell utilityButtonSelector:utilityButtonSelector andCellWidth:60];
}

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(TZTUserStockTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector andCellWidth:(CGFloat)fWidth
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.fButtonWidth = fWidth;
        self.utilityButtons = utilityButtons;
        self.utilityButtonWidth = [self calculateUtilityButtonWidth];
        self.parentCell = parentCell;
        self.utilityButtonSelector = utilityButtonSelector;
    }
    
    return self;
}

#pragma mark Populating utility buttons

- (CGFloat)calculateUtilityButtonWidth {
    CGFloat buttonWidth = self.fButtonWidth;
    if (buttonWidth * _utilityButtons.count > kUtilityButtonsWidthMax) {
        CGFloat buffer = (buttonWidth * _utilityButtons.count) - kUtilityButtonsWidthMax;
        buttonWidth -= (buffer / _utilityButtons.count);
    }
    return buttonWidth+3.5;
}

- (CGFloat)utilityButtonsWidth {
    return (_utilityButtons.count * _utilityButtonWidth);
}

- (void)populateUtilityButtons {
    NSUInteger utilityButtonsCounter = 0;
    CGRect rc = self.bounds;
    rc.size.width = [_utilityButtons count] * _utilityButtonWidth;
    rc.origin.x = self.bounds.size.width;// - rc.size.width;
    if (_backView == NULL)
    {
        _backView = [[UIView alloc] initWithFrame:rc];
        _backView.backgroundColor = self.clBackColor;
        [self addSubview:_backView];
        [_backView release];
    }
    else
    {
        _backView.frame = rc;
    }
    for (UIButton *utilityButton in _utilityButtons) {
        CGFloat utilityButtonXCord = 0;
        if (utilityButtonsCounter >= 1) utilityButtonXCord = _utilityButtonWidth * utilityButtonsCounter;
        [utilityButton setFrame:CGRectMake(utilityButtonXCord, 0, _utilityButtonWidth, CGRectGetHeight(self.bounds))];
        [utilityButton setTag:utilityButtonsCounter];
        [utilityButton addTarget:_parentCell action:_utilityButtonSelector forControlEvents:UIControlEventTouchDown];
        [self addSubview: utilityButton];
        utilityButtonsCounter++;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
     for (UIButton *utilityButton in _utilityButtons)
     {
         NSString* strShowKind = objc_getAssociatedObject(utilityButton, "k");
         if (strShowKind.length <= 0)//使用颜色
         {
         }
         else//图片名称
         {
             [utilityButton setImage:[UIImage imageTztNamed:strShowKind] forState:UIControlStateNormal];
         }
     }
}

-(void)setShow:(BOOL)show
{
    _bShow = show;
}

@end

@interface TZTUserStockTableViewCell()<UIScrollViewDelegate>

@property(nonatomic,retain)NSDictionary  *pDataDict;
@property (nonatomic, strong) UIScrollView *cellScrollView;
@property (nonatomic) CGFloat height;
@property (nonatomic, strong) UIView *scrollViewContentView;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewRight;
@property (nonatomic, strong) UITableView *containingTableView;
@property (nonatomic, strong) UILabel     *pLabelInfo;

@property (nonatomic, retain)UILabel *lbStockName;
@property (nonatomic, retain)UILabel *lbStockChange;
@property (nonatomic, retain)UILabel *lbStockCode;
@property (nonatomic, retain)UILabel *lbStockPrice;
@property (nonatomic, retain)UILabel *lbStockData;
@property (nonatomic, retain)UILabel *lbStockUpDown;
@property (nonatomic, retain)UIButton *btnStock;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain)UIImageView  *imageViewEx;

/**
 *    @author yinjp
 *
 *    @brief  显示的labels，除名称，代码和前面的市场图片外，其他添加上去的view
 */
@property (nonatomic, retain)NSMutableArray *ayLabels;
/**
 *    @author yinjp
 *
 *    @brief  显示的列的key
 */
@property (nonatomic, retain)NSMutableArray *ayShowKeys;

@property (nonatomic)BOOL bUseSepLine;
@property(nonatomic,retain)UIView   *pSepLineView;
@property (nonatomic)BOOL bShowRZBD;
@end

@implementation TZTUserStockTableViewCell

@synthesize imgView = _imgView;
@synthesize imageViewEx = _imageViewEx;
@synthesize bRank;
@synthesize cellState = _cellState;
@synthesize bUserStock = _bUserStock;
@synthesize nRowIndex = _nRowIndex;
@synthesize pLabelInfo = _pLabelInfo;
@synthesize nColCount = _nColCount;
@synthesize ayLabels = _ayLabels;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons ayColKeys_:(NSMutableArray*)@[@"Name",@"NewPrice",@"Range"]];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons ayColKeys_:(NSMutableArray*)ayColKeys
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons ayColKeys_:ayColKeys bUseSep_:NO];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons ayColKeys_:(NSMutableArray*)ayColKeys bUseSep_:(BOOL)bUseSep
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nsSection = @"Range";//默认
        
#ifndef tzt_ZSSC
        self.rightUtilityButtons = rightUtilityButtons;
        self.leftUtilityButtons = leftUtilityButtons;
#endif
        self.height = self.frame.size.height;
        self.containingTableView = containingTableView;
        _ayShowKeys = NewObject(NSMutableArray);
        for (NSInteger i = 0; i < ayColKeys.count; i++)
        {
            [_ayShowKeys addObject:[ayColKeys objectAtIndex:i]];
        }
        _nColCount = ayColKeys.count;
        self.highlighted = NO;
        _bUseSepLine = bUseSep;
        [self initializer];
    }
    
    return self;
    
}

-(void)dealloc
{
    if (_ayShowKeys)
    {
        [_ayShowKeys removeAllObjects];
        [_ayShowKeys release];
    }
    
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self initializer];
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
        [self initializer];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
        [self initViews];
    return self;
}

- (void)initViews
{
    int nFontSize = 17;
    if (_nColCount >= 4)
        nFontSize = 15;
    
    //固定创建名称，代码，以及名称前的市场图片
    _lbStockName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lbStockName.font = tztUIBaseViewTextFont(nFontSize-2);
    self.lbStockName.textAlignment = NSTextAlignmentLeft;
    self.lbStockName.adjustsFontSizeToFitWidth = YES;
    self.lbStockName.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview: self.lbStockName];
    [_lbStockName release];
    
    _lbStockCode = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lbStockCode.font = tztUIBaseViewTextFont(10);
    self.lbStockCode.textAlignment = NSTextAlignmentLeft;
    self.lbStockCode.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview: self.lbStockCode];
    [_lbStockCode release];
    
    CGRect imagFrame = CGRectZero;
    imagFrame.origin.y += (self.frame.size.height * 2 / 3 - 10 + 5) / 2;
    imagFrame.size.height = 10.0f;
    imagFrame.size.width = 10;//self.frame.size.width;
    
    _imgView = [[UIImageView alloc] init];
    self.imgView.frame = imagFrame;
    _imgView.backgroundColor = [UIColor redColor];
    self.imgView.userInteractionEnabled = YES;
    [self addSubview:self.imgView];
    [_imgView release];
    
    CGRect imageFrameEx = CGRectZero;
    imageFrameEx.origin.y  = imagFrame.origin.y + imagFrame.size.height + 2;
    imageFrameEx.size.height = 10.f;
    imageFrameEx.size.width = 10;
    
    _imageViewEx = [[UIImageView alloc] init];
    _imageViewEx.frame = imageFrameEx;
    _imageViewEx.userInteractionEnabled = YES;
    [self addSubview:_imageViewEx];
    [_imageViewEx release];
    
    self.lbStockCode.textColor = [UIColor tztThemeTextColorLabel];
    self.lbStockName.textColor = [UIColor colorWithTztRGBStr:@"102,102,102"/* tztThemeTextColorLabel*/];
    
    if (_bUseSepLine)
    {
        if (_pSepLineView == nil)
        {
            _pSepLineView = [[UIView alloc] init];
            [self.contentView addSubview:_pSepLineView];
            [_pSepLineView release];
        }
    }
    
    if (_ayLabels == nil)
        _ayLabels = NewObject(NSMutableArray);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.lbStockName forKey:@"Name"];
    [self.ayLabels addObject:dict];
    
    //i从1开始，去掉了前面的名称列
    for(NSInteger i = 0; i < self.ayShowKeys.count; i++)
    {
        NSString* str = [self.ayShowKeys objectAtIndex:i];
        if ([str caseInsensitiveCompare:@"Name"] == NSOrderedSame)
        {
            continue;
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
#ifdef tzt_ZSSC
            label.font = tztUIBaseViewTextFont(nFontSize);
#else
            label.font = tztUIBaseViewTextBoldFont(nFontSize);
#endif
            label.textAlignment = NSTextAlignmentRight;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor tztThemeTextColorLabel];
            label.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:label];
            NSDictionary* dict = [NSDictionary dictionaryWithObject:label forKey:str];
            [_ayLabels addObject:dict];
            [label release];
        }
    }
    
    self.btnStock = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnStock setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
#ifdef tzt_ZSSC
    [self.btnStock.titleLabel setFont:tztUIBaseViewTextFont(nFontSize)];
#else
    [self.btnStock.titleLabel setFont:tztUIBaseViewTextBoldFont(nFontSize)];
#endif
    self.btnStock.layer.cornerRadius = 2.0f;
    [self.btnStock setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    self.btnStock.adjustsImageWhenDisabled = YES;
    self.btnStock.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.btnStock addTarget:self action:@selector(OnChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnStock];
    
    if ((_nRowIndex % 2) == 0)
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColor];
    else
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColorEx];
    
    _pLabelInfo = [[UILabel alloc] initWithFrame:self.bounds];
    _pLabelInfo.backgroundColor = [UIColor tztThemeBackgroundColor];
    _pLabelInfo.adjustsFontSizeToFitWidth = YES;
    _pLabelInfo.textAlignment = NSTextAlignmentCenter;
    _pLabelInfo.font = tztUIBaseViewTextFont(11);
    _pLabelInfo.textColor = [UIColor darkGrayColor];
    _pLabelInfo.text = @"宝宝为您提供沪深、港股、美股实时行情";
    _pLabelInfo.hidden = YES;
    [self addSubview:_pLabelInfo];
    [_pLabelInfo release];
}

- (void)initializer
{
    if (self.rightUtilityButtons.count > 0 || self.leftUtilityButtons.count > 0)
    {
        UISwipeGestureRecognizer *pan = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
        [pan setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:pan];
        [pan release];
        UISwipeGestureRecognizer *pan1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
        [pan1 setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:pan1];
        [pan1 release];
    }
    [self initViews];
    CGSize sz = CGSizeZero;
    if (_rightUtilityButtons.count > 0)
    {
        UIImage* image = [(UIButton*)[_rightUtilityButtons objectAtIndex:0] imageForState:UIControlStateNormal];
        if (image.size.width > 0 && image.size.height > 0)
        {
            sz = image.size;
        }
    }
    SWUtilityButtonView *scrollViewButtonViewRight = nil;
    if (sz.width > 0)
    {
         scrollViewButtonViewRight = [[SWUtilityButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:) andCellWidth:sz.width];
    }
    else
        scrollViewButtonViewRight = [[SWUtilityButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:)];
    [scrollViewButtonViewRight setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewRight = scrollViewButtonViewRight;
    self.scrollViewButtonViewRight.clBackColor = self.contentView.backgroundColor;
    [scrollViewButtonViewRight populateUtilityButtons];
    [self.contentView addSubview:scrollViewButtonViewRight];
    [scrollViewButtonViewRight release];
    return;
}

#pragma mark Selection
- (void)HiddenQuickSell:(TZTUserStockTableViewCell *)cell
{
    if (self != cell)
    {
        if (!cell.scrollViewButtonViewRight.bShow)
            return;
        [UIView animateWithDuration:0.5f animations:^(void)
         {
             CGRect rcFrame = self.scrollViewButtonViewRight.frame;
             rcFrame.origin.x += rcFrame.size.width;
             cell.scrollViewButtonViewRight.frame = rcFrame;
             [cell.scrollViewButtonViewRight setShow:NO];
         }];
    }
}

- (BOOL)CancelQuickSellShow
{
    if (!self.scrollViewButtonViewRight.bShow)
        return NO;
    [UIView animateWithDuration:0.5f animations:^(void)
     {
         CGRect rcFrame = self.scrollViewButtonViewRight.frame;
         rcFrame.origin.x += rcFrame.size.width;
         self.scrollViewButtonViewRight.frame = rcFrame;
         [self.scrollViewButtonViewRight setShow:NO];
     }];
    return YES;
}

- (void)scrollViewPressed:(id)sender
{
    //判断当前市场类型
    int nType = [[self.pDataDict tztObjectForKey:@"StockType"] intValue];
    if (!MakeStockMarketStock(nType))
        return;
    
    if ((_nRowIndex % 2) == 0)
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColor];
    else
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColorEx];
    
    UISwipeGestureRecognizer *pan = (UISwipeGestureRecognizer*)sender;
    if (pan.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if (self.scrollViewButtonViewRight.bShow)
            return;
        if (_tztDelegate && [_tztDelegate respondsToSelector:@selector(HiddenQuickSell:)])
        {
            [_tztDelegate HiddenQuickSell:self];
        }
        [UIView animateWithDuration:0.5f animations:^(void)
         {
             CGRect rcFrame = self.scrollViewButtonViewRight.frame;
             rcFrame.origin.x -= rcFrame.size.width;
             self.scrollViewButtonViewRight.frame = rcFrame;
             [self.scrollViewButtonViewRight setShow:YES];
             
             [NSTimer scheduledTimerWithTimeInterval:5
                                              target:self
                                            selector:@selector(CancelQuickSellShow)
                                            userInfo:self
                                             repeats:NO];
         }];
    }
    else if (pan.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (!self.scrollViewButtonViewRight.bShow)
            return;
        
        [UIView animateWithDuration:0.5f animations:^(void)
         {
             CGRect rcFrame = self.scrollViewButtonViewRight.frame;
             rcFrame.origin.x += rcFrame.size.width;
             self.scrollViewButtonViewRight.frame = rcFrame;
             [self.scrollViewButtonViewRight setShow:NO];
         }];
    }
    self.scrollViewButtonViewRight.backView.backgroundColor = self.contentView.backgroundColor;
}

- (void)timerEndCellHighlight:(id)sender
{
    if (self.highlighted)
    {
        self.scrollViewButtonViewLeft.hidden = NO;
        self.scrollViewButtonViewRight.hidden = NO;
        [self setHighlighted:NO];
    }
}

#pragma mark UITableViewCell overrides
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.scrollViewContentView.backgroundColor = backgroundColor;
}

#pragma mark - Utility buttons handling

- (void)rightUtilityButtonHandler:(id)sender
{
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    [self.scrollViewButtonViewRight setShow:NO];
    [UIView animateWithDuration:0.5f animations:^(void)
     {
         CGRect rcFrame = self.scrollViewButtonViewRight.frame;
         rcFrame.origin.x += rcFrame.size.width;
         self.scrollViewButtonViewRight.frame = rcFrame;
         [self.scrollViewButtonViewRight setShow:NO];
     }];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerRightUtilityButtonWithIndex:)])
        [_delegate swippableTableViewCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonTag];
}

- (void)leftUtilityButtonHandler:(id)sender
{
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerLeftUtilityButtonWithIndex:)])
        [_delegate swippableTableViewCell:self didTriggerLeftUtilityButtonWithIndex:utilityButtonTag];
}

- (void)hideUtilityButtonsAnimated:(BOOL)animated
{
    [self.cellScrollView setContentOffset:CGPointMake([self leftUtilityButtonsWidth], 0) animated:animated];
    _cellState = kCellStateCenter;
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)])
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
}

#pragma mark - Overriden methods
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger nCount = _nColCount;
    if (nCount < 1)
        nCount = 3;
    CGFloat fXMargin = 3;
    
    CGFloat width = (self.bounds.size.width - (nCount + 1) * fXMargin - 5) / nCount;
    CGFloat fHeight = 30;
    CGFloat fYMargin = (self.frame.size.height - fHeight) / 2;
    if (fYMargin <= 0)
    {
        fHeight = self.frame.size.height - 4;
        fYMargin = 2;
    }
    self.imgView.frame = CGRectMake(1, (self.frame.size.height * 2 / 3 - 9 + 5) / 2, 12, 9);
    if (self.imageView.image)
    {
        self.imageViewEx.frame = CGRectMake(1, self.imgView.frame.origin.y + self.imgView.frame.size.height + 1, 12, 9);
    }
    else
    {
        self.imageViewEx.frame = CGRectMake(1, (self.frame.size.height * 2 / 3 - 9 + 5) / 2, 12, 9);
    }
    self.pSepLineView.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 0.5f);
    self.pSepLineView.backgroundColor = [UIColor tztThemeBorderColorGrid];
    //14为左侧的图片预留宽度
    self.lbStockCode.frame = CGRectMake(14, fYMargin + (fHeight * 2 / 3), width-15, (fHeight / 3));
    self.lbStockName.frame = CGRectMake(14, fYMargin, width-15, (fHeight * 2 / 3));
    
    for (NSInteger i = 0; i < self.ayLabels.count; i++)
    {
        NSString* strKey = [self.ayShowKeys objectAtIndex:i];
        if ([strKey caseInsensitiveCompare:@"Name"] == NSOrderedSame)
            continue;
        
        CGRect rcFrame = CGRectMake(width * (i) + (fXMargin * (i)), fYMargin, width, fHeight);
        if (self.ayLabels.count == 3)
        {
            if (i == 1)
            {
                rcFrame.size.width -= 10;
            }
        }
        UIView *view = [[self.ayLabels objectAtIndex:i] objectForKey:strKey];
        view.frame = rcFrame;
        
        if ( (i == self.ayLabels.count-1) && _bUserStock)
        {
            CGRect rc = rcFrame;
            if (rc.size.width > 100)
            {
                rc.origin.x += 20;
                rc.size.width -= 20;
            }
            view.hidden = YES;
            self.btnStock.frame = rc;
        }
    }

    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);

    self.scrollViewButtonViewLeft.frame = CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height);
    [self.scrollViewButtonViewLeft setShow:NO];
    if (!self.scrollViewButtonViewRight.bShow)
    {
        self.scrollViewButtonViewRight.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height);
        [self.scrollViewButtonViewRight setShow:NO];
    }
    self.scrollViewContentView.frame = CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height);
    
    self.lbStockCode.textColor = [UIColor colorWithTztRGBStr:@"102,102,102" /*tztThemeTextColorLabel*/];
    self.lbStockName.textColor = [UIColor tztThemeTextColorLabel];
    if ((_nRowIndex % 2) == 0)
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColor];
    else
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColorEx];
}

#pragma mark - Setup helpers

-(void)setNsSection:(NSString *)nsName
{
    if (nsName.length > 0)
    {
        [_nsSection release];
        _nsSection = [nsName retain];
    }
}

-(void)setShowColKeys:(NSArray*)ayKeys
{
    if (ayKeys && ayKeys.count > 0)
    {
        [self.ayShowKeys removeAllObjects];
        for (NSInteger i = 0; i < ayKeys.count; i++)
        {
            [self.ayShowKeys addObject:[ayKeys objectAtIndex:i]];
        }
    }
    _nColCount = ayKeys.count;
    
    for (NSDictionary *dict in self.ayLabels)
    {
        for (NSString* nsKey in dict.allKeys)
        {
            if ([nsKey caseInsensitiveCompare:@"Name"] == NSOrderedSame)
                continue;
            else
            {
                UIView *pView = [dict objectForKey:nsKey];
                [pView removeFromSuperview];
            }
        }
    }
    
    [self.ayLabels removeAllObjects];
    int nFontSize = 17;
    if (_nColCount >= 4)
        nFontSize = 15;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.lbStockName forKey:@"Name"];
    [self.ayLabels addObject:dict];
    
    for(NSInteger i = 0; i < self.ayShowKeys.count; i++)
    {
        NSString* str = [self.ayShowKeys objectAtIndex:i];
        if ([str caseInsensitiveCompare:@"Name"] == NSOrderedSame)
        {
            continue;
        }
        else
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
#ifdef tzt_ZSSC
            label.font = tztUIBaseViewTextFont(nFontSize);
#else
            label.font = tztUIBaseViewTextBoldFont(nFontSize);
#endif
            label.textAlignment = NSTextAlignmentRight;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor tztThemeTextColorLabel];
            label.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:label];
            NSDictionary* dict = [NSDictionary dictionaryWithObject:label forKey:str];
            [_ayLabels addObject:dict];
            [label release];
        }
    }
}

-(void)setContent:(NSMutableDictionary *)pData
{
    self.pDataDict = pData;
    [self.imgView setImage:nil];
    [self.imageViewEx setImage:nil];
    self.imageViewEx.backgroundColor = [UIColor clearColor];
    self.imgView.backgroundColor = [UIColor clearColor];
    int nType = [[pData tztObjectForKey:@"StockType"] intValue];
    
    if (MakeHKMarket(nType))
        [self.imgView setImage:[UIImage imageTztNamed:@"TZTHKIcon@2x.png"]];
    else if(MakeUSMarket(nType))
        [self.imgView setImage:[UIImage imageTztNamed:@"TZTUSIcon@2x.png"]];
    
    /*
     //0-否，1-是，x-无此属性
     char    c_IsGgt;
     char    c_CanBuy;
     char    c_CanSell;
     
     //融资标的
     char    c_RZBD;
     //融券标的
     char    c_RQBD;
     */
    _bShowRZBD = NO;
    NSString* strProp = [pData tztObjectForKey:tztStockProp];
    const char* cProp = [strProp UTF8String];
    if (strProp.length > 3)
    {
        if (cProp[3] == '1')
            _bShowRZBD = YES;
        else
        {
            if (strProp.length > 4)
            {
                if (cProp[4] == '1')
                    _bShowRZBD = YES;
            }
        }
    }
    
    _bShowRZBD = NO;
    if (_bShowRZBD)
    {
        [self.imageViewEx setImage:[UIImage imageTztNamed:@"TZTRZRQIcon@2x.png"]];
    }
    
    NSDictionary* dictRatio = [pData tztObjectForKey:@"Ratio"];
    NSString* strRatio = [dictRatio tztObjectForKey:@"value"];
    
    NSDictionary* dictRange = [pData tztObjectForKey:@"Range"];
    NSString* strRange = [dictRange tztObjectForKey:@"value"];
    
    UIColor *pColor = [UIColor tztThemeHQBalanceColor];
    int nFlag = 1;
    if (nFlag == 0)
        pColor = [UIColor tztThemeHQBalanceColor];
    else if ([strRange hasPrefix:@"-"] && ![strRange isEqualToString:@"-.-"] && ![strRange isEqualToString:@"-.-%"])
        pColor = [UIColor tztThemeHQDownColor];
    else
        pColor = [UIColor tztThemeHQUpColor];
    
    if (!ISNSStringValid(strRatio) || [strRatio isEqualToString:@"-.-"] || [strRatio isEqualToString:@"--"])
    {
        nFlag = 0;
    }
    
    for (NSInteger i = 0; i < self.ayShowKeys.count; i++)
    {
        NSString* strData = [self.ayShowKeys objectAtIndex:i];
        if (strData.length < 1)
            continue;
        
        NSArray *ay = [strData componentsSeparatedByString:@"|"];
        if (ay.count <= 0)
            continue;
        NSString* strKey = [ay objectAtIndex:0];
        BOOL bUseColor = TRUE;//使用后台返回颜色
        if (ay.count > 1)
        {
            NSString* strUseColor = [ay objectAtIndex:1];
            if (strUseColor.length > 0)
                bUseColor = ([strUseColor intValue] > 0);
        }
        NSDictionary* dictName = [pData tztObjectForKey:strKey];
        NSString* strValue = [dictName tztObjectForKey:@"value"];
        if (!ISNSStringValid(strValue))
            strValue = @"-.-";
        if ([strKey caseInsensitiveCompare:@"Name"] == NSOrderedSame)
        {
            self.lbStockName.text = strValue;
            
            NSDictionary* dictCode = [pData tztObjectForKey:@"Code"];
            strValue = [dictCode tztObjectForKey:@"value"];
            self.lbStockCode.text = strValue;
        }
        else
        {
            UILabel *label = [[self.ayLabels objectAtIndex:i] objectForKey:strData];
            label.text = strValue;
            if (([strKey caseInsensitiveCompare:self.nsSection] == NSOrderedSame
                 &&[strKey caseInsensitiveCompare:@"Range"] == NSOrderedSame)
                || ([strKey caseInsensitiveCompare:@"NewPrice"] == NSOrderedSame))
            {
                label.textColor = pColor;
            }
            else
                label.textColor = [UIColor tztThemeTextColorLabel];
            
            if (!bUseColor)
                label.textColor = [UIColor tztThemeTextColorLabel];
        }
        
        
    }
    
    [self layoutSubviews];
}

-(void)setCellContent:(NSDictionary*)dict nsKey_:(NSString *)nsKey
{
    _pLabelInfo.hidden =(dict != NULL);
    if (dict == NULL)
    {
        _pLabelInfo.text = nsKey;
        return;
    }
    self.pDataDict = dict;
    [self.imgView setImage:nil];
    [self.imageViewEx setImage:nil];
    self.imgView.backgroundColor = [UIColor clearColor];
    self.imageViewEx.backgroundColor = [UIColor clearColor];
    int nType = [[dict tztObjectForKey:@"StockType"] intValue];
    
    if (MakeHKMarket(nType))
        [self.imgView setImage:[UIImage imageTztNamed:@"TZTHKIcon@2x.png"]];
    else if(MakeUSMarket(nType))
        [self.imgView setImage:[UIImage imageTztNamed:@"TZTUSIcon@2x.png"]];
    
    /*
     //0-否，1-是，x-无此属性
     char    c_IsGgt;
     char    c_CanBuy;
     char    c_CanSell;
     
     //融资标的
     char    c_RZBD;
     //融券标的
     char    c_RQBD;
     */
    _bShowRZBD = NO;
    NSString* strProp = [dict tztObjectForKey:tztStockProp];
    const char* cProp = [strProp UTF8String];
    if (strProp.length > 3)
    {
        if (cProp[3] == '1')
            _bShowRZBD = YES;
        else
        {
            if (strProp.length > 4)
            {
                if (cProp[4] == '1')
                    _bShowRZBD = YES;
            }
        }
    }
    
    _bShowRZBD = NO;
    if (_bShowRZBD)
    {
        [self.imageViewEx setImage:[UIImage imageTztNamed:@"TZTRZRQIcon@2x.png"]];
    }
    
    
    NSDictionary* dictRatio = [dict tztObjectForKey:@"Ratio"];
    NSString* strRatio = [dictRatio tztObjectForKey:@"value"];
    
    NSDictionary* dictRange = [dict tztObjectForKey:@"Range"];
    NSString* strRange = [dictRange tztObjectForKey:@"value"];
    
    UIColor *pColor = [UIColor tztThemeHQBalanceColor];
    int nFlag = 1;
    if (nFlag == 0)
        pColor = [UIColor tztThemeHQBalanceColor];
    else if ([strRange hasPrefix:@"-"] && ![strRange isEqualToString:@"-.-"] && ![strRange isEqualToString:@"-.-%"])
        pColor = [UIColor tztThemeHQDownColor];
    else
        pColor = [UIColor tztThemeHQUpColor];
    
    if (!ISNSStringValid(strRatio) || [strRatio isEqualToString:@"-.-"] || [strRatio isEqualToString:@"--"])
    {
        nFlag = 0;
    }
    
    for (NSInteger i = 0; i < self.ayShowKeys.count; i++)
    {
        NSString* strData = [self.ayShowKeys objectAtIndex:i];
        if (strData.length < 1)
            continue;
        
        NSArray *ay = [strData componentsSeparatedByString:@"|"];
        if (ay.count <= 0)
            continue;
        NSString* strKey = [ay objectAtIndex:0];
        BOOL bUseColor = TRUE;//使用后台返回颜色
        if (ay.count > 1)
        {
            NSString* strUseColor = [ay objectAtIndex:1];
            if (strUseColor.length > 0)
                bUseColor = ([strUseColor intValue] > 0);
        }
        
        NSDictionary* dictName = [dict tztObjectForKey:strKey];
        NSString* strValue = [dictName tztObjectForKey:@"value"];
        if (!ISNSStringValid(strValue))
            strValue = @"-.-";
        if ([strKey caseInsensitiveCompare:@"Name"] == NSOrderedSame)
        {
            self.lbStockName.text = strValue;
            
            NSDictionary* dictCode = [dict tztObjectForKey:@"Code"];
            strValue = [dictCode tztObjectForKey:@"value"];
            self.lbStockCode.text = strValue;
        }
        else
        {
            UILabel *label = [[self.ayLabels objectAtIndex:i] objectForKey:strData];
            label.text = strValue;
            
            if (!bUseColor)
                label.textColor = [UIColor tztThemeTextColorLabel];
            else
            {
                if (([strKey caseInsensitiveCompare:self.nsSection] == NSOrderedSame
                     &&[strKey caseInsensitiveCompare:@"Range"] == NSOrderedSame)
                    || ([strKey caseInsensitiveCompare:@"NewPrice"] == NSOrderedSame))
                {
                    label.textColor = pColor;
                }
                else
                    label.textColor = [UIColor tztThemeTextColorLabel];
            }
        }
    }
    
    NSDictionary* dictTemp = [dict tztObjectForKey:nsKey];
    
    NSString *title = [dictTemp tztObjectForKey:@"value"];
    
    self.lbStockData.hidden = YES;
    self.btnStock.hidden = NO;
    if ([strRatio caseInsensitiveCompare:@"-.-"] == NSOrderedSame
        || [strRatio caseInsensitiveCompare:@"--"] == NSOrderedSame
        || [strRatio caseInsensitiveCompare:@"0.00"] == NSOrderedSame)
    {
        [self.btnStock setBackgroundColor:[UIColor colorWithTztRGBStr:@"170,170,170"]];
    }
    else if ([strRatio hasPrefix:@"-"])
    {
        [self.btnStock setBackgroundColor:[UIColor tztThemeHQDownColor]];
    }
    else
    {
        if ([nsKey isEqualToString:@"Ratio"] || [nsKey isEqualToString:@"Range"]) {
            title = [NSString stringWithFormat:@"+%@", [[dict tztObjectForKey:nsKey] objectForKey:@"value"]];
        }
        [self.btnStock setBackgroundColor:[UIColor tztThemeHQUpColor]];
    }
    [self.btnStock setTztTitle:title];
}
//
-(void)OnChange:(id)sender
{
    if (self.tztDelegate && [self.tztDelegate respondsToSelector:@selector(OnChange:)])
    {
        [self.tztDelegate OnChange:sender];
    }
}

#pragma mark - Setup helpers

- (CGFloat)leftUtilityButtonsWidth {
    return [_scrollViewButtonViewLeft utilityButtonsWidth];
}

- (CGFloat)rightUtilityButtonsWidth {
    return [_scrollViewButtonViewRight utilityButtonsWidth];
}

- (CGFloat)utilityButtonsPadding {
    return ([_scrollViewButtonViewLeft utilityButtonsWidth] + [_scrollViewButtonViewRight utilityButtonsWidth]);
}

- (CGPoint)scrollViewContentOffset {
    return CGPointMake([_scrollViewButtonViewLeft utilityButtonsWidth], 0);
}

#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityButtonsPadding];
    _cellState = kCellStateRight;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateRight];
    }
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = [self leftUtilityButtonsWidth];
    _cellState = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _cellState = kCellStateLeft;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateLeft];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = [self utilityButtonsPadding] - ([self rightUtilityButtonsWidth] / 2);
                CGFloat leftThreshold = [self leftUtilityButtonsWidth] / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x >= ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x > [self leftUtilityButtonsWidth] / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x <= [self leftUtilityButtonsWidth] / 2)
                    [self scrollToLeft:targetContentOffset];
                else if (targetContentOffset->x < ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [self leftUtilityButtonsWidth]) {
        // Expose the right button view
        self.scrollViewButtonViewRight.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityButtonsWidth]), 0.0f, [self rightUtilityButtonsWidth], _height);
    } else {
        // Expose the left button view
        self.scrollViewButtonViewLeft.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, [self leftUtilityButtonsWidth], _height);
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //
    [super touchesBegan:touches withEvent:event];
    if (self.scrollViewButtonViewRight.bShow)
        return;
    self.contentView.backgroundColor = [UIColor tztThemeHQTableSelectColor];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if ((_nRowIndex % 2) == 0)
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColor];
    else
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColorEx];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if ((_nRowIndex % 2) == 0)
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColor];
    else
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColorEx];
}

- (void)CancelSelected
{
    if ((_nRowIndex % 2) == 0)
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColor];
    else
        self.contentView.backgroundColor = [UIColor tztThemeHQReportCellColorEx];
}
@end


#pragma mark NSMutableArray class extension helper

@implementation NSMutableArray(SWUtilityButtonView)
- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title {
//    self.nsImageName = @"";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addObject:button];
//    return button;
}

- (void)addUtilityButtonWithColor:(UIColor *)color icon:(NSString *)imageName
{
    if (imageName == NULL)
        imageName = @"";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    objc_setAssociatedObject(button, "k",imageName, OBJC_ASSOCIATION_RETAIN);
    [button setImage:[UIImage imageTztNamed:imageName] forState:UIControlStateNormal];
    [self addObject:button];
//    return button;
}

@end
