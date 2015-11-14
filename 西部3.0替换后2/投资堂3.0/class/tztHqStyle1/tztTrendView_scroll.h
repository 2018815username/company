//
//  tztTrendView_scroll.h
//  tztMobileApp_HTSC
//
//  Created by King on 14-2-10.
//
//

@interface tztTrendView_scroll : UIView<tztSocketDataDelegate,tztHqBaseViewDelegate>
{
    UIScrollView    *_pScrollView;
    
    tztTrendView    *_pTrendView;
    
    NSMutableArray  *_pAyButton;
    NSMutableArray  *_pAyData;
    NSMutableArray *_dataArray;
    NSMutableArray *_ayStockType;
    UIButton* trendButton;
    BOOL _ishidden;
}

 /**
 *	@brief	数据显示位置 0-显示在分时图上 1-显示在分时图下
 */
@property(nonatomic)int nShowTop;
@property(nonatomic, retain)NSMutableArray *dataArray;
@property(nonatomic, retain)UIScrollView    *pScrollView;
@property(nonatomic, retain)tztTrendView    *pTrendView;
@property(nonatomic, retain)NSMutableArray  *pAyButton;
@property(nonatomic, retain)NSMutableArray  *pAyData;
@property(nonatomic,retain)NSMutableArray *ayStockType;
@property(nonatomic)BOOL    hasHiddenBtn;
@property(nonatomic)int     nHiddenBtnWidth;
@property(nonatomic, assign)id  tztDelegate;
@property(nonatomic, retain)UIButton* trendButton;
@property(nonatomic,assign)BOOL ishidden;

-(void)onSetViewRequest:(BOOL)bRequest;
-(void)setAyScrollData:(NSMutableArray*)ayData;
-(void)RequestReportData;
-(void)DealWithSelect:(NSInteger)nSel bFirst_:(BOOL)bFirst;
-(void)JumpStock:(NSInteger)nSel;
-(void)FixStockData:(tztNewMSParse *)pParse;
- (NSMutableArray *)getSendStockArray:(NSMutableArray *)sourceArray;
-(void)InsideTrend:(id)sender;
@end
