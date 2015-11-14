//
//  tztGTJAYYKHView.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-4.
//
//

#import "tztBaseTradeView.h"
#import "tztUIVCBaseView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface tztGTJAYYKHView : tztBaseTradeView<tztUIDroplistViewDelegate,CLLocationManagerDelegate>
{
    tztUIVCBaseView         *_tztTable;
    NSMutableArray          *_ayBranch;
    NSMutableArray          *_ayNearBranch;
    NSMutableDictionary     *_ayAddressCode;
    NSMutableDictionary     *_ayBranchCode;
    CLLocationManager *     _mLocation;
    NSString        * _nsMyLat;
    NSString        * _nsMyLong;
    BOOL                _bGetAllBranch;
    BOOL                _bGetEmptyProvince;
    NSMutableArray  * _ayDefaultBranch;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTable;
@property(nonatomic,retain)NSMutableArray     *ayBranch;
@property(nonatomic,retain)NSMutableArray     *ayNearBranch;
@property(nonatomic,retain)NSMutableArray     *ayDefaultBranch;
@property(nonatomic,retain)NSMutableDictionary * ayAddressCode;
@property(nonatomic,retain)NSMutableDictionary * ayBranchCode;
@property(nonatomic,retain)CLLocationManager *mLocation;
@property(nonatomic,retain)NSString *nsMyLat;
@property(nonatomic,retain)NSString *nsMyLong;
-(void)setDefault;
@end
