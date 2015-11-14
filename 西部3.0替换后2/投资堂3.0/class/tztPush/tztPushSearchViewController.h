//
//  tztPushSearchViewController.h
//  tztMobileApp_HTSC
//
//  Created by King on 14-3-6.
//
//

#import "TZTUIBaseViewController.h"
#import "tztPushSeachView.h"

@interface tztPushSearchViewController : TZTUIBaseViewController<tztUIButtonDelegate>
@property(nonatomic,retain)tztPushSeachView *pSearchView;
@end
