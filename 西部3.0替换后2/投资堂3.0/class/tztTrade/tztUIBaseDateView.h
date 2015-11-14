/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        查询界面上面的时间小界面
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       zhangxl
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

@protocol tztUIBaseDateViewDelegate<NSObject>
@optional
-(void)OnSetData:(NSString *)PreData NextData:(NSString *)nextdata;
@end

@interface tztUIBaseDateView : TZTUIBaseView<UIActionSheetDelegate>
{
    UILabel * _pPreLable;
    UILabel * _pNextLable;
    UIImageView * _pPreBG;
    UIImageView * _pNextBG;
    UIImageView *_pPreSelectBG;
    UIImageView *_pNextSelectBG;
    
    UIButton * _pBtnBegDate;
    UIButton * _pBtnEndDate;
    UIButton * _pBtnOnOK;
    BOOL    _pIsEnd;
}
-(void)ShowDateView:(UIButton *)button;
-(NSString *)DateToNSString:(NSDate *)date Fomat:(NSString *)format;
-(NSDate *)NSStringToDate:(NSString *)StrDate;
-(BOOL)Check;
-(NSString *)GetBegDate;
-(NSString *)GetEndDate;
@end
