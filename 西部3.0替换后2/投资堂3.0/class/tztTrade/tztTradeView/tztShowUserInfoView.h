//
//  tztShowUserInfoView.h
//  tztMobileApp_yyz
//
//  Created by 张 小龙 on 13-5-29.
//
//

#import "tztBaseTradeView.h"
#import "tztListDetailView.h"
@interface tztShowUserInfoView : tztBaseTradeView<UIScrollViewDelegate>
{
    tztListDetailView       *_pDetailView;
}
@property(nonatomic ,retain)tztListDetailView       *pDetailView;
@end
