//
//  tztUIShowUserInfoViewController.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-29.
//
//

#import "TZTUIBaseViewController.h"
#import "tztShowUserInfoView.h"
@interface tztUIShowUserInfoViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztShowUserInfoView   *_pView;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztShowUserInfoView  *pView;
@end
