//
//  tztUIGTJAYYKHViewController.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-4.
//
//

#import "TZTUIBaseViewController.h"
#import "TZTUIBaseTitleView.h"
#import "tztGTJAYYKHView.h"

@interface tztUIGTJAYYKHViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztGTJAYYKHView   *_pView;
    NSMutableArray *_ayBranchInfo;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztGTJAYYKHView  *pView;
@property(nonatomic,retain)NSMutableArray  *ayBranchInfo;
@end
