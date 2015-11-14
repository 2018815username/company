//
//  tztUIDBPZXYViewController.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-15.
//
//

#import "TZTUIBaseViewController.h"
#import "tztDBPZXYView.h"
@interface tztUIDBPZXYViewController :TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    
    tztDBPZXYView    *_pView;
    
}
@property(nonatomic, retain)TZTUIBaseTitleView  *pTitleView;
@property(nonatomic, retain)tztDBPZXYView  *pView;
@end