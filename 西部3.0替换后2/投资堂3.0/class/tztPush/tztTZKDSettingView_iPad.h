/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        快递设置View
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       DBQ
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/


@interface tztTZKDSettingView_iPad : TZTUIBaseView <UIActionSheetDelegate>
{
    UILabel * _pPreLable;           // 接收快递时间Label
    UILabel * _pNextLable;          // ~ Label
    UILabel * _pServiceLocate;      // 服务地址Label
    UIImageView * _pPreBG;          // 选中前_pBtnBegDate背景
    UIImageView * _pNextBG;         // 选中前_pBtnEndDate背景
    UIImageView *_pPreSelectBG;     // 选中_pBtnBegDate背景
    UIImageView *_pNextSelectBG;    // 选中_pBtnEndDate背景
    
    UIButton * _pBtnBegDate;        // 开始时间
    UIButton * _pBtnEndDate;        // 结束时间
    UIButton * _pBtnOnOK;           // 确定按钮
    BOOL    _pIsEnd;                // 是否结束时间
}

-(void)ShowDateView:(UIButton *)button; // Called when _pBtnBegDate or _pBtnEndDate clicked
-(NSString *)DateToNSString:(NSDate *)date Fomat:(NSString *)format;
-(NSDate *)NSStringToDate:(NSString *)StrDate;
-(NSString *)GetBegDate;                // Get string from _pBtnBegDate without ":"
-(NSString *)GetEndDate;                // Get string from _pBtnEndDate without ":"
@end
