

#import "tztBaseTradeView.h"
/**
 *    @author yinjp
 *
 *    @brief  备兑券锁定，解锁
 */
@interface tztCoveredLockView : tztBaseTradeView

/**
 *    @author yinjp
 *
 *    @brief  当前证券代码
 */
@property(nonatomic,retain)NSString *CurStockCode;

/**
 *    @author yinjp
 *
 *    @brief  设置证券代码
 *
 *    @param nsCode 证券代码
 */
-(void)setStockCode:(NSString *)nsCode;

/**
 *    @author yinjp
 *
 *    @brief  获取显示的实际大小
 *
 *    @return 实际大小
 */
-(CGSize)getTableShowSize;
@end
