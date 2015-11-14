//
//  TZTInitViewController.h
//  TZT
//  初始化
//  Created by Engineer on 09-9-3.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#ifndef __TZTINITVIEWCONTROLLER_H__
#define __TZTINITVIEWCONTROLLER_H__

#import "tztInitView.h"
#import "TZTAppObj.h"
//#import "TZTUIBaseViewController.h"
enum {
    TZTSysInit = 0, //初始化开始
	TZTSysJhAction, //均衡还是
	TZTSysJhFinish, //均衡结束
    TZTSysMarketInit,//市场列表开始
    TZTSysDownHomePage,//下载首页
    TZTSysRequestUrl,//请求公告url
    TZTSysReqUniqueID,//请求唯一标识
	TZTSysInitEnd,   //初始化结束
	TZTSysInitFinish,//初始化完成
};
//zxl 20130930 基类改成UIViewController 
@interface TZTInitViewController : UIViewController<UIAlertViewDelegate,tztSocketDataDelegate,tztInitViewDelegate> 
{
	tztInitView*     _pInitView;
    
	float               _fTimeSpace;

	int                 _nInitStep;//进度
	int                 _nStepCount;//次数
	int                 _nSysDate;//系统日期
    
    NSString            *_nsUpdateURL;
    UInt16               _nTztReqNo;
}
@property(nonatomic,retain) NSString          *nsUpdateURL;
//退出程序
- (void)exitApplication;
//开始初始化
- (void)OpenInit:(BOOL)bShow;
- (void)OnInit;//初始化
- (void)OnJhInit;
- (void)OnFinish;//完成
- (void)OnGetTztJHAction;//请求均衡
- (void)OnJHFinish;//均衡请求处理
- (BOOL)doRequestMarket;
- (void)OnTimeOutAction;//超时处理
@end

#endif