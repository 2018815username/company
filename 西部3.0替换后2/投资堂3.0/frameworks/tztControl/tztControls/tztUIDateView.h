/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        日期控件（iphone）
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <UIKit/UIKit.h>
#import "tztUIDatePicker.h"

@interface tztUIDateView : UIView<UITableViewDelegate, UITableViewDataSource,tztUIDatePickerDelegate>
{
    int             _nID;
    NSInteger       _vcType;
    UILabel         *_pBeginDateLb;
    UILabel         *_pEndDateLb;

    NSDate          *_pBeginDate;
    NSDate          *_pEndDate;
    
    NSInteger       _pBeginDateStr;
    NSInteger       _pEndDateStr;
    
    tztUIDatePicker *_tztDatePicker;
    UITableView     *_pTableV;
}
@property(nonatomic,retain) NSDate              *pBeginDate;
@property(nonatomic,retain) NSDate				*pEndDate;
@property(nonatomic,retain) UITableView			*pTableV;
@property(nonatomic,retain) UILabel				*pBeginDateLb;
@property(nonatomic,retain) UILabel				*pEndDateLb;
@property(assign) NSInteger vcType;
-(void)SetEndDate:(NSDate*)currentDate;
-(void)SetBegDate:(NSDate*)currentDate;
//zxl 20130718 添加设置默认最大和最小时间
-(void)setMaxDate:(NSDate*)MaxDate;
-(void)SetMinDate:(NSDate *)MinDate;
@end
