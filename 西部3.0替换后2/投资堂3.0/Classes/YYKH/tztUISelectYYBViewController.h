//
//  tztUISelectYYBViewController.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-6.
//
//

#import "TZTUIBaseViewController.h"
#import "TZTUIBaseTitleView.h"
#import "tztSlectYYBView.h"
@interface tztUISelectYYBViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztSlectYYBView   *_pView;
    NSMutableArray  *_ayBranchInfo;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztSlectYYBView  *pView;
@property(nonatomic,retain)NSMutableArray *ayBranchInfo;
@end
