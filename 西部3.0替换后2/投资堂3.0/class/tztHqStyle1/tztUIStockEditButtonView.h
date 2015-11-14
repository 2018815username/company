//
//  tztUIStockEditButtonView.h
//  tztMobileApp_HTSC
//
//  Created by King on 14-2-19.
//
//

#import <UIKit/UIKit.h>

@protocol tztUIStockEditButtonViewDelegate <NSObject>

@optional

-(void)tztUIStockEditButtonViewClicked:(id)sender;

@end

@interface tztUIStockEditButtonView : UIView


@property(nonatomic,assign)id<tztUIStockEditButtonViewDelegate> tztDelegate;
@end
