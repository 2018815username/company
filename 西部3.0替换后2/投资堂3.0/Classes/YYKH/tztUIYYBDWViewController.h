//
//  tztUIYYBDWViewController.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-6.
//
//

#import "TZTUIBaseViewController.h"
#import "TZTUIBaseTitleView.h"
#import "tztYYBDWView.h"
@interface tztUIYYBDWViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztYYBDWView   *_pView;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztYYBDWView  *pView;
@end
