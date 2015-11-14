
#import "tztBaseTradeView.h"

/**
 *    @author yinjp
 *
 *    @brief  期权委托view 买入开平仓，卖出开平仓，备兑开平仓
 */
@interface tztOptionBuySellView : tztBaseTradeView<UIAlertViewDelegate>

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
@end
