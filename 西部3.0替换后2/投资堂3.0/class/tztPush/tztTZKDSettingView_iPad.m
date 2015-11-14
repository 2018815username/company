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

#import "tztTZKDSettingView_iPad.h"

@implementation tztTZKDSettingView_iPad

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
        _pIsEnd = FALSE;
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    
    DelObject(_pPreLable);
    DelObject(_pNextLable);
    DelObject(_pServiceLocate);
    DelObject(_pPreBG);
    DelObject(_pNextBG);
    DelObject(_pPreSelectBG);
    DelObject(_pNextSelectBG);
    DelObject(_pBtnBegDate);
    DelObject(_pBtnEndDate);
    DelObject(_pBtnOnOK);
    
    [super dealloc];
}

-(void) setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
   
    int nMargin = 10;
    CGRect rcFrame = CGRectMake(nMargin, nMargin, 150, 30);
    if (_pPreLable == NULL)
    {
        _pPreLable = [[UILabel alloc] initWithFrame:rcFrame];
        _pPreLable.text = @"接收快递时间:";
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
    rcFrame.size.width = 30;
    
    if (_pNextLable == NULL)
    {
        _pNextLable = [[UILabel alloc] initWithFrame:rcFrame];
        _pNextLable.text = @"~";
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
    
    rcFrame = _pPreLable.frame;
    rcFrame.origin.x = nMargin;
    rcFrame.origin.y = _pNextSelectBG.frame.origin.y + _pNextSelectBG.frame.size.height + nMargin*3;
    rcFrame.size = CGSizeMake( 400, 30);
    
    if (_pServiceLocate == NULL)
    {
        _pServiceLocate = [[UILabel alloc] initWithFrame:rcFrame];
        _pServiceLocate.text = [NSString stringWithFormat:@"快递服务地址：    %@", [[TZTServerListDeal getShareClass] GetJYAddress]];
        _pServiceLocate.textColor = [UIColor whiteColor];
        _pServiceLocate.backgroundColor = [UIColor clearColor];
        [self addSubview:_pServiceLocate];
        [_pServiceLocate release];
    }
    else
        _pServiceLocate.frame = rcFrame;
    
    rcFrame.origin.x = _pBtnBegDate.frame.origin.x;
    rcFrame.origin.y = _pServiceLocate.frame.origin.y + _pServiceLocate.frame.size.height + nMargin*5;
    rcFrame.size = CGSizeMake( 200, 40);
    if (_pBtnOnOK == NULL)
    {
        _pBtnOnOK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_pBtnOnOK addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
        [_pBtnOnOK setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBackMiddle.png"] forState:UIControlStateNormal];
        [_pBtnOnOK setBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBackMiddle.png"] forState:UIControlStateHighlighted];
        [_pBtnOnOK setShowsTouchWhenHighlighted:YES];
        [_pBtnOnOK setTitle:@"确定" forState:UIControlStateNormal];
        _pBtnOnOK.frame = rcFrame;
        [self addSubview:_pBtnOnOK];
    }
    else
        _pBtnOnOK.frame = rcFrame;
    
    [self RequestPushTime];
}

//获取推送时间
-(void)RequestPushTime
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"41037" withDictValue:pDict];
    DelObject(pDict);
}

#pragma mark - BtnClicked

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
        [self SetPushTime];
    }
}

// Called when _pBtnBegDate or _pBtnEndDate clicked
-(void)ShowDateView:(UIButton *)button
{
#ifdef __IPHONE_8_0
    if (IS_TZTIOS(8))
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"\n\n\n\n\n\n\n\n\n\n\n"// change UIAlertController height
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIDatePicker* picker = [[UIDatePicker alloc] init];
        picker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
        picker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        
        NSDate *date = [self NSStringToDate: button.titleLabel.text];
        picker.date = date;
        [picker addTarget:self action:@selector(shouldDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        
        [picker setFrame:CGRectMake(0, 0, 280,300)] ;
        picker.datePickerMode = UIDatePickerModeTime;
        
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
        
        if(strDate && [strDate length]>0)
            [self NSStringToDate:strDate];
        
        UIDatePicker* picker = [[UIDatePicker alloc] init];
        picker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
        picker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        
        NSDate *date = [self NSStringToDate: button.titleLabel.text];
        picker.date = date;
        [picker addTarget:self action:@selector(shouldDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        
        [picker setFrame:CGRectMake(0, 0, 280,300)] ;
        picker.datePickerMode = UIDatePickerModeTime;
        
        [pActionSheet addSubview:picker];
        [picker release];
        
        CGRect rcFrame = picker.frame;
        rcFrame.origin.x = button.frame.origin.x + button.frame.size.width/2 - rcFrame.size.width/2;
        rcFrame.origin.y = -175;
        
        [pActionSheet showFromRect:rcFrame inView:self animated:YES];
        [pActionSheet release];
        return;
    }
#endif
    
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
    
    if(strDate && [strDate length]>0)
        [self NSStringToDate:strDate];
    
    UIDatePicker* picker = [[UIDatePicker alloc] init];
    picker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
    picker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    NSDate *date = [self NSStringToDate: button.titleLabel.text];
    picker.date = date;
    [picker addTarget:self action:@selector(shouldDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    [picker setFrame:CGRectMake(0, 0, 280,300)] ;
    picker.datePickerMode = UIDatePickerModeTime;
    
    [pActionSheet addSubview:picker];
    [picker release];
    
    CGRect rcFrame = picker.frame;
    rcFrame.origin.x = button.frame.origin.x + button.frame.size.width/2 - rcFrame.size.width/2;
    rcFrame.origin.y = -175;
    
    [pActionSheet showFromRect:rcFrame inView:self animated:YES];
    [pActionSheet release];
}

//设置推送时间
-(void)SetPushTime
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [pDict setTztObject:[self GetBegDate] forKey:@"begindate"];
    [pDict setTztObject:[self GetEndDate] forKey:@"enddate"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"41034" withDictValue:pDict];
    DelObject(pDict);
}

#pragma mark - DateDeal

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
    [dateformatter setDateFormat:@"HH:mm"];
    NSDate* date = [dateformatter dateFromString:StrDate];
    [dateformatter release];
    return date;
}

// Get string from _pBtnBegDate without ":"
-(NSString *)GetBegDate
{
    NSString *begdata = [NSString stringWithFormat:@"%@",_pBtnBegDate.titleLabel.text];
    if (begdata == NULL || [begdata length] < 5)
        begdata = @"08:00";
    begdata = [self DateToNSString:[self NSStringToDate:begdata] Fomat:@"HHmm"];
    return begdata;
}

// Get string from _pBtnEndDate without ":"
-(NSString *)GetEndDate
{
    NSString *enddata = [NSString stringWithFormat:@"%@",_pBtnEndDate.titleLabel.text];
    if (enddata == NULL || [enddata length] < 5)
        enddata = @"20:00";
    enddata = [self DateToNSString:[self NSStringToDate:enddata] Fomat:@"HHmm"];
    return enddata;
}

#pragma DelegateMethods

// Picker delegate
-(void)shouldDatePickerChanged:(UIDatePicker*)picker
{
    if (_pIsEnd)
    {
        [_pBtnEndDate setTztTitle:[self DateToNSString:picker.date Fomat:@"HH:mm"]];
    }else
    {
        [_pBtnBegDate setTztTitle:[self DateToNSString:picker.date Fomat:@"HH:mm"]];
    }
    
}

// Net delegate
-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    if ([pParse IsAction:@"41037"])
    {
        NSString* nsBeginTime = [pParse GetByName:@"begindate"];
        NSString* nsEndTime = [pParse GetByName:@"enddate"];
        
        if (nsBeginTime == NULL || [nsBeginTime length] <= 0)
            nsBeginTime = @"0800";
        if (nsEndTime == NULL || [nsEndTime length] <= 0)
            nsEndTime = @"2000";
        
        int nBeginH = [nsBeginTime intValue] / 100;
        int nBeginM = [nsBeginTime intValue] % 100;
        
        nsBeginTime = [NSString stringWithFormat:@"%02d:%02d", nBeginH, nBeginM];
        
        int nEndH = [nsEndTime intValue] / 100;
        int nEndM = [nsEndTime intValue] % 100;
        nsEndTime = [NSString stringWithFormat:@"%02d:%02d", nEndH, nEndM];
        
        [_pBtnBegDate setTztTitle:nsBeginTime];
        [_pBtnEndDate setTztTitle:nsEndTime];
        
    }
    if ([pParse IsAction:@"41034"])
    {
        NSString* strMsg = [pParse GetErrorMessage];
        if (strMsg && strMsg.length > 0)
        {
            [self showMessageBox:strMsg nType_:TZTBoxTypeNoButton delegate_:nil];
        }
    }
    
    return 0;
}

@end
