/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        tztNSLocation
 * 文件标识:
 * 摘要说明:        定位功能,单例模式
 *
 * 当前版本:
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface tztNSLocation : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager* _clManager;
}
//longitude
@property (nonatomic,retain) NSString* strGpsX;
//latitude
@property (nonatomic,retain) NSString* strGpsY;
//是否提示
@property BOOL bHiddenTips;
//获取成功
@property BOOL bGetOk;
//获取坐标
- (void)getLocation:(void (^)(NSString* strGpsX,NSString* strGpsY))completion;

+ (void)initShareClass;
+ (void)freeShareClass;
+ (tztNSLocation*)getShareClass;
- (void)stopUpdatingLocation;
- (void)startUpdatingLocation;
@end
