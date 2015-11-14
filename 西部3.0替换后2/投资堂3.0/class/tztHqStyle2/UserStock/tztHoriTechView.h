

#import <UIKit/UIKit.h>
 /**
 *	@brief	横屏k线
 */
@interface tztHoriTechView : tztHqBaseView

@property(nonatomic,assign)tztKLineCycle KLineCycleStyle;//周期类型

//获取报价数据
- (TNewPriceData*)GetNewPriceData;
@end

