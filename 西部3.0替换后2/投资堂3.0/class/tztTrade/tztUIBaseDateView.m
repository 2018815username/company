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
#import "tztUIBaseDateView.h"

@implementation tztUIBaseDateView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        _pIsEnd = FALSE;
        //zxl 20131011 修改了界面背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"tztTradeSegmentBg.png"]];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    int nMargin = 5;
    CGRect rcFrame = CGRectMake(5, nMargin, 80, frame.size.height - 2 * nMargin);
    if (_pPreLable == NULL)
    {
        _pPreLable = [[UILabel alloc] initWithFrame:rcFrame];
        _pPreLable.text = @"开始日期";
        _pPreLable.textColor = [UIColor whiteColor];
        _pPreLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_pPreLable];
        [_pPreLable release];
    }
    else
        _pPreLable.frame = rcFrame;
    
    rcFrame.origin.x += _pPreLable.frame.size.width;
    rcFrame.size.width = 120;
    if (_pPreBG == NULL)
    {
        _pPreBG = [[UIImageView alloc] initWithFrame:rcFrame];
        _pPreBG.image = [UIImage imageTztNamed:@"tztUIBaseSelectDataBG.png"];
        [self addSubview:_pPreBG];
        [_pPreBG release];
    }
    else
        _pPreBG.frame = rcFrame;
    rcFrame.origin.x += 5;
    if (_pBtnBegDate == NULL)
    {
        _pBtnBegDate = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnBegDate addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [_pBtnBegDate setTztTitleColor:[UIColor blackColor]];
        _pBtnBegDate.frame = rcFrame;
        [self addSubview:_pBtnBegDate];
        [self bringSubviewToFront:_pBtnBegDate];
        
        int nMargin = 30;
        if ([tztTechSetting getInstance].nDateMargin > 0)
            nMargin = [tztTechSetting getInstance].nDateMargin;
        
        [_pBtnBegDate setTztTitle:[self DateToNSString:[[NSDate date] dateByAddingTimeInterval:(-nMargin * 24 * 60 *60)] Fomat:@"yyyy-MM-dd"]];
    }
    else
        _pBtnBegDate.frame = rcFrame;
    
    rcFrame = CGRectMake(_pPreBG.frame.origin.x -5, _pPreBG.frame.origin.y, 27, 30);
    if (_pPreSelectBG == NULL)
    {
        _pPreSelectBG = [[UIImageView alloc] initWithFrame:rcFrame];
        _pPreSelectBG.image = [UIImage imageTztNamed:@"tztUIBaseSelectBG.png"];
        [_pPreSelectBG setContentMode:UIViewContentModeCenter];
        [self addSubview:_pPreSelectBG];
        [self bringSubviewToFront:_pPreSelectBG];
        [_pPreSelectBG release];
    }
    else
        _pPreSelectBG.frame = rcFrame;
    
    rcFrame = _pPreLable.frame;
    rcFrame.origin.x = _pPreBG.frame.origin.x + _pPreBG.frame.size.width + 15;
    
    if (_pNextLable == NULL)
    {
        _pNextLable = [[UILabel alloc] initWithFrame:rcFrame];
        _pNextLable.text = @"结束日期";
        _pNextLable.textColor = [UIColor whiteColor];
        _pNextLable.backgroundColor = [UIColor clearColor];
        [self addSubview:_pNextLable];
        [_pNextLable release];
    }
    else
        _pNextLable.frame = rcFrame;
    
    rcFrame = _pPreBG.frame;
    rcFrame.origin.x = _pNextLable.frame.origin.x + _pNextLable.frame.size.width;
    if (_pNextBG == NULL)
    {
        _pNextBG = [[UIImageView alloc] initWithFrame:rcFrame];
        _pNextBG.image = [UIImage imageTztNamed:@"tztUIBaseSelectDataBG.png"];
        [self addSubview:_pNextBG];
        [_pNextBG release];
    }
    else
        _pNextBG.frame = rcFrame;
    
    rcFrame.origin.x += 5;
    if (_pBtnEndDate == NULL)
    {
        _pBtnEndDate = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnEndDate addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        _pBtnEndDate.frame = rcFrame;
        [_pBtnEndDate setTztTitleColor:[UIColor blackColor]];
        [self addSubview:_pBtnEndDate];
        [self bringSubviewToFront:_pBtnEndDate];
        [_pBtnEndDate setTztTitle:[self DateToNSString:[[NSDate date] dateByAddingTimeInterval:(/*-1.0*/0 * 24 * 60 *60)] Fomat:@"yyyy-MM-dd"]];
    }else
        _pBtnEndDate.frame = rcFrame;
    
    rcFrame = _pPreSelectBG.frame;
    rcFrame.origin.x = _pNextBG.frame.origin.x - 5;
    if (_pNextSelectBG == NULL)
    {
        _pNextSelectBG = [[UIImageView alloc] initWithFrame:rcFrame];
        _pNextSelectBG.image = [UIImage imageTztNamed:@"tztUIBaseSelectBG.png"];
        [self addSubview:_pNextSelectBG];
        [self bringSubviewToFront:_pNextSelectBG];
        [_pNextSelectBG release];
    }
    else
        _pNextSelectBG.frame = rcFrame;
     //zxl 20131011 修改了按钮的位置和颜色
    rcFrame.origin.x = self.bounds.size.width - 80;
    rcFrame.origin.y = 5;
    rcFrame.size = CGSizeMake( 70, 30);
    if (_pBtnOnOK == NULL)
    {
        _pBtnOnOK = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pBtnOnOK addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [_pBtnOnOK setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBackSmall.png"] forState:UIControlStateNormal];
        [_pBtnOnOK setTztTitle:@"确定"];
        [_pBtnOnOK setTztTitleColor:[UIColor whiteColor]];
         _pBtnOnOK.frame = rcFrame;
        [self addSubview:_pBtnOnOK];
    }
    else
        _pBtnOnOK.frame = rcFrame;
}

-(BOOL)Check
{
    NSDate * beg = [self NSStringToDate:_pBtnBegDate.titleLabel.text];
    NSDate * end = [self NSStringToDate:_pBtnEndDate.titleLabel.text];
    if ([beg earlierDate:end] == end)
    {
        [self showMessageBox:@"选择日期错误：结束日期小于开始日期！" nType_:TZTBoxTypeButtonOK delegate_:NULL];
        return FALSE;
    }
	int Det = [end timeIntervalSinceDate:beg] / (24 * 60 *60);
	if(abs(Det) > 60 )
	{
        [self showMessageBox:@"查询时间间隔不能大于60天" nType_:TZTBoxTypeButtonOK delegate_:NULL];
        return FALSE;
	}
    return TRUE;
}
-(void)OnButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == _pBtnBegDate)
    {
        _pIsEnd = FALSE;
        [self ShowDateView:sender];
    }
    if (button == _pBtnEndDate)
    {
        _pIsEnd = TRUE;
        [self ShowDateView:sender];
    }
    if (button == _pBtnOnOK)
    {
        if (self.pDelegate && [self.pDelegate respondsToSelector:@selector(OnSetData:NextData:)]&& [self Check])
		{
			NSString *begdata = [self GetBegDate];
			NSString *enddata = [self GetEndDate];
//            enddata = [self DateToNSString:[self NSStringToDate:enddata] Fomat:@"yyyyMMdd"];
			if (begdata != NULL && [begdata length] > 0 && enddata != NULL && [enddata length] > 0)
			{
				[self.pDelegate OnSetData:begdata NextData:enddata];
			}
		}
    }
}
-(void)ShowDateView:(UIButton *)button
{
    if (IS_TZTIOS(8))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"\n\n\n\n\n\n\n\n\n\n\n"// change UIAlertController height
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString *strDate = button.titleLabel.text;
        
        NSDate *date = nil;
        if(strDate && [strDate length]>0)
            [self NSStringToDate:strDate];
        
        UIDatePicker* picker=[[UIDatePicker alloc]init];
        picker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
        picker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        //    NSDate *date = nil; // 设置弹出picker的默认时间 byDBQ20130820
        date = [self NSStringToDate:button.titleLabel.text];
        if (date == nil)
            date = [NSDate date];
        picker.date = date;
        picker.datePickerMode = UIDatePickerModeDate;
        
        if (button == _pBtnBegDate)
        {
            picker.maximumDate = [self NSStringToDate:_pBtnEndDate.titleLabel.text];
        }
        //zxl 20131016修改了日期的限制
        if (button == _pBtnEndDate)
        {
            picker.maximumDate = [[self NSStringToDate:_pBtnEndDate.titleLabel.text] laterDate:[NSDate date]];
        }
        
        [picker addTarget:self action:@selector(shouldDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        

        CGRect pickerFrame = CGRectMake(12, 12, 270, 250);
        picker.frame = pickerFrame;
        [alert.view addSubview:picker];
        [picker release];
        TZTUIBaseViewController* pBottomVC = (TZTUIBaseViewController*)g_navigationController.topViewController;
        if (!pBottomVC)
            pBottomVC = [TZTAppObj getTopViewController]; // 修复moreNavigationController时弹出框不能点击问题 byDBQ20130729
        CGRect rcFrom = button.frame;
        if (button)
        {
            rcFrom.origin = button.center;
        }
        rcFrom.origin.y = [button gettztwindowy:nil] + button.frame.size.height;
        rcFrom.origin.x = [button gettztwindowx:nil] + button.frame.size.width / 2;
        rcFrom.size = pickerFrame.size;
        [pBottomVC PopViewController:alert rect:rcFrom];
        return;
    }
    else
    {
        
        UIActionSheet* pActionSheet = [[UIActionSheet alloc]
                                       initWithTitle:@"  "
                                       delegate:self
                                       cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                       otherButtonTitles:nil];
        
        [pActionSheet addButtonWithTitle:@""];
        [pActionSheet addButtonWithTitle:@""];
        [pActionSheet addButtonWithTitle:@""];
        
        NSString *strDate = button.titleLabel.text;
        
        NSDate *date = nil;
        if(strDate && [strDate length]>0)
            [self NSStringToDate:strDate];
        
        UIDatePicker* picker = [[UIDatePicker alloc] init];
        picker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
        picker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        date = [self NSStringToDate:button.titleLabel.text];
        if (date == nil)
            date = [NSDate date];
        picker.date = date;
        
        if (button == _pBtnBegDate)
        {
            picker.maximumDate = [self NSStringToDate:_pBtnEndDate.titleLabel.text];
        }
        //zxl 20131016修改了日期的限制
        if (button == _pBtnEndDate)
        {
            picker.maximumDate = [[self NSStringToDate:_pBtnEndDate.titleLabel.text] laterDate:[NSDate date]];
        }
        
        [picker addTarget:self action:@selector(shouldDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        
        [picker setFrame:CGRectMake(0, 0, 280,300)] ;
        picker.datePickerMode = UIDatePickerModeDate;
        
        [pActionSheet addSubview:picker];
        [picker release];
        
        CGRect rcFrame = picker.frame;
        rcFrame.origin.x = button.frame.origin.x + button.frame.size.width/2 - rcFrame.size.width/2;
        rcFrame.origin.y = -175;
        
        [pActionSheet showFromRect:rcFrame inView:self.pDelegate animated:YES];
        [pActionSheet release];
        return;
    }
}
-(NSString *)DateToNSString:(NSDate *)date Fomat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];	
    [dateFormatter setDateFormat:format];
    NSString * nowDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return nowDate;
}
-(NSDate *)NSStringToDate:(NSString *)StrDate
{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
    [dateformatter setTimeZone:tz];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [dateformatter dateFromString:StrDate];
    [dateformatter release];
    return date;
}
-(NSString *)GetBegDate
{
    NSString *begdata = [NSString stringWithFormat:@"%@",_pBtnBegDate.titleLabel.text];
    begdata = [self DateToNSString:[self NSStringToDate:begdata] Fomat:@"yyyyMMdd"];
    return begdata;
}
-(NSString *)GetEndDate
{
    NSString *enddata = [NSString stringWithFormat:@"%@",_pBtnEndDate.titleLabel.text];
    enddata = [self DateToNSString:[self NSStringToDate:enddata] Fomat:@"yyyyMMdd"];
    return enddata;
}
-(void)shouldDatePickerChanged:(UIDatePicker*)picker
{
    if (_pIsEnd)
    {
        [_pBtnEndDate setTztTitle:[self DateToNSString:picker.date Fomat:@"yyyy-MM-dd"]];
    }else
    {
         [_pBtnBegDate setTztTitle:[self DateToNSString:picker.date Fomat:@"yyyy-MM-dd"]];
    }
    
}
@end
