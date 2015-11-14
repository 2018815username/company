/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztUITrendViewController
 * 文件标识：
 * 摘    要：   新分时展示方式
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013－12-11
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/

#import "TZTUIBaseViewController.h"
#import "tztUIStockView.h"
#import "tztWebView.h"

@interface tztUITrendViewController : TZTUIBaseViewController<tztHqBaseViewDelegate,tztGridViewDelegate, UITableViewDataSource, UITableViewDelegate, tztHTTPWebViewDelegate, tztSocketDataDelegate>
{
    //显示表格
    UITableView         *_tztTableView;
    //通讯代理
    id                  _pListView;
}

@property(nonatomic, retain)UITableView     *tztTableView;
@property(nonatomic, assign)id              pListView;

-(void)setStockInfo:(tztStockInfo*)pStockInfo nRequest_:(int)nRequest;
@end
