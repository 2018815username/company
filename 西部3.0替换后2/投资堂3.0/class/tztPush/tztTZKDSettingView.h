/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:    投资快递设置view
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

@interface tztTZKDSettingView : TZTUIBaseView
{
    tztUIVCBaseView     *_pVCBaseView;
    
    //接收时间
    NSString            *_nsTime;
    //是否接收
    BOOL                _bReceive;
    //声音提示
    BOOL                _bSound;
    //程序图标标记
    BOOL                _bIconNum;
    //服务器地址
    NSString            *_nsServer;
}

@property(nonatomic,retain)tztUIVCBaseView  *pVCBaseView;
@property(nonatomic,retain)NSString         *nsTime;
@property(nonatomic,retain)NSString         *nsServer;

//获取推送时间
-(void)RequestPushTime;
@end
