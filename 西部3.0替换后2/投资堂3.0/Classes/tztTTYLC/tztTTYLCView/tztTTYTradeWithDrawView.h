/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:		tztTTYTradeWithDrawView
 * 文件标识:
 * 摘要说明:		天天盈撤单界面
 *
 * 当前版本:	2.0
 * 作    者:	zhangxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztTradeWithDrawView.h"

@interface tztTTYTradeWithDrawView : tztTradeWithDrawView
{
    NSString        *_nsInitDateIndex;//发生日期索引
    NSString        *_nsSerialNoIndex;//流水序号索引
    NSString        *_nsJJGSDM;         //基金公司代码
    NSString        *_nsJJDMIndex;      //基金代码
    
    int             _nInitDateIndex;//发生日期索引;
    int             _nSerialNoIndex;//流水序号索引
    int             _nJJGSDM;         //基金公司代码
    int             _nJJDMIndex;      //基金代码
}
@property(nonatomic,retain)NSString        *nsInitDateIndex;//发生日期索引
@property(nonatomic,retain)NSString        *nsSerialNoIndex;//发生日期索引
@property(nonatomic,retain)NSString        *nsJJGSDM;//发生日期索引
@property(nonatomic,retain)NSString        *nsJJDMIndex;//发生日期索引
@end
