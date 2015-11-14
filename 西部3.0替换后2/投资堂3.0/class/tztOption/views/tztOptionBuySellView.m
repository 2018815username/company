
#import "tztOptionBuySellView.h"

/**
 *    @author yinjp
 *
 *    @brief  功能说明：
 
 *  //流程说明：具体功能号字段见：国泰君安客户端接口文档.doc
 1、合约买卖：
 1、输入合约代码，通过5402查询个股期权基础信息，并进行界面显示
 
 2、委托申报
 5404－申报提交委托
 
 */
/**
 *    @author yinjp
 *
 *    @brief  界面显示tag定义，和配置文件对应
 */
enum{
    kTagCode = 1000,    //合约代码
    kTagPrice = 1001,   //委托价格
    kTagAmount = 1002,  //委托数量
    
    kTagName = 2000,    //合约名称
    kTagKYAmount = 2001,//可用数量
    
    kTagType = 3000,    //委托方式
    
    kTagAmountAdd = 4000, //数量+
    kTagAmountDel = 4001, //数量-
    
    kTagPriceAdd = 4010, //价格＋
    kTagPriceDel = 4011, //价格－
    
    kTagOK = 5000,      //确定按钮
    kTagClear = 5001,   //清空按钮
    
    kTagPriceNew = 6000,//最新，后面依次追加其他显示数据
    kTagPriceClose= 6001,//结算
    kTagPriceZT = 6002, //涨停
    kTagPriceDT = 6003, //跌停
    
    //买卖5档
    kTagBuyPrice1 = 6004,
    kTagBuyPrice2 = 6005,
    kTagBuyPrice3 = 6006,
    kTagBuyPrice4 = 6007,
    kTagBuyPrice5 = 6008,
    
    /*预留6-10档*/
    
    kTagBuyAmount1 = 6014,
    kTagBuyAmount2 = 6015,
    kTagBuyAmount3 = 6016,
    kTagBuyAmount4 = 6017,
    kTagBuyAmount5 = 6018,
};


@interface tztOptionBuySellView()<tztGroupRadioViewDelegate>
{
    CGFloat     _fMoveStep;
    NSInteger   _nDotValid;
    NSInteger   _nAccountIndex;
    
    BOOL        _bBuyFlag;
}
@property(nonatomic,retain)tztUIVCBaseView  *tztTradeView;
/**
 *    @author yinjp
 *
 *    @brief  账户信息
 */
@property(nonatomic,retain)NSMutableArray   *ayAccountInfo;
/**
 *    @author yinjp
 *
 *    @brief  委托方式
 */
@property(nonatomic,retain)NSMutableArray   *ayWTType;

@property(nonatomic,retain)UIView               *pBackView;
@property(nonatomic,retain)tztGroupRadioView    *pRadioView;

@end

@implementation tztOptionBuySellView

-(id)init
{
    if (self = [super init])
    {
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    if (_tztTradeView == nil)
    {
        _tztTradeView = NewObject(tztUIVCBaseView);
        _tztTradeView.nXMargin = 0;
        _tztTradeView.tztDelegate = self;
        _tztTradeView.tableConfig = @"tztUIOptionBuySell";
        _tztTradeView.frame = rcFrame;
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
    {
        _tztTradeView.frame = rcFrame;
    }
    
    tztUIButton* pBtn = (tztUIButton*)[_tztTradeView getViewWithTag:kTagOK];
    [pBtn setTztTitle:GetTitleByID(_nMsgType)];
    switch (_nMsgType)
    {
        case MENU_JY_GGQQ_BuyOpen://买入开仓
        case MENU_JY_GGQQ_CoveredOpen:
        {
            [pBtn setBackgroundColor:[UIColor colorWithTztRGBStr:@"204,34,43"]];
        }
            break;
        case MENU_JY_GGQQ_SellOpen:
        {
            [pBtn setBackgroundColor:[UIColor colorWithTztRGBStr:@"0,131,124"]];
        }
            break;
        default:
        {
            [pBtn setBackgroundColor:[UIColor colorWithTztRGBStr:@"68,68,68"]];
        }
            break;
    }
    
    UIColor *pColor = [UIColor colorWithTztRGBStr:@"45,45,45"];
    UIColor *pColorTxt = [UIColor whiteColor];
    if (g_nSkinType == 1)
    {
        pColor = [UIColor colorWithTztRGBStr:@"235,235,235"];
        pColorTxt = [UIColor blackColor];
    }
    //处理显示
    UIView *pCellView = [_tztTradeView getCellWithFlag:@"TZTDM"];
    pCellView.backgroundColor = pColor;
    
    UIView *pView = [_tztTradeView getViewWithTag:kTagCode];
    pView.backgroundColor = pCellView.backgroundColor;
    pView.layer.borderWidth = 0;
    if ([pView isKindOfClass:[UITextField class]])
    {
        
        ((UITextField*)pView).textColor = pColorTxt;
    }
    
    pCellView = [_tztTradeView getCellWithFlag:@"TZTName"];
    pCellView.backgroundColor = pColor;
    [_tztTradeView setLabelText:@"测试数据" withTag_:kTagName];
    
    pCellView = [_tztTradeView getCellWithFlag:@"TZTWTFS"];
    pCellView.backgroundColor = pColor;
    pView = [_tztTradeView getViewWithTag:kTagType];
    pView.backgroundColor = pCellView.backgroundColor;
    pView.layer.borderWidth = 0;
    if ([pView isKindOfClass:[tztUIDroplistView class]])
    {
        ((tztUIDroplistView*)pView).pBackView.backgroundColor = pColor;
        ((tztUIDroplistView*)pView).textfield.backgroundColor = pColor;
        ((tztUIDroplistView*)pView).textbtn.backgroundColor = pColor;
        ((tztUIDroplistView*)pView).textColor = pColorTxt;
        [((tztUIDroplistView*)pView) setText:@"完算测试"];
    }
    
    pCellView = [_tztTradeView getCellWithFlag:@"TZTJG"];
    pCellView.backgroundColor = pColor;
    pView = [_tztTradeView getViewWithTag:kTagPrice];
    pView.backgroundColor = pCellView.backgroundColor;
    pView.layer.borderWidth = 0;
    if ([pView isKindOfClass:[UITextField class]])
    {
        ((UITextField*)pView).textColor = pColorTxt;
    }
    
    pCellView = [_tztTradeView getCellWithFlag:@"TZTKYSL"];
    pCellView.backgroundColor = pColor;
    
    [_tztTradeView setLabelText:@"测试数据" withTag_:kTagKYAmount];
    
    pCellView = [_tztTradeView getCellWithFlag:@"TZTSL"];
    pCellView.backgroundColor = pColor;
    pView = [_tztTradeView getViewWithTag:kTagAmount];
    pView.backgroundColor = pCellView.backgroundColor;
    pView.layer.borderWidth = 0;
    if ([pView isKindOfClass:[UITextField class]])
    {
        ((UITextField*)pView).textColor = pColorTxt;
    }
    
    CGFloat fY = [pView gettztwindowy:_tztTradeView];
    CGFloat fX = [pView gettztwindowx:nil];
    
    CGRect rcRadio = CGRectMake(fX, fY + pView.frame.size.height + 5, pView.frame.size.width, 24);
    
    if (_pBackView == nil)
    {
        _pBackView = [[UIView alloc] initWithFrame:CGRectMake(0, fY+pView.frame.size.height + 5, self.frame.size.width, 24)];
        [_tztTradeView addSubview:_pBackView];
        [_pBackView release];
    }
    else
        _pBackView.frame = CGRectMake(0, fY+pView.frame.size.height + 5, self.frame.size.width, 24);
    _pBackView.backgroundColor = pColor;
    if (_pRadioView == NULL)
    {
        NSArray *ay = [NSArray arrayWithObjects:@"全部|tzt_trade_hold_radio", @"1/2|tzt_trade_hold_radio", @"1/3|tzt_trade_hold_radio",  nil];
        UIImage* imageSel = [UIImage imageTztNamed:@"tzt_trade_hold_radio_sel"];
        _pRadioView = [[tztGroupRadioView alloc] initWithFrame:rcRadio andItems:ay withSelectedIamge:imageSel];
        _pRadioView.tztDelegate = self;
        [_tztTradeView addSubview:_pRadioView];
        [_pRadioView release];
    }
    else
    {
        _pRadioView.frame = rcRadio;
    }
    
    pCellView = [_tztTradeView getCellWithFlag:@"TZTCZ"];
    pCellView.backgroundColor = self.backgroundColor;
    
    pCellView = [_tztTradeView getCellWithFlag:@"TZTZXZL"];
    pCellView.backgroundColor = self.backgroundColor;
    
    pCellView = [_tztTradeView getCellWithFlag:@"TZTZTDT"];
    pCellView.backgroundColor = self.backgroundColor;
    
    for (int i = 1; i < 6; i++)
    {
        NSString* str = [NSString stringWithFormat:@"TZTSALE%d",i];
        pCellView = [_tztTradeView getCellWithFlag:str];
        pCellView.backgroundColor = self.backgroundColor;
    }
}

#pragma mark 外部设置股票代码
-(void)setStockCode:(NSString *)nsCode
{
    if (!_tztTradeView)
        return;
    
    [_tztTradeView setEditorText:nsCode nsPlaceholder_:nil withTag_:kTagCode];
    self.CurStockCode = [NSString stringWithFormat:@"%@", nsCode];
}

#pragma mark 清理界面数据
-(void)ClearData
{
    [_tztTradeView setEditorText:@"" nsPlaceholder_:nil withTag_:kTagCode];
    self.CurStockCode = @"";
    [self ClearDataWithOutCode];
}

-(void)ClearDataWithOutCode
{
    [_tztTradeView setLabelText:@"" withTag_:kTagName];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:nil withTag_:kTagPrice];
    [_tztTradeView setLabelText:@"" withTag_:kTagKYAmount];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:nil withTag_:kTagAmount];
    
    for (int i = kTagPriceNew; i <= kTagBuyAmount5; i++)
    {
        [_tztTradeView setButtonTitle:@""
                              clText_:[UIColor whiteColor]
                            forState_:UIControlStateNormal
                             withTag_:i];
    }
    
    [self.ayAccountInfo removeAllObjects];
}

#pragma mark 界面数据操作处理

/**
 *    @author yinjp
 *
 *    @brief  按钮点击操作
 *
 *    @param sender 对应按钮
 */
-(void)OnButtonClick:(id)sender
{
    if (sender == nil)
        return;
    
    UIButton *pButton = (UIButton*)sender;
    NSInteger nTag = pButton.tag;
    if ([pButton isKindOfClass:[tztUIButton class]])
    {
        nTag = [((tztUIButton*)pButton).tzttagcode intValue];
    }
    
    NSString* nsString = [pButton titleForState:UIControlStateNormal];
    switch (nTag)
    {
        case kTagAmountAdd:
        {
            
        }
            break;
        case kTagAmountDel:
        {
            
        }
            break;
        case kTagPriceAdd:
        {
            
        }
            break;
        case kTagPriceDel:
        {
            
        }
            break;
        case kTagOK:
        {
            [self OnSendBuySellData];
        }
            break;
        case kTagClear:
        {
            [self ClearData];
        }
            break;
        default:
            break;
    }
}

/**
 *    @author yinjp
 *
 *    @brief  下拉框选择事件
 *
 *    @param droplistview 下拉框对象
 *    @param index        选择位置
 */
-(void)tztDroplistView:(tztUIDroplistView*)droplistview didSelectIndex:(NSInteger)index
{
    
}

/**
 *    @author yinjp
 *
 *    @brief  输入框内容改变响应事件
 *
 *    @param tztUIBaseView 对应输入框对象
 *    @param text          改变后的文字内容
 */
-(void)tztUIBaseView:(UIView*)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == nil || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    NSInteger nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagCode:
        {
            //检测代码长度，若达到制定长度，自动进行数据查询
            //若代码长度变更，则清空其余内容显示
            if (self.CurStockCode == nil)
                self.CurStockCode = @"";
            if ([inputField.text length] < 1)
            {
                self.CurStockCode = @"";
                [self ClearData];
            }
            
            if (inputField.text != nil && inputField.text.length == inputField.maxlen)
            {
                if (self.CurStockCode && [self.CurStockCode compare:inputField.text] != NSOrderedSame)
                {
                    self.CurStockCode = [NSString stringWithFormat:@"%@", inputField.text];
                    [self ClearDataWithOutCode];
                }
            }
            else
            {
                self.CurStockCode = @"";
                [self ClearDataWithOutCode];
            }
            
            if (self.CurStockCode.length == inputField.maxlen)
            {
                [self OnRefresh];
            }
        }
            break;
        default:
            break;
    }
}

/**
 *    @author yinjp
 *
 *    @brief  radio选择事件响应
 *
 *    @param sender   GroupRadio对象
 *    @param index    选择的位置索引
 *    @param bChecked 是否选中
 */
-(void)tztGroupRadioView:(id)sender selectAtIndex:(NSUInteger)index forState:(BOOL)bChecked
{
    NSString* nsValue = @"";
    if ([nsValue caseInsensitiveCompare:@"--"] == NSOrderedSame)
    {
        nsValue = nil;
        [_tztTradeView setEditorText:nil nsPlaceholder_:nil withTag_:kTagAmount];
        return;
    }
    
    if (sender == self.pRadioView)
    {
        switch (index)
        {
            case 0://全部
            {
            }
                break;
            case 1://1/2
            {
            }
                break;
            case 2://1/3
            {
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark 请求数据
/**
 *    @author yinjp
 *
 *    @brief  请求证券数据
 */

-(void)OnRefresh
{
    NSInteger nMaxLen = ((TZTUITextField*)[self.tztTradeView viewWithTag:kTagCode]).maxlen;
    if (self.CurStockCode == nil || self.CurStockCode.length < nMaxLen)
        return;
    
    tztJYLoginInfo* jyLoginInfo = [tztJYLoginInfo GetCurJYLoginInfo:TZTAccountGGQQType];
    NSMutableDictionary *dict = NewObject(NSMutableDictionary);
    [dict setTztObject:self.CurStockCode forKey:@"stockcode"];
    if (jyLoginInfo)
    {
        NSString* strFundAccount = jyLoginInfo.nsFundAccount;
        NSString* strUserCode = jyLoginInfo.nsUserCode;
        if (strFundAccount)
            [dict setTztObject:strFundAccount forKey:@"fundcode"];
        if (strUserCode)
            [dict setTztObject:strUserCode forKey:@"UserCode"];
    }
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [dict setTztObject:strReqno forKey:@"Reqno"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"5402" withDictValue:dict];
    DelObject(dict);
}

/**
 *    @author yinjp
 *
 *    @brief  发送委托请求
 */
-(void)OnSendBuySellData
{
    if (_tztTradeView == nil)
        return;
    //合约代码
    NSString* nsCode = [_tztTradeView GetEidtorText:kTagCode];
    //合约名称
    NSString* nsName = [_tztTradeView GetLabelText:kTagName];
    //委托方式
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:kTagType];
    NSString* nsType = [_tztTradeView getComBoxText:kTagType];
    //委托价格
    NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
    //委托数量
    NSString* nsAmount = [_tztTradeView GetEidtorText:kTagAmount];
    //股东账号
    NSString* nsAccount = @"";
    //数据判断
    if (nsCode.length < 1)
    {
        tztAfxMessageBlock(@"请输入合约代码!", nil, nil, TZTBoxTypeButtonOK, ^(NSInteger nIndex){
        });
        return;
    }
    if (nsPrice.length < 1)
    {
        tztAfxMessageBlock(@"请输入委托价格!", nil, nil, TZTBoxTypeButtonOK, ^(NSInteger nIndex){
        });
        return;
    }
    
    if ([nsPrice floatValue] < 0.001)
    {
        tztAfxMessageBlock(@"请输入有效的委托价格!", nil, nil, TZTBoxTypeButtonOK, ^(NSInteger nIndex){
        });
        return;
    }
    
    if ([nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        tztAfxMessageBlock(@"请输入委托数量!", nil, nil, TZTBoxTypeButtonOK, ^(NSInteger nIndex){
            
        });
        return;
    }
    
    NSString* strInfo = @"";
    strInfo = [NSString stringWithFormat:@"委托账号:%@\r\n合约代码:%@\r\n合约名称:%@\r\n委托方式:%@\r\n委托价格:%@\r\n委托数量:%@\r\n\r\n确认进行该委托？",
               nsAccount,nsCode,nsName,nsType,nsPrice,nsAmount];
    
    tztAfxMessageBlock(strInfo, GetTitleByID(_nMsgType), nil, TZTBoxTypeButtonBoth, ^(NSInteger nIndex){
        if (nIndex == 0)
        {
            NSMutableDictionary *pDict = NewObjectAutoD(NSMutableDictionary);
            
            _ntztReqNo++;
            if (_ntztReqNo >= UINT16_MAX)
                _ntztReqNo = 1;
            
            NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
            [pDict setTztValue:strReqno forKey:@"Reqno"];
            
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"" withDictValue:pDict];
        }
    });
    
}

/**
 *    @author yinjp
 *
 *    @brief  定时请求5档数据
 *
 *    @param wParam Ignore
 *    @param lParam Ignore
 *
 *    @return 1
 */
-(NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    return 1;
}
#pragma mark 处理服务器返回数据
-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == nil)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    /*个股期权基础数据查询*/
    if ([pParse GetAction] == 5402)
    {
        
    }
    return 1;
}

//处理5档买卖数据
-(void)DealBuySellData:(tztNewMSParse*)pParse
{
    
}

@end
