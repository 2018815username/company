/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        功能列表
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztUIFuctionListViewController.h"

////////////////////////////////////////
@interface tztUIFuctionListViewController ()

@end
///////////////////////////////////////
@implementation tztUIFuctionListViewController
@synthesize pMenuView = _pMenuView;
@synthesize nsProfileName = _nsProfileName;
@synthesize pDict = _pDict;
@synthesize nFixBackColor = _nFixBackColor;

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
    NSLog(@"viewdidlog");
    [super viewDidLoad];
    [self LoadLayoutView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didreceivememorywarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds; //
    int nType = TZTTitleReport; // 交易 ntype＝257
//#ifdef tzt_NewVersion // 新版委托交易不要返回 byDBQ20130715
//    if ([TZTUIBaseVCMsg GetSameClassViewController:[tztUIFuctionListViewController class]])
//    {
//#ifdef Support_UserInfo
//        nType = TZTTitleUser;
//#else
//        nType = TZTTitleReport;
//#endif
//    }
//    else
//    {
//#ifdef Support_UserInfo
//        nType = TZTTitleUserInfo;
//#else
//        nType = NULL;
//#endif
//    }
//#else
//    
//#ifdef Support_UserInfo
//    nType = TZTTitleUser;
//#else
//    nType = TZTTitleReport;
//#endif
//    
//#endif
    
#ifdef Support_UserInfo
    nType = TZTTitleUser;
#else
    nType = TZTTitleReport;//257
#endif
    
    [self onSetTztTitleView:self.nsTitle type:nType]; //在这里设置交易 title
    

    CGRect rcMenu = rcFrame;
    rcMenu.origin = CGPointZero;
    rcMenu.origin.y += _tztTitleView.frame.size.height;
    rcMenu.size.height -= (_tztTitleView.frame.size.height);
    if (_pMenuView == NULL)
    {
        _pMenuView = [[tztUITableListView alloc] initWithFrame:rcMenu];
        if (_nsProfileName &&[_nsProfileName length] > 0)
            [_pMenuView setPlistfile:_nsProfileName listname:@"TZTTradeGrid"];
        _pMenuView.tztdelegate = self;  //将委托设置到自己
        _pMenuView.bExpandALL = TRUE;
        _pMenuView.isMarketMenu = _nFixBackColor;
        [_tztBaseView addSubview:_pMenuView];
        [_pMenuView release];
    }
    else
    {
        _pMenuView.frame = rcMenu;
        [_pMenuView reloadData];
    }
    [self reloadTheme];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadTheme];
}

- (void)reloadTheme
{
    [super reloadTheme];
//    self.view.backgroundColor = self.tztTitleView.backgroundColor;
    if (_nFixBackColor)
    {
        _pMenuView.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
        _pMenuView.tableview.backgroundColor = [UIColor tztThemeBackgroundColorHQ];
    }
    else
    {
        _pMenuView.backgroundColor = [UIColor tztThemeBackgroundColor];
        _pMenuView.tableview.backgroundColor = [UIColor tztThemeBackgroundColor];
    }
    
//    if (g_nThemeColor == 1 || g_nSkinType == 1)
//    {
//        [self.tztTitleView.firstBtn setImage:tztBackWhiteImag forState:UIControlStateNormal];
//        _pMenuView.backgroundColor = [UIColor whiteColor];
//        _pMenuView.tableview.backgroundColor = [UIColor whiteColor]; // not work
        _pMenuView.tableview.frame = CGRectMake(0, 0, _pMenuView.frame.size.width, _pMenuView.frame.size.height);
        _pMenuView.bRound = NO;
        _pMenuView.tableview.layer.cornerRadius = 0;
        [_pMenuView.tableview reloadData];
//    }
}

-(void)SetTitle:(NSString *)strTitle
{
    if (strTitle)
        self.nsTitle = [NSString stringWithFormat:@"%@", strTitle];
    if (_tztTitleView && strTitle)
    {
        [_tztTitleView setTitle:strTitle];
    }
}

-(void)setProfileName:(NSString *)strProfileName
{
    if (strProfileName == NULL || [strProfileName length] < 1)
        return;
    
    self.nsProfileName = [NSString stringWithFormat:@"%@",strProfileName];
}

- (void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [TZTUIBaseVCMsg OnMsg:Sys_Menu_ReRegist wParam:0 lParam:0];
            }
                break;
                
            default:
                break;
        }
    }
}

-(BOOL)tztUITableListView:(tztUITableListView *)pMenuView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString *)strMsgValue
{
    if (pMenuView == _pMenuView)
    {
        if (nMsgType == Sys_Menu_ReRegist || nMsgType == MENU_SYS_ReLogin)
        {
            [self showMessageBox:@"您确定要重新激活吗?"
                          nType_:TZTBoxTypeButtonBoth
                           nTag_:0x1111
                       delegate_:self
                      withTitle_:@"重新激活确认"];
            return TRUE;
        }
        
        if(nMsgType != 1234)
        {
            [TZTUIBaseVCMsg OnMsg:nMsgType wParam:0 lParam:0];
        }
        else
        {
            //当作文件名称读取文件内容并展示
            NSString* strTitle = @"投资堂";
            NSString * strChild = @"";
            NSArray* ay = [strMsgValue componentsSeparatedByString:@"|"];
            if (ay && [ay count] > 1)
            {
                strTitle = [ay objectAtIndex:1];
                strChild = [ay objectAtIndex:3];
            }
              
            //源代码
            tztUIFuctionListViewController *pVC = NewObject(tztUIFuctionListViewController);
            pVC.nFixBackColor = _nFixBackColor;
            [pVC setProfileName:strChild];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC SetTitle:strTitle];
            [pVC release];
        }
    }
    
    return TRUE;
}
-(void)tztUITableListView:(tztUITableListView *)tableView didSelectSection:(tztUITableListInfo *)sectioninfo
{
    
}

-(void)CreateToolBar
{
    
}
@end
