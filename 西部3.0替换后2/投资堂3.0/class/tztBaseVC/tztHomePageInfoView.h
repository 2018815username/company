/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        首页资讯view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztInfoTableView.h"
@protocol tztHomePageInfoViewDelegate<NSObject>
@optional
-(void)tztHomePageInfoView:(id)tztInfoView fullscreen:(BOOL)bfull;
@end

@interface tztHomePageInfoView : tztHqBaseView<tztInfoDelegate,tztHqBaseViewDelegate>
{
    UIView      *_pView;
    //全屏显示
    UIButton    *_pBtnFullScreen;
    
    //最新要闻
    tztUISwitch    *_pBtnNewInfo;
    //新股在线
    tztUISwitch    *_pBtnNewStockInfo;
    //期货聚焦
    tztUISwitch    *_pBtnFuturInfo;
    //
    UIButton    *_pBtnMore;
    
    tztInfoTableView    *_pTableInfoView;
    id<tztHomePageInfoViewDelegate> _tztHomePageInfodelegate;
    int         _nClickCount;
}
@property (nonatomic,assign) id<tztHomePageInfoViewDelegate> tztHomePageInfodelegate;
- (void)reloadAllData;
- (void)RequestData;
@end
