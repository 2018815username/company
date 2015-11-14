/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        历史分时viewController
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"

@interface tztUIHisTrendViewController : TZTUIBaseViewController<tztHqBaseViewDelegate>
{
    tztHisTrendView     *_pHisTrendView;
    
    NSString            *_nsHisDate;
    
    id<tztHqBaseViewDelegate>_tztdelegate;
    
}

@property(nonatomic, retain)tztHisTrendView *pHisTrendView;
@property(nonatomic, retain)NSString        *nsHisDate;
@property(nonatomic, assign)id<tztHqBaseViewDelegate> tztdelegate;


-(void)setRequestDate:(NSString*)nsDate pStock_:(tztStockInfo*)pStock;
@end

