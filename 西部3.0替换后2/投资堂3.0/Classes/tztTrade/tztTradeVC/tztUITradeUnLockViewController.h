//
//  tztUITradeLockViewController.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-22.
//
//

#import "TZTUIBaseViewController.h"
#import "TZTUIBaseTitleView.h"
#import "tztTradeUnLockView.h"

@interface tztUITradeUnLockViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztTradeUnLockView   *_pView;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztTradeUnLockView  *pView;

@end
