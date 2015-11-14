/*
 业务功能接口：
 A、	沪港通可买数查询5100
 传入参数
 字段名            字段类型      必要      说明
 MobileCode         String      Y       手机号
 Token              String      Y       时间戳
 Reqno              Int         Y       请求标识
 StockCode          String      Y       股票代码
 Price              String      Y       价格
 
 传出参数
 字段名            字段类型	必要      说明
 ErrorNo            Int             错误号
 ErrorMessage       String          返回信息
 GRID0              String          价差类型|起点价格|终点价格|价差|
 MaxQty             String          最大可买数量
 WTACCOUNTTYPE      String          市场代码 应固定为HKACCOUNT
 WTACCOUNT          String          股东账号
 BuyRate            String          买入汇率
 BuyUnit            String          每手股数
 
 出参说明：
 1.	GRID0数据为价差查询(330351)返回的记录集
 2.	最大可买数量调用大约可买获取(332711)获取
 3.	市场代码、股东账号、每手股数调用代码输入确认(332710)获取
 4.	汇率调用汇率查询(330350)获取
 
 
 B、	沪港通可卖数查询5101
 传入参数
 字段名            字段类型        必要      说明
 MobileCode         String      Y       手机号
 Token              String      Y       时间戳
 Reqno              Int         Y       请求标识
 StockCode          String      Y       股票代码
 Price              String      N		价格 恒生柜台可不送 金证柜台必须送
 
 传出参数
 字段名            字段类型        必要          说明
 ErrorNo            Int                     错误号
 ErrorMessage       String                  返回信息
 GRID0              String                  价差类型|起点价格|终点价格|价差|
 MaxQty             String                  最大可卖数量
 WTACCOUNTTYPE      String                  市场代码 应固定为HKACCOUNT
 WTACCOUNT          String                  股东账号
 SellRate           String                  汇率
 SellUnit           String                  每手股数
 
 出参说明：
 1.	GRID0数据为价差查询(330351)返回的记录集
 2.	最大可卖数量调用持仓查询(332770)获取
 3.	市场代码、股东账号、每手股数调用代码输入确认(332710)获取
 4.	汇率调用汇率查询(330350)获取
 
 C、	沪港通委托确认5102(332712)
 传入参数
 字段名            字段类型        必要      说明
 MobileCode         String        Y         手机号
 Token              String        Y         时间戳
 Reqno              Int           Y         请求标识
 WTACCOUNTTYPE      String        Y         市场代码
 WTACCOUNT          String        Y         股东账号
 STOCKCODE          String        Y         股票代码
 PRICE              String        Y         委托价格
 VOLUME             String        Y         委托数量
 DIRECTION          String        Y         买卖方向  B买入 S卖出
 PRICELEVELS        String        Y         最大价格等级  1竞价限价 0增强限价
 TIMETYPE           String        Y         订单时间类型
 0-	当日有效 即正常情况允许部分成交
 4-	即时成交 即不允许部分成交
 
 传出参数
 字段名            字段类型        必要      说明
 ErrorNo            Int                 错误号
 ErrorMessage       String              返回信息
 AnswerNo           String              委托序号
 InitDate           String              委托日期
 
 
 流程说明：
 1、和普通委托不同，需要先发送行情查询，请求到相应的10档或1档行情，获取最新价格(卖1或买1)
 2、得到价格后，通过价格和代码，进行可卖、可买信息查询
 3、最后输入相关数据后才可以委托
 
 */
#import "tztHKBuySellView.h"
#import "tztUIVCBaseView.h"

#define tztHKStartPrice   @"tztHKStartPrice"
#define tztHKEndPrice     @"tztHKEndPrice"
#define tztHKPriceValue   @"tztHKPriceValue"

enum
{
    //输入框区间1000-2000
    kTagTextStockCode = 1000,   //代码
    kTagTextPrice,              //价格
    kTagTextAmount,             //数量
    
    //下拉框区间 2000-3000
    kTagListType = 2000,        //委托类型
    
    //按钮 3000-5000
    kTagBtnPriceAdd = 3000,     //价格＋
    kTagBtnPriceDel,            //价格－
    kTagBtnAmountAdd,           //数量＋
    kTagBtnAmountDel,           //数量－
    
    //功能按钮－5000
    kTagBtnOK       = 5000,     //确定按钮
    kTagBtnSwitch,              //切换
    kTagBtnRefresh,             //刷新
    kTagBtnClear,               //清空
    
    kTagLabelRMB = 6000,        //折合金额
    kTagLabelMaxTitle,          //最多可买(卖)标题
    kTagLabelMaxValue,          //最多可买(卖)数据
    kTagLabelInfo,              //提示信息
    
    //买卖档7000-
    kTagBtnBuyPrice = 7000,     //买价10档开始
    
    kTagBtnSellPrice = 7010,    //卖价10档开始
    
    kTagBtnBuyVolume = 7020,    //买量10档开始
    
    kTagBtnSellVolume = 7030,   //卖量10档开始
  
    
    kTagLine = 8000,//分割线
};



@interface tztHKBuySellView()<tztUIButtonDelegate>
{
    UIScrollView    *_pScrollView;
    int     _nCurrentSel;//当前选择委托方式
    double   _fMoveStep; //－＋按钮每次执行区间
    int     _nDotValid; //小数位数
    UInt16  _ntztReqNoHQ;
    UInt16  _ntztReqInfo;
    
    NSString *_nsWTAccount;
    NSString *nsWTAccountType;
    float   _fRate;//汇率
    int     _nUnit;//每手股数
}

/*服务器返回数据记录*/
@property(nonatomic,retain)NSString* nsStockName;
@property(nonatomic,retain)NSString* nsWTAccount;
@property(nonatomic,retain)NSString* nsWTAccountType;
@property(nonatomic,retain)NSMutableArray *ayJC;


@property(nonatomic,retain)tztUIVCBaseView  *tztTradeView;
@property(nonatomic,retain)tztUIVCBaseView  *tztDetailView;
 /**
 *	@brief	当前股票代码
 */
@property(nonatomic,retain)NSString* CurStockCode;

 /**
 *	@brief	委托方式
 */
@property(nonatomic,retain)NSMutableArray *ayWTType;
 /**
 *	@brief	滚动view
 */
@property(nonatomic,retain)UIScrollView *pScrollView;

@property(nonatomic,retain)NSString *nsNewPrice;

/*页面布局使用*/
@property(nonatomic,retain)tztUIButton      *pBtnOK;
@property(nonatomic,retain)tztUIButton      *pBtnSwitch;
@property(nonatomic,retain)tztUIButton      *pBtnRefresh;
@property(nonatomic,retain)tztUIButton      *pBtnClear;

@property(nonatomic,retain)tztUILabel       *pLabelInfo;

@property(nonatomic,retain)tztUILabel       *pLabelPriceAdd;
@property(nonatomic,retain)tztUILabel       *pLabelPriceDel;
@property(nonatomic,retain)tztUILabel       *pLabelAmountAdd;
@property(nonatomic,retain)tztUILabel       *pLabelAmountDel;


NSComparisonResult compareJC(NSMutableDictionary *firstValue, NSMutableDictionary *secondValue, void *context);

@end

@implementation tztHKBuySellView
@synthesize pScrollView = _pScrollView;
@synthesize CurStockCode =  _CurStockCode;
@synthesize bBuyFlag = _bBuyFlag;
@synthesize ayWTType = _ayWTType;
@synthesize tztTradeView = _tztTradeView;
@synthesize tztDetailView = _tztDetailView;
@synthesize nsWTAccount = _nsWTAccount;
@synthesize nsWTAccountType = _nsWTAccountType;
@synthesize ayJC = _ayJC;
@synthesize nsNewPrice = _nsNewPrice;
@synthesize nsStockName = _nsStockName;
@synthesize pLabelPriceAdd = _pLabelPriceAdd;
@synthesize pLabelPriceDel = _pLabelPriceDel;
@synthesize pLabelAmountAdd = _pLabelAmountAdd;
@synthesize pLabelAmountDel = _pLabelAmountDel;

-(id)init
{
    if (self = [super init])
    {
        [self initData];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initData];
    }
    return self;
}

-(void)initData
{
    _nDotValid = 3;
    _fMoveStep = 1.f/pow(10.f, _nDotValid);
    _nUnit = 1000;
    _ntztReqInfo = 0x5555;
    [[tztMoblieStockComm getShareInstance] addObj:self];
    //增加行情通道，需要请求10档或1档数据
    [[tztMoblieStockComm getSharehqInstance] addObj:self];
    if (_ayWTType == NULL)
        _ayWTType = NewObject(NSMutableArray);
    [_ayWTType removeAllObjects];
    [_ayWTType addObject:@"竞价限价"];
    [_ayWTType addObject:@"增强限价"];
    
    if (_ayJC == NULL)
        _ayJC = NewObject(NSMutableArray);
}

-(void)dealloc
{
    DelObject(_ayJC);
    DelObject(_ayWTType);
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [[tztMoblieStockComm getSharehqInstance] removeObj:self];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    
    if (_pScrollView == NULL)
    {
        _pScrollView = [[UIScrollView alloc] initWithFrame:rcFrame];
        [self addSubview:_pScrollView];
        [_pScrollView release];
    }
    else
    {
        _pScrollView.frame = rcFrame;
    }
    
    if (_tztTradeView == NULL)
    {
        _tztTradeView = NewObject(tztUIVCBaseView);
        _tztTradeView.tztDelegate = self;
        _tztTradeView.nXMargin = 0;
        _tztTradeView.nYMargin = 0;
        _tztTradeView.tableConfig = @"tztUIHKTradeBuyStock";
        _tztTradeView.frame = rcFrame;
        [_pScrollView addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
        _tztTradeView.frame = rcFrame;
    
    [self setShowStyle];
    
    int nHeight = [_tztTradeView getTableShowSize].height;
    
    CGRect rcButton = rcFrame;
    rcButton.origin.y += nHeight;
    rcButton.size.width = rcFrame.size.width / 2;
    rcButton.size.height = 50;
    NSString *strTitle = (_bBuyFlag ? @"买    入" : @"卖    出");
    if (_pBtnOK == NULL)
    {
        _pBtnOK = [[tztUIButton alloc] initWithProperty:@"tag=5000|type=custom|title=买  入|font=17|"];
        _pBtnOK.tztdelegate = self;
        [_pScrollView addSubview:_pBtnOK];
        [_pBtnOK release];
    }
    [_pBtnOK setTztTitle:strTitle];
    [_pBtnOK setTztTitleColor:[UIColor whiteColor]];
    _pBtnOK.frame = rcButton;
    _pBtnOK.backgroundColor = [UIColor colorWithTztRGBStr:@"195,41,46"];
    
    if (_pBtnSwitch == NULL)
    {
        _pBtnSwitch = [[tztUIButton alloc] initWithProperty:@"tag=5001|type=custom|title=买/卖|font=14"];
        _pBtnSwitch.tztdelegate = self;
        [_pScrollView addSubview:_pBtnSwitch];
        [_pBtnSwitch release];
    }
    _pBtnSwitch.frame = CGRectMake(rcButton.origin.x + rcButton.size.width
                                   , rcButton.origin.y,
                                   rcButton.size.width / 3,
                                   rcButton.size.height);
    [_pBtnSwitch setTztTitleColor:[UIColor blackColor]];
    _pBtnSwitch.backgroundColor = [UIColor colorWithTztRGBStr:@"237,237,237"];
    
    UIView *pLine = [_pScrollView viewWithTag:kTagLine];
    CGRect rcLine = _pBtnSwitch.frame;
    rcLine.origin.x += rcLine.size.width - 1;
    rcLine.size.width = 1;
    if (pLine == NULL)
    {
        pLine = [[UIView alloc] initWithFrame:rcLine];
        [_pScrollView addSubview:pLine];
        pLine.tag = kTagLine;
        pLine.backgroundColor = [UIColor colorWithTztRGBStr:@"224,224,224"];
        [pLine release];
    }
    else
        pLine.frame = rcLine;
    
    rcButton = _pBtnSwitch.frame;
    if (_pBtnRefresh == NULL)
    {
        _pBtnRefresh = [[tztUIButton alloc] initWithProperty:@"tag=5002|type=custom|title=刷新|font=14"];
        _pBtnRefresh.tztdelegate = self;
        [_pScrollView addSubview:_pBtnRefresh];
        [_pBtnRefresh release];
    }
    _pBtnRefresh.frame = CGRectMake(rcButton.origin.x + rcButton.size.width,
                                    rcButton.origin.y,
                                    rcButton.size.width,
                                    rcButton.size.height);
    [_pBtnRefresh setTztTitleColor:[UIColor blackColor]];
    _pBtnRefresh.backgroundColor = [UIColor colorWithTztRGBStr:@"237,237,237"];
    
    pLine = [_pScrollView viewWithTag:kTagLine+1];
    rcLine = _pBtnRefresh.frame;
    rcLine.origin.x += rcLine.size.width - 1;
    rcLine.size.width = 1;
    if (pLine == NULL)
    {
        pLine = [[UIView alloc] initWithFrame:rcLine];
        [_pScrollView addSubview:pLine];
        pLine.tag = kTagLine;
        pLine.backgroundColor = [UIColor colorWithTztRGBStr:@"224,224,224"];
        [pLine release];
    }
    else
        pLine.frame = rcLine;
    
    rcButton = _pBtnRefresh.frame;
    if (_pBtnClear == NULL)
    {
        _pBtnClear = [[tztUIButton alloc] initWithProperty:@"tag=5003|type=custom|title=清空|font=14"];
        _pBtnClear.tztdelegate = self;
        [_pScrollView addSubview:_pBtnClear];
        [_pBtnClear release];
    }
    _pBtnClear.frame = CGRectMake(rcButton.origin.x + rcButton.size.width,
                                  rcButton.origin.y,
                                  rcButton.size.width,
                                  rcButton.size.height);
    [_pBtnClear setTztTitleColor:[UIColor blackColor]];
    _pBtnClear.backgroundColor = [UIColor colorWithTztRGBStr:@"237,237,237"];
    
    CGRect rcInfo = rcFrame;
    rcInfo.origin.y = rcButton.origin.y + rcButton.size.height;
    rcInfo.size.height = 30;
    if (_pLabelInfo == NULL)
    {
        _pLabelInfo = [[tztUILabel alloc] initWithProperty:@"text=点击价格快速下单|font=12|textalignment=center"];
        [_pScrollView addSubview:_pLabelInfo];
        [_pLabelInfo release];
    }
    _pLabelInfo.backgroundColor = [UIColor colorWithTztRGBStr:@"48,48,48"];
    _pLabelInfo.textColor = [UIColor grayColor];
    _pLabelInfo.frame = rcInfo;
    
    //十档。。。。此处根据权限判断加载10档还是1档配置文件
    CGRect rcDetail = rcFrame;
    rcDetail.origin.y = rcInfo.origin.y + rcInfo.size.height;
    if (_tztDetailView == NULL)
    {
        _tztDetailView = NewObject(tztUIVCBaseView);
        _tztDetailView.tztDelegate = self;
        _tztDetailView.nXMargin = 0;
        _tztDetailView.nYMargin = 0;
        _tztDetailView.tableConfig = @"tztUIHKTradeDetail";
        _tztDetailView.frame = rcDetail;
        [_pScrollView addSubview:_tztDetailView];
        [_tztDetailView release];
    }
    else
        _tztDetailView.frame = rcDetail;
    _tztDetailView.backgroundColor = [UIColor colorWithTztRGBStr:@"62,62,62"];
    
    nHeight = [_tztDetailView getTableShowSize].height;
    
    int nTotalHeight = rcDetail.origin.y + nHeight;
    if (nTotalHeight < self.frame.size.height)
        nTotalHeight = self.frame.size.height;
    self.backgroundColor = [UIColor colorWithTztRGBStr:@"62,62,62"];
    self.pScrollView.contentSize = CGSizeMake(self.frame.size.width, nTotalHeight);
}

//根据.plst配置文件，对相应布局进行微调
//修改输入框背景色等
-(void)setShowStyle
{
    //
    UIView *pView = nil;
    float fBtnWidth = 70;
    float fLeftWidth = (self.frame.size.width - 70 * 2);
    //代码
    pView = [_tztTradeView getViewWithTag:kTagTextStockCode];
    if (pView && [pView isKindOfClass:[tztUITextField class]])
    {
        CGRect rc = pView.frame;
        rc.size.width = self.frame.size.width;
        pView.frame = rc;
        ((tztUITextField*)pView).textColor = [UIColor whiteColor];
        ((tztUITextField*)pView).clPlaceHolder = [UIColor lightGrayColor];
    }
    
    [_tztTradeView setComBoxData:_ayWTType ayContent_:_ayWTType AndIndex_:0 withTag_:kTagListType];
    pView = [_tztTradeView getViewWithTag:kTagListType];
    if (pView && [pView isKindOfClass:[tztUIDroplistView class]])
    {
        CGRect rc = pView.frame;
        rc.size.width = self.frame.size.width;
        pView.frame = rc;
    }
    
    
    
    //价格－
    pView = [_tztTradeView getViewWithTag:kTagBtnPriceDel];
    if (pView && [pView isKindOfClass:[tztUIButton class]])
    {
        CGRect rc = pView.frame;
        rc.size.height += (rc.origin.y * 2);
        rc.origin.y = 1;
        rc.size.width = fBtnWidth;
        pView.frame = rc;
        
        rc.size.height = rc.size.height / 3;
        rc.origin.y += (rc.size.height*2) - 5;
        if (_pLabelPriceDel == NULL)
        {
            _pLabelPriceDel = [[tztUILabel alloc] initWithProperty:@"text=0.001|font=10|textalignment=center|textcolor=140,140,140"];
            _pLabelPriceDel.frame = rc;
            [pView addSubview:_pLabelPriceDel];
            _pLabelPriceDel.backgroundColor = [UIColor clearColor];
            _pLabelPriceDel.userInteractionEnabled = NO;
            _pLabelPriceDel.adjustsFontSizeToFitWidth = YES;
            [_pLabelPriceDel release];
        }
        else
        {
            _pLabelPriceDel.frame = rc;
        }
    }
    
    //价格输入
    pView = [_tztTradeView getViewWithTag:kTagTextPrice];
    if (pView && [pView isKindOfClass:[tztUITextField class]])
    {
        CGRect rc = pView.frame;
        rc.origin.x = fBtnWidth;
        rc.size.width = fLeftWidth;
        
        ((tztUITextField*)pView).textColor = [UIColor whiteColor];
        ((tztUITextField*)pView).backgroundColor = [UIColor colorWithTztRGBStr:@"62,62,62"];
        ((tztUITextField*)pView).clPlaceHolder = [UIColor lightGrayColor];
        pView.frame = rc;
    }
    
    //价格＋
    pView = [_tztTradeView getViewWithTag:kTagBtnPriceAdd];
    if (pView && [pView isKindOfClass:[tztUIButton class]])
    {
        CGRect rc = pView.frame;
        rc.size.height += (rc.origin.y * 2);
        rc.origin.y = 1;
        rc.origin.x = fLeftWidth + fBtnWidth;
        rc.size.width = fBtnWidth;
        pView.frame = rc;
        
        
        rc.origin.x = 0;
        rc.size.height = rc.size.height / 3;
        rc.origin.y += (rc.size.height*2) - 5;
        if (_pLabelPriceAdd == NULL)
        {
            _pLabelPriceAdd = [[tztUILabel alloc] initWithProperty:@"text=0.001|font=10|textalignment=center|textcolor=140,140,140|"];
            _pLabelPriceAdd.frame = rc;
            [pView addSubview:_pLabelPriceAdd];
            _pLabelPriceAdd.backgroundColor = [UIColor clearColor];
            _pLabelPriceAdd.userInteractionEnabled = NO;
            _pLabelPriceAdd.adjustsFontSizeToFitWidth = YES;
            [_pLabelPriceAdd release];
        }
        else
        {
            _pLabelPriceAdd.frame = rc;
        }
    }
    
    //数量－
    pView = [_tztTradeView getViewWithTag:kTagBtnAmountDel];
    if (pView && [pView isKindOfClass:[tztUIButton class]])
    {
        CGRect rc = pView.frame;
        rc.size.height += (rc.origin.y * 2);
        rc.origin.y = 1;
        rc.size.width = fBtnWidth;
        pView.frame = rc;
        
        rc.size.height = rc.size.height / 3;
        rc.origin.y += (rc.size.height*2) - 5;
        if (_pLabelAmountDel == NULL)
        {
            _pLabelAmountDel = [[tztUILabel alloc] initWithProperty:@"text=1000|font=10|textalignment=center|textcolor=140,140,140|"];
            _pLabelAmountDel.frame = rc;
            [pView addSubview:_pLabelAmountDel];
            _pLabelAmountDel.backgroundColor = [UIColor clearColor];
            _pLabelAmountDel.userInteractionEnabled = NO;
            _pLabelAmountDel.adjustsFontSizeToFitWidth = YES;
            [_pLabelAmountDel release];
        }
        else
        {
            _pLabelAmountDel.frame = rc;
        }
    }
    
    //数量输入
    pView = [_tztTradeView getViewWithTag:kTagTextAmount];
    if (pView && [pView isKindOfClass:[tztUITextField class]])
    {
        CGRect rc = pView.frame;
        rc.origin.x = fBtnWidth;
        rc.size.width = fLeftWidth;
        
        ((tztUITextField*)pView).textColor = [UIColor whiteColor];
        ((tztUITextField*)pView).backgroundColor = [UIColor colorWithTztRGBStr:@"62,62,62"];
        ((tztUITextField*)pView).clPlaceHolder = [UIColor lightGrayColor];
        pView.frame = rc;
    }

    
    //数量＋
    pView = [_tztTradeView getViewWithTag:kTagBtnAmountAdd];
    if (pView && [pView isKindOfClass:[tztUIButton class]])
    {
        CGRect rc = pView.frame;
        rc.size.height += (rc.origin.y * 2);
        rc.origin.y = 1;
        rc.origin.x = fLeftWidth + fBtnWidth;
        rc.size.width = fBtnWidth;
        pView.frame = rc;
        
        rc.origin.x = 0;
        rc.size.height = rc.size.height / 3;
        rc.origin.y += (rc.size.height*2) - 5;
        if (_pLabelAmountAdd == NULL)
        {
            _pLabelAmountAdd = [[tztUILabel alloc] initWithProperty:@"text=1000|font=10|textalignment=center|textcolor=140,140,140|"];
            _pLabelAmountAdd.frame = rc;
            [pView addSubview:_pLabelAmountAdd];
            _pLabelAmountAdd.backgroundColor = [UIColor clearColor];
            _pLabelAmountAdd.userInteractionEnabled = NO;
            _pLabelAmountAdd.adjustsFontSizeToFitWidth = YES;
            [_pLabelAmountAdd release];
        }
        else
        {
            _pLabelAmountAdd.frame = rc;
        }
    }
    
    //折合
    pView = [_tztTradeView getViewWithTag:kTagLabelRMB];
    if (pView && [pView isKindOfClass:[tztUILabel class]])
    {
        ((tztUILabel*)pView).textColor = [UIColor redColor];
//        ((tztUILabel*)pView).text = @" ¥12345678";
        ((tztUILabel*)pView).adjustsFontSizeToFitWidth = YES;
    }
    
    //最大可买(卖)
    int nWidth = 0;
    pView = [_tztTradeView getViewWithTag:kTagLabelMaxTitle];
    if (pView && [pView isKindOfClass:[tztUILabel class]])
    {
        nWidth = pView.frame.origin.x + pView.frame.size.width;
        ((tztUILabel*)pView).textColor = [UIColor whiteColor];
        ((tztUILabel*)pView).adjustsFontSizeToFitWidth = YES;
//        pView.backgroundColor = [UIColor redColor];
        if (_bBuyFlag)
            ((tztUILabel*)pView).text = @"最大可买:";
        else
            ((tztUILabel*)pView).text = @"最大可卖:";
    }
    
    //最大可买(卖)
    pView = [_tztTradeView getViewWithTag:kTagLabelMaxValue];
    if (pView && [pView isKindOfClass:[tztUILabel class]])
    {
        CGRect rc = pView.frame;
        rc.origin.x = nWidth + 5;
        pView.frame = rc;
        ((tztUILabel*)pView).textColor = [UIColor whiteColor];
//        ((tztUILabel*)pView).text = @"123455677";
        ((tztUILabel*)pView).adjustsFontSizeToFitWidth = YES;
//        [((tztUIButton*)pView) setTztTitleColor:[UIColor whiteColor]];
//        [((tztUIButton*)pView) setTztTitle:@"123345667"];//.text = @"12345678";
//        ((tztUIButton*)pView).contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        ((tztUIButton*)pView).titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    pView = [_tztTradeView getCellWithFlag:@"TZTMax"];
    pView.backgroundColor = [UIColor colorWithTztRGBStr:@"48,48,48"];
}

 /**
 *	@brief	清除界面全部数据
 *
 *	@return
 */
-(void)ClearData
{
    [_tztTradeView setEditorText:@""
                  nsPlaceholder_:NULL withTag_:kTagTextStockCode andNotifi:YES];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
}

 /**
 *	@brief	清除界面除代码外的全部数据
 *
 *	@return
 */
-(void)ClearDataWithOutCode
{
    self.nsWTAccount = @"";
    self.nsWTAccountType = @"";
    self.nsNewPrice = @"";
    self.nsStockName = @"";
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagTextPrice];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagTextAmount];
    
    [_tztTradeView setLabelText:@"" withTag_:kTagLabelRMB];
    [_tztTradeView setLabelText:@"" withTag_:kTagLabelMaxValue];
    
    for (int i = kTagBtnBuyPrice; i < kTagBtnSellVolume + 10 ; i++)
    {
        [_tztDetailView setButtonTitle:@""
                              clText_:[UIColor whiteColor]
                            forState_:UIControlStateNormal
                             withTag_:i];
    }
}

#pragma 数据操作
-(void)setStockCode:(NSString *)strCode
{
    if (strCode == NULL || strCode.length < 5)
        return;
    strCode = [strCode lowercaseString];
    if ([strCode hasPrefix:@"h"])
        strCode = [strCode substringFromIndex:1];
    self.CurStockCode = [NSString stringWithFormat:@"%@", strCode];
    if (_tztTradeView)
        [_tztTradeView setEditorText:strCode nsPlaceholder_:NULL withTag_:kTagTextStockCode];
}

 /**
 *	@brief	根据股票代码请求十档行情数据,根据代码请求股票数据
 *
 *	@return
 */
-(void)OnRefresh:(BOOL)bStockInfo
{
    if (self.CurStockCode == NULL || self.CurStockCode.length < 5)
        return;
    
    //测试，固定价格，先跑流程
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNoHQ++;
    if (_ntztReqNoHQ >= UINT16_MAX)
        _ntztReqNoHQ = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNoHQ);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    //
    [pDict setTztObject:[NSString stringWithFormat:@"H%@",self.CurStockCode] forKey:@"StockCode"];
    [pDict setTztObject:@"2" forKey:@"level"];//2-返回10档数据
    [pDict setTztObject:@"2" forKey:@"AccountIndex"];//2-返回扩展数据
    
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"43" withDictValue:pDict];
    DelObject(pDict);
    
    if (bStockInfo)
        [self OnRequestStockInfo];
    //
}

 /**
 *	@brief	根据股票代码，以及OnRefresh请求得到的价格，去获取可买、可卖数量
 *
 *	@return
 */
-(void)OnRequestStockInfo

{
    if (self.CurStockCode == NULL || self.CurStockCode.length < 5)
        return;
    
    //测试，固定价格，先跑流程
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqInfo++;
    if (_ntztReqInfo >= UINT16_MAX)
        _ntztReqInfo = 0x5555;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqInfo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    //
    [pDict setTztObject:self.CurStockCode forKey:@"StockCode"];
    
    if (self.nsNewPrice)
        [pDict setTztObject:self.nsNewPrice forKey:@"Price"];
    
    if (_bBuyFlag)
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5100" withDictValue:pDict];
    else
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5101" withDictValue:pDict];
    DelObject(pDict);
}

-(void)RequestMaxValueData
{
    if (self.CurStockCode == NULL || self.CurStockCode.length < 5)
        return;
    
    //测试，固定价格，先跑流程
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    //
    [pDict setTztObject:self.CurStockCode forKey:@"StockCode"];
    
    if (self.nsNewPrice)
        [pDict setTztObject:self.nsNewPrice forKey:@"Price"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5112" withDictValue:pDict];
    DelObject(pDict);
}

 /**
 *	@brief	发送确认提交买卖数据
 *
 *	@param 	bSend 	是否要发送，false的时候对界面数据进行本地校验
 *
 *	@return
 */
-(void)OnSendBuySell:(BOOL)bSend
{
    if (_tztTradeView == NULL || ![_tztTradeView CheckInput])
        return;
    
    if (self.CurStockCode.length < 5)
    {
        tztAfxMessageBox(@"请输入正确的股票代码!");
        return;
    }
    
    //获取委托类型
    int nSelectIndex = [_tztTradeView getComBoxSelctedIndex:kTagListType];
    if (nSelectIndex < 0 || nSelectIndex >= [self.ayWTType count])
    {
        tztAfxMessageBox(@"无法正确获取委托类型，请退出重试!");
        return;
    }
    NSString* strWTName = [self.ayWTType objectAtIndex:nSelectIndex];
    NSString* strWTType = @"";
    if (nSelectIndex == 0)//竞价限价
        strWTType = @"1";
    else if (nSelectIndex == 1)//增强限价
        strWTType = @"0";
    
    //获取价格
    NSString* strPrice = [_tztTradeView GetEidtorText:kTagTextPrice];
    if (strPrice.length <= 0)
    {
        tztAfxMessageBox(@"请输入正确的委托价格!");
        return;
    }
    
    //获取委托数量
    NSString* strAmount = [_tztTradeView GetEidtorText:kTagTextAmount];
    if (strAmount.length <= 0 || [strAmount intValue] < 1)
    {
        tztAfxMessageBox(@"请输入正确的委托数量!");
        return;
    }
    
    if (self.nsWTAccount.length <= 0 || self.nsWTAccountType.length <= 0)
    {
        tztAfxMessageBox(@"数据错误，请点击刷新按钮重试!");
        return;
    }
    
    NSString* strContent = [NSString stringWithFormat:@"委托账号:%@\r\n委托类型:%@\r\n股票代码:%@\r\n股票名称:%@\r\n委托价格:%@\r\n委托数量:%@\r\n\r\n确认%@该股票?",
                            self.nsWTAccount,strWTName, self.CurStockCode, self.nsStockName, strPrice, strAmount, (_bBuyFlag?@"买入":@"卖出")];
    NSString* strTitle = GetTitleByID(_nMsgType);
    tztAfxMessageBlock(strContent, strTitle, nil, TZTBoxTypeButtonBoth, ^(NSInteger nIndex)
                       {
                           if (nIndex == 0)//确认买入
                           {
                               //组织数据发送
                               NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
                               
                               _ntztReqNo++;
                               if (_ntztReqNo >= UINT16_MAX)
                                   _ntztReqNo = 1;
                               NSString * strReqno = tztKeyReqno((long)self, _ntztReqNo);
                               [pDict setTztObject:strReqno forKey:@"Reqno"];
                               
                               if (self.nsWTAccountType)
                                   [pDict setTztObject:self.nsWTAccountType forKey:@"WTAccountType"];
                               if (self.nsWTAccount)
                                   [pDict setTztObject:self.nsWTAccount forKey:@"WTAccount"];
                               
                               [pDict setTztObject:self.CurStockCode forKey:@"StockCode"];
                               [pDict setTztObject:strPrice forKey:@"price"];
                               [pDict setTztObject:strAmount forKey:@"Volume"];
                               [pDict setTztObject:(_bBuyFlag ? @"B" : @"S") forKey:@"Direction"];
                               [pDict setTztObject:strWTType forKey:@"PriceLevels"];
                               //使用交易通道
                               [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5102" withDictValue:pDict];
                               DelObject(pDict);
                           }
                       });
    
}

//定时请求十档或1档行情（注意，这时候请求回来数据后，不应该再根据价格去获取可卖可买数量了，接受数据要区分处理）
-(UInt32)OnRequestData:(UInt32)wParam lParam_:(UInt32)lParam
{
    [self OnRefresh:FALSE];
    return 1;
}

//数据接受处理
-(UInt32)OnCommNotify:(UInt32)wParam lParam_:(UInt32)lParam
{
    tztNewMSParse* pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    NSString* strReqno = [pParse GetByName:@"Reqno"];
    tztNewReqno* newReqno = [tztNewReqno reqnoWithString:strReqno];
    //判断是不是当前界面发起的请求
    if ([newReqno getIphoneKey] != (long)self)
        return 0;
    //判断请求序号reqno
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNoHQ]
        && ![pParse IsIphoneKey:(long)self reqno:_ntztReqNo]
        && ![pParse IsIphoneKey:(long)self reqno:_ntztReqInfo])
        return 0;
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];
    if ([tztBaseTradeView IsExitError:nErrNo])
    {
        [self OnNeedLoginOut];
        tztAfxMessageBox(strError);
        return 0;
    }
    
    //根据功能号解析对应数据
    if ([pParse IsAction:@"5102"])
    {
        if (nErrNo < 0)
            tztAfxMessageBox(strError);
        else
        {
            if (strError.length > 0)
            {
                tztAfxMessageBox(strError);
            }
            else
            {
                NSString* strAnswerNo = [pParse GetByName:@"answerno"];
                strError = [NSString stringWithFormat:@"委托成功!\r\n委托序号:%@", strAnswerNo];
                tztAfxMessageBox(strError);
            }
            [self ClearData];
        }
        return 1;
    }
    else if ([pParse IsAction:@"43"])
    {
        [self DealHQData:pParse];
    }
    else if ([pParse IsAction:@"5112"])
    {
        NSString* strMaxCount = [pParse GetByName:@"MaxQty"];//最大数量（可买/卖）
        
        if (!ISNSStringValid(strMaxCount))
            strMaxCount = @"--";
        
        //显示最大数量
        [_tztTradeView setLabelText:strMaxCount withTag_:kTagLabelMaxValue];
    }
    else if ([pParse IsAction:@"5100"] || [pParse IsAction:@"5101"])
    {
//        NSString* strMaxCount = [pParse GetByName:@"MaxQty"];//最大数量（可买/卖）
        NSString* strWTAccount = [pParse GetByName:@"WTAccount"];
        NSString* strWTAccountType = [pParse GetByName:@"WTAccountType"];
        NSString* strRate = [pParse GetByName:@"BuyRate"];//买入汇率
        NSString* strUnit = [pParse GetByName:@"BuyUnit"];//每手股数
        if ([pParse IsAction:@"5101"])
        {
            strRate = [pParse GetByName:@"SellRate"];
            strUnit = [pParse GetByName:@"SellUnit"];
        }
        if (ISNSStringValid(strRate))//汇率
        {
            _fRate = [strRate floatValue];
        }
        if (ISNSStringValid(strUnit))
        {
            _nUnit = [strUnit intValue];
            if (self.pLabelAmountDel)
                self.pLabelAmountDel.text = strUnit;
            if (self.pLabelAmountAdd)
                self.pLabelAmountAdd.text = strUnit;
        }
        
        
//        if (!ISNSStringValid(strMaxCount))
//            strMaxCount = @"--";
        if (ISNSStringValid(strWTAccount))
            self.nsWTAccount = [NSString stringWithFormat:@"%@", strWTAccount];
        if (ISNSStringValid(strWTAccountType))
            self.nsWTAccountType = [NSString stringWithFormat:@"%@", strWTAccountType];
        
        if (_ayJC == NULL)
            _ayJC = NewObject(NSMutableArray);
        [_ayJC removeAllObjects];
        //价差处理，处在区间内，取当前区间价差，若在临界值，－取上一个区间价差，＋取下一个区间价差
        NSArray* ayGrid = [pParse GetArrayByName:@"Grid"];
        int nStartIndex = 1;
        int nEndIndex = 2;
        int nValueIndex = 3;
        for (int i = 1; i < [ayGrid count]; i++)//0-标题行 //价差类型 起点价格 终点价格 价差
        {
            NSArray* ayValue = [ayGrid objectAtIndex:i];
            if (ayValue == NULL || [ayValue count] < 4)
                continue;
            //取数据
            NSString* strStartPrice = [ayValue objectAtIndex:nStartIndex];
            NSString* strEndPrice = [ayValue objectAtIndex:nEndIndex];
            NSString* strJC = [ayValue objectAtIndex:nValueIndex];
            if (strStartPrice == NULL)
                strStartPrice = @"";
            if (strEndPrice == NULL)
                strEndPrice = @"";
            if (strJC == NULL)
                strJC = @"";
            
            NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strStartPrice forKey:tztHKStartPrice];
            [pDict setTztObject:strEndPrice forKey:tztHKEndPrice];
            [pDict setTztObject:strJC forKey:tztHKPriceValue];
            
            [_ayJC addObject:pDict];
            [pDict release];
        }
        
        //显示最大数量
//        [_tztTradeView setLabelText:strMaxCount withTag_:kTagLabelMaxValue];
        //设置价格显示
        NSString* strPrice = [_tztTradeView GetEidtorText:kTagTextPrice];
        if (strPrice.length <= 0)
            [_tztTradeView setEditorText:self.nsNewPrice nsPlaceholder_:NULL withTag_:kTagTextPrice];
        //设置名称显示
        self.nsStockName = [self.nsStockName stringByReplacingOccurrencesOfString:@" " withString:@""];
        UIView* pView = [_tztTradeView  getViewWithTag:kTagTextStockCode];
        BOOL bFouce = FALSE;
        if (pView && [pView isKindOfClass:[tztUITextField class]])
        {
            bFouce = [(tztUITextField*)pView isFirstResponder];
        }
        if (!bFouce)
            [_tztTradeView setEditorText:[NSString stringWithFormat:@"%@ %@", self.nsStockName, self.CurStockCode] nsPlaceholder_:NULL withTag_:kTagTextStockCode andNotifi:NO];
        //处理价差
        [_ayJC sortUsingFunction:compareJC context:NULL];
        
        [self DealJCData];
    }
    
    return 1;
}

NSComparisonResult compareJC(NSMutableDictionary *firstValue, NSMutableDictionary *secondValue, void *context)
{
    double fStart = [[firstValue objectForKey:tztHKStartPrice] doubleValue];
    double fEnd   = [[secondValue objectForKey:tztHKStartPrice] doubleValue];
    
    if (fStart < fEnd)
        return NSOrderedAscending;
    else if (fStart > fEnd)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

 /**
 *	@brief	处理价差数据，并处理界面显示
 *
 *	@return
 */
-(void)DealJCData
{
    CGSize sz = [self GetPriceRegion:NO];
    [self setBtnRegionShow:sz];
}

-(void)setBtnRegionShow:(CGSize)sz
{
    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
    double dRegion = sz.width / pow(10.f, _nDotValid);
    NSString* str = [NSString stringWithFormat:strPriceformat, dRegion];
    
    double dRight = sz.height / pow(10.f, _nDotValid);
    NSString* strR = [NSString stringWithFormat:strPriceformat, dRight];
    
    _pLabelPriceAdd.text = strR;
    _pLabelPriceDel.text = str;
}

 /**
 *	@brief	获取价格操作区间
 *
 *	@return	整型，根据_nDotValue放大相应倍数
 */
-(CGSize)GetPriceRegion:(BOOL)bAdd
{
    //获取当前输入框价格
    NSString* strPrice = [_tztTradeView GetEidtorText:kTagTextPrice];
    double nPrice = [strPrice doubleValue] * pow(10.f, _nDotValid);
    for (int i = 0; i < [self.ayJC count]; i++)
    {
        NSMutableDictionary *pDict = [self.ayJC objectAtIndex:i];
        NSString* strStart = [pDict objectForKey:tztHKStartPrice];
        NSString* strEnd = [pDict objectForKey:tztHKEndPrice];
        NSString* strRegion = [pDict objectForKey:tztHKPriceValue];
        
        int nStart = [strStart doubleValue] * pow(10.f, _nDotValid);
        int nEnd = [strEnd doubleValue] * pow(10.f, _nDotValid);
        int nRegion = [strRegion doubleValue] * pow(10.f, _nDotValid);
        
        if (nPrice < nStart && i == 0)//比第一个还要小，直接返回第一个
        {
            return CGSizeMake(nRegion, nRegion);
        }
        else if (nPrice > nEnd && i == [self.ayJC count] - 1)
        {
            return CGSizeMake(nRegion, nRegion);
        }
        
        if (nPrice > nStart && nPrice < nEnd)//在当前区间范围内，直接使用
        {
            return CGSizeMake(nRegion, nRegion);
        }
        else if (nPrice == nStart)
        {
            if (bAdd)
                return CGSizeMake(nRegion, nRegion);
            else
            {
                //取上个区间
                if (i > 0)
                {
                    NSMutableDictionary *pSubDict = [self.ayJC objectAtIndex:i-1];
                    strRegion = [pSubDict objectForKey:tztHKPriceValue];
                    int nPreRegion = [strRegion doubleValue] * pow(10.f, _nDotValid);
                    return CGSizeMake(nPreRegion, nRegion);
                }
                else
                    return CGSizeMake(nRegion, nRegion);
            }
        }
        else if (nPrice == nEnd)
        {
            if (!bAdd)
                return CGSizeMake(nRegion, nRegion);
            else
            {
                if ((i+1) < [self.ayJC count])
                {
                    NSMutableDictionary *pSubDict = [self.ayJC objectAtIndex:i+1];
                    strRegion = [pSubDict objectForKey:tztHKPriceValue];
                    int nNextRegion = [strRegion doubleValue] * pow(10.f, _nDotValid);
                    return CGSizeMake(nRegion, nNextRegion);
                }
                else
                    return CGSizeMake(nRegion, nRegion);
            }
        }
        
    }
    return CGSizeMake(1, 1);
    
}

 /**
 *	@brief	处理服务器返回的行情数据
 *
 *	@param 	pParse 	服务器返回数据
 *
 *	@return
 */
-(void)DealHQData:(tztNewMSParse*)pParse
{
    if (pParse == NULL)
        return;
    
    if ([pParse IsAction:@"43"])
    {
        //获取股票代码名称
        //买卖5档
        NSData* DataGrid = [pParse GetNSData:@"BinData"];
        int nDataLen = [DataGrid length];
        if (DataGrid && nDataLen > 0)
        {
            TNewPriceData pPriceData;
            TNewPriceDataEx pPriceDataEx;//6-10档
            NSString* strBase = [pParse GetByName:@"BinData"];
            setTNewPriceData(&pPriceData,strBase);
            
            NSString* strLevel2Bin = [pParse GetByName:@"Level2Bin"];
            setTNewPriceDataEx(&pPriceDataEx, strLevel2Bin);
            
            //把数据显示到界面上
            NSString* strCode = [[[NSString alloc] initWithBytes:pPriceData.Code length:sizeof(pPriceData.Code) encoding:NSStringEncodingGBK] autorelease];
            strCode = [strCode substringFromIndex:1];
            if ([strCode caseInsensitiveCompare:self.CurStockCode] != NSOrderedSame)
                return;
            
            NSString* strName = getName_TNewPriceData(&pPriceData);
            if (strName && strName.length > 0)
            {
                strName  = [strName stringByReplacingOccurrencesOfString:@" " withString:@""];
                self.nsStockName = [NSString stringWithFormat:@"%@", strName];
                
            }
            else
                self.nsStockName = @"";
            _nDotValid = pPriceData.nDecimal;
            [_tztTradeView setEditorDotValue:_nDotValid withTag_:kTagTextPrice];
            /*
             //买卖档7000-
             kTagBtnBuyPrice = 7000,     //买价10档开始
             
             kTagBtnSellPrice = 7010,    //卖价10档开始
             
             kTagBtnBuyVolume = 7020,    //买量10档开始
             
             kTagBtnSellVolume = 7030,   //卖量10档开始
             */
            //卖1 价、量
            [self SetValueForDetail:pPriceData.a.StockData.p4
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnSellPrice
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q4
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnSellVolume
                           bVolume_:YES];
            //卖2 价、量
            [self SetValueForDetail:pPriceData.a.StockData.P5
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnSellPrice+1
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q5
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnSellVolume+1
                           bVolume_:YES];
            //卖3 价、量
            [self SetValueForDetail:pPriceData.a.StockData.P6
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnSellPrice+2
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q6
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnSellVolume+2
                           bVolume_:YES];
            //卖4 价、量
            [self SetValueForDetail:pPriceData.a.StockData.p9
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnSellPrice+3
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q9
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnSellVolume+3
                           bVolume_:YES];
            //卖5 价、量
            [self SetValueForDetail:pPriceData.a.StockData.p10
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnSellPrice+4
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q10
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnSellVolume+4
                           bVolume_:YES];
            
            //买入5档
            //买1 价、量
            [self SetValueForDetail:pPriceData.a.StockData.p1
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnBuyPrice
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q4
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnBuyVolume
                           bVolume_:YES];
            //买2 价、量
            [self SetValueForDetail:pPriceData.a.StockData.p2
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnBuyPrice+1
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q2
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnBuyVolume+1
                           bVolume_:YES];
            //买3 价、量
            [self SetValueForDetail:pPriceData.a.StockData.p3
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnBuyPrice+2
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q3
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnBuyVolume+2
                           bVolume_:YES];
            //买4 价、量
            [self SetValueForDetail:pPriceData.a.StockData.p7
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnBuyPrice+3
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q7
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnBuyVolume+3
                           bVolume_:YES];
            //买5 价、量
            [self SetValueForDetail:pPriceData.a.StockData.p8
                           nCompare:pPriceData.Close_p
                             nDivd_:1000
                          nDecimal_:pPriceData.nDecimal
                              nTag_:kTagBtnBuyPrice+4
                           bVolume_:NO];
            [self SetValueForDetail:pPriceData.a.StockData.Q8
                           nCompare:0
                             nDivd_:100
                          nDecimal_:0
                              nTag_:kTagBtnBuyVolume+4
                           bVolume_:YES];
            
            NSString *strPrice = [_tztDetailView getButtonTitle:(_bBuyFlag ? kTagBtnSellPrice : kTagBtnBuyPrice) forState_:UIControlStateNormal];
            if (strPrice == NULL || strPrice.length < 1 || [strPrice isEqualToString:@"-"])
                self.nsNewPrice = @"0";
            else
                self.nsNewPrice = [NSString stringWithFormat:@"%@", strPrice];
            
            //获取当前输入框的价格，如果没有价格，则自动去查询可卖可买，否则不查了
            NSString* nsEditPrice = [_tztTradeView GetEidtorText:kTagTextPrice];
            if (nsEditPrice.length <= 0)
            {
                UIView *pView = [_tztTradeView getViewWithTag:kTagTextPrice];
                BOOL bFocused = FALSE;
                if (pView && [pView isKindOfClass:[tztUITextField class]])
                    bFocused = [((tztUITextField*)pView) isFirstResponder];
                if (!bFocused)
                    [_tztTradeView setEditorText:self.nsNewPrice nsPlaceholder_:NULL withTag_:kTagTextPrice];
                [self RequestMaxValueData];
//                [self OnRequestStockInfo];
            }
        }
    }
    
}

-(UIColor*)getColor:(int)nValue nCompare:(int)nCompare
{
    UIColor* upColor = [UIColor tztThemeHQUpColor];
    UIColor* downColor = [UIColor tztThemeHQDownColor];
    UIColor* balanceColor = [UIColor tztThemeHQBalanceColor];
    if (nValue > nCompare)
        return upColor;
    else if (nValue < nCompare)
        return downColor;
    else
        return balanceColor;
}

-(void)SetValueForDetail:(uint32_t)nValue nCompare:(uint32_t)nCompare nDivd_:(uint32_t)nDivd nDecimal_:(int32_t)nDecimal
                   nTag_:(int)nTag bVolume_:(BOOL)bVolume
{
    NSString* strValue = @"--";
    if (nDivd == 0)
        nDivd = 1;
    UIColor *pColor = [UIColor tztThemeHQBalanceColor];
    if (bVolume)
        pColor = [UIColor orangeColor];
    else
    {
        if (nValue > nCompare)
            pColor = [UIColor tztThemeHQUpColor];
        else if (nValue < nCompare)
            pColor = [UIColor tztThemeHQDownColor];
    }
    
    if (bVolume)
    {
        strValue = NStringOfULong(nValue / nDivd);
    }
    else
    {
        strValue = NSStringOfVal_Ref_Dec_Div(nValue,
                                             0,
                                             nDecimal,
                                             1000);
    }
    
    UIView* pView = [_tztDetailView getViewWithTag:nTag];
    if (pView && [pView isKindOfClass:[UIButton class]])
    {
        ((UIButton*)pView).titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    [_tztDetailView setButtonTitle:strValue clText_:pColor forState_:UIControlStateNormal withTag_:nTag];
}

#pragma 控件操作
 /**
 *	@brief	输入框内容改变事件处理
 *
 *	@param 	tztUIBaseView 	输入框
 *	@param 	text 	具体内容
 *
 *	@return
 */
- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
//    
//    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
//    NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagTextStockCode://代码
        {
            if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
            if ([inputField.text length] <= 0)
            {
                self.CurStockCode = @"";
                [self ClearData];//清空界面数据
            }
            
            if (inputField.text != NULL && inputField.text.length == 5)
            {
                if (self.CurStockCode && [self.CurStockCode compare:inputField.text] != NSOrderedSame)
                {
                    self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                    [self ClearDataWithOutCode];
                }
            }
            else if (inputField.text.length > 5)
            {
                inputField.text = [inputField.text substringToIndex:5];
                [inputField resignFirstResponder];
                [self OnRefresh:YES];
                break;
            }
            else
            {
                self.CurStockCode = @"";
                [self ClearDataWithOutCode];
            }
            
            if (self.CurStockCode.length == 5)
            {
                [inputField resignFirstResponder];
                [self OnRefresh:YES];
            }
        }
            break;
        case kTagTextPrice://价格
        {
            NSString* strPrice =  text ;//[_tztTradeView GetEidtorText:kTagTextPrice];
            double dPrice = [strPrice doubleValue];
            CGSize sz = [self GetPriceRegion:YES];
            _fMoveStep = sz.width / pow(10.f, _nDotValid);
            dPrice += _fMoveStep;
//            NSString* nsPrice = [NSString stringWithFormat:@"%.3lf", dPrice];
//            [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:kTagTextPrice andNotifi:NO];
//            [self OnRequestStockInfo];
            [self setBtnRegionShow:sz];
            [self CalcRateRMB];
        }
            break;
        case kTagTextAmount://数量
        {
            [self CalcRateRMB];
        }
            break;
            
        default:
            break;
    }
}

 /**
 *	@brief	输入框焦点发生改变
 *
 *	@param 	tztUIBaseView 	输入框
 *	@param 	text 	文本
 *
 *	@return
 */
-(void)tztUIBaseView:(UIView *)tztUIBaseView focuseChanged:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagTextStockCode:
        {
            if (self.CurStockCode.length == 5)
            {
                if (self.nsStockName && self.nsStockName.length > 0)
                    [_tztTradeView setEditorText:[NSString stringWithFormat:@"%@ %@",self.nsStockName, self.CurStockCode] nsPlaceholder_:nil withTag_:kTagTextStockCode andNotifi:NO];
                else
                    [_tztTradeView setEditorText:[NSString stringWithFormat:@"%@", self.CurStockCode] nsPlaceholder_:nil withTag_:kTagTextStockCode andNotifi:NO];
            }
        }
            break;
        case kTagTextPrice:
        {
            //价格变更，重新请求可卖可买
            self.nsNewPrice = inputField.text;
            NSString* strPrice = [_tztTradeView GetEidtorText:kTagTextPrice];
            if (strPrice.length <= 0)
                [_tztTradeView setEditorText:self.nsNewPrice nsPlaceholder_:NULL withTag_:kTagTextPrice];
//            [self OnRequestStockInfo];
            [self RequestMaxValueData];
        }
            break;
        default:
            break;
    }
}

-(void)tztUIBaseView:(UIView *)tztUIBaseView beginEditText:(NSString *)text
{
    if ([((tztUITextField*)tztUIBaseView).tzttagcode intValue] == kTagTextStockCode)
    {
        if (self.CurStockCode.length == 5)
        {
            [_tztTradeView setEditorText:self.CurStockCode nsPlaceholder_:nil withTag_:kTagTextStockCode andNotifi:NO];
        }
    }
}

 /**
 *	@brief	按钮事件处理
 *
 *	@param 	sender 	按钮
 *
 *	@return
 */
-(void)OnButtonClick:(id)sender
{
    if (sender == NULL)
        return;
    
	UIButton * pButton = (UIButton*)sender;
	int nTag = pButton.tag;
    
    if ([pButton isKindOfClass:[tztUIButton class]])
    {
        nTag = [((tztUIButton*)pButton).tzttagcode intValue];
    }
    
    NSString* nsString = [pButton titleForState:UIControlStateNormal];
    
    if (nTag == kTagBtnOK)//买入，卖出
    {
        [self OnSendBuySell:YES];
    }
    else if (nTag == kTagBtnSwitch)//切换
    {
        NSString *stockCode = @"";
        //zxl 20130806 添加了空判断
        if (self.CurStockCode &&[self.CurStockCode length] > 0 )
        {
            stockCode = [NSString stringWithString:self.CurStockCode];
        }
        tztStockInfo *pStockInfo = NewObject(tztStockInfo);
        pStockInfo.stockCode = [NSString stringWithFormat:@"%@", stockCode];
        [TZTUIBaseVCMsg OnMsg:(_bBuyFlag ? MENU_JY_HK_Sell : MENU_JY_HK_Buy ) wParam:(UInt32)pStockInfo lParam:1];
        [pStockInfo release];
    }
    else if (nTag == kTagBtnRefresh)//刷新
    {
        [self OnRefresh:YES];
    }
    else if (nTag == kTagBtnClear)//清空
    {
        [self ClearData];
    }
    else if (nTag == kTagBtnPriceAdd)//价格＋
    {
        NSString* strPrice = [_tztTradeView GetEidtorText:kTagTextPrice];
        double dPrice = [strPrice doubleValue];
        CGSize sz = [self GetPriceRegion:YES];
        _fMoveStep = sz.height / pow(10.f, _nDotValid);
        dPrice += _fMoveStep;
        NSString* nsPrice = [NSString stringWithFormat:@"%.3lf", dPrice];
        [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:kTagTextPrice];
        [self RequestMaxValueData];
//        [self OnRequestStockInfo];
//        [self setBtnRegionShow:sz];
        //修改同时要修改折合人民币
        [self CalcRateRMB];
    }
    else if (nTag == kTagBtnPriceDel)//价格－
    {
        NSString* strPrice = [_tztTradeView GetEidtorText:kTagTextPrice];
        double dPrice = [strPrice doubleValue];
        CGSize sz = [self GetPriceRegion:NO];
        _fMoveStep = sz.width / pow(10.f, _nDotValid);
        dPrice -= _fMoveStep;
        if (dPrice < _fMoveStep)
            dPrice = 0.0f;
        
        NSString* nsPrice = [NSString stringWithFormat:@"%.3lf", dPrice];
        [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:kTagTextPrice];
        [self RequestMaxValueData];
//        [self OnRequestStockInfo];
//        [self setBtnRegionShow:sz];
        //修改同时要修改折合人民币
        [self CalcRateRMB];
    }
    else if (nTag == kTagBtnAmountAdd)//数量＋
    {
        NSString* nsAmount = [_tztTradeView GetEidtorText:kTagTextAmount];
        int nAmount = [nsAmount intValue];
        
        nAmount += _nUnit;
        
        nsAmount = [NSString stringWithFormat:@"%d", nAmount];
        [_tztTradeView setEditorText:nsAmount nsPlaceholder_:NULL withTag_:kTagTextAmount];
        //修改同时要修改折合人民币
        [self CalcRateRMB];
    }
    else if (nTag == kTagBtnAmountDel)//数量－
    {
        NSString* nsAmount = [_tztTradeView GetEidtorText:kTagTextAmount];
        int nAmount = [nsAmount intValue];
        
        nAmount -= _nUnit;
        if (nAmount <= 0)
            nAmount = 0;
        
        nsAmount = [NSString stringWithFormat:@"%d", nAmount];
        [_tztTradeView setEditorText:nsAmount nsPlaceholder_:NULL withTag_:kTagTextAmount];
        //修改同时要修改折合人民币
        [self CalcRateRMB];
    }
    //十档价格点击处理...
    else if ((nTag >= kTagBtnBuyPrice && nTag <= kTagBtnBuyPrice + 9)
             || (nTag >= kTagBtnSellPrice && nTag <= kTagBtnSellPrice + 9))
    {
        [_tztTradeView setEditorText:nsString nsPlaceholder_:NULL withTag_:kTagTextPrice];
        self.nsNewPrice = [NSString stringWithFormat:@"%@", nsString];
        [self RequestMaxValueData];
//        [self OnRequestStockInfo];
        [self CalcRateRMB];
    }
}

 /**
 *	@brief	折合人民币计算
 *
 *	@return
 */
-(void)CalcRateRMB
{
    //获取价格
    NSString* strPrice = [_tztTradeView GetEidtorText:kTagTextPrice];
    //获取数量
    NSString* strAmount = [_tztTradeView GetEidtorText:kTagTextAmount];
    
    //计算金额并显示
    float fMoney = ([strPrice floatValue] * [strAmount intValue]) * ((_fRate > 0.0000001) ? _fRate : 1);
    
    NSString* strMoney = [NSString stringWithFormat:@" ¥%.2f", fMoney];
    
    [_tztTradeView setLabelText:strMoney withTag_:kTagLabelRMB];
}

 /**
 *	@brief	选择框事件处理
 *
 *	@param 	droplistview 	下拉选择框
 *	@param 	index 	选中位置索引
 *
 *	@return
 */
-(void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    switch ([droplistview.tzttagcode intValue])
    {
        case kTagListType://委托类型
        {
            
        }
            break;
            
        default:
            break;
    }
}
@end
