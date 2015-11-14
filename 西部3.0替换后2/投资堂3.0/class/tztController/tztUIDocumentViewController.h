/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        tztUIDocumentViewCotroller
 * 文件标识:
 * 摘要说明:        文档打开显示vc
 *
 * 当前版本:        1.0
 * 作    者:       Yinjp
 * 更新日期:        20140603
 * 整理修改:
 *
 ***************************************************************/

#import "TZTUIBaseViewController.h"

@interface tztUIDocumentViewController : TZTUIBaseViewController

/**
 *	单一实例
 *
 *	@return	tztUIDocumentViewController对象
 */
+(tztUIDocumentViewController*)getShareInstance;

-(void)freeShareInstance;


/**
 *	打开指定文档
 *
 *	@param 	nofitication 	通知唤起，object对应的是打开的文件
 */
-(void)OpenDocument:(NSNotification*)nofitication;

-(void)OpenDocumentWithURL:(NSString *)nsURL;
@end
