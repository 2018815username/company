/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        交易界面中间的工具条
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUIBaseView.h"
enum
{
    LoadPageBtn = 0,//刷新按钮
    BackPageBtn,//上页
    NextPageBtn,//下页
    OKBtn,//确定
    CancelBtn,//撤单
    ClearBtn//清空
};

@protocol tztToolDelegate <NSObject>
@optional
-(void)LoadPage;
-(void)BackPage;
-(void)NextPage;
-(void)OnBtnOK;
-(void)OnBtnCancel;
-(void)OnBtnClear;
@end

@interface tztUITradeToolBarView : TZTUIBaseView
{
    NSMutableArray * _pBtnArray;
    UIImageView *_pBGimage;
}
@property(nonatomic,retain)  NSMutableArray *pBtnArray;
-(void)GreatBtnArray;
-(void)SetBtnArrayByPageType:(NSInteger)pagetype;
@end
