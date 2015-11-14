//
//  tztDBPZXYView.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-14.
//
//

#import "tztBaseTradeView.h"
@interface tztDBPZXYView : tztBaseTradeView<tztUIDroplistViewDelegate>
{
    tztUIVCBaseView      *_tztTableView;
    NSString                *_CurStockCode;
    NSMutableArray          *_ayAccount;
    NSMutableArray          *_ayType;
    NSMutableArray          *_ayVolumn;
}
@property(nonatomic,retain)tztUIVCBaseView   *tztTableView;
@property(nonatomic,retain)NSString * CurStockCode;
@property(nonatomic,retain)NSMutableArray       *ayAccount;
@property(nonatomic,retain)NSMutableArray       *ayType;
@property(nonatomic,retain)NSMutableArray       *ayVolumn;
@end
