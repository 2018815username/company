//
//  tztTradeHisSearchViewController.m
//  tztMobileApp_GJUserStock
//
//  Created by King on 14-8-28.
//
//

#import "tztTradeHisSearchViewController.h"
#import "tztWebView.h"


#define tztShow_Nildate 0
#define tztShow_Begdate 1
#define tztShow_Enddate 2

@interface tztTradeHisSearchViewController ()<tztTagViewDelegate, tztUIDatePickerDelegate>
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
@property(nonatomic,retain)tztWebView   *pWebView;

 /**
 *	@brief	日期选择器
 */
@property(nonatomic,retain)UIDatePicker  *tztDatePicker;
@property(nonatomic,retain)UIButton        *pAlphaView;

@property(nonatomic,retain)NSDate       *pBeginDate;
@property(nonatomic,retain)NSDate       *pEndDate;
@end

@implementation tztTradeHisSearchViewController
@synthesize pTopView = _pTopView;
@synthesize tztTagView = _tztTagView;
@synthesize pBtnBeginDate = _pBtnBeginDate;
@synthesize pBtnEndDate = _pBtnEndDate;
@synthesize pBtnSearch = _pBtnSearch;
@synthesize pWebView = _pWebView;
@synthesize nCurrentTagIndex = _nCurrentTagIndex;
@synthesize pAlphaView = _pAlphaView;
@synthesize strURL = _strURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _nCurrentTagIndex = 0;
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

- (void)LoadLayoutView
{
    CGRect rcFrame = _tztBounds;
    if (_nMsgType == MENU_JY_PT_QueryTransHis
        || _nMsgType == MENU_JY_PT_QueryTradeDay
        || _nMsgType == MENU_JY_RZRQ_QueryTransHis)
    {
        [self onSetTztTitleView:@"成交历史" type:TZTTitleReport];
    }
    else if (_nMsgType == MENU_JY_PT_QueryJG
             || _nMsgType == MENU_JY_RZRQ_QueryJG)
    {
        [self onSetTztTitleView:@"交割单" type:TZTTitleReturn];
    }
    else if (_nMsgType == MENU_JY_RZRQ_QueryFundsDayHis
             || _nMsgType == MENU_JY_RZRQ_QueryFundsDay)
    {
        [self onSetTztTitleView:@"资金流水" type:TZTTitleReturn];
    }
    
    [self onSetTztTitleView:GetTitleByID(_nMsgType) type:TZTTitleReport];
    [self.tztTitleView.fourthBtn setTztBackgroundImage:nil];
    [self.tztTitleView.fourthBtn setTztImage:nil];
    CGRect rcTitle = self.tztTitleView.fourthBtn.frame;
    rcTitle.size.width = 70;
    rcTitle.origin.x = self.tztTitleView.frame.size.width - rcTitle.size.width;
    self.tztTitleView.fourthBtn.frame = rcTitle;
    if (_nMsgType == MENU_JY_RZRQ_QueryTransHis)
    {
        self.tztTitleView.fourthBtn.titleLabel.font = tztUIBaseViewTextFont(13);
        [self.tztTitleView.fourthBtn setTztTitle:@"交割单"];
    }
    else
    {
        self.tztTitleView.fourthBtn.hidden = (_nMsgType != MENU_JY_RZRQ_QueryTransHis);
    }
//    self.tztTitleView.fourthBtn.titleLabel.font = tztUIBaseViewTextFont(13.0f);
    
    rcFrame.origin.y += self.tztTitleView.frame.size.height;
    rcFrame.size.height -= self.tztTitleView.frame.size.height;
    
    CGRect rcTop = rcFrame;
    rcTop.size.height = 80;
    
    if (_nMsgType == MENU_JY_RZRQ_QueryFundsDayHis
        || _nMsgType == MENU_JY_RZRQ_QueryFundsDay)
    {
        _nCurrentTagIndex = 2;
        rcTop.size.height = 50;
    }
    
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
    CGRect rcTag = _pTopView.bounds;
    if (_nMsgType == MENU_JY_RZRQ_QueryFundsDayHis
        || _nMsgType == MENU_JY_RZRQ_QueryFundsDay)
    {
        rcTag.size.height = 0;
    }
    else
    {
        rcTag.size.height = 30;
        if (_tztTagView == NULL)
        {
            _tztTagView = [[TZTTagView alloc] init];
            
            if (_nMsgType == MENU_JY_RZRQ_QueryRZQK)
            {
                _tztTagView.ayData = [NSMutableArray arrayWithObjects:@"融资负债|15208", @"融券负债|15209",nil];
            }
            else
            {
                _tztTagView.ayData = [NSMutableArray arrayWithObjects:@"一周|1234", @"一月|2234", @"自定义|3234",nil];
            }
            _tztTagView.frame = rcTag;
            _tztTagView.delegate = self;
            [_pTopView addSubview:_tztTagView];
            [_tztTagView release];
        }
        else
            _tztTagView.frame = rcTag;
    }
    
    int nHeight = 35;
    int nWidth = 100;
    
    CGRect rcBtn = _pTopView.bounds;
    rcBtn.origin.y += (rcTag.size.height + (rcTop.size.height - rcTag.size.height - nHeight) / 2);
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
    rcWeb.size.height -= rcTop.size.height;
    if (_pWebView == NULL)
    {
        _pWebView = [[tztWebView alloc] initWithFrame:rcWeb];
        [self.tztBaseView addSubview:_pWebView];
        [_pWebView release];
        [self RefreshData];
    }
    else
    {
        _pWebView.frame =rcWeb;
    }
    
    [self SetDate:_nCurrentTagIndex];
}


-(void)OnToolbarMenuClick:(id)sender
{
    UIButton *pBtn = (UIButton*)sender;
    
    NSInteger nTag = pBtn.tag;
    if (nTag == HQ_MENU_SearchStock)//
    {
        switch (_nMsgType)
        {
            case MENU_JY_PT_QueryTransHis:
            case MENU_JY_PT_QueryTradeDay:
            {
                [TZTUIBaseVCMsg OnMsg:MENU_JY_PT_QueryJG wParam:0 lParam:0];
            }
                break;
            case MENU_JY_RZRQ_QueryTransHis:
            {
                [TZTUIBaseVCMsg OnMsg:MENU_JY_RZRQ_QueryJG wParam:0 lParam:0];
            }
                break;
            default:
                break;
        }
    }
    else
        [super OnToolbarMenuClick:sender];
}

-(void)RefreshData
{
    if (self.pWebView == NULL)
        return;
    
    NSString* strBeginDate = [self StringWithNSDate:self.pBeginDate withFlag_:NO];
    NSString* strEndDate = [self StringWithNSDate:self.pEndDate withFlag_:NO];
    
    NSString * strUrl = @"";
    if (self.strURL.length > 0)
    {
        strUrl = [NSString stringWithFormat:self.strURL, strBeginDate, strEndDate];
    }
    else
    {
        switch (_nMsgType)
        {
            case MENU_JY_PT_QueryTransHis:
            case MENU_JY_PT_QueryTradeDay:
            {
                strUrl = [NSString stringWithFormat:@"yjb/jy_history.htm?begindate=%@&enddate=%@", strBeginDate, strEndDate];
            }
                break;
            case MENU_JY_PT_QueryJG:
            {
                strUrl = [NSString stringWithFormat:@"/yjb/deliveryOrder.htm?begindate=%@&enddate=%@", strBeginDate, strEndDate];
            }
                break;
            case MENU_JY_RZRQ_QueryTransHis://RZRQ历史成交
            {
                strUrl = [NSString stringWithFormat:@"/yjb/rzrq/rzrq-history.htm?type=2&begindate=%@&enddate=%@", strBeginDate, strEndDate];
            }
                break;
            case MENU_JY_RZRQ_QueryJG://
            {
                strUrl = [NSString stringWithFormat:@"/yjb/rzrq/rzrq-history.htm?type=3&begindate=%@&enddate=%@", strBeginDate, strEndDate];
            }
                break;
            case MENU_JY_RZRQ_QueryRZQK:
            {
                if (_nCurrentTagIndex == 0)
                    strUrl = [NSString stringWithFormat:@"/yjb/rzrq/rzrq-history.htm?type=0&begindate=%@&enddate=%@", strBeginDate, strEndDate];
                else
                    strUrl = [NSString stringWithFormat:@"/yjb/rzrq/rzrq-history.htm?type=1&begindate=%@&enddate=%@", strBeginDate, strEndDate];
            }
                break;
            default:
                break;
        }
    }
    
    [self.pWebView setWebURL:[tztlocalHTTPServer getLocalHttpUrl:strUrl]];
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

//顶部tag选择
-(void)tztTagView:(TZTTagView *)tagView OnButtonClick:(UIButton *)sender AtIndex:(int)nIndex
{
    _nCurrentTagIndex = nIndex;
    if (_nMsgType == MENU_JY_RZRQ_QueryRZQK)
    {
        [self SetDate:2];//不限制时间
        [self RefreshData];
    }
    else
    {
        [self SetDate:_nCurrentTagIndex];
    }
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

-(void)GetSelected
{
    
}

@end
