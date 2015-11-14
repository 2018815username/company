//
//  TZTUIStockDetailHeaderVIew.h
//  tztMobileApp_GJUserStock
//
//  Created by 在琦中 on 14-3-26.
//
//

#import <UIKit/UIKit.h>

@interface TZTRateView : tztHqBaseView
{
}
@property(nonatomic)BOOL bBlockReportHeader;
- (void)updateContent;
@end

@interface TZTReportRateView : tztHqBaseView
{
    UILabel *lbToday;       // 今开
    UILabel *lbTomorrow;    // 昨收
    UILabel *lbVolume;      // 成交量
    UILabel *lbTurnover;    // 换手率
}

- (void)updateContent;

@end

typedef enum : NSUInteger {
    tztShowHorizontal = 0,//水平布局显示（default）
    tztShowVertical,      //垂直布局显示
} tztShowRateType;

@interface TZTReportRateDetailView : tztHqBaseView
{
    UILabel *lbHightest;    // 最高
    UILabel *lbLowwest;     // 最低
    UILabel *lbDealVolume;  // 成交额
    
    UILabel *lbInner;       // 内盘
    UILabel *lbOuter;       // 外盘
    UILabel *lbTotal;       // 总市值
    
    UILabel *lbEarn;        // 市盈率
    UILabel *lbAmplitude;   // 振幅
    UILabel *lbFlow;        // 流通市值
}

@property(nonatomic)NSInteger     nNumberOfRow;
@property(nonatomic)tztShowRateType     nShowType;
@property(nonatomic)BOOL    bBlockReportHeader;
- (void)updateContent;
- (CGFloat)GetNeedHeight;

@end


@interface TZTUIStockDetailHeaderView : tztHqBaseView
{
    TZTRateView *_rateView;
    TZTReportRateView *_reportRateView;
    TZTReportRateDetailView *_reportRateDetailView;
}
@property(nonatomic)BOOL bExpand;
@property(nonatomic,retain)TZTRateView *rateView;
@property(nonatomic,retain)TZTReportRateView *reportRateView;
@property(nonatomic,retain)TZTReportRateDetailView *reportRateDetailView;
@property(nonatomic)BOOL bBlockReportHeader;

- (void)updateContent;
- (CGFloat)GetNeedHeight;
@end
