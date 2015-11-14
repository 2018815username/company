/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztWebInfoContentVC
 * 文件标识：
 * 摘    要：   网页打开资讯详情
 *
 * 当前版本：    1.0
 * 作    者：   yinjp
 * 完成日期：    2013-12-06
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/

#import "tztWebViewController.h"

@interface tztWebInfoContentViewController : tztWebViewController
{
    //是否全屏
    int     _nFullScreen;
    //左侧按钮类型
    int         _nFirstType;
    //右侧按钮类型
    int         _nSecondType;
    //要打开的url链接地址
    NSString*   _nsCurrentURL;
    //左侧按钮事件
    NSString    *_nsFirstURL;
    //右侧按钮事件
    NSString*   _nsSecondURL;
    
    UIViewController    *_parentVC;
}

@property(nonatomic) int  nFullScreen;
@property(nonatomic) int  nFirstType;
@property(nonatomic) int  nSecondType;

@property(nonatomic,retain)NSString* nsCurrenctURL;
@property(nonatomic,retain)NSString* nsFirstURL;
@property(nonatomic,retain)NSString* nsSecondURL;
@property(nonatomic,retain)UIViewController* parentVC;

@end
