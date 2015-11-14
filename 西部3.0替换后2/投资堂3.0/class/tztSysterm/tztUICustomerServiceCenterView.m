/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        服务中心
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUICustomerServiceCenterView.h"
#import "tztUIFuctionListViewController.h"

@implementation tztUICustomerServiceCenterView
@synthesize pMenuView = _pMenuView;
@synthesize nsProfileName = _nsProfileName;

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
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
    rcFrame.origin = CGPointZero;
    
    if (_pMenuView == NULL)
    {
        _pMenuView = [[tztUITableListView alloc] initWithFrame:rcFrame];
        [_pMenuView setPlistfile:self.nsProfileName listname:@"systemsetting"];
        _pMenuView.tztdelegate = self;
        if (g_nSkinType == 1) {
            _pMenuView.bRound = NO;
        }
        [self addSubview:_pMenuView];
        [_pMenuView release];
        [_pMenuView reloadData];
    }
    else
    {
        _pMenuView.frame = rcFrame;
        [_pMenuView reloadData];
    }
    _pMenuView.backgroundColor = [UIColor tztThemeBackgroundColor];
//    if (g_nSkinType == 1) {
//        _pMenuView.backgroundColor = [UIColor colorWithTztRGBStr:@"247, 247, 247"];
//    }
}

-(void)tztUITableListView:(tztUITableListView*)tableView didSelectCell:(tztUITableListInfo*)cellinfo
{
    
}

-(void)tztUITableListView:(tztUITableListView*)tableView didSelectSection:(tztUITableListInfo*)sectioninfo
{
    
}

-(BOOL)tztUITableListView:(tztUITableListView*)tableView withMsgType:(NSInteger)nMsgType withMsgValue:(NSString*)strMsgValue
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
    else if (nMsgType == HQ_MENU_TztTelPhone)
    {
        NSString* strTelphone ;
        
        strTelphone = TZTDailPhoneNUM;
        
        UIViewController* pVC = [g_navigationController topViewController];
        if(pVC && [pVC isKindOfClass:[TZTUIBaseViewController class]])
        {
            [(TZTUIBaseViewController *)pVC OnShowPhoneList:strTelphone];
        }
        else
        {
            NSString *telStr = [[NSString alloc] initWithFormat:@"tel:%@",strTelphone];
            NSString *strUrl = [telStr stringByAddingPercentEscapesUsingEncoding:NSMacOSRomanStringEncoding];
            NSURL *telURL = [[NSURL alloc] initWithString:strUrl];
            [[UIApplication sharedApplication] openURL:telURL];
            [telStr release];
            [telURL release];
        }
        return TRUE;
    }
    else
    {
        if (nMsgType == 1234)
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
            
            tztUIFuctionListViewController *pVC = NewObject(tztUIFuctionListViewController);
            [pVC setProfileName:strChild];
            [g_navigationController pushViewController:pVC animated:UseAnimated];
            [pVC SetTitle:strTitle];
            [pVC release];
        }
        else
            [TZTUIBaseVCMsg OnMsg:nMsgType wParam:(NSUInteger)strMsgValue lParam:0];
        return TRUE;
    }
}
//
//-(void)DealWithMenu:(int)nMsgType nsParam_:(NSString*)nsParam pAy_:(NSArray*)pAy
//{
//    if (nMsgType == Sys_Menu_ReRegist)
//    {
//        
//        [self showMessageBox:@"您确定要重新激活吗?"
//                      nType_:TZTBoxTypeButtonBoth
//                       nTag_:0x1111
//                   delegate_:self
//                  withTitle_:@"重新激活确认"];
//        return;
//    }
//    else
//    {
//        [TZTUIBaseVCMsg OnMsg:nMsgType wParam:(NSUInteger)nsParam lParam:0];
//    }
//}

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
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
@end
