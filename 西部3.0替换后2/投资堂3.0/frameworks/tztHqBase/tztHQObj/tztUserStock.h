/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztUserStock.h
 * 文件标识：
 * 摘    要：自选股
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期： 2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import <UIKit/UIKit.h>

#define tztUserStockNotificationName    @"tztUserStock"
#define tztRectStockNotificationName    @"tztRectStock"
//股票信息
@protocol tztSocketDataDelegate;
@class tztStockInfo;
/**自选股处理对象*/
@interface tztUserStock : NSObject<tztSocketDataDelegate>
{
    BOOL        _bShowTips;
}
/**请求序号*/
@property int ntztReqno;
/**是否使用新的带市场号的方式，默认使用*/
@property BOOL bUseNewUserStock;
/**对应账号*/
@property(nonatomic,retain)NSString *nsAccount;
/**自选股同步使用的通道类型，参考tztSessionType,默认使用行情通道tztSession_ExchangeHQ*/
@property int nTokenType;

/**单例模式*/
+(void)initShareClass;
+(void)freeShareClass;
+(tztUserStock*)getShareClass;

/**获取自选股列表*/
+(NSMutableArray*)GetUserStockArray;
/**获取自选股列表*/
+(NSMutableArray*)GetUserStockArray:(BOOL)bSecend;
/**保存自选股列表，不发出自选股变动通知*/
+(void)SaveUserStockArray:(NSMutableArray *)ayStock;
/**保存自选股列表，bPost＝TRUE，发出自选股变动通知*/
+(void)SaveUserStockArray:(NSMutableArray *)ayStock post:(BOOL)bPost;
/**自选股通知，pStock当前操作的自选股，nDirection：0-保存， 1-删除，2-同步*/
+(void)postUserStockChange:(tztStockInfo*)pStock direction:(int)nDirection;
/**加入自选*/
+(void)AddUserStock:(tztStockInfo*)pStock;
/**删除自选*/
+(void)DelUserStock:(tztStockInfo*)pStock;
/**删除自选提交服务器*/
+ (void)SendDelUserStockReq:(tztStockInfo *)pStock;
/**是否已经存在*/
+(int)IndexUserStock:(tztStockInfo*)pStock;
/**上传自选股至服务器*/
+(void)UploadUserStock;
/**上传自选股至服务器,上传前是否显示确认框*/
+(void)UploadUserStock:(BOOL)bShowBox;
/**下载自选股*/
+(void)DownloadUserStock;
/**合并自选*/
+(void)MergerUserStock;
//上传
-(void)Upload;
//-(void)Upload:(BOOL)bShowTips;
-(void)Download;
-(void)Download:(BOOL)bShowTips;
-(void)Merger;
-(void)Merger:(BOOL)bShowTips;

+(NSString*)GetNSUserStock;
+(NSString*)GetNSUserStock:(BOOL)bStockType;
//获取字符串的最近浏览
+(NSString*)GetNSRecentStock;
//最近浏览数据变更
+(void)postRecentStockChange;
//加入最近浏览
+(void)AddRecentStock:(tztStockInfo*)pStock;
//清空最近浏览
+(void)ClearRecentStock;
//获取老版本自选股
+ (void)readOldVersionUserStock;
@end
