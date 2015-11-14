/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        通用请求view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

@interface tztCommRequestView : TZTUIBaseView<tztGridViewDelegate, tztUIProgressViewDelegate>
{
    TZTUIReportGridView       *_pListView;
    NSString                  *_nsTztFileData;
    NSString                  *_nsTztFileType;
    BOOL                      _bCancel;
    
    NSString                  *_nsReqAction;
}
@property(nonatomic,retain)TZTUIReportGridView *pListView;
@property(nonatomic,retain)NSString            *nsTztFileData;
@property(nonatomic,retain)NSString            *nsTztFileType;
@property(nonatomic,retain)NSString            *nsReqAction;

//增删自选，添加到服务器
-(void)SendToServer:(tztStockInfo*)pStock nDirection_:(int)nDirect;
//从服务器下载自选
-(void)DownFromServer:(tztStockInfo*)pStock;
//有效期查询
-(void)OnRequestValidDate;
//下载pdf
-(void)DownloadFile:(NSString*)strParams;
//切换账号
//-(void)ChangeAccount:(NSString*)strAccount;
@end
