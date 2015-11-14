//
//  tztInitObject.h
//  tztMobileApp_HTSC
//
//  Created by zztzt on 13-9-18.
//
//

#import <Foundation/Foundation.h>
//enum {
//    TZTSysInit = 0, //初始化开始
//	TZTSysJhAction, //均衡还是
//	TZTSysJhFinish, //均衡结束
//    TZTSysMarketInit,//市场列表开始
//    TZTSysDownHomePage,//下载首页
//    TZTSysRequestUrl,//请求公告url
//	TZTSysInitEnd,   //初始化结束
//	TZTSysInitFinish,//初始化完成
//};


@interface tztInitObject : NSObject<tztSocketDataDelegate>
{
    float       _fTimeSpace;
    int         _nInitStep;
    int         _nStepCount;
    int         _nSysDate;
    dispatch_source_t _initTimer;
}
//开始初始化
- (void)OpenInit:(BOOL)bShow;
- (void)OnJhInit;
- (void)OnFinish;//完成
- (void)OnGetTztJHAction;//请求均衡
- (void)OnJHFinish;//均衡请求处理
- (BOOL)doRequestMarket;
- (void)OnTimeOutAction;//超时处理

@end
