//
//  TZTStockDetailTittleVeiw.h
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 4/3/14.
//
//

#import <UIKit/UIKit.h>

@interface TZTStockDetailTittleVeiw : tztHqBaseView
{
    UILabel *lbStock;       // 股票
    UILabel *lbState;       // 交易状态
    UILabel *lbData;        // 股票数据
}

- (void)updateUserStockTitle:(BOOL)hide;
- (void)SetDefaultState;
-(void)setStockDetailInfo:(NSInteger)nStockType nStatus:(int)nStatus;
- (void)updateContent;
@end
