
#import "tztCoveredLockView.h"

enum {
    kTagCode = 1000,    //合约代码
    kTagAmount = 1002,  //委托数量
    
    kTagName = 2000,    //合约名称
    kTagKYAmount = 2001,//可用数量
    
    kTagAmountAdd = 4000,//数量＋
    kTagAmountDel = 4001,//数量－
    
    kTagOK = 5000,      //确定
    kTagClear = 5001,   //清空
};

@interface tztCoveredLockView()
{
    NSInteger   _nAccountIndex;
}
@property(nonatomic,retain)tztUIVCBaseView  *tztTradeView;
/**
 *    @author yinjp
 *
 *    @brief  账户信息
 */
@property(nonatomic,retain)NSMutableArray   *ayAccountInfo;

@end

@implementation tztCoveredLockView

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)dealloc
{
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
        _tztTradeView.tableConfig = @"tztUICovereLock";
        _tztTradeView.frame = rcFrame;
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
    {
        _tztTradeView.frame = rcFrame;
    }
    
    tztUIButton *pBtn = (tztUIButton*)[_tztTradeView getViewWithTag:kTagOK];
    [pBtn setTztTitle:GetTitleByID(_nMsgType)];
    
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
    
    pCellView = [_tztTradeView getCellWithFlag:@"TZTCZ"];
    pCellView.backgroundColor = self.backgroundColor;
}

#pragma mark 外部设置股票代码
-(void)setStockCode:(NSString *)nsCode
{
    if (nsCode.length < 1)
        return;
    if (_tztTradeView)
    {
        [_tztTradeView setEditorText:nsCode nsPlaceholder_:nil withTag_:kTagCode];
        self.CurStockCode = [NSString stringWithFormat:@"%@", nsCode];
    }
}

#pragma mark 清理界面数据
-(void)ClearData
{
    [_tztTradeView setEditorText:@"" nsPlaceholder_:nil withTag_:kTagCode];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
}

-(void)ClearDataWithOutCode
{
    [_tztTradeView setLabelText:@"" withTag_:kTagName];
    [_tztTradeView setLabelText:@"" withTag_:kTagKYAmount];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:nil withTag_:kTagAmount];
    [self.ayAccountInfo removeAllObjects];
}

#pragma mark 界面数据操作处理
/**
 *    @author yinjp
 *
 *    @brief  按钮点击操作
 *
 *    @param sender 对应按钮对象
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
 *    @brief  输入框内容改变响应事件
 *
 *    @param tztUIBaseView 输入框对象
 *    @param text          改变后的内容
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
                [self OnInquireStockData];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 请求数据
/**
 *    @author yinjp
 *
 *    @brief  请求证券数据
 */
-(void)OnInquireStockData
{
    
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
    //委托数量
    NSString* nsAmount = [_tztTradeView GetEidtorText:kTagAmount];
    //股东账号
    NSString* nsAccount = @"";
    if (nsCode.length < 1)
    {
        tztAfxMessageBlock(@"请输入合约代码!", nil, nil, TZTBoxTypeButtonOK, ^(NSInteger nIndex){
        });
        return;
    }
    
    if ( (nsAmount.length < 1) || ([nsAmount intValue] < 1))
    {
        tztAfxMessageBlock(@"请输入委托数量!", nil, nil, TZTBoxTypeButtonOK, ^(NSInteger nIndex){
        });
        return;
    }
    
    NSString* strInfo = @"";
    strInfo = [NSString stringWithFormat:@"委托账号:%@\r\n合约代码:%@\r\n合约名称:%@\r\n委托数量:%@\r\n\r\n确认进行该委托?",
               nsAccount, nsCode, nsName, nsAmount];
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


#pragma mark 处理服务器返回数据
-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == nil)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    return 1;
}

-(CGSize)getTableShowSize
{
    return [_tztTradeView getTableShowSize];
}
@end
