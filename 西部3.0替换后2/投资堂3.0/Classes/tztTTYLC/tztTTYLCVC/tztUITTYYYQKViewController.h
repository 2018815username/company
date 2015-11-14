/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        现金增值计划登记vc
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztTTYYYQKView.h"

@interface tztUITTYYYQKViewController : TZTUIBaseViewController
{    
    tztTTYYYQKView              *_pTradeView;
    
    NSString                    *_CurStockCode; 
}
@property(nonatomic,retain)tztTTYYYQKView               *pTradeView;
@property(nonatomic,retain)NSString                     *CurStockCode;

@end
