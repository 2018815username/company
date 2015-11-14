//
//  tztRZRQHisSearchViewController.m
//  tztMobileApp_ZSSC
//
//  Created by King on 15-3-18.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import "tztRZRQHisSearchViewController.h"
#import "tztRZRQSearchView.h"

#define tztShow_Nildate 0
#define tztShow_Begdate 1
#define tztShow_Enddate 2

@interface tztRZRQHisSearchViewController ()
/**
 *	@brief	上半部份底部view
 */
@property(nonatomic,retain)UIView       *pTopView;
/**
 *	@brief	tab切换view
 */
@property(nonatomic,retain)TZTTagView   *tztTagView;
/**
 *	@brief	当前tag选中位置
 */
@property(nonatomic)int                 nCurrentTagIndex;

/**
 *	@brief	开始日期选择按钮
 */
@property(nonatomic,retain)UIButton     *pBtnBeginDate;
/**
 *	@brief	到 文本
 */
@property(nonatomic,retain)UILabel      *pLabelTxt;
/**
 *	@brief	结束日期选择按钮
 */
@property(nonatomic,retain)UIButton     *pBtnEndDate;
/**
 *	@brief	确定搜索按钮
 */
@property(nonatomic,retain)UIButton     *pBtnSearch;
/**
 *	@brief	数据显示view，用页面展示
 */
@property(nonatomic,retain)tztRZRQSearchView   *pSeachView;

/**
 *	@brief	日期选择器
 */
@property(nonatomic,retain)UIDatePicker  *tztDatePicker;
@property(nonatomic,retain)UIButton        *pAlphaView;

@property(nonatomic,retain)NSDate       *pBeginDate;
@property(nonatomic,retain)NSDate       *pEndDate;
@end

@implementation tztRZRQHisSearchViewController

@synthesize pTopView = _pTopView;
@synthesize tztTagView = _tztTagView;
@synthesize pBtnBeginDate = _pBtnBeginDate;
@synthesize pBtnEndDate = _pBtnEndDate;
@synthesize pBtnSearch = _pBtnSearch;
@synthesize pSeachView = _pSeachView;
@synthesize nCurrentTagIndex = _nCurrentTagIndex;
@synthesize pAlphaView = _pAlphaView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nCurrentTagIndex = 2;
    self.pBeginDate = [NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970] - 7 * 24 * 60 * 60)];
    self.pEndDate = [NSDate dateWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow]];
    [self LoadLayoutView];
    CGRect rc = _tztBounds;
    rc.origin.y += self.pTopView.frame.origin.y + self.pTopView.frame.size.height;
    if (_pAlphaView == NULL)
    {
        self.pAlphaView = [UIButton buttonWithType:UIButtonTypeCustom];// [[UIView alloc] initWithFrame:rc];
        self.pAlphaView.frame = rc;
        self.pAlphaView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
        [self.pAlphaView addTarget:self
                            action:@selector(OnBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.tztBaseView addSubview:self.pAlphaView];
        //        [_pAlphaView release];
    }
    else
        self.pAlphaView.frame = rc;
    
    if(_tztDatePicker == nil)
    {
        _tztDatePicker = [[UIDatePicker alloc] init];
        _tztDatePicker.datePickerMode = UIDatePickerModeDate;
        _tztDatePicker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
        _tztDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [_tztDatePicker addTarget:self action:@selector(shouldDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        _tztDatePicker.maximumDate = [NSDate date];
        [self.pAlphaView addSubview:_tztDatePicker];
        [_tztDatePicker release];
    }
    //IOS7显示不明显，设置背景颜色
    if (IS_TZTIOS(7))
        [_tztDatePicker setBackgroundColor:[UIColor whiteColor]];
    _tztDatePicker.frame = CGRectMake(0, _tztBounds.size.height - 280, TZTScreenWidth, 180);
    self.pAlphaView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    if (g_pSystermConfig && g_pSystermConfig.bNSearchFuncJY)
    {
        [self onSetTztTitleView:GetTitleByID(_nMsgType) type:TZTTitleReturn];
    }
    else
    {
        [self onSetTztTitleView:GetTitleByID(_nMsgType) type:TZTTitleReport];
    }
    rcFrame.origin.y += self.tztTitleView.frame.size.height;
    rcFrame.size.height -= self.tztTitleView.frame.size.height;
    
    CGRect rcTop = rcFrame;
    rcTop.size.height = 80;
    
    
#ifdef tzt_ZSSC
    rcTop.size.height = 50;
#endif
    
    if (_pTopView == NULL)
    {
        _pTopView = [[UIView alloc] initWithFrame:rcTop];
        _pTopView.backgroundColor = [UIColor clearColor];
        [self.tztBaseView addSubview:_pTopView];
        [_pTopView release];
    }
    else
        _pTopView.frame = rcTop;
    _pTopView.backgroundColor = [UIColor tztThemeBackgroundColorSection];
    
    int nHeight = 35;
    int nWidth = 100;
    
    CGRect rcBtn = _pTopView.bounds;
    rcBtn.origin.y += (rcTop.size.height - nHeight) / 2;
    rcBtn.origin.x += 5;
    rcBtn.size.height = nHeight;
    rcBtn.size.width = nWidth;
    
    if (_pBtnBeginDate == NULL)
    {
        _pBtnBeginDate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _pBtnBeginDate.frame = rcBtn;
        [_pBtnBeginDate addTarget:self
                           action:@selector(OnBtnClick:)
                 forControlEvents:UIControlEventTouchUpInside];
        [_pTopView addSubview:_pBtnBeginDate];
    }
    else
        _pBtnBeginDate.frame = rcBtn;
    
    _pBtnBeginDate.backgroundColor = [UIColor tztThemeBackgroundColorEditor];
    
    CGRect rcLabel = rcBtn;
    rcLabel.origin.x += rcBtn.size.width;
    rcLabel.size.width = 30;
    if (_pLabelTxt == NULL)
    {
        _pLabelTxt = [[UILabel alloc] initWithFrame:rcLabel];
        _pLabelTxt.text = @"↔︎";
        _pLabelTxt.font = tztUIBaseViewTextFont(16);
        _pLabelTxt.textColor = [UIColor darkGrayColor];
        _pLabelTxt.textAlignment = UITextAlignmentCenter;
        [_pTopView addSubview:_pLabelTxt];
        [_pLabelTxt release];
    }
    else
        _pLabelTxt.frame = rcLabel;
    
    rcBtn.origin.x += rcBtn.size.width + rcLabel.size.width;
    if (_pBtnEndDate == NULL)
    {
        _pBtnEndDate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _pBtnEndDate.frame = rcBtn;
        [_pBtnEndDate addTarget:self
                         action:@selector(OnBtnClick:)
               forControlEvents:UIControlEventTouchUpInside];
        [_pTopView addSubview:_pBtnEndDate];
    }
    else
        _pBtnEndDate.frame = rcBtn;
    _pBtnEndDate.backgroundColor = [UIColor tztThemeBackgroundColorEditor];
    
    rcBtn.origin.x += rcBtn.size.width + 10;
    rcBtn.size.width = (rcTop.size.width - rcBtn.origin.x - 5);
    if (_pBtnSearch == NULL)
    {
        _pBtnSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _pBtnSearch.frame = rcBtn;
        [_pBtnSearch setTztBackgroundImage:[UIImage imageTztNamed:@"tztButtonRed.png"]];
        [_pBtnSearch addTarget:self
                        action:@selector(OnBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
        [_pBtnSearch setTztTitleColor:[UIColor whiteColor]];
        [_pBtnSearch setTztTitle:@"确定"];
        [_pTopView addSubview:_pBtnSearch];
    }
    else
        _pBtnSearch.frame = rcBtn;
    
    
    CGRect rcWeb = rcFrame;
    rcWeb.origin.y += rcTop.size.height;
    rcWeb.size.height -= (rcTop.size.height + TZTToolBarHeight);
    if (_pSeachView == NULL)
    {
        _pSeachView = [[tztRZRQSearchView alloc] init];
        _pSeachView.frame = rcWeb;
        _pSeachView.bDetailNew = YES;
        _pSeachView.nMsgType = _nMsgType;
        [self.tztBaseView addSubview:_pSeachView];
        [_pSeachView release];
        [self RefreshData];
    }
    else
    {
        _pSeachView.nMsgType = _nMsgType;
        _pSeachView.frame =rcWeb;
    }
    
    [_tztBaseView bringSubviewToFront:_tztTitleView];
    [self CreateToolBar];
    
    [self SetDate:_nCurrentTagIndex];
}

-(void)CreateToolBar
{
    NSMutableArray  *pAy = NewObject(NSMutableArray);
    [pAy addObject:@"详细|6808"];
    [pAy addObject:@"刷新|6802"];
#ifdef tzt_NewVersion
    [tztUIBarButtonItem getTradeBottomItemByArray:pAy target:self withSEL:@selector(OnToolbarMenuClick:) forView:_tztBaseView];
#else
    [super CreateToolBar];
    [tztUIBarButtonItem GetToolBarItemByArray:pAy delegate_:self forToolbar_:toolBar];
#endif
    
    DelObject(pAy);
}

-(void)OnToolbarMenuClick:(id)sender
{
    BOOL bDeal = FALSE;
    if (_pSeachView)
    {
        bDeal = [_pSeachView OnToolbarMenuClick:sender];
    }
    if (!bDeal)
        [super OnToolbarMenuClick:sender];
}

//按钮事件处理
-(void)OnBtnClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    if (pBtn == self.pBtnBeginDate)
    {
        //选择开始日期
        self.pAlphaView.hidden = NO;
        //
        self.tztDatePicker.date = self.pBeginDate;
        self.tztDatePicker.tag = tztShow_Begdate;
    }
    else if (pBtn == self.pBtnEndDate)
    {
        //选择结束日期
        self.pAlphaView.hidden = NO;
        self.tztDatePicker.date = self.pEndDate;
        self.tztDatePicker.tag = tztShow_Enddate;
    }
    else if (pBtn == self.pBtnSearch)
    {
        //确定查询
        self.pAlphaView.hidden = YES;
        [self RefreshData];
    }
    else if (pBtn == self.pAlphaView)
    {
        //隐藏
        self.pAlphaView.hidden = YES;
    }
}

-(void)RefreshData
{
    if (self.pSeachView == NULL)
        return;
    
    NSString* strBeginDate = [self StringWithNSDate:self.pBeginDate withFlag_:NO];
    NSString* strEndDate = [self StringWithNSDate:self.pEndDate withFlag_:NO];
    
    self.pSeachView.nsBeginDate = [NSString stringWithFormat:@"%@", strBeginDate];
    self.pSeachView.nsEndDate = [NSString stringWithFormat:@"%@", strEndDate];
    [self.pSeachView OnRequestData];
}




//日期发生变化
-(void)shouldDatePickerChanged:(UIDatePicker*)picker
{
    if (picker == nil ||picker.tag == 0)
        return;
    
    if (_nCurrentTagIndex == 0)//一周
    {
        if (picker.tag == tztShow_Begdate)//选择的开始日期，那么结束日期也根据一周联动
        {
            self.pBeginDate = picker.date;
            self.pEndDate = [NSDate dateWithTimeInterval:(7*24*60*60) sinceDate:self.pBeginDate];
            if ([self.pEndDate compare:self.tztDatePicker.maximumDate] == NSOrderedDescending)
            {
                self.pEndDate = self.tztDatePicker.maximumDate;
            }
        }
        else if (picker.tag == tztShow_Enddate)
        {
            self.pEndDate = picker.date;
            self.pBeginDate = [NSDate dateWithTimeInterval:(-7*24*60*60) sinceDate:self.pEndDate];
        }
    }
    else if(_nCurrentTagIndex == 1)//一月
    {
        if (picker.tag == tztShow_Begdate)
        {
            self.pBeginDate = picker.date;
            self.pEndDate = [NSDate dateWithTimeInterval:(30*24*60*60) sinceDate:self.pBeginDate];
            if ([self.pEndDate compare:self.tztDatePicker.maximumDate] == NSOrderedDescending)
            {
                self.pEndDate = self.tztDatePicker.maximumDate;
            }
        }
        else if (picker.tag == tztShow_Enddate)
        {
            self.pEndDate = picker.date;
            self.pBeginDate = [NSDate dateWithTimeInterval:(-30*24*60*60) sinceDate:self.pEndDate];
        }
    }
    else
    {
        if (picker.tag == tztShow_Begdate)
        {
            self.pBeginDate = picker.date;
        }
        else if (picker.tag == tztShow_Enddate)
        {
            self.pEndDate = picker.date;
        }
    }
    
    [self.pBtnBeginDate setTztTitle:[self StringWithNSDate:self.pBeginDate withFlag_:YES]];
    [self.pBtnEndDate setTztTitle:[self StringWithNSDate:self.pEndDate withFlag_:YES]];
}

//处理日期
/*nTag ： 0 － 默认
 1 - 开始
 2 － 结束
 */
-(void)SetDate:(int)nTag
{
    self.pAlphaView.hidden = YES;
    switch (_nCurrentTagIndex)
    {
        case 0://一周
        {
            //默认取今天向前一周数据
            self.pBeginDate = [NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970] - 7 * 24 * 60 * 60)];
            self.pEndDate = [NSDate dateWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow]];
        }
            break;
        case 1://一月
        {
            self.pBeginDate = [NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970] - 30 * 24 * 60 * 60)];
            self.pEndDate = [NSDate dateWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow]];
        }
            break;
        case 2://自定义
        {
            self.pBeginDate = [NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970] - 30 * 24 * 60 * 60)];
            self.pEndDate = [NSDate dateWithTimeIntervalSinceNow:[[NSDate date] timeIntervalSinceNow]];
        }
            break;
            
        default:
            break;
    }
    
    [self.pBtnBeginDate setTztTitle:[self StringWithNSDate:self.pBeginDate withFlag_:YES]];
    [self.pBtnEndDate setTztTitle:[self StringWithNSDate:self.pEndDate withFlag_:YES]];
}

- (NSString *)StringWithNSDate:(NSDate *)date withFlag_:(BOOL)bFlag
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    if (bFlag)
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    else
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:date];
}

@end
