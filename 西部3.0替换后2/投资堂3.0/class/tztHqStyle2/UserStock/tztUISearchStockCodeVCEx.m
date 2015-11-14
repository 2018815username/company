/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUISearchStockStockCodeVCEx
 * 文件标识：
 * 摘    要：   个股查询扩展
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-12
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import "tztBaseUIWebView.h"
#import "tztUISearchStockCodeVCEx.h"
#import "tztUISearchStockViewStyle3.h"

@interface tztUISearchStockCodeVCEx ()
{
    UIView      *_pTitleBack;
    UIButton    *_pBtnBack;
    UIButton    *_pBtnSearch;
    
    UILabel         *_pLabel;
    UIImageView     *_pImageView;
    tztUITextField  *_pTextField;
    
    UISearchBar *_pSearchBar;
}
@property(nonatomic,retain)UISearchBar *pSearchBar;
@property(nonatomic,retain)tztUISearchStockViewStyle3 *pSearchStockViewStyle3;
@property NSInteger nSearchType;
@end

@implementation tztUISearchStockCodeVCEx
@synthesize pSearchStockView = _pSearchStockView;
@synthesize nsURL = _nsURL;
@synthesize lParam = _lParam;
@synthesize bHidenAddBtn = _bHidenAddBtn;
@synthesize pSearchBar = _pSearchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nSearchType = 1;
    NSString *strType = [g_pSystermConfig.pDict tztObjectForKey:@"SearchStockType"];
    if (strType && strType.length > 0)
        _nSearchType = [strType intValue];
    [self LoadLayoutView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#ifdef __IPHONE_7_0
    if (IS_TZTIOS(7))
    {
//        if (g_nSkinType >= 1)
//        {
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//        }
//        else
        {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }
#endif
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_pTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
#ifdef __IPHONE_7_0
    if (IS_TZTIOS(7))
    {
//        if (g_nSkinType >= 1)
//        {
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        }
//        else
//        {
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//        }
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    DelObject(_pSearchStockView);
    [super dealloc];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;//self.view.bounds;
//    rcFrame.size.height -= _tztBaseView.frame.origin.y;
    
    CGRect rcTitle = rcFrame;
    rcTitle.size.height = TZTToolBarHeight + (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
    if (_pTitleBack == nil)
    {
        _pTitleBack = [[UIView alloc] initWithFrame:rcTitle];
        [_tztBaseView addSubview:_pTitleBack];
        [_pTitleBack release];
    }
    else
    {
        _pTitleBack.frame = rcTitle;
    }
    
    _pTitleBack.backgroundColor = [UIColor tztThemeBackgroundColorTitle];
    
    CGRect rcBack = rcTitle;
//    UIImage* backimage = [UIImage imageTztNamed:@"TZTnavbarbackbg.png"];
    rcBack.size = CGSizeMake(10, 4);
    rcBack.origin.y += (rcTitle.size.height - rcBack.size.height - (IS_TZTIOS(7) ? TZTStatuBarHeight : 0)) / 2;
    
    
    CGRect rcSearchBar = rcTitle;
    rcSearchBar.origin.x += 5 + rcBack.size.width;
    rcSearchBar.origin.y += (7 + (IS_TZTIOS(7) ? TZTStatuBarHeight : 0));
    rcSearchBar.size.width -= 80;
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
    /*
     if (_pImageView == nil)
     {
     _pImageView = [[UIImageView alloc] initWithFrame:rcImage];
     _pImageView.contentMode = UIViewContentModeCenter;
     _pImageView.image = [UIImage imageTztNamed:@"tztSearchIcon.png"];
     [_tztBaseView addSubview:_pImageView];
     [_pImageView release];
     }
     else
     {
     _pImageView.frame = rcImage;
     }
     */
    
    CGRect rcTextField = rcSearchBar;
    rcTextField.origin.x += rcImage.size.width + 5;
    rcTextField.size.width -= (2+rcImage.size.width);
    if (_pTextField == nil)
    {
        _pTextField = [[tztUITextField alloc] initWithProperty:@"tag=1000|keyboardtype=number|maxlen=6|placeholder=请输入股票代码/首字母|textalignment=left"];
        _pTextField.tztdelegate = self;
        _pTextField.frame = rcTextField;
        _pTextField.leftViewMode = UITextFieldViewModeAlways;

        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"tztSearchIcon.png"]];
        image.frame = CGRectMake(0, 0, 16, 16);
        _pTextField.leftView = image;
        [image release];
        
        _pTextField.layer.cornerRadius = 2.5f;
        
//        _pTextField.leftView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTGGIcon.png"]] autorelease];
        [_tztBaseView addSubview:_pTextField];
        [_pTextField release];
//        [_pTextField becomeFirstResponder];
    }
    else
    {
        _pTextField.frame = rcTextField;
    }
    _pTextField.backgroundColor = [UIColor tztThemeBackgroundColorEditor];
    _pTextField.layer.borderColor = [UIColor tztThemeBackgroundColorEditor].CGColor;

    CGRect rcBtn = rcTitle;
    rcBtn.origin.y += (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
    rcBtn.origin.x = rcSearchBar.origin.x + rcSearchBar.size.width + 2;
    rcBtn.size.height = rcTitle.size.height - (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
    rcBtn.size.width = (rcTitle.size.width - rcBtn.origin.x - 2);
    if (_pBtnSearch == nil)
    {
        _pBtnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnSearch setShowsTouchWhenHighlighted:YES];
        [_pBtnSearch setBackgroundColor:[UIColor clearColor]];
        [_pBtnSearch setTztTitle:@"取消"];
        _pBtnSearch.frame = rcBtn;
        [_pBtnSearch addTarget:self action:@selector(OnReturnBack) forControlEvents:UIControlEventTouchUpInside];
        [_pBtnSearch.titleLabel setFont:tztUIBaseViewTextFont(15.0f)];
        [_tztBaseView addSubview:_pBtnSearch];
    }
    else
    {
        _pBtnBack.frame = rcBtn;
    }
    [_pBtnSearch setTztTitleColor:[UIColor whiteColor]];
    
    CGRect rcTable = rcFrame;
    rcTable.origin.y += _pTitleBack.frame.size.height;
    rcTable.size.height -= (_pTitleBack.frame.size.height);
    
    
    if (_nSearchType == 2)
    {
        if (_pSearchStockViewStyle3 == nil)
        {
            _pSearchStockViewStyle3 = [[tztUISearchStockViewStyle3 alloc] init];
            _pSearchStockViewStyle3.frame = rcTable;
            _pSearchStockViewStyle3.tztdelegate = self;
            [_tztBaseView addSubview:_pSearchStockViewStyle3];
            [_pSearchStockViewStyle3 release];
        }
        else
            _pSearchStockViewStyle3.frame = rcTable;
        _pSearchStockViewStyle3.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    }
    else
    {
        if (_pSearchStockView == nil)
        {
            _pSearchStockView = [[tztUISearchStockViewEx alloc] init];
            _pSearchStockView.frame = rcTable;
            if (self.nsURL)
                _pSearchStockView.nsURL = [NSString stringWithFormat:@"%@", self.nsURL];
            _pSearchStockView.bHidenAddBtn = _bHidenAddBtn;
            _pSearchStockView.tztdelegate = self;
            [_tztBaseView addSubview:_pSearchStockView];
        }
        else
        {
            _pSearchStockView.frame = rcTable;
        }
        _pSearchStockView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    }
    
    self.view.backgroundColor = [UIColor tztThemeBackgroundColorHQ];

}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//得到股票数据
-(void)tzthqView:(id)hqView setStockCode:(tztStockInfo *)pStock
{
    [g_navigationController popViewControllerAnimated:NO];
    if (pStock == NULL || pStock.stockCode == NULL || pStock.stockCode.length <= 0)
        return;
    BOOL bRunJS = FALSE;//调用js
    if (self.nsURL && self.nsURL.length > 0)
    {
        //调用js函数
        if (self.nsURL && [self.nsURL hasPrefix:@"JsFuncName="])
        {
            NSArray *pAy = [self.nsURL componentsSeparatedByString:@"="];
            if ([pAy count] > 1)
            {
                NSString* str = [pAy objectAtIndex:1];
                str = [str stringByReplacingOccurrencesOfString:@"($stockcode)" withString:pStock.stockCode];
                if (pStock.stockName && pStock.stockName.length > 0)
                    str = [str stringByReplacingOccurrencesOfString:@"($stockname)" withString:pStock.stockName];
                if (self.lParam && [self.lParam isKindOfClass:[tztBaseUIWebView class]])
                {
                    [((tztBaseUIWebView*)self.lParam) tztStringByEvaluatingJavaScriptFromString:str];
                    bRunJS = TRUE;
                }
            }
        }
    }
    
    if (!bRunJS)
        [TZTUIBaseVCMsg OnMsg:HQ_MENU_Trend wParam:(NSUInteger)pStock lParam:0];
}

-(void)OnReturnBack
{
//    if (self.presentedViewController || self.modalViewController)
//    {
//        [self dismissModalViewControllerAnimated:NO];
//    }
    //
    [g_navigationController popViewControllerAnimated:UseAnimated];
    return;
    if (self.pParentVC)
        [TZTUIBaseVCMsg IPadPopViewController:self.pParentVC];
    else
        [TZTUIBaseVCMsg IPadPopViewController:g_navigationController];
}

-(void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (([text length] >= _pTextField.maxlen))
    {
        [_pTextField resignFirstResponder];
    }
    if ([text caseInsensitiveCompare:@".zztzt"] == NSOrderedSame)//打开地址设置界面
    {
        [g_navigationController popViewControllerAnimated:NO];
        _pTextField.text = @"";
        [TZTUIBaseVCMsg OnMsg:Sys_Menu_AddDelServer wParam:0 lParam:0];
        return;
    }
    else if([text caseInsensitiveCompare:@"..ajax"] == NSOrderedSame )
    {
        _pTextField.text = @"";
        [TZTUIBaseVCMsg OnMsg:ID_MENU_AJAXTEST wParam:0 lParam:0];
        return;
    }
    else if ([text caseInsensitiveCompare:@".clear"] == NSOrderedSame)
    {
        NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
        [tztKeyChain save:tztLogMobile data:@""];
        [tztKeyChain save:@"com.tzt.userinfo" data:pDict];
        //读取用户信息
        [TZTUserInfoDeal SaveAndLoadLogin:TRUE nFlag_:1];
        return;
    }
    else if([text caseInsensitiveCompare:@"tztui0"] == NSOrderedSame
            || [text caseInsensitiveCompare:@"tztui1"] == NSOrderedSame
            || [text caseInsensitiveCompare:@"tztui2"] == NSOrderedSame)
    {
        //获取ui
        NSString *strUI = [text substringFromIndex:[@"tztui" length]];
        int nType = [strUI intValue];
#ifdef tztRunSchemesURL
        NSString* str = [NSString stringWithFormat:@"%@://ui=%d",tztRunSchemesURL, nType];
        [[TZTAppObj getShareInstance] tztHandleOpenURL:[NSURL URLWithString:str]];
#endif
        
    }
    
    if (_nSearchType > 1)
    {
        if (_pSearchStockViewStyle3)
            [_pSearchStockViewStyle3 RequestStock:text];
    }
    else
    {
        if (_pSearchStockView)
            [_pSearchStockView RequestStock:text];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    if (_nSearchType > 1)
    {
        if (_pSearchStockViewStyle3)
            [_pSearchStockViewStyle3 RequestStock:searchText];
    }
    else
    {
        if (_pSearchStockView)
            [_pSearchStockView RequestStock:searchText];
    }
}

-(void)tztSearchStockBeginScroll
{
    [_pTextField resignFirstResponder];
}
@end
