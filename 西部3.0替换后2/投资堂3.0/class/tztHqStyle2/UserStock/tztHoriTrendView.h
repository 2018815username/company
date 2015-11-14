

#import <UIKit/UIKit.h>
 /**
 *	@brief	横屏分时
 */
@interface tztHoriTrendView : tztHqBaseView

//@property(nonatomic,assign)tztKLineCycle KLineCycleStyle;//周期类型

 /**
 *	@brief	分时
 */
@property(nonatomic,retain)tztTrendView  *pTrendView;

 /**
 *	@brief	最新价
 */
@property(nonatomic,retain)tztPriceView  *pPriceView;

 /**
 *	@brief	明细
 */
@property(nonatomic,retain)tztDetailView *pDetailView;

 /**
 *	@brief	分价
 */
@property(nonatomic,retain)tztFenJiaView *pFenJiaView;

 /**
 *	@brief	segcontrol切换
 */
@property(nonatomic,retain)TZTSegSectionView *pSegControl;

 /**
 *	@brief	当前seg选中
 */
@property(nonatomic,assign)NSInteger nCurIndex;

@property(nonatomic)int nSegShowType;

 /**
 *	@brief	横屏显示
 */
@property(nonatomic)BOOL bHoriShow;

 /**
 *	@brief	右侧明细及segcontrol等宽度
 */
@property(nonatomic)CGFloat fDetailWidth;

 /**
 *	@brief	分时图显示方式
 */
@property(nonatomic)tztTrendPriceStyle tztPriceStyle;

 /**
 *	@brief	分时左侧价格显示在图内
 */
@property(nonatomic)BOOL    bShowLeftPriceInSide;

 /**
 *	@brief	显示最高最低价
 */
@property(nonatomic)BOOL    bShowMaxMinPrice;

 /**
 *	@brief	隐藏时间轴
 */
@property(nonatomic)BOOL    bHiddenTime;


//获取报价数据
- (TNewPriceData*)GetNewPriceData;
@end
