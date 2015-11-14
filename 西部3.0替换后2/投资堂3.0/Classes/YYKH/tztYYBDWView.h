//
//  tztYYWDView.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-6-6.
//
//

#import "tztBaseTradeView.h"
#import "tztUIVCBaseView.h"
@interface tztYYBDWView : tztBaseTradeView
{
    tztUIVCBaseView         *_tztTable;
    NSMutableArray          *_ayBranch;
    NSMutableDictionary     *_ayAddressCode;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTable;
@property(nonatomic,retain)NSMutableArray     *ayBranch;
@property(nonatomic,retain)NSMutableDictionary * ayAddressCode;
@end
