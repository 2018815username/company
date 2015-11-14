/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    数据库操作基类
 * 文件标识：
 * 摘    要：
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：    20130911
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/
#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface tztDataBase : NSObject
{
    NSString        *_nsDataBaseName;
    
    sqlite3         *_tztDB;
}
@property(nonatomic, retain)NSString    *nsDataBaseName;

//打开，数据库，若不存在，则自动创建
/*成功返回TRUE，失败返回FALSE*/
-(BOOL)tztOpenDataBase;

//关闭数据库
-(BOOL)tztCloseDataBase;

/*
创建数据库表
 nsTableName         表格名称
 pAyKeyAndType       字段集，使用字典，防止重复，第一个作为primary key value对应的是字段数据类型
 pAyIndex            索引字段
 
 成功返回TRUE
 失败返回FALSE
 */
-(BOOL)tztCreateTable:(NSString*)nsTableName withKey_:(NSMutableArray*)pAyKeyAndType andIndexKey_:(NSMutableArray*)pAyIndex;

/*直接传入sql语句创建，不创建索引
 若要创建索引，手动调用tztExecSQL执行创建索引sql语句
 */
-(BOOL)tztCreateTable:(NSString*)nsSQL;

/*
 向打开的数据库指定的nsTableName中插入记录
 */
-(BOOL)tztInserRecord:(NSMutableArray*)pAyData ayColumn_:(NSMutableArray*)ayColumn withTableName_:(NSString*)nsTableName;

/*
 从指定的nsTable中查询记录，并且查询条件是pDict，对应key是table中字段，value是查询内容
 返回查询到的记录数组
 */
-(NSMutableArray*)tztSearchRecord:(NSMutableDictionary*)pDict withTableName_:(NSString*)nsTableName;

/*
 直接传入sql语句进行查询
 返回结果记录集数组
 */
-(NSMutableArray*)tztSearchRecord:(NSString*)nsSQL;

/*
更新记录
 */
-(BOOL)tztUpDateRecode:(NSMutableDictionary*)pDict withTableName_:(NSString*)nsTableName;

/*
 从nsTableName中删除记录pDict
 成功返回TRUE
 失败返回FALSE
 */
-(BOOL)tztDeleteRecord:(NSMutableDictionary*)pDict withTableName_:(NSString*)nsTableName;

/*
 执行指定的sql语句
 */
-(BOOL)tztExecSQL:(NSString*)nsSQL;

@end
