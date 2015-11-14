//
//  tztMarketMoreView.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-7-29.
//
//

#import "tztMarketMoreView.h"
#import "tztWebView.h"

#define tztShowTitle    @"tztShowTitle"
#define tztShowImage    @"tztShowImage"
#define tztFunction     @"tztFunction"
#define tztMarket       @"tztMarket"

#define tztButtonTag    0x1234
@interface tztUIMarketViewCell : UIView

@property(nonatomic,retain)NSMutableDictionary   *pDictData;
@property(nonatomic,assign)int nCols;
@property(nonatomic,retain)UILabel               *pTitleView;
@property(nonatomic,assign)id tztDelegate;
@end

@implementation tztUIMarketViewCell
@synthesize pDictData = _pDictData;
@synthesize nCols = _nCols;
@synthesize pTitleView = _pTitleView;
@synthesize tztDelegate = _tztDelegate;
-(id)init
{
    self = [super init];
    if (self)
    {
        _nCols = 3;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _nCols = 3;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    self.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    CGRect rcTitle = self.bounds;
    rcTitle.size.height = 0;
//    if (_pTitleView == NULL)
//    {
//        _pTitleView = [[UILabel alloc] initWithFrame:rcTitle];
//        [self addSubview:_pTitleView];
//        [_pTitleView release];
//    }
//    else
//        _pTitleView.frame = rcTitle;
//    
//    _pTitleView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
//    _pTitleView.textColor = [UIColor tztThemeTextColorLabel];
//    _pTitleView.font = tztUIBaseViewTextFont(13.f);
//    
//    NSString* strTitle = [self.pDictData objectForKey:tztShowTitle];
//    if (ISNSStringValid(strTitle))
//        _pTitleView.text = [NSString stringWithFormat:@"        %@", strTitle];
//    else
//        _pTitleView.text = @"";
    
    CGRect rcFrame = self.bounds;
    rcFrame.origin.y += rcTitle.size.height;
    rcFrame.size.height -= rcTitle.size.height;
    
    NSMutableArray *ayMarket = [self.pDictData objectForKey:tztMarket];
    
    NSInteger nMarketCount = [ayMarket count];
    if (nMarketCount <= 0)
        return;
    int nXMargin = 10;
    int nYMargin = 5;
    
    NSInteger nRows = (nMarketCount / _nCols + (nMarketCount % _nCols == 0 ? 0 : 1));
    float fWidth = (rcFrame.size.width - (_nCols + 1) * nXMargin) / _nCols;
    float fHeight = 35;// (rcFrame.size.height - (nRows + 1) * nYMargin) / nRows;
    nYMargin = (rcFrame.size.height - nRows * fHeight) / (nRows + 1);
    
    for (int i = 0; i < [ayMarket count]; i++)
    {
        NSString* strMarket = [ayMarket objectAtIndex:i];
        NSArray *ayData = [strMarket componentsSeparatedByString:@"|"];
        if (ayData == NULL || [ayData count] <= 0)
            continue;
        
        float x = (i % _nCols) * fWidth + ((i % _nCols)+1)*nXMargin;
        float y = (i / _nCols) * fHeight + ((i / _nCols)+1)*nYMargin + rcTitle.size.height;
        CGRect rcBtn = CGRectMake(x, y, fWidth, fHeight);
        int nBtnTag = [[ayData objectAtIndex:0] intValue];
        UIButton *pBtn = (UIButton*)[self viewWithTag:tztButtonTag + nBtnTag];
        if (pBtn == NULL)
        {
            pBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [pBtn addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            pBtn.tag = tztButtonTag + nBtnTag;
            [self addSubview:pBtn];
        }
        pBtn.titleLabel.textColor = [UIColor tztThemeTextColorForSection];
        pBtn.backgroundColor = [UIColor tztThemeBackgroundColorSection];
        pBtn.layer.borderColor = [UIColor tztThemeBorderColorGrid].CGColor;
        pBtn.layer.borderWidth = .5f;
        pBtn.titleLabel.font = tztUIBaseViewTextFont(13.f);
        [pBtn setTztTitleColor:[UIColor tztThemeTextColorLabel]];
        pBtn.showsTouchWhenHighlighted = YES;
        NSString* strTitle = @"";
        if ([ayData count] > 1)
            strTitle = [ayData objectAtIndex:1];
        [pBtn setTztTitle:strTitle];
        pBtn.frame = rcBtn;
    }
    
}

-(void)OnButtonClick:(id)sender
{
    //点击处理
    UIButton *button = (UIButton*)sender;
    NSInteger nTag = button.tag - tztButtonTag;
    
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_Report wParam:(NSUInteger)[NSString stringWithFormat:@"%ld",(long)nTag] lParam:0];
}

@end



@interface tztMarketMoreView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,retain)UITableView *pTableView;
@property(nonatomic,retain)NSMutableArray *pDataArray;


-(void)initData;
@end

@interface tztMarketMoreView()
{
    
}
@property(nonatomic,retain)tztWebView *pWebView;
@end

@implementation tztMarketMoreView
@synthesize tztdelegate = _tztdelegate;
@synthesize pTableView = _pTableView;
@synthesize pDataArray = _pDataArray;
@synthesize pWebView = _pWebView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initData];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initData];
    }
    return self;
}

-(void)initData
{
    if (_pDataArray == NULL)
        _pDataArray = NewObject(NSMutableArray);
    
    [_pDataArray removeAllObjects];
    
    //个股
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    [pDict setObject:@"沪深" forKey:tztShowTitle];
    [pDict setObject:@"TZTGGIcon@2x.png" forKey:tztShowImage];
    NSMutableArray* ayMarket = NewObject(NSMutableArray);
    [ayMarket addObject:@"324|上证A股"];//上证a
    [ayMarket addObject:@"326|上证B股"];//上证b
    [ayMarket addObject:@"325|深证A股"];//深证a
    [ayMarket addObject:@"327|深证B股"];//深证b
    [ayMarket addObject:@"310|中小板"];//中小板
    [ayMarket addObject:@"311|创业板"];//创业板
//    [ayMarket addObject:@"346|沪深三板"];//三板
    [ayMarket addObject:@"350|风险警示"];//退市整理
    [ayMarket addObject:@"351|退市整理"];//退市整理
    [ayMarket addObject:@"355|沪股通标的"];//沪股通标的
    
    //    [pDict setObject:[NSString stringWithFormat:<#(NSString *), ...#>] forKey:<#(id<NSCopying>)#>]
    [pDict setObject:ayMarket forKey:tztMarket];
    [ayMarket release];
    [_pDataArray addObject:pDict];
    [pDict release];

    //港股
    pDict = NewObject(NSMutableDictionary);
    [pDict setObject:@"港股" forKey:tztShowTitle];
    [pDict setObject:@"TZTHKIconEx@2x.png" forKey:tztShowImage];
    ayMarket = NewObject(NSMutableArray);
    [ayMarket addObject:@"606|香港主板"];//香港主板
    [ayMarket addObject:@"607|香港创业板"];//香港创业板
    [ayMarket addObject:@"630|港股通标的"];//港股通标的
    [ayMarket addObject:@"603|红筹股"];//红筹股
    [ayMarket addObject:@"604|蓝筹股"];//蓝筹股
    [ayMarket addObject:@"602|国企股"];//国企股
    
    [pDict setObject:ayMarket forKey:tztMarket];
    [ayMarket release];
    [_pDataArray addObject:pDict];
    [pDict release];
    
    //外盘
    pDict = NewObject(NSMutableDictionary);
    [pDict setObject:@"全球市场" forKey:tztShowTitle];//包含国内外期货、外汇
    [pDict setObject:@"TZTQQIcon@2x.png" forKey:tztShowImage];
    ayMarket = NewObject(NSMutableArray);
    [ayMarket addObject:@"1601|美股中概股"];
    [ayMarket addObject:@"1602|美股明星股"];
    [ayMarket addObject:@"901|国际指数"];
//    [ayMarket addObject:@"7|国内期货"];//对应市场菜单中的市场编号，7-国内期货 9-全球市场 8-外汇 10-国际指数
//    [ayMarket addObject:@"8|外汇"];
    
//    [pDict setObject:[NSString stringWithFormat:@"%d", MENU_HQ_QH] forKey:tztFunction];
    [pDict setObject:ayMarket forKey:tztMarket];
    [ayMarket release];
    [_pDataArray addObject:pDict];
    [pDict release];
    
    //债券
    pDict = NewObject(NSMutableDictionary);
    [pDict setObject:@"债券" forKey:tztShowTitle];
    [pDict setObject:@"TZTZQIcon@2x.png" forKey:tztShowImage];
    ayMarket = NewObject(NSMutableArray);
    //债券中增加国债逆回购放在最前方取消沪深债券；
    [ayMarket addObject:@"353|国债逆回购"];//国债逆回购
    [ayMarket addObject:@"343|上证债券"];//上证债券
    [ayMarket addObject:@"344|深证债券"];//深证债券
    
    [pDict setObject:ayMarket forKey:tztMarket];
    [ayMarket release];
    [_pDataArray addObject:pDict];
    [pDict release];
    
    //基金
    pDict = NewObject(NSMutableDictionary);
    [pDict setObject:@"基金" forKey:tztShowTitle];
    [pDict setObject:@"TZTJJIcon@2x.png" forKey:tztShowImage];
    ayMarket = NewObject(NSMutableArray);
    [ayMarket addObject:@"330|沪深封闭基金"];//沪深基金
    [ayMarket addObject:@"1401|上证封闭基金"];//ETF
    [ayMarket addObject:@"1402|深证封闭基金"];//LOF
    
    [pDict setObject:ayMarket forKey:tztMarket];
    [ayMarket release];
    [_pDataArray addObject:pDict];
    [pDict release];
    
    //期货
    pDict = NewObject(NSMutableDictionary);
    [pDict setObject:@"期货" forKey:tztShowTitle];
    [pDict setObject:@"TZTQHIcon@2x.png" forKey:tztShowImage];
    ayMarket = NewObject(NSMutableArray);
    [ayMarket addObject:@"70101|股指期货"];//股指期货
    [ayMarket addObject:@"702|郑州期货"];//郑州期货
    [ayMarket addObject:@"703|上海期货"];//上海期货
    [ayMarket addObject:@"704|大连期货"];//大连期货
    [ayMarket addObject:@"9|国际期货"];//国际期货
    
    [pDict setObject:ayMarket forKey:tztMarket];
    [ayMarket release];
    [_pDataArray addObject:pDict];
    [pDict release];
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    if (_bShowUseWeb)
    {
        if (_pWebView == nil)
        {
            _pWebView = [[tztWebView alloc] initWithFrame:rcFrame];
            [self addSubview:_pWebView];
            [_pWebView release];
        }
        else
            _pWebView.frame = rcFrame;
    }
    else
    {
        rcFrame.origin.y += 5;
        rcFrame.size.height -= 5;
        if (_pTableView == NULL)
        {
            _pTableView = [[UITableView alloc] initWithFrame:rcFrame style:UITableViewStylePlain];
            _pTableView.delegate = self;
            _pTableView.dataSource = self;
            _pTableView.sectionHeaderHeight = 25;
            _pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //        _pTableView.sectionHeaderHeight = 0;
            [self addSubview:_pTableView];
            [_pTableView release];
        }
        else
        {
            _pTableView.frame = rcFrame;
        }
        self.pTableView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    }
}

-(void)setURL:(NSString*)strURL
{
    if (!_bShowUseWeb)
        return;
    if (_pWebView == nil)
        return;
    [_pWebView setWebURL:[tztlocalHTTPServer getLocalHttpUrl:strURL]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_pDataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section >= [_pDataArray count])
//        return 0;
//    
//    NSMutableDictionary *pDict = [_pDataArray objectAtIndex:section];
//    NSMutableArray *array = [pDict objectForKey:tztMarket];
//    nCount = [array count];
    
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_pDataArray count] <= 0)
        return 40;
    NSInteger nCount = 0;
    if (indexPath.section >= [_pDataArray count])
        return 0;
    
    NSMutableDictionary *pDict = [_pDataArray objectAtIndex:indexPath.section];
    NSMutableArray *array = [pDict objectForKey:tztMarket];
    nCount = [array count];
    
    int nCols = 3;
    if (indexPath.section == 1)
        nCols = 4;
    NSInteger nRow = (nCount / nCols + (nCount % nCols == 0 ? 0 : 1));
    
    return (nRow) * 35.f + (nRow+1)*5 + 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section >= [_pDataArray count])
        return nil;
    
    NSDictionary* pDict = [_pDataArray objectAtIndex:section];
    
    NSString* strImage = [pDict objectForKey:tztShowImage];
    CGRect sectionRect = CGRectMake(0, 0, self.bounds.size.width, tableView.sectionHeaderHeight );
    UIView *pView = [[[UIView alloc] initWithFrame:sectionRect] autorelease];
    pView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    
    UIView *pLine = [[UIView alloc] initWithFrame:CGRectMake(5, 10, sectionRect.size.width - 10, 1)];
    pLine.backgroundColor = [UIColor tztThemeBackgroundColorSection];
    [pView addSubview:pLine];
    [pLine release];
    
    CGRect rcImage = pView.bounds;
    rcImage.size.width = 15;
    rcImage.size.height = 15;
    rcImage.origin.x += 5;
    rcImage.origin.y += (sectionRect.size.height - rcImage.size.height) / 2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rcImage];
    [imageView setImage:[UIImage imageTztNamed:strImage]];
    imageView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    [pView addSubview:imageView];
    [imageView release];
    
    UIFont *pFont = tztUIBaseViewTextFont(14.f);
    NSString* strTitle = [pDict objectForKey:tztShowTitle];
    int nWidth = [strTitle sizeWithFont:pFont].width + 10;
    CGRect rcLabel = sectionRect;
    rcLabel.origin.x += rcImage.origin.x + rcImage.size.width;
    rcLabel.size.width = nWidth;
    rcLabel.size.height -= 3;
    
    UILabel *pLabel = [[UILabel alloc] initWithFrame:rcLabel];
    pLabel.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    pLabel.textColor = [UIColor tztThemeTextColorLabel];
    
    pLabel.text = [NSString stringWithFormat:@" %@", strTitle];
    pLabel.font = pFont;
    
    [pView addSubview:pLabel];
    [pLabel release];
    return pView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = [NSString stringWithFormat:@"cellId%ld%ld", (long)indexPath.section, (long)indexPath.row ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
  
    NSMutableDictionary *pDict = [_pDataArray objectAtIndex:indexPath.section];
    NSMutableArray *array = [pDict objectForKey:tztMarket];
    NSInteger nCount = [array count];
    
    int nCols = 3;
//    if (indexPath.section == 1)
//        nCols = 4;
    NSInteger nRow = (nCount / nCols + (nCount % nCols == 0 ? 0 : 1));
    
    float fHeight = (nRow) * 35.f + (nRow+1) * 5 + 10;
    CGRect sectionRect = CGRectMake(0, 0, self.bounds.size.width, fHeight);
    
    if (cell == NULL)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        tztUIMarketViewCell *pView = [[[tztUIMarketViewCell alloc] init] autorelease];
        pView.nCols = 3;// (indexPath.section == 1 ? 4 : 3);
        pView.tag = 0x12345;
        pView.pDictData = [_pDataArray objectAtIndex:indexPath.section];
        pView.frame = sectionRect;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:pView];
    }
    else
    {
        tztUIMarketViewCell* pView = (tztUIMarketViewCell*)[cell.contentView viewWithTag:0x12345];
        if (pView)
        {
            pView.nCols = 3;// (indexPath.section == 1 ? 4 : 3);
            pView.pDictData = [_pDataArray objectAtIndex:indexPath.section];
            pView.frame = sectionRect;
        }
    }
    return cell;
}


@end
