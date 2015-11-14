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
@interface tztUserStock : NSObject<tztSocketDataDelegate>
{
    int         _ntztReqno;
}
@property int ntztReqno;
@property BOOL bUseNewUserStock;
@property(nonatomic,retain)NSString *nsAccount;

+(void)initShareClass;
+(void)freeShareClass;
+(tztUserStock*)getShareClass;

//获取自选股列表
+(NSMutableArray*)GetUserStockArray;
+(NSMutableArray*)GetUserStockArray:(BOOL)bSecend;
+(void)SaveUserStockArray:(NSMutableArray *)ayStock;
+(void)SaveUserStockArray:(NSMutableArray *)ayStock post:(BOOL)bPost;
+(void)postUserStockChange;
//加入自选
+(void)AddUserStock:(tztStockInfo*)pStock;
//删除自选
+(void)DelUserStock:(tztStockInfo*)pStock;
//删除自选提交服务器
+ (void)SendDelUserStockReq:(tztStockInfo *)pStock;
//是否已经存在
+(int)IndexUserStock:(tztStockInfo*)pStock;
//上传自选股至服务器
+(void)UploadUserStock;
+(void)UploadUserStock:(BOOL)bShowBox;
//下载自选股
+(void)DownloadUserStock;
//合并自选
+(void)MergerUserStock;
//上传
-(void)Upload;
-(void)Download;
-(void)Merger;

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
