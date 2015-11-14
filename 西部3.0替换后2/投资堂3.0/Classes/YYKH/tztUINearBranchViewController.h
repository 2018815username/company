//
//  tztUINearBranchViewController.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-5.
//
//

#import "TZTUIBaseViewController.h"
#import "TZTUIBaseTitleView.h"
#import "tztNearBranchView.h"
@interface tztUINearBranchViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztNearBranchView   *_pView;
    NSMutableArray * _ayBranch;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztNearBranchView  *pView;
@property(nonatomic,retain)NSMutableArray  *ayBranch;
@end
