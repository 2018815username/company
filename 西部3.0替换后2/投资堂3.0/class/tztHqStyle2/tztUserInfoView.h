//
//  tztUserInfoViewController.h
//  tztMobileApp_HTSC
//
//  Created by King on 14-9-24.
//
//
#import <UIKit/UIKit.h>

@interface tztUserInfoView : UIView

-(void)onSetViewRequest:(BOOL)bRequest;
-(void)setStockCode:(NSString*)strStockCode Request:(int)nRequest;
@property(nonatomic,assign)id tztDelegate;
@end
