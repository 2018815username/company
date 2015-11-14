
#import <tztHqBase/tztHqBase.h>

@interface tztUIStockDetailHeaderViewEx : tztHqBaseView

@property(nonatomic,assign)BOOL bShowUserStock;
@property(nonatomic,assign)BOOL bShowBlock;
@property(nonatomic,assign)BOOL bShowTradeStock;

@property(nonatomic,assign)BOOL bExpand;


-(void)updateContent;
-(CGFloat)GetNeedHeight;

-(void)setShowKeys:(NSArray*)ayKeys andExchangeKeys:(NSArray*)ayExchangeKeys;
@end
