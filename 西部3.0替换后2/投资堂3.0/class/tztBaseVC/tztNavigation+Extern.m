
@implementation tztHTTPData(tztOther)


-(void)tztShouldDealLeftViewController:(UINavigationController*)nav
{
    if ([nav.viewControllers count] <= 1)
    {
        PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
        if ( direction > 0 )
        {
            [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:tzt_SideWidthLeft forDirection:PPRevealSideDirectionLeft animated:YES];
            [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:tzt_SideWidthRight forDirection:PPRevealSideDirectionRight animated:YES];
        }
    }
}

-(id)tztPopViewControllerAnimated:(UINavigationController*)nav
{
    PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
    if ( direction > 0)
    {
        id returnValue = nil;
        if (direction == PPRevealSideDirectionLeft)
        {
            returnValue = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
        }
        else if(direction == PPRevealSideDirectionRight)
        {
            returnValue = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
        }
        if (returnValue)
        {
            if (returnValue == nav)
                return nil;
            return returnValue;
        }
    }
    return nil;
}

-(id)tztPushViewController:(UIViewController*)viewController nav:(UINavigationController*)nav
{
   
    if (([viewController getVcShowKind] == tztvckind_JY || [viewController getVcShowKind] == tztvckind_Pop || [viewController getVcShowKind] ==tztvckind_ZX||[viewController getVcShowKind] == tztvckind_HQ)
        && ![viewController isKindOfClass:[[NSBundle mainBundle] classNamed:@"tztUIHomePageViewController"]]
        && ![viewController isKindOfClass:[[NSBundle mainBundle] classNamed:@"tztUITradeViewController"]]
        && [[viewController getVcShowType] intValue] != tztVcShowTypeRoot )//交易不显示底部tabbar
    {
        [viewController SetHidesBottomBarWhenPushed:YES];
    }
    
    if (nav.topViewController && nav.topViewController.hidesBottomBarWhenPushed)
        [viewController SetHidesBottomBarWhenPushed:YES];
    PPRevealSideDirection direction = [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController getSideToClose];
    if (direction > 0)
    {
        id returnValue = nil;
        if (direction == PPRevealSideDirectionLeft)
        {
            returnValue = [TZTAppObj getShareInstance].rootTabBarController.leftVC.navigationController;
        }
        else if (direction == PPRevealSideDirectionRight)
        {
            returnValue = [TZTAppObj getShareInstance].rootTabBarController.rightVC.navigationController;
        }
        if (returnValue)
        {
            [viewController SetHidesBottomBarWhenPushed:YES];
            [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionLeft animated:YES];
            [[TZTAppObj getShareInstance].rootTabBarController.revealSideViewController changeOffset:0 forDirection:PPRevealSideDirectionRight animated:YES];
            
            if (returnValue == nav)
                return nil;
            if (direction == PPRevealSideDirectionLeft)
                [[TZTAppObj getShareInstance].rootTabBarController.leftVC tztPushViewController:viewController animated:UseAnimated];
            else if (direction == PPRevealSideDirectionRight)
                [[TZTAppObj getShareInstance].rootTabBarController.rightVC tztPushViewController:viewController animated:UseAnimated];
            
            return returnValue;
        }
    }
    return nil;
}

-(void)tztInitWithRootViewController:(tztUINavigationController*)nav
{
#ifdef __IPHONE_7_0
    if (nav)
    {
        nav.interactivePopGestureRecognizer.enabled = NO;
    }
#endif
}

@end

//@implementation TZTUIMessageBox(tztPrivate)
//
//-(NSMutableDictionary*)tztMsgBoxSetProperties:(TZTUIMessageBox*)msgBox
//{
//    NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
//    [pDict setTztObject:@"center" forKey:tztMsgBoxTitleAlignment];
//    msgBox.m_TitleFont = tztUIBaseViewTextFont(20);
//    if (g_ntztHaveBtnOK && msgBox.m_nType == TZTBoxTypeNoButton)
//    {
//        msgBox.m_nType = TZTBoxTypeButtonOK;
//    }
//    return pDict;
//}
//
//@end


