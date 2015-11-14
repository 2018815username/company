//
//  TZTUserStockDetailViewController.h
//  tztMobileApp_GJUserStock
//
//  Created by 在琦中 on 14-3-26.
//
//

#import "TZTUIBaseViewController.h"
#import "TZTUserStockDetailTableView.h"
#import "TZTStockDetailTittleVeiw.h"
#import "tztGJBaseViewController.h"
#import "TZTBottomOperateView.h"

@interface TZTUserStockDetailViewController : tztGJBaseViewController <tztHqBaseViewDelegate,  tztMutilScrollViewDelegate>
{
    //是否显示工具栏
    int         _nHasToolbar;
    int         _nTitleType;//标题类型
    
    TZTUserStockDetailTableView * userTableView;
    TZTStockDetailTittleVeiw *stockDetailTittleVeiw;
    
    TZTUserStockDetailTableView * userTableView2;
    TZTStockDetailTittleVeiw *stockDetailTittleVeiw2;
    
    TZTUserStockDetailTableView * userTableView3;
    TZTStockDetailTittleVeiw *stockDetailTittleVeiw3;
    
    TZTBottomOperateView *bottomOperateView;
    TZTBottomOperateView *bottomOperateView2;
    TZTBottomOperateView *bottomOperateView3;
    
    // 划动页
    tztMutilScrollView *_pMutilViews;
    // 划动页数组
    NSMutableArray *_pAyViews;
    
}

@property (nonatomic, retain) NSMutableArray *stockArray;

-(void)ClearData;
-(void)setStockInfo:(tztStockInfo*)pStockInfo nRequest_:(int)nRequest;
-(void)OnRequestNewData:(tztStockInfo*)pStock;
@end
extern id g_pUserStockDetail;