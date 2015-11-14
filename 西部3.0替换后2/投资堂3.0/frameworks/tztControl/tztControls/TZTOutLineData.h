/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTOutLineData
* 文件标识:
* 摘要说明:		配置文件格式处理
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <Foundation/Foundation.h>

@interface TZTOutLineData : NSObject 
{
	NSArray		*Outlinelist;
	NSMutableDictionary	*OutlineCell;
}

//读取配置文件
-(id) initWithFile:(NSString*)strFile;
-(id)initWithData:(NSMutableDictionary*)pDict;

-(id)initWithData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent;
//为服务器设置特殊处理，其他地方使用要慎重
-(id)initWithData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent withButtonTag_:(int)nBeginTag;
//
-(id)initWithData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent withButtonTag_:(int)nBeginTag bShowAdd_:(BOOL)bShow;
//返回总记录
-(NSInteger) OutlineCount;
//获取某一位置数据
-(NSDictionary*)objectAtIndex:(NSInteger)index;
//获取指定key的index位置数据
-(NSString*)objectForKey:(NSString*)strCell atIndex:(int)index;
//获取指定key的标题
-(NSString*)titleForKey:(NSString*)strCell;
//获取指定key的功能号
-(int)msgTypeForKey:(NSString*)strCell;
//获取控件数组
-(NSMutableArray*)controlTypeForKey:(NSString*)strCell;
//返回制定单元数据
-(NSString*)stringForKey:(NSString*)strCell atIndex:(int)index;
//获取行背景色
-(UIColor*)BackColorForKey:(NSString*)strCell;
//选中背景色
-(UIColor*)SelectColorForKey:(NSString*)strCell;
//获取参数
-(NSString*)nsParamForKey:(NSString*)strCell;
//
-(NSArray*)arrayForKey:(NSString*)strCell;

@end
