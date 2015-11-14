//
//  tztSlectYYBView.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-6.
//
//

#import "TZTUIBaseView.h"
#import "tztUIVCBaseView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface tztSlectYYBView : TZTUIBaseView<CLLocationManagerDelegate>
{
    tztUIVCBaseView         *_tztTable;
    NSMutableArray  *_ayBranchInfo;
    
     NSMutableArray          *_ayBranch;
    CLLocationManager *     _mLocation;
    NSString        * _nsMyLat;
    NSString        * _nsMyLong;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTable;
@property(nonatomic,retain)NSMutableArray     *ayBranch;
@property(nonatomic,retain)NSMutableArray *ayBranchInfo;
@property(nonatomic,retain)CLLocationManager *mLocation;
@property(nonatomic,retain)NSString *nsMyLat;
@property(nonatomic,retain)NSString *nsMyLong;
-(void)SetDefaultData;
@end
