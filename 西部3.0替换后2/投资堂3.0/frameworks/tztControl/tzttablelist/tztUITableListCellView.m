   //
//  tztUITableListCellView.m
//  tztMobileApp
//
//  Created by yangares on 13-4-25.
//
//

#import "tztUITableListCellView.h"

@implementation tztUITableListCellView
@synthesize cellproperty = _cellproperty;
@synthesize bBackBlackColor = _bBackBlackColor;
@synthesize opened = _opened;
@synthesize nType = _nType;
//Icon大小
#define tztTableCellIconWidth 32
#define tztTableCellIconHeight 24
#define tztTableCellMargin 5

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	//调用父类创建
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{

        _cellinfo = NewObject(NSMutableDictionary);
        //默认缩进距离
        self.indentationWidth = 20;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellproperty = NewObjectAutoD(NSMutableDictionary);
        [_cellproperty setTztValue:@"20" forKey:@"Indentation"];
        [_cellproperty setTztValue:@",,26,26" forKey:@"IconRect"];
        [_cellproperty setTztValue:@",,12,12" forKey:@"RightRect"];
        [_cellproperty setTztValue:[NSString stringWithFormat:@"%d",tztTableCellMargin] forKey:@"CellMargin"];
        [_cellproperty setTztValue:@"" forKey:@"GridLine"];
    }
	return self;
}

- (void)dealloc
{
    DelObject(_cellinfo);
    NilObject(self.cellproperty);
    [super dealloc];
}

//重新布局各个view显示
-(void)layoutSubviews
{
	[super layoutSubviews];
    //当前view的高度，宽度
    float nHeight = self.frame.size.height;
    float width = self.frame.size.width;
    //当前view的缩进距离
    float indentation = self.indentationWidth * self.indentationLevel;
    float fCellMargin = tztTableCellMargin;
    if(_cellproperty)
    {
        NSString* strIndentation = [_cellproperty tztValueForKey:@"Indentation"];
        if(strIndentation && [strIndentation floatValue] > 0)
        {
            self.indentationWidth = [strIndentation floatValue];
            indentation = self.indentationWidth * self.indentationLevel;
        }
        
        NSString* strCellMargin = [_cellproperty tztValueForKey:@"CellMargin"];
        if(strCellMargin && [strCellMargin floatValue] >= 0)
        {
            fCellMargin = [strCellMargin floatValue];
        }
    }
    //可用区域（总宽度 － 缩进距离 － 总间距 － 10）
    int nValidWidth = width - (indentation ? indentation:fCellMargin * 2) - fCellMargin * 2 - 10;
    int nLeft = (indentation ? indentation:fCellMargin * 2);
    //垂直居中
    int nTop = 0;// = (nHeight - (m_nIconWidth > 0 ? m_nIconWidth : tztTableCellIconWidth)) / 2;

    //图标
    NSString* strIconRect = @"";
    if(_cellproperty)
        strIconRect = [_cellproperty tztValueForKey:@"IconRect"];
    if(strIconRect && [strIconRect length] > 0)
    {
        CGRect iconFrame = CGRectMaketztNSString(strIconRect, 0, 0, tztTableCellIconWidth, tztTableCellIconHeight, nValidWidth, nHeight);
        nTop = (nHeight - iconFrame.size.height) / 2;
        if (nTop < 0)
        {
            nTop = 0;
            iconFrame.size.height = nHeight;
        }
        iconFrame.origin.y = nTop;
        iconFrame.origin.x += nLeft;
        if(_iconimageview == nil)
        {
            _iconimageview = NewObject(UIImageView);
            _iconimageview.image = nil;
            [self.contentView addSubview:_iconimageview];
            [_iconimageview release];
        }
        
        if(_cellinfo)
        {
            NSString* strIcon = [_cellinfo tztValueForKey:@"IconImage"];
            if(strIcon && [strIcon length] > 0)
            {
                if ([strIcon rangeOfString:@"tzt" options:NSCaseInsensitiveSearch].location == NSNotFound)
                {
                    tztUITableListInfo *listinfo = [_cellinfo tztObjectForKey:@"CellInfo"];
                    BOOL bFirst = (listinfo && listinfo.cellLevel == 0);//只有第一级菜单才有默认图片显示
                    strIcon = [NSString stringWithFormat:@"tztimage_%@",strIcon];
                    if ([UIImage imageTztNamed:strIcon])
                        _iconimageview.image = [UIImage imageTztNamed:strIcon];
                    else if(bFirst)//使用默认的图标
                        _iconimageview.image = [UIImage imageTztNamed:@"tzt_hqmenu_default.png"];
                }
                else if([strIcon length] > 0)
                {
                    _iconimageview.image = [UIImage imageTztNamed:strIcon];
                }
            }
            else
                _iconimageview.image = nil;
        }
        
        if(_iconimageview.image) //有图形
        {
            _iconimageview.hidden = NO;
            _iconimageview.frame = iconFrame;
            nLeft = iconFrame.origin.x + iconFrame.size.width + fCellMargin;
        }
        else
        {
            _iconimageview.hidden = YES;
            nLeft += fCellMargin;
        }
    }
    else if(_iconimageview)
    {
        _iconimageview.hidden = YES;
        nLeft += fCellMargin;
    }
    //右侧图
    NSString* strRightRect = @"";
    if(_cellproperty)
        strRightRect = [_cellproperty tztValueForKey:@"RightRect"];
    if(strRightRect && [strRightRect length] > 0)
    {
        CGRect rightFrame = CGRectMaketztNSString(strRightRect, 0, 0, tztTableCellIconWidth, tztTableCellIconHeight, nValidWidth, nHeight);
        nTop = (nHeight - rightFrame.size.height) / 2;
        if (nTop < 0)
        {
            nTop = 0;
            rightFrame.size.height = nHeight;
        }
        rightFrame.origin.y = nTop;
        rightFrame.origin.x = MAX(nLeft,width - 20 - rightFrame.size.width -  fCellMargin * 2);
        if(_rightimageview == nil)
        {
            _rightimageview = NewObject(UIImageView);
            [self.contentView addSubview:_rightimageview];
            [_rightimageview release];
        }
        _rightimageview.hidden = NO;
        _rightimageview.frame = rightFrame;
        
        if(_cellinfo)
        {
            NSString* strRight = [_cellinfo tztValueForKey:@"RightImage"];
            tztUITableListInfo *listinfo = [_cellinfo tztObjectForKey:@"CellInfo"];
            BOOL bHaveChild = TRUE;
//            bHaveChild = (listinfo && listinfo.cellayChild && [listinfo.cellayChild count] > 0);
            if(strRight)
                _rightimageview.image = [UIImage imageTztNamed:strRight];
            else if(bHaveChild)
                _rightimageview.image = [UIImage imageTztNamed:@"TZTTableArrorRight.png"];
            
            if (_opened && listinfo && listinfo.cellayChild && [listinfo.cellayChild count] > 0)
            {
                _rightimageview.layer.transform = CATransform3DMakeRotation((M_PI / 180) * 90, 0.0f, 0.0f, 1.0f);
            }
            else
            {
                _rightimageview.layer.transform = CATransform3DMakeRotation((M_PI / 180) * 1, 0.0f, 0.0f, 1.0f);
            }
        }
        nValidWidth = rightFrame.origin.x - nLeft - fCellMargin;
    }
    else if(_rightimageview)
    {
        _rightimageview.hidden = YES;
    }
    
    NSString* strBackBlackColor = nil;
    if(_cellproperty)
        strBackBlackColor = [_cellproperty tztValueForKey:@"BackBlackColor"];
    if(strBackBlackColor == nil || [strBackBlackColor length] <= 0)
        strBackBlackColor = @"37,37,37";
    
    self.backgroundColor = [UIColor colorWithTztRGBStr:strBackBlackColor];
//    self.bBackBlackColor = ([strBackBlackColor intValue] > 0);
    
    
    NSString* strTitleRect = @",,,";
    
    if(_cellproperty)
        strTitleRect = [_cellproperty tztValueForKey:@"TitleRect"];
    
    if(strTitleRect == nil || [strTitleRect length] <= 0)
        strTitleRect = @",,,";
    if(strTitleRect && [strTitleRect length] > 0)
    {
        CGRect titleFrame = CGRectMaketztNSString(strTitleRect, 0, 0, nValidWidth, tztTableCellIconHeight, nValidWidth, nHeight);
        nTop = (nHeight - titleFrame.size.height) / 2;
        if (nTop < 0)
        {
            nTop = 0;
            titleFrame.size.height = nHeight;
        }
        titleFrame.origin.y = nTop;
        titleFrame.origin.x = MAX(nLeft,titleFrame.origin.x);
        titleFrame.size.width = MIN(titleFrame.size.width, nValidWidth);
        if(_titleLabel == nil)
        {
            _titleLabel = NewObject(UILabel);
            _titleLabel.font = tztUIBaseViewTextBoldFont(0);
            _titleLabel.textColor = [UIColor colorXORUIColor:self.backgroundColor];
//            if (_bBackBlackColor)
//                _titleLabel.textColor = [UIColor whiteColor];
//            else
//                _titleLabel.textColor = [UIColor blackColor];
            
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.contentView addSubview:_titleLabel];
            [_titleLabel release];
        }
        _titleLabel.frame = titleFrame;
        
        if(_cellinfo)
        {
            NSString* strTitle = [_cellinfo tztValueForKey:@"Title"];
            if(strTitle)
                _titleLabel.text = strTitle;
            else
                _titleLabel.text = @"";
        }
    }
    
    //间隔
    NSString* strGridLine = nil;
    if(_cellproperty)
        strGridLine = [_cellproperty tztValueForKey:@"GridLine"];
    NSString* strGridColor = nil;
    if (_cellproperty)
        strGridColor = [_cellproperty tztValueForKey:@"GridColor"];
    if(strGridLine)
    {
        [self setGridLine:strGridLine nsColor_:strGridColor];
    }
    else if(_gridLine)
    {
        _gridLine.hidden = YES;
    }
    
    NSString* strBackground = nil;
    if(_cellproperty)
        strBackground = [_cellproperty tztValueForKey:@"Background"];
    
    if(strBackground)
    {
        [self setBackground:strBackground];
    }
    else if(_backgroundimageview != nil)
    {
        _backgroundimageview.hidden = YES;
    }

    
    if (_cellinfo && IS_TZTIPAD)//iPad才有选中效果
    {
        tztUITableListInfo *listinfo = [_cellinfo tztObjectForKey:@"CellInfo"];
        if (listinfo && listinfo.bSelected)
        {
            [self setBackground:@"TZTMenuSelect.png"];
        }
    }
    [self reloadTheme];
}

- (void)reloadTheme
{
    [self setGridLine:nil nsColor_:[UIColor tztThemeGridColorString]];
    if (_nType >= 1)
    {
        self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        _titleLabel.textColor = [UIColor tztThemeHQFixTextColor];
    }
    else
    {
        self.backgroundColor = [UIColor tztThemeBackgroundColor];
        _titleLabel.textColor = [UIColor tztThemeTextColorLabel];
    }
    if (g_nSkinType == 1)
    {
//        self.backgroundColor = [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1.0];
//        [self setGridLine:nil nsColor_:@"217, 217, 217"];
        _rightimageview.image = [UIImage imageTztNamed:@"TZTTableArrorRight_white.png"];
//        _titleLabel.textColor = [UIColor darkGrayColor];
    }
}

//设置分割符
-(void)setGridLine:(NSString *)nsImg nsColor_:(NSString*)nsColor
{
	//是否使用图片
	BOOL bUseImg = TRUE;
	if (nsImg == NULL || [nsImg length] < 1)
	{
		bUseImg = FALSE;
	}
	else
	{
		//图片不存在，则也使用颜色填充
		if (![UIImage imageTztNamed:nsImg])
			bUseImg = FALSE;
	}
	//分割线view
    if(_gridLine == nil)
    {
        CGRect lineframe = self.bounds;
        lineframe.size.height = 1;
        _gridLine = [[UIView alloc]initWithFrame:lineframe];
        [self addSubview:_gridLine];
        [_gridLine release];
    }
	//设置为半透明
    [_gridLine setAlpha:0.5];
	if (bUseImg)
	{
		_gridLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:nsImg]];
	}
	else
	{
        if (nsColor.length < 1)
        {
            nsColor = [UIColor tztThemeGridColorString];
        }
        UIColor *pColor = [UIColor colorWithTztRGBStr:nsColor];
        if (nsColor && nsColor.length > 0)
        {
            pColor = [UIColor colorWithTztRGBStr:nsColor];
        }
		_gridLine.backgroundColor =  pColor;
	}
     _gridLine.hidden = NO;
}

//设置背景图片
-(void)setBackground:(NSString*)nsImg
{
	BOOL bUseImg = TRUE;
	if (nsImg == NULL || [nsImg length] < 1)
	{
		bUseImg = FALSE;
	}
	else
	{
		//图片读取失败或图片不存在
		if (![UIImage imageTztNamed:nsImg])
			bUseImg = FALSE;
	}
	
	//创建背景view
	if (_backgroundimageview == nil)
	{
		_backgroundimageview = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:_backgroundimageview];
		[self sendSubviewToBack:_backgroundimageview];
		[_backgroundimageview release];
	}
	
	//使用图片
	if (bUseImg)
	{
		_backgroundimageview.image = [UIImage imageTztNamed:nsImg];
	}
	else
	{
		//使用透明色
		_backgroundimageview.backgroundColor = [UIColor clearColor];
	}
    _backgroundimageview.hidden = NO;
}

//显示数据
- (void)setCellInfo:(NSString*)strTitle Icon:(NSString*)strIcon Right:(NSString*)strRight Info:(tztUITableListInfo*)info
{
    if(_cellinfo == nil)
    {
        _cellinfo = NewObject(NSMutableDictionary);
    }
    [_cellinfo setTztValue:strTitle forKey:@"Title"];
    [_cellinfo setTztValue:strIcon forKey:@"IconImage"];
    [_cellinfo setTztValue:strRight forKey:@"RightImage"];
    [_cellinfo setTztObject:info forKey:@"CellInfo"];
    [self layoutSubviews];
}
@end

@implementation tztUITableListSectionView
@synthesize section = _section;
@synthesize opened = _opened;
@synthesize tztdelegate = _tztdelegate;
@synthesize tableinfo = _tableinfo;
@synthesize cellview = _cellview;
@synthesize nType = _nType;

- (id)initWithFrame:(CGRect)frame andType:(int)nType
{
    self.nType = nType;
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
																					  action:@selector(toggleAction:)] autorelease];
		[self addGestureRecognizer:tapGesture];
		self.userInteractionEnabled = YES;
        if(_cellview == nil)
        {
            _cellview = [[tztUITableListCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tzttablesection"];
            _cellview.frame = self.bounds;
            _cellview.userInteractionEnabled = NO;
            _cellview.nType = _nType;
            [self addSubview:_cellview];
            [_cellview release];
        }
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)setSectionProperty:(NSMutableDictionary*)property
{
    if(_cellview)
    {
        _cellview.cellproperty = property;
        [_cellview layoutSubviews];
    }
}

- (void)setListInfo:(tztUITableListInfo*)listinfo section:(NSInteger)sectionNumber delegate:(id<tztUITableListSectionViewDelegate>)tztdelegate
{
    self.tableinfo = listinfo;
    self.tztdelegate = tztdelegate;
    _section = sectionNumber;
    _opened = _tableinfo.cellExpand;
    
    _cellview.opened = _opened;
    [_cellview setCellInfo:_tableinfo.cellTitle Icon:_tableinfo.cellImageName Right:nil Info:_tableinfo];
}

-(IBAction)toggleAction:(id)sender {
	
	_opened = !_opened;
	if (_opened) {
		if ([_tztdelegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
			[_tztdelegate sectionHeaderView:self sectionOpened:_section];
		}
	}
	else {
		if ([_tztdelegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
			[_tztdelegate sectionHeaderView:self sectionClosed:_section];
		}
	}
    
}

@end
