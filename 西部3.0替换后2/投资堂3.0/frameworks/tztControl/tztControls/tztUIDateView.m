/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        日期显示view
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztUIDateView.h"
#import "tztUITradeSearchViewController.h"
#import "TZTUIBaseVCMsg.h"
#ifdef Support_FundTrade
#import "tztUIFountSearchWTVC.h"
#endif

#ifdef Support_RZRQ
#import "tztUIRZRQSearchViewController.h"
#endif

#ifdef Support_TradeETF
#import "tztUIETFSearchVC.h"
#endif

#ifdef Support_DFCG
#import "tztUIDFCGSearchViewController.h"
#endif

#define Show_Nildate 0
#define Show_Begdate 1
#define Show_Enddate 2
@interface tztUIDateView (tztPrivate)
-(void)initdata;
-(void)initsubframe;
-(void)GetSelected;
@end

@implementation tztUIDateView

@synthesize pTableV = _pTableV;
@synthesize pBeginDate = _pBeginDate;
@synthesize pEndDate = _pEndDate;
@synthesize vcType = _vcType;
@synthesize pBeginDateLb = _pBeginDateLb;
@synthesize pEndDateLb = _pEndDateLb;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initdata];
        [self initsubframe];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(id)init
{
    if (self = [super init])
    {
        [self initdata];
    }
    return  self;
}

- (void)initdata
{
    int nMargin = 30;
    if ([tztTechSetting getInstance].nDateMargin > 0)
        nMargin = [tztTechSetting getInstance].nDateMargin;
    if (_pBeginDate == nil)
    {
        self.pBeginDate = [[NSDate date] dateByAddingTimeInterval:(-nMargin * 24 * 60 * 60)];
    }
    if (_pEndDate == nil)
    {
        self.pEndDate = [[NSDate date] dateByAddingTimeInterval:(/*-1.0*/0 * 24 * 60 * 60)];
    }
    if (_pTableV == nil)
    {
        _pTableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_pTableV];
        _pTableV.delegate = self;
        _pTableV.dataSource = self;
        _pTableV.scrollEnabled = NO; // 避免下拖界面混乱 byDBQ20130801
        [_pTableV release];
    }
    if(_tztDatePicker == nil)
    {
        _tztDatePicker = [[tztUIDatePicker alloc] init];
        _tztDatePicker.tztdelegate = self;
        _tztDatePicker.tag = Show_Begdate;
        if (IS_TZTIOS(7))
            _tztDatePicker.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tztDatePicker];
        [_tztDatePicker release];
    }
    _nID = Show_Begdate;
}

- (void)initsubframe
{
    CGRect rcFrame = self.bounds;
    if (_pTableV)
    {
        _pTableV.frame = CGRectMake(0, 0, rcFrame.size.width, rcFrame.size.height - 180);
        if(_tztDatePicker)
        {
            _tztDatePicker.frame = CGRectMake(0, _pTableV.frame.size.height , TZTScreenWidth, rcFrame.size.height - _pTableV.frame.size.height);
        }
        [_pTableV reloadData];
    }
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    [self initsubframe];
}

-(NSInteger)intWithNSString:(NSString*)string
{
    if((!string)&&([string length] != 8))
		return 0;
	NSInteger date = [string intValue]; 
	return date;
}

- (NSString *)StringWithNSDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyyMMdd"];
	return [dateFormatter stringFromDate:date];
}

-(void)SetEndDate:(NSDate*)currentDate
{
    //zxl 20130718 设置时间的时候赋值
    self.pEndDate = currentDate;
    NSString* nowDate = [self StringWithNSDate:currentDate];
	self.pEndDateLb.text = nowDate;
	_pEndDateStr = [self intWithNSString:nowDate];
}

-(void)SetBegDate:(NSDate*)currentDate
{
    //zxl 20130718 设置时间的时候赋值
    self.pBeginDate = currentDate;
	NSString* nowDate = [self StringWithNSDate:currentDate];
	self.pBeginDateLb.text = nowDate;
	_pBeginDateStr = [self intWithNSString:nowDate];
}
/*函数功能：设置默认最大时间
 入参：时间
 出参：
 */
-(void)setMaxDate:(NSDate*)MaxDate
{
    _tztDatePicker.tztDatePicker.maximumDate = MaxDate;
}
/*函数功能：设置默认最小时间
 入参：时间
 出参：
 */
-(void)SetMinDate:(NSDate *)MinDate
{
    _tztDatePicker.tztDatePicker.minimumDate = MinDate;
}
-(void)goCancel
{
    [g_navigationController popViewControllerAnimated:UseAnimated];
    //返回，取消风火轮显示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIViewController* pTop = g_navigationController.topViewController;
    if (![pTop isKindOfClass:[TZTUIBaseViewController class]])
    {
        g_navigationController.navigationBar.hidden = NO;
        [[TZTAppObj getShareInstance] setMenuBarHidden:NO animated:YES];
    }
}

-(void) goOk
{
    if (_pBeginDateStr > _pEndDateStr)
    {
        [self showMessageBox:@"开始时间不能大于结束日期!" nType_:TZTBoxTypeNoButton delegate_:nil];
        return;
    }
//    int iMaxDays = 30*3; // Avoid potential leak.  byDBQ20131031
    NSTimeInterval timeInterVal = [[NSDate date] timeIntervalSince1970];
    int iWeek = GetFormatTime(@"e", timeInterVal);
    int iTime = GetFormatTime(@"H", timeInterVal) * 100 + GetFormatTime(@"m", timeInterVal);
    
    if( iTime < 930 || iTime > 1500 || iWeek == 0 || iWeek == 6)
    {
//        iMaxDays = 360*5; // Avoid potential leak.  byDBQ20131031
    }
//    int iDet = [_pEndDate timeIntervalSinceDate:_pBeginDate] / (24 * 60 *60);
    
//    if(abs(iDet) > iMaxDays )
//    {
//        return;
//    }
#ifdef Support_FundTrade
    if (_vcType == WT_JJINQUIRECJ || _vcType == WT_JJINQUIREWT
        || _vcType == WT_JJPHInquireHisEntrust || _vcType == WT_JJPHInquireHisCJ
        || _vcType == MENU_QS_HTSC_ZJLC_QueryVerifyHis || _vcType == MENU_QS_HTSC_ZJLC_QueryWTHis || _vcType == WT_DKRY_LSWT || _vcType == WT_DKRY_WTQR ||_vcType == MENU_JY_FUND_QueryVerifyHis || _vcType == MENU_JY_FUND_QueryWTHis)
    {
        //基金历史成交 和 历史委托
        BOOL bPush = FALSE;
        tztUIFountSearchWTVC *pVC = (tztUIFountSearchWTVC *)gettztHaveViewContrller([tztUIFountSearchWTVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
        [pVC retain];

        pVC.nMsgType = _vcType;
        pVC.nsBeginDate = [NSString stringWithFormat:@"%ld",(long)_pBeginDateStr];
        pVC.nsEndDate = [NSString stringWithFormat:@"%ld",(long)_pEndDateStr];
#ifdef Support_HTSC
        [pVC SetHidesBottomBarWhenPushed:YES];
#endif
        if(bPush)
        {
            [g_navigationController pushViewController:pVC animated:UseAnimated];
        }
        [pVC release];
        return;
    }
#endif
    
#ifdef Support_TradeETF
    if (_vcType == WT_ETFInquireHisEntrust || _vcType == MENU_JY_FUND_HBQueryHis)//货币基金历史委托
    {
        BOOL bPush = FALSE;
        tztUIETFSearchVC *pVC = (tztUIETFSearchVC *)gettztHaveViewContrller([tztUIETFSearchVC class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);

        [pVC retain];

        pVC.nMsgType = _vcType;
        pVC.nsBeginDate = [NSString stringWithFormat:@"%ld",(long)_pBeginDateStr];
        pVC.nsEndDate = [NSString stringWithFormat:@"%ld",(long)_pEndDateStr];
#ifdef Support_HTSC
        [pVC SetHidesBottomBarWhenPushed:YES];
#endif
        if(bPush)
        {
            [g_navigationController pushViewController:pVC animated:UseAnimated];
        }
        [pVC release];
        return;
    }
#endif
    
#ifdef Support_RZRQ
    if (IsRZRQMsgType(_vcType))
    {
        
        BOOL bPush = FALSE;
        tztUIRZRQSearchViewController *pVC = (tztUIRZRQSearchViewController *)gettztHaveViewContrller([tztUIRZRQSearchViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
        [pVC retain];

        pVC.nMsgType = _vcType;
        pVC.nsBeginDate = [NSString stringWithFormat:@"%ld",(long)_pBeginDateStr];
        pVC.nsEndDate = [NSString stringWithFormat:@"%ld",(long)_pEndDateStr];
#ifdef Support_HTSC
        [pVC SetHidesBottomBarWhenPushed:YES];
#endif
        if(bPush)
        {
            [g_navigationController pushViewController:pVC animated:UseAnimated];
        }
        [pVC release];
        return;
    }
#endif
    
#ifdef  Support_DFCG
    if (IsDFBankJYMsgType(_vcType))
    {
        BOOL bPush = FALSE;
        tztUIDFCGSearchViewController *pVC = (tztUIDFCGSearchViewController *)gettztHaveViewContrller([tztUIDFCGSearchViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,FALSE);
        [pVC retain];

        pVC.nMsgType = _vcType;
        pVC.nsBeginDate = [NSString stringWithFormat:@"%ld",(long)_pBeginDateStr];
        pVC.nsEndDate = [NSString stringWithFormat:@"%ld",(long)_pEndDateStr];
#ifdef Support_HTSC
        [pVC SetHidesBottomBarWhenPushed:YES];
#endif
        if(bPush)
        {
            [g_navigationController pushViewController:pVC animated:UseAnimated];
        }
        [pVC release];
        return;
    }
#endif
    {
        BOOL bPush = FALSE;
        tztUITradeSearchViewController *pVC = (tztUITradeSearchViewController *)gettztHaveViewContrller([tztUITradeSearchViewController class],tztvckind_JY,[NSString stringWithFormat:@"%d",tztVcShowTypeSame],&bPush,TRUE);
        [pVC retain];

        pVC.nMsgType = _vcType;
        pVC.nsBeginDate = [NSString stringWithFormat:@"%ld",(long)_pBeginDateStr];
        pVC.nsEndDate = [NSString stringWithFormat:@"%ld",(long)_pEndDateStr];
#ifdef Support_HTSC
        [pVC SetHidesBottomBarWhenPushed:YES];
#endif
        if(bPush)
        {
            [g_navigationController pushViewController:pVC animated:UseAnimated];
        }
        [pVC release];
        return;
    }
    return;
}

-(void)GetSelected
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	UITableViewCell * begincell= [_pTableV cellForRowAtIndexPath:indexPath]; 
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
	UITableViewCell * endcell= [_pTableV cellForRowAtIndexPath:indexPath]; 
    if(begincell && endcell)
    {
        _tztDatePicker.tag = _nID;
        _tztDatePicker.hidden = NO;
        if(_nID == Show_Begdate)
        {   
            begincell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            endcell.accessoryType =  UITableViewCellAccessoryNone;
            [_tztDatePicker setCurDate:_pBeginDate];
        }
        else if (_nID == Show_Enddate) 
        {
            begincell.accessoryType =  UITableViewCellAccessoryNone;
            endcell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
            [_tztDatePicker setCurDate:_pEndDate];
        }
    }
	return;
}


- (void)tztUIDatePicker:(tztUIDatePicker *)datePickerView selectDate:(NSDate *)selectDate
{
	if (datePickerView.tag == Show_Begdate)
    {
        self.pBeginDate = selectDate;
        [self SetBegDate:_pBeginDate];
    }
    else if (datePickerView.tag == Show_Enddate)
    {
        self.pEndDate = selectDate;
        [self SetEndDate:_pEndDate];
    }
}


- (void)createCellSubView:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int dateX = cell.contentView.frame.size.width - 150;
    CGRect rcFrame = cell.frame;
	switch (indexPath.row) 
    {
		case 0:
		{
			UILabel *m_pBeginlb = (UILabel*)[cell.contentView viewWithTag:0x1111]; 
            CGSize szDrawSize = CGSizeZero;
            if (m_pBeginlb == nil)
            {
                
                m_pBeginlb = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, cell.frame.size.height)];
                m_pBeginlb.text = @"开始日期";
                m_pBeginlb.tag = 0x1111;
                m_pBeginlb.font = tztUIBaseViewTextFont(0);
            
                szDrawSize = [m_pBeginlb.text sizeWithFont:m_pBeginlb.font
                                            constrainedToSize:m_pBeginlb.frame.size
                                                    lineBreakMode:UILineBreakModeCharacterWrap];
                m_pBeginlb.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:m_pBeginlb];
                [m_pBeginlb release];
            }
            m_pBeginlb.frame = CGRectMake(5, 0 + (rcFrame.size.height - szDrawSize.height) / 2, szDrawSize.width, szDrawSize.height);
            
			UILabel *datelb = (UILabel*)[cell.contentView viewWithTag:0x2222];
            
            if (datelb == nil)
            {
                datelb = [[UILabel alloc] initWithFrame:CGRectMake(dateX, 0, 100, cell.frame.size.height)];
                datelb.backgroundColor = [UIColor clearColor];
                datelb.tag = 0x2222;
                self.pBeginDateLb = datelb;
                [cell.contentView addSubview:_pBeginDateLb];
                [datelb release];
            }
			[self SetBegDate:_pBeginDate] ;
            if(_nID == Show_Begdate)
            {   
                cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
                [_tztDatePicker setCurDate:_pBeginDate];
            }
            else if (_nID == Show_Enddate) 
            {
                cell.accessoryType =  UITableViewCellAccessoryNone;
            }
		}
			break;
		case 1:
		{
			UILabel *m_pEndlb = (UILabel*)[cell.contentView viewWithTag:0x3333];
            if (m_pEndlb == nil)
            {
                m_pEndlb = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, cell.frame.size.height)];
                m_pEndlb.text = @"结束日期";
                m_pEndlb.tag = 0x3333;
                m_pEndlb.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:m_pEndlb];
                [m_pEndlb release];
            }
            
            UILabel *datelb = (UILabel*)[cell.contentView viewWithTag:0x4444];
            if (datelb == nil)
            {
                datelb = [[UILabel alloc] initWithFrame:CGRectMake(dateX, 0, 100, cell.frame.size.height)];
                datelb.backgroundColor = [UIColor clearColor];
                datelb.tag = 0x4444;
                self.pEndDateLb = datelb;
                [cell.contentView addSubview:_pEndDateLb];
                [datelb release];
            }
			[self SetEndDate:_pEndDate];
            if(_nID == Show_Enddate)
            {   
                cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
                [_tztDatePicker setCurDate:_pBeginDate];
            }
            else if (_nID == Show_Begdate) 
            {
                cell.accessoryType =  UITableViewCellAccessoryNone;
            }
		}
			break;
		case 2:
		{
			int buttonY = (rcFrame.size.height - 30)/2;
            UIButton* btnOk = (UIButton*)[cell.contentView viewWithTag:0x5555];
            if(btnOk == nil)
            {
                btnOk = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [btnOk setTitle:@"确定" forState:UIControlStateNormal];
                [btnOk addTarget:self action:@selector(goOk) forControlEvents:UIControlEventTouchUpInside];
                btnOk.frame = CGRectMake(20, buttonY, 80, 30);
                [cell.contentView addSubview:btnOk];
            }
            
            UIButton* btnCancel = (UIButton*)[cell.contentView viewWithTag:0x6666];
            if(btnCancel == nil)
            {
                btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
                [btnCancel addTarget:self action:@selector(goCancel) forControlEvents:UIControlEventTouchUpInside];
                btnCancel.frame = CGRectMake(dateX + 20, buttonY, 80, 30);
                [cell.contentView addSubview:btnCancel];
            }
		}
			break;
		default:
			break;
	}
} 

#pragma mark UITableViewdelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString * cellString = @"TableCell" ;  
	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellString];   
    if (cell == nil) {   
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellString] autorelease];   
    }   
	[self createCellSubView:cell cellForRowAtIndexPath:indexPath];
    return cell;   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}  

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = _pTableV.frame.size.height;
    return height / 4;
    if (height <= 200)
    {
        return height / 3;
    }
    return height / 4;
}

//每个section显示的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"请设置查询的时间区间";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if (indexPath.row == 0) 
    {
		_nID = Show_Begdate;
	}
    else if (indexPath.row == 1) 
    {
		_nID = Show_Enddate;
	}
	[self GetSelected];
}
@end
