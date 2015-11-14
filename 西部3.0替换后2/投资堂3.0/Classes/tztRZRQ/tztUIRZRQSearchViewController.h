/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        融资融券查询vc
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/
#import <UIKit/UIKit.h>
#import "TZTUIBaseViewController.h"
#import "tztRZRQSearchView.h"



@interface tztUIRZRQSearchViewController : TZTUIBaseViewController
{
    tztRZRQSearchView      *_pSearchView;
    NSString                *_nsBeginDate;
    NSString                *_nsEndDate;
}
@property(nonatomic, retain)tztRZRQSearchView  *pSearchView;
@property(nonatomic, retain)NSString            *nsBeginDate;
@property(nonatomic, retain)NSString            *nsEndDate;

@end
