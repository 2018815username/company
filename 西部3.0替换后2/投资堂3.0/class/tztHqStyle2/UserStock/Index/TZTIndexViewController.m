/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:    首页VC
 *
 * 当前版本:
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTIndexViewController.h"
#import "tztMarketMoreView.h"
#import "TZTBlockTableView.h"

@interface TZTIndexViewController ()<tztUIBaseViewTextDelegate>
{
    //是否显示工具栏
    int         _nHasToolbar;
    int         _nTitleType;//标题类型
    TZTTagView  *_tagView;
}

 /**
 *	@brief	自选
 */
@property(nonatomic,retain) TZTUserStockTableView   *userTableView;
 /**
 *	@brief	沪深
 */
@property(nonatomic,retain) TZTHSStockTableView     *hsTableView;
 /**
 *	@brief	港股
 */
@property(nonatomic,retain) TZTHSStockTableView     *hkTableView;
 /**
 *	@brief	美股
 */
@property(nonatomic,retain) TZTHSStockTableView     *usTableView;
 /**
 *	@brief	环球
 */
@property(nonatomic,retain) /*TZTHSStockTableView*/tztMarketMoreView     *qqTableView;

@property(nonatomic,retain) UIButton                *pBtnEditor;



 /**
 *	@brief	标题背景
 */
@property(nonatomic,retain)UIView                   *pTitleBackView;

@property(nonatomic,retain)UILabel                  *pLabel;

@property(nonatomic,retain)tztUITextField           *pTextField;

@property(nonatomic,retain)UIButton                 *pLeftButton;

@property(nonatomic,retain)UIButton                 *pSearchButton;

@property(nonatomic,retain)NSMutableArray           *ayTableViews;//显示的view数组

@end

@implementation TZTIndexViewController
@synthesize userTableView = _userTableView;
@synthesize hsTableView   = _hsTableView;
@synthesize hkTableView   = _hkTableView;
@synthesize usTableView   = _usTableView;
@synthesize qqTableView   = _qqTableView;
@synthesize pBtnEditor    = _pBtnEditor;
@synthesize pTitleBackView = _pTitleBackView;
@synthesize pLabel = _pLabel;
@synthesize pTextField = _pTextField;
@synthesize pLeftButton = _pLeftButton;
@synthesize pSearchButton = _pSearchButton;
//@synthesize moreMarketView = _moreMarketView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        _nHasToolbar = 1;
        if (IS_TZTIPAD)
        {
            _nTitleType = TZTTitleEdit|TZTTitleNormal;
        }
        else
        {
            _nTitleType = TZTTitleIcon;
        }
    }
    self.nsTitle = @"市场行情";
    
    return self;
}

-(void)dealloc
{
    DelObject(_ayTableViews);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_ayTableViews == nil)
        _ayTableViews = NewObject(NSMutableArray);
    
    //读取配置tztQuoteTagSetting，对应配置选项
    
    [self LoadLayoutView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetMessage:) name:@"tztGetPushMessage" object:nil];
    
    [_hsTableView setStockCode:@"1" Request:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!IS_TZTIPAD)
    {
        [super viewDidAppear:animated];//????此处暂时先注释，pad版本弹出会导致右侧的关闭按钮失效，原因待查
        [self LoadLayoutView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (NSInteger i = 0; i < self.ayTableViews.count; i++)
    {
        UIView *pView = [self.ayTableViews objectAtIndex:i];
        if (pView.hidden)
        {
            [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
        }
        else
        {
            [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)YES];
        }
        if (pView && !pView.hidden)
        {
            [pView tztperformSelector:@"setStockCode:Request:" withObject:[tztUserStock GetNSUserStock] withObject:(id)YES];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    for (NSInteger i = 0; i < self.ayTableViews.count; i++)
    {
        UIView *pView = [self.ayTableViews objectAtIndex:i];
        [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
    }
}

-(void)OnEditBtn
{
    [TZTUIBaseVCMsg OnMsg:HQ_MENU_EditUserStock wParam:0 lParam:0];
}

-(void)OnContactUS:(id)sender
{
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}


-(void)GetMessage:(NSNotification*)noti
{
    NSInteger n = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (n > 0)
    {
        [self.pLeftButton setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo+1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.pLeftButton setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo.png"] forState:UIControlStateNormal];
    }
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    if (CGRectIsEmpty(rcFrame) || CGRectIsNull(rcFrame))
        return;
    CGRect rcTitle = self.tztTitleView.frame;
    
    if (self.tztTitleType == tztTitleNew)
    {
        if (_pTitleBackView == NULL)
        {
            _pTitleBackView = [[UIView alloc] initWithFrame:rcTitle];
            _pTitleBackView.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
            [_tztBaseView addSubview:_pTitleBackView];
            [_pTitleBackView release];
        }
        else
        {
            _pTitleBackView.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
            _pTitleBackView.frame = rcTitle;
        }
        
        CGRect rcSearchBar = rcTitle;
        rcSearchBar.origin.x += 5 + 60;
        rcSearchBar.origin.y += (7 + (IS_TZTIOS(7) ? TZTStatuBarHeight : 0));
        rcSearchBar.size.width -= 70 * 2;
        rcSearchBar.size.height = rcTitle.size.height - 14 - (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
        
        CGRect rcLabel = rcSearchBar;
        if (_pLabel == nil)
        {
            _pLabel = [[UILabel alloc] initWithFrame:rcLabel];
            _pLabel.backgroundColor = [UIColor clearColor];
            _pLabel.layer.cornerRadius = 5.0f;
            [_tztBaseView addSubview:_pLabel];
            [_pLabel release];
        }
        else
        {
            _pLabel.frame = rcLabel;
        }
        
        CGRect rcImage = CGRectMake(rcLabel.origin.x + 5, rcLabel.origin.y, 2, 2);
        rcImage.origin.y += (rcLabel.size.height - rcImage.size.height) / 2;
        
        CGRect rcTextField = rcSearchBar;
        rcTextField.origin.x += rcImage.size.width + 5;
        rcTextField.size.width -= (2+rcImage.size.width);
        if (_pTextField == nil)
        {
            _pTextField = [[tztUITextField alloc] initWithProperty:@"tag=1000|keyboardtype=number|maxlen=6||textalignment=left|textcolor=255,255,255|enabled=0|"];
            _pTextField.enabled = NO;
            _pTextField.tztdelegate = self;
            _pTextField.backgroundColor = [UIColor colorWithTztRGBStr:@"20,22,27"];
            _pTextField.layer.borderColor = [UIColor colorWithTztRGBStr:@"25,27,34"].CGColor;
            _pTextField.layer.borderWidth = 1.1f;
            _pTextField.textColor = [UIColor whiteColor];
            _pTextField.frame = rcTextField;
            _pTextField.leftViewMode = UITextFieldViewModeAlways;
            
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTnavbarsearch.png"]];
            image.alpha = 0.5f;
            image.frame = CGRectMake(0, 0, 30, 30);
            _pTextField.leftView = image;
            [image release];
            
            _pTextField.layer.cornerRadius = 2.5f;
            [_tztBaseView addSubview:_pTextField];
            [_pTextField release];
        }
        else
        {
            _pTextField.frame = rcTextField;
        }
        CGRect rcButton = rcTextField;
        if (_pSearchButton == NULL)
        {
            _pSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _pSearchButton.frame = rcButton;
            _pSearchButton.backgroundColor = [UIColor clearColor];
            [_pSearchButton setTztTitle:@"请输入股票代码/首字母"];
            [_pSearchButton setTztTitleColor:[UIColor lightTextColor]];
            [_pSearchButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [_pSearchButton addTarget:self
                               action:@selector(OnSearchStockCode)
                     forControlEvents:UIControlEventTouchUpInside];
            _pSearchButton.titleLabel.font = tztUIBaseViewTextFont(11.f);
            [_tztBaseView addSubview:_pSearchButton];
        }
        _pSearchButton.frame = rcButton;

        CGRect rcLeftItem = self.tztTitleView.firstBtn.frame;
        CGSize sz = CGSizeMake(60, 44);
        rcLeftItem.origin.x += (rcLeftItem.size.width - sz.width) / 2;
        rcLeftItem.origin.y += (rcLeftItem.size.height - sz.height) / 2;
        rcLeftItem.size = sz;
        
        if (_pLeftButton == NULL)
        {
            _pLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pTitleBackView addSubview:_pLeftButton];
            
            NSInteger n = [UIApplication sharedApplication].applicationIconBadgeNumber;
            if (n > 0)
            {
                [_pLeftButton setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo+1.png"] forState:UIControlStateNormal];
            }
            else
            {
                [_pLeftButton setBackgroundImage:[UIImage imageTztNamed:@"TZTLogo.png"] forState:UIControlStateNormal];
            }
            [_pLeftButton setTztTitle:@""];
            [_pLeftButton addTarget:self
                             action:@selector(OnLeftItem:)
                   forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.pLeftButton.frame = rcLeftItem;
        self.pLeftButton.hidden = self.bHiddenLeftIcon;
        
        CGRect rcEdit = self.tztTitleView.fourthBtn.frame;
        
        rcEdit.size.width = 60;
        if (_pBtnEditor == NULL)
        {
            _pBtnEditor = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pTitleBackView insertSubview:_pBtnEditor belowSubview:self.tztTitleView.fourthBtn];
            [_pBtnEditor setTztImage:[UIImage imageTztNamed:@"TZTEditUserStock@2x.png"]];
            [_pBtnEditor setTztTitle:@""];
            self.pBtnEditor.alpha = .0f;
            [_pBtnEditor addTarget:self
                            action:@selector(OnEditBtn)
                  forControlEvents:UIControlEventTouchUpInside];
        }
        self.pBtnEditor.frame = rcEdit;
    }
    else
    {
        self.tztTitleView.firstBtn.hidden = self.bHiddenLeftIcon;
    }
    
    
    //读取配置文件
    NSMutableDictionary *dictData = GetDictByListName(@"tztQuoteTagSetting");
    BOOL bShowSepLine = ([[dictData objectForKey:@"hassepline"] intValue] > 0);
    NSMutableArray *ayData = [dictData objectForKey:@"quotesettings"];
    if (ayData == nil)
        ayData = NewObjectAutoD(NSMutableArray);
    //没有配置，增加默认值 显示名称｜tag(对应宏定义)｜类名｜
    if (ayData.count <= 0)
    {
        [ayData addObject:@"沪深|12004|TZTHSStockTableView"];
        [ayData addObject:@"港股|12005|TZTHSStockTableView"];
        [ayData addObject:@"美股|12009|TZTHSStockTableView"];
        [ayData addObject:@"更多|12018|tztMarketMoreView"];
    }
    
    CGFloat fTagHeight = 35;
    if (ayData.count < 2)
        fTagHeight = 0;
    CGRect rect = rcFrame;
    rect.origin.y += self.tztTitleView.frame.size.height;
    rect.size.height = fTagHeight;
    
    //@"美股|12009",@"环球|12008", 
    if (_tagView == NULL)
    {
        _tagView = [[TZTTagView alloc] init];
        _tagView.ayData = ayData;
        _tagView.frame = rect;
        _tagView.delegate = self;
        [_tztBaseView addSubview:_tagView];
        [_tagView release];
    }
    else
        _tagView.frame = rect;
    
    UIView *pView = [_tztBaseView viewWithTag:0x5765];
    if (bShowSepLine)
    {
        CGRect rcLine = rect;
        rcLine.origin.y += rect.size.height + 1;
        rcLine.size.height = 0.5f;
        
        if (pView == nil)
        {
            pView = [[UIView alloc] initWithFrame:rcLine];
            [_tztBaseView addSubview:pView];
            [pView release];
        }
        else
        {
            pView.frame = rcLine;
        }
        
        pView.backgroundColor = [UIColor tztThemeBorderColorGrid];
    }
    pView.hidden = !bShowSepLine;
    
    rect.origin.y += rect.size.height + 2;
#ifdef tzt_NewVersion
    rect.size.height = rcFrame.size.height - rect.origin.y - 2;
#else
    rect.size.height = rcFrame.size.height - rect.origin.y - TZTToolBarHeight - 2;
#endif
    
    for (NSInteger i = 0; i < ayData.count; i++)
    {
        NSString* str = [ayData objectAtIndex:i];
        NSArray *ay = [str componentsSeparatedByString:@"|"];
        if (ay.count < 3)
            continue;
        int nTag = [[ay objectAtIndex:1] intValue];
        NSString* strClass = [ay objectAtIndex:2];
        if (strClass.length <= 0)
            continue;
        
        UIView *pView = [_tztBaseView viewWithTag:nTag + 0x7777];
        if (pView == nil)
        {
            pView = [[NSClassFromString(strClass) alloc] init];
            pView.tag = nTag + 0x7777;
            
            if ([pView isKindOfClass:[tztMarketMoreView class]])
            {
                if (ay.count > 3)
                {
                    NSString* str = [ay objectAtIndex:3];
                    if (str.length > 0)
                    {
                        ((tztMarketMoreView*)pView).bShowUseWeb = YES;
                        ((TZTHSStockTableView*)pView).frame = rect;
                        [(tztMarketMoreView*)pView setURL:str];
                    }
                }
            }
            
            ((TZTHSStockTableView*)pView).frame = rect;
            [_tztBaseView addSubview:pView];
            [_ayTableViews addObject:pView];
            
            if (i == 0)
            {
                [pView tztperformSelector:@"OnSetViewRequest:" withObject:(id)YES];
                [pView tztperformSelector:@"setStockCode:Request:" withObject:[tztUserStock GetNSUserStock] withObject:(id)YES];
                
                if (self.tztTitleType == tztTitleOld)
                {
                    NSString* strTitle = [ay objectAtIndex:0];
                    if (ISNSStringValid(strTitle))
                        self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
                    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
                    self.tztTitleView.firstBtn.hidden = self.bHiddenLeftIcon;
                }
            }
            
            pView.hidden = (i != 0);
            if ([pView isKindOfClass:[TZTHSStockTableView class]]
                || [pView isKindOfClass:[TZTBlockTableView class]])
            {
                ((TZTHSStockTableView*)pView).ntztMarket = nTag;
            }
            if ([pView isKindOfClass:[TZTUserStockTableView class]])
            {
                ((TZTUserStockTableView*)pView).nShowInQuote = 1;
                [UIView animateWithDuration:0.3f animations:^{
                    self.pBtnEditor.alpha = (pView.hidden ? 0 : 1);
                }];
//                self.pBtnEditor.hidden = pView.hidden;
            }
            
            [pView release];
            
        }
        else
        {
            pView.frame = rect;
        }
    }
    [self CreateToolBar];
    
    /**/
    //增加左侧可拖动功能
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_tztTitleView];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_tztTitleView];
    
    if (self.pTitleBackView)
    {
        [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:self.pTitleBackView];
        [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:self.pTitleBackView];
    }
    
    CGRect rcLeft = CGRectMake(0, _tztTitleView.frame.size.height, 15, _tztBounds.size.height);
    if (_pLeftView == nil)
    {
        _pLeftView = [[UIView alloc] initWithFrame:rcLeft];
        _pLeftView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_pLeftView];
        [_pLeftView release];
    }
    else
    {
        _pLeftView.frame = rcLeft;
    }
    
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews removeObject:_pLeftView];
    [[TZTAppObj getShareInstance].rootTabBarController.ayViews addObject:_pLeftView];
    
    [[TZTAppObj getShareInstance].rootTabBarController RefreshAddCustomsViews];
}

-(void)OnLeftItem:(id)sender
{
    [[TZTAppObj getShareInstance].rootTabBarController ShowLeftVC];
}

-(void)OnSearchStockCode
{
    [TZTUIBaseVCMsg OnMsg:MENU_HQ_SearchStock wParam:0 lParam:0];
}

//创建toolbar
-(void)CreateToolBar
{
#ifdef tzt_NewVersion
    return;
#endif
    
}

-(void)tztTagView:(TZTTagView *)tagView OnButtonClick:(UIButton *)sender AtIndex:(int)nIndex
{
    if (tagView != _tagView)
        return;
    
    for (NSInteger i = 0; i < self.ayTableViews.count; i++)
    {
        UIView *pView = [self.ayTableViews objectAtIndex:i];
        if ((sender.tag + 0x7777) == pView.tag)//
        {
            if (self.tztTitleType == tztTitleOld)
            {
                NSArray *ay = tagView.ayData;
                if (nIndex >= 0 && nIndex < ay.count)
                {
                    NSString* strData = [ay objectAtIndex:nIndex];
                    NSArray *aySub = [strData componentsSeparatedByString:@"|"];
                    if (aySub.count > 0)
                    {
                        NSString* strTitle = [aySub objectAtIndex:0];
                        if (ISNSStringValid(strTitle))
                        {
                            self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
                            [self onSetTztTitleView:strTitle type:TZTTitleReport];
                            self.tztTitleView.firstBtn.hidden = self.bHiddenLeftIcon;
                        }
                    }
                }
            }
            pView.hidden = NO;
            [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)YES];
            [pView tztperformSelector:@"setStockCode:Request:" withObject:[tztUserStock GetNSUserStock] withObject:(id)YES];
            
            [UIView animateWithDuration:0.3f animations:^{
                
                if ([pView isKindOfClass:[TZTUserStockTableView class]])
                {
                    self.pBtnEditor.alpha = 1.f;
                }
                else
                    self.pBtnEditor.alpha = 0.f;
            }];
        }
        else
        {
            pView.hidden = YES;
            [pView tztperformSelector:@"onSetViewRequest:" withObject:(id)NO];
        }
    }
}

@end
