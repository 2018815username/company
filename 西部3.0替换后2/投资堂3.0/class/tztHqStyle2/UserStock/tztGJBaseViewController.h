//
//  tztGJBaseViewController.h
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-3-28.
//
//

#import "TZTUIBaseViewController.h"

@protocol UserStockDelegate <NSObject>

- (void)updataContents;

@end


@interface tztGJBaseViewController : TZTUIBaseViewController
{
    UIView * _pLeftView;
}

@property (nonatomic, assign)id <UserStockDelegate> delegate;

@property(nonatomic,retain)UIView *pLeftView;


- (void)refreshColor;

@end
