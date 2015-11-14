/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztCheckServerListView.h
 * 文件标识：
 * 摘    要：服务器检测
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2013.05.15
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "tztBaseSetViewController.h"

@interface tztCheckServerListView : tztUIBaseSetView<tztUIButtonDelegate>
{
    tztUIButton* _btnTest;
    UIScrollView* _scrollView;
    NSMutableArray* _ayLabel;
}
@end

@interface tztCheckServerListCell : UIView
{
    UIView* _gridLine;
    UILabel* _labelindex;
    UILabel* _labelname;
    UILabel* _labelinfo;
//    UIButton* _btnSet;
    
    NSString* _hostname;//服务器地址
	int _hostport;//服务器端口
    int _nIndex;
    tztGCDAsyncSocket* _tztAsyncSocket;
    dispatch_queue_t dataSocketQueue;
    NSTimeInterval theOnlineDate;
    __block NSTimeInterval theDateCount;
}
@property(nonatomic,retain) NSString* hostname;//服务器地址
@property int hostport;
@property int nIndex;
- (void)setServer:(NSString*)strServer withPort:(int)nPort;
- (void)onTestServer;
- (NSString *)getDateCount;
@end