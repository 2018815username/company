//
//  tztTradeLockView.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-22.
//
//

#import <UIKit/UIKit.h>
#import "tztBaseTradeView.h"
#import "TZTTokenM.h"
@interface tztTradeUnLockView : tztBaseTradeView
{
     tztUIVCBaseView      *_tztTableView;
    tztZJAccountInfo *_pCurZJInfo;
    BOOL            _bHasToken;
    TZTTokenM *_pToken;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTableView;
@property(nonatomic,retain)tztZJAccountInfo *pCurZJInfo;
@property (nonatomic, retain) TZTTokenM *pToken;
@property BOOL bHasToken;
@end
