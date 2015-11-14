/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯详情显示
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
#import "tztInfoContentView.h"
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000  
//#import <CoreMotion/CoreMotion.h>
//#endif

@interface tztZXContentViewController : TZTUIBaseViewController<tztHqBaseViewDelegate>
{
    tztInfoContentView      *_tztInfoContent;
    
    NSArray                 *_pAyInfo;
    
    tztInfoItem             *_pInfoItem;
    
    NSString                *_stockCode;
    
    id                      _pListView;
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000      
//    CMMotionManager* motionManager;
//#endif
}
@property(nonatomic, retain)tztInfoContentView  *tztInfoContent;
@property(nonatomic, retain)NSArray             *pAyInfo;
@property(nonatomic, retain)tztInfoItem         *pInfoItem;
@property(nonatomic, retain)NSString            *stockCode;
@property(nonatomic, assign)id                  pListView;
-(void)OnBtnPreStock:(id)sender;
-(void)OnBtnNextStock:(id)sender;
@end
