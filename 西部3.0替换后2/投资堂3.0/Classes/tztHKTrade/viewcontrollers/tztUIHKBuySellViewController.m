//
//  tztUIHKBuySellViewController.m
//  tztMobileApp_HTSC
//
//  Created by King on 14-9-16.
//
//

#import "tztUIHKBuySellViewController.h"
#import "tztHKBuySellView.h"

@interface tztUIHKBuySellViewController ()

 /**
 *	@brief	操作,布局界面
 */
@property(nonatomic,retain)tztHKBuySellView *pHKBuySellView;

@end

@implementation tztUIHKBuySellViewController
@synthesize pHKBuySellView = _pHKBuySellView;
@synthesize bBuyFlag = _bBuyFlag;
@synthesize CurStockCode = _CurStockCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadLayoutView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
}

 /**
 *	@brief	界面布局
 *
 *	@return	无
 */
-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    
    NSString * sTitle = [self GetTitle:_nMsgType];
    if (sTitle == NULL)
        sTitle = @"";
    self.nsTitle = [NSString stringWithFormat:@"%@", sTitle];
    [self onSetTztTitleView:self.nsTitle type:TZTTitleReport];
    CGRect rcBuySell = rcFrame;
    rcBuySell.origin.y += _tztTitleView.frame.size.height;
    if (IS_TZTIPAD||!g_pSystermConfig.bShowbottomTool)
        rcBuySell.size.height -= _tztTitleView.frame.size.height;
    else
        rcBuySell.size.height -= (_tztTitleView.frame.size.height + TZTToolBarHeight);
    
    if (_pHKBuySellView == nil)
    {
        _pHKBuySellView = [[tztHKBuySellView alloc] init];
        _pHKBuySellView.bBuyFlag = _bBuyFlag;
        _pHKBuySellView.delegate = self;
        _pHKBuySellView.nMsgType = _nMsgType;
        _pHKBuySellView.frame = rcBuySell;
        if (self.CurStockCode && [self.CurStockCode length] > 0) // 赋值self.CurStockCode byDBQ20130729
        {
            [_pHKBuySellView setStockCode:self.CurStockCode];
            [_pHKBuySellView OnRefresh];
        }
        [_tztBaseView addSubview:_pHKBuySellView];
        [_pHKBuySellView release];
        
    }
    else
    {
        _pHKBuySellView.frame = rcBuySell;
    }
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
}

-(void)CreateToolBar
{
    
}

-(void)OnRequestData
{
    if (self.CurStockCode == NULL || self.CurStockCode.length < 1)
    {
        if (_pHKBuySellView)
        {
            [_pHKBuySellView ClearData];
        }
    }
    else
    {
        if (_pHKBuySellView)
        {
            [_pHKBuySellView ClearData];
            [_pHKBuySellView setStockCode:self.CurStockCode];
            [_pHKBuySellView OnRefresh];
        }
    }
    
}

 /**
 *	@brief	根据页面类型功能号获取统一标题名称
 *
 *	@param 	nMsgType 	页面功能号
 *
 *	@return	标题
 */
- (NSString *)GetTitle:(NSInteger)nMsgType
{
    NSString* strTitle = GetTitleByID(nMsgType);
    if (strTitle.length<=0) {
        switch (nMsgType) {
            case MENU_JY_HK_Buy:
                strTitle = @"买入";
                break;
            case MENU_JY_HK_Sell:
                strTitle = @"卖出";
                break;
            case MENU_JY_HK_WithDraw:
                strTitle =@"撤单";
                break;
            default:
                break;
        }
    }
    return strTitle;
}

@end
