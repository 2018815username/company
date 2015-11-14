//
//  tztUIMapViewController.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-5.
//
//

#import "TZTUIBaseViewController.h"
#import "TZTUIBaseTitleView.h"
#import "tztMapView.h"

@interface tztUIMapViewController : TZTUIBaseViewController
{
    TZTUIBaseTitleView      *_pTitleView;
    tztMapView   *_pView;
    MapAnnotation*  _DLocation;
    MapAnnotation*  _DMyLocation;
}
@property(nonatomic,retain)TZTUIBaseTitleView   *pTitleView;
@property(nonatomic,retain)tztMapView  *pView;
@property (nonatomic,retain) MapAnnotation* DLocation;
@property (nonatomic,retain) MapAnnotation* DMyLocation;
@end
