/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯内容显示view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztInfoBase.h"

#define tztinfocontentmode @"<h3 align=""center""><font color=#C7C7C7 size=4>[-headInfo-]</font></h3><p align=""right""><font color=#696969 size=1>[-timeInfo-]</font></p>[-bodyInfo-]"

#define tztinfocontentmodeWhite  @"<h3 align=""center""><font color=#262626 size=4>[-headInfo-]</font></h3><p align=""right""><font color=#696969 size=1>[-timeInfo-]</font></p>[-bodyInfo-]"

@interface tztInfoContentView : tztHqBaseView<tztInfoDelegate>
{
    //资讯基类
    tztInfoBase     *_infoBase;
    //数据显示
    UIWebView       *_infoWebView;
    UITextView      *_infoTextView;
    
    NSString        *_hsString;
    
    UIFont          *_pFont;
    NSString        *_nsData;
    
    id              _pListView;
    BOOL            _bRequestList;
}

@property(nonatomic,retain)tztInfoBase  *infoBase;
@property(nonatomic,retain)UITextView   *infoTextView;
@property(nonatomic,retain)UIWebView   *infoWebView;
@property(nonatomic,retain)NSString     *hsString;
@property(nonatomic,retain)NSString         *nsData;
@property(nonatomic,retain)UIFont           *pFont;
@property(nonatomic,assign)id               pListView;
@property(nonatomic) BOOL bRequestList;

//xinlan test
@property(nonatomic,retain)NSString* infoContent;
@property(nonatomic,retain)NSString* menuTitle;
@property(nonatomic,retain)NSString* menuDate;

-(void)setStockInfo:(tztStockInfo*)pStockInfo HsString_:(NSString*)HsString;
-(void)SetInfoData:(NSMutableArray*)ayData;
- (void)onPreInfo;
- (void)onNextInfo;
//xinlan test
- (void)setMenu:(NSString *)title infoContetn:(NSString *)text;
-(void)setDate:(NSString*)date;
@end
