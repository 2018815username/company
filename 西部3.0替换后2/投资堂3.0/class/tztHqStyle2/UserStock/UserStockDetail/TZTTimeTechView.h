//
//  TZTTimeTechView.h
//  tztMobileApp_GJUserStock
//
//  Created by 在琦中 on 14-3-27.
//
//

#import <UIKit/UIKit.h>


@interface TZTTimeTechView : tztHqBaseView <tztHqBaseViewDelegate>
{
}
@property(nonatomic,assign)BOOL isHorizon;//是否横屏显示
-(TNewPriceData*)GetNewPriceData;
- (void)setSegment:(int)segmentIndex;
-(void)setStockInfo:(tztStockInfo *)pStockInfo Request:(int)nRequest;
-(void)ClearData;
@end
