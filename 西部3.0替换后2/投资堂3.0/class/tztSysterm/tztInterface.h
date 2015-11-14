/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称: 实现券商接口调用 以及回调数据函数(公共文件 可以根据不同券商去实现这个文件内容)
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import <Foundation/Foundation.h>

@interface tztInterface : NSObject<UIPopoverControllerDelegate>
{
    UIPopoverController *_PopoverVC;
}
@property(nonatomic,retain)UIPopoverController                           *PopoverVC;

+(tztInterface*)getShareInterface;
+(void)freeShareInterface;
/*处理数据重组并返回*/
-(NSDictionary *)GetChangeParams:(NSDictionary *)Params;
/*券商接口特殊处理*/
-(void)OnDealNib:(int)nMsgType ArryApp:(NSArray *)arryApp;
/* 个股查询*/
-(void)OnSelectHQStock:(tztStockInfo *)pStock;
/*显示查询界面*/
-(void)ShowStockQueryVC:(UIViewController*)pPopVC  Rect:(CGRect)rect;
/*接口数据返回*/
-(NSInteger)callbackDataDeal:(id)caller withParams:(NSDictionary *)params;
@end
extern tztInterface * g_Interface;
