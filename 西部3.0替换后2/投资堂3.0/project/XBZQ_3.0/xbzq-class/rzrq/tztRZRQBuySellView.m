/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       xyt
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztRZRQBuySellView.h"
/*tag值，与配置文件中对应*/
enum  {
	kTagCode = 2000,
	kTagPrice , //委托价格
	kTagCount,  //委托数量
	
    kTagNewPrice = 4997,
    kTagNewCount = 4999,
	kTagStockInfo = 5000,
    kTagStockCode = 2220,
    
    kTagOK        = 10000,//确定
    kTagRefresh   = 10001,//刷新
    kTagClear     = 10002,//清空
};


@implementation tztRZRQBuySellView
@synthesize tztTradeView = _tztTradeView;
@synthesize CurStockName = _CurStockName;
@synthesize CurStockCode = _CurStockCode;
@synthesize ayAccount = _ayAccount;
@synthesize ayType = _ayType;
@synthesize ayStockNum = _ayStockNum;
@synthesize ayData = _ayData;
@synthesize bBuyFlag = _bBuyFlag;
@synthesize nsTSInfo = _nsTSInfo;
-(id)init
{
    if (self = [super init])
    {
        _nDotValid = 2;
        _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
        [[tztMoblieStockComm getShareInstance] addObj:self];
    }
    return self;
}

-(void)dealloc
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    DelObject(_ayType);
    DelObject(_ayAccount);
    DelObject(_ayStockNum);
    [super dealloc];
    
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame)) 
        return;
    
    [super setFrame:frame];
    
    CGRect rcFrame = self.bounds;
    
    if(!_pTradeToolBar.hidden)
    {
        rcFrame.size.height -= _pTradeToolBar.frame.size.height;
    }
    
    if (_tztTradeView == NULL)
    {
        _tztTradeView = NewObject(tztUIVCBaseView);
        _tztTradeView.tztDelegate = self;
        switch (_nMsgType) {
            case WT_RZRQBUY:        //普通买入
            case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
                _tztTradeView.tableConfig = @"tztUITradeRZRQBuyStock";
                break;
            case WT_RZRQBUYRETURN:  //买券还券
            case MENU_JY_RZRQ_BuyReturn://买券还券
                _tztTradeView.tableConfig = @"tztUITradeRZRQBuyReturnStock";
                break;
            case WT_RZRQSALE:       //普通卖出
            case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
                _tztTradeView.tableConfig = @"tztUITradeRZRQSaleStock";
                break;
            case WT_RZRQSALERETURN: //卖券还款
            case MENU_JY_RZRQ_SellReturn://卖券还款
                _tztTradeView.tableConfig = @"tztUITradeRZRQSaleReturnStock";
                break;
            case WT_RZRQRZBUY:      //融资买入
            case MENU_JY_RZRQ_XYBuy:// 融资买入
                _tztTradeView.tableConfig = @"tztUITradeRZRQRZBuyStock";
                
                break;
            case WT_RZRQRQSALE:     //融券卖出
            case MENU_JY_RZRQ_XYSell://融券卖出
                _tztTradeView.tableConfig = @"tztUITradeRZRQRQBuyStock";
                break;
            default:
                break;
        }
        
        _tztTradeView.frame = rcFrame;
        [self addSubview:_tztTradeView];
        [_tztTradeView release];
    }
    else
        _tztTradeView.frame = rcFrame;
    
/*
    //根据不同页面,显示有所区别
    switch (_nMsgType) 
    {
        case WT_RZRQBUY:    //普通买入
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
        //case WT_RZRQSALE:   //普通卖出
            [_tztTradeView setLabelText:@"资金" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约买" withTag_:kTagNewCount-1];
            break;
        case WT_RZRQSALE:   //普通卖出
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
            [_tztTradeView setLabelText:@"资金" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约卖" withTag_:kTagNewCount-1];
            break;
        case WT_RZRQRZBUY:  //融资买入
        case MENU_JY_RZRQ_XYBuy:// 融资买入
            [_tztTradeView setLabelText:@"负债" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约买" withTag_:kTagNewCount-1];
            break;
        case WT_RZRQRQSALE: //融券卖出
        case MENU_JY_RZRQ_XYSell://融券卖出
            [_tztTradeView setLabelText:@"负债" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约卖" withTag_:kTagNewCount-1];
            break;
        case WT_RZRQBUYRETURN://卖券还券
        case MENU_JY_RZRQ_BuyReturn://买券还券
            [_tztTradeView setLabelText:@"合约" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约买" withTag_:kTagNewCount-1];
            break;
        case WT_RZRQSALERETURN://买券还款
        case MENU_JY_RZRQ_SellReturn://卖券还款
            [_tztTradeView setLabelText:@"负债" withTag_:kTagNewPrice-1];
            [_tztTradeView setLabelText:@"约卖" withTag_:kTagNewCount-1];
            break;
        default:
            break;
    }
  */
    switch (_nMsgType)
    {
        case WT_RZRQBUY:    //普通买入
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
            [_tztTradeView setButtonTitle:@"资金"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewPrice-1];
            [_tztTradeView setButtonTitle:@"约买"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewCount-1];

                     break;
        case WT_RZRQSALE:   //普通卖出
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
            [_tztTradeView setButtonTitle:@"资金"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewPrice-1];
            [_tztTradeView setButtonTitle:@"约卖"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewCount-1];
            break;
        case WT_RZRQRZBUY:  //融资买入
        case MENU_JY_RZRQ_XYBuy:// 融资买入
            [_tztTradeView setButtonTitle:@"负债"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewPrice-1];
            [_tztTradeView setButtonTitle:@"约买"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewCount-1];
            break;
        case WT_RZRQRQSALE: //融券卖出
        case MENU_JY_RZRQ_XYSell://融券卖出
            [_tztTradeView setButtonTitle:@"负债"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewPrice-1];
            [_tztTradeView setButtonTitle:@"约卖"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewCount-1];

            break;
        case WT_RZRQBUYRETURN://卖券还券
        case MENU_JY_RZRQ_BuyReturn://买券还券
            [_tztTradeView setButtonTitle:@"合约"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewPrice-1];
            [_tztTradeView setButtonTitle:@"约买"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewCount-1];
            break;
        case WT_RZRQSALERETURN://买券还款
        case MENU_JY_RZRQ_SellReturn://卖券还款
            [_tztTradeView setButtonTitle:@"负债"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewPrice-1];
            [_tztTradeView setButtonTitle:@"约卖"
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewCount-1];

            break;
        default:
            break;
    }

    if (IS_TZTIPAD) // 改iPad左边列表翻滚位移过大问题 byDBQ20130827
    {
        _tztTradeView.contentSize = CGSizeMake(rcFrame.size.width, rcFrame.size.height + 50);
    }
    
    UIView* zijinView = [_tztTradeView getCellWithFlag:@"TZTZJYM"];
    [zijinView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView*view = (UIView*)obj;
        if (idx == 1 && [view isKindOfClass:[tztUILabel class]]) {
//            tztUILabel *lb = (tztUILabel*)obj;
//            [lb setLabelBackgroundColor:@"49,49,49" andMyBackGroundImage:@"tzt_zjImage.png"];
        }else if(idx == 2 && [obj isKindOfClass:[tztUILabel class]]){
         //   tztUILabel *lb = (tztUILabel*)obj;
            //[lb setLabelBackgroundColor:@"0,255,0"];
        }else if (idx == 3&& [view isKindOfClass:[tztUILabel class]]){
//            tztUILabel *lb = (tztUILabel*)obj;
//            [lb setLabelBackgroundColor:@"49,49,49" andMyBackGroundImage:@"tzt_zjImage.png"];
//            
        }
        if (idx  == 2 || idx == 4) {
            tztUIButton* btn = (tztUIButton*)obj;
            CGRect rect = btn.frame;
            rect.origin.x-=4;
            btn.frame = rect;
        }

    }];
//    [_tztTradeView setButtonTitle:@""
//                          clText_:[UIColor whiteColor]
//                        forState_:UIControlStateNormal
//                         withTag_:100];
//    


}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
    NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagCode:
		{
			if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
                [self ClearData];
			}
            
            if (inputField.text != NULL && inputField.text.length == 6)
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
			
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
			}
		}
			break;
        case kTagStockCode://可编辑的下拉控件
        {
            if (self.CurStockCode == NULL)
                self.CurStockCode = @"";
			if ([inputField.text length] <= 0 && self.CurStockCode.length > 0)
			{
                self.CurStockCode = @"";
				//清空界面其它数据
                [self ClearData];
			}
            
            if (inputField.text != NULL && inputField.text.length == 6)
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
			if ([self.CurStockCode length] == 6)
			{
				[self OnRefresh];
			}
        }
            break;

		case kTagPrice:
		{
		}
			break;
		case kTagCount:
		{
            if(!_bBuyFlag)
                return;
            if (_tztTradeView)
            {
                NSString* strPrice =  [_tztTradeView GetEidtorText:kTagPrice];
                NSString* nsPrice = [NSString stringWithFormat:strPriceformat, [strPrice floatValue]];
                NSString* strAmount = inputField.text;
                
                NSString* strMoney = @"";
                if ([strAmount intValue] > 0 && [nsPrice floatValue] >= _fMoveStep)
                {
                    strMoney = [NSString stringWithFormat:strMoneyformat, [nsPrice floatValue] * [strAmount intValue]];
                }
//                [_tztTradeView setLabelText:strMoney withTag_:2020];
                TZTNSLog(@"%@",strMoney);
            }
		}
			break;
		default:
			break;
    }
}

-(void)tztUIBaseView:(UIView *)tztUIBaseView focuseChanged:(NSString *)text
{
    if (tztUIBaseView == NULL || ![tztUIBaseView isKindOfClass:[tztUITextField class]])
        return;
    
    NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
    NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
    tztUITextField* inputField = (tztUITextField*)tztUIBaseView;
    int nTag = [inputField.tzttagcode intValue];
    switch (nTag)
    {
        case kTagPrice:
        {
            if(_nMsgType == WT_RZRQSALE || _nMsgType == WT_RZRQSALERETURN ||_nMsgType == MENU_JY_RZRQ_PTSell ||_nMsgType == MENU_JY_RZRQ_SellReturn)
                return;
            NSString* strPrice = [NSString stringWithFormat:strPriceformat, [inputField.text floatValue]];
            if (_tztTradeView)
            {
                NSString* strAmount = [_tztTradeView GetEidtorText:kTagCount];
                NSString* strMoney = @"";
                if ([strAmount intValue] > 0 && [strPrice floatValue] >= _fMoveStep)
                {
                    strMoney = [NSString stringWithFormat:strMoneyformat, [strPrice floatValue] * [strAmount intValue]];
                    TZTNSLog(@"%@",strMoney);
                }
                if(strPrice && [strPrice length] > 0 && [strPrice floatValue] >= _fMoveStep)
                {
                    [self OnRefresh];

                }
                else
                {
                    [_tztTradeView setButtonTitle:@"" clText_:[UIColor redColor] forState_:UIControlStateNormal withTag_:kTagStockInfo+1];
                }
            }
        }
            break;
        default:
            break;
    }
}

-(void)setStockCode:(NSString*)nsCode
{
    if (nsCode == NULL || [nsCode length] < 6)
        return;
    self.CurStockCode = [NSString stringWithFormat:@"%@",nsCode];
    if (_tztTradeView)
    {
        [_tztTradeView setEditorText:nsCode nsPlaceholder_:NULL withTag_:2000];
        [_tztTradeView setComBoxText:nsCode withTag_:kTagStockCode];
    }
}

-(void)ClearDataWithOutCode
{
//    [_tztTradeView setComBoxText:@"" withTag_:kTagStockCode];
    [_tztTradeView setComBoxData:NULL ayContent_:NULL AndIndex_:-1 withTag_:1000];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2001];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2002];
    [_tztTradeView setComBoxText:@"" withTag_:2020];
    //清空可编辑的droplist控件数据
//    [_tztTradeView setComBoxTextField:kTagStockCode];
    
    [_tztTradeView setLabelText:@"" withTag_:3000];
    
    //
   // [_tztTradeView setLabelText:@"" withTag_:kTagNewPrice];
    [_tztTradeView setButtonTitle:@""
                          clText_:[UIColor whiteColor]
                        forState_:UIControlStateNormal
                         withTag_:kTagNewPrice];
    
    [_tztTradeView setButtonTitle:@""
                          clText_:[UIColor whiteColor]
                        forState_:UIControlStateNormal
                         withTag_:kTagNewCount];
    for (int i = 5000; i <= 5026; i++)
    {
        [_tztTradeView setButtonTitle:@""
                              clText_:[UIColor whiteColor]
                            forState_:UIControlStateNormal
                             withTag_:i];
    }
}

//清空界面数据
-(void) ClearData
{
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:2000];
    [_tztTradeView setComBoxText:@"" withTag_:kTagStockCode];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagStockCode];
    [_tztTradeView setEditorText:@"" nsPlaceholder_:NULL withTag_:kTagCode];
    [self ClearDataWithOutCode];
    self.CurStockCode = @"";
}

-(void)OnInquireFund
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    //[pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"0" forKey:@"StartPos"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    switch (_nMsgType) 
    {
        case WT_RZRQBUY:    //普通买入  担保买入
        case WT_RZRQSALE:
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"402" withDictValue:pDict];
            break;
//        case WT_RZRQSALE:   //普通卖出 担保卖出
//            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"403" withDictValue:pDict];
//            break;
        case WT_RZRQRZBUY:  //融资买入
        case MENU_JY_RZRQ_XYBuy:// 融资买入
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"406" withDictValue:pDict];
            break;
        case WT_RZRQRQSALE: //融券卖出
        case MENU_JY_RZRQ_XYSell://融券卖出
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"406" withDictValue:pDict];
            break;
        case WT_RZRQBUYRETURN://买券还券
        case MENU_JY_RZRQ_BuyReturn://买券还券

            [pDict setObject:@"1" forKey:@"tokentype"];
            _isShowDropList = NO;
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"OnInquireFund" withDictValue:pDict];
            break;
        case WT_RZRQSALERETURN://买券还款
        case MENU_JY_RZRQ_SellReturn://卖券还款
            [[tztMoblieStockComm getShareInstance] onSendDataAction:@"406" withDictValue:pDict];
            break;
        default:
            break;
    }
    DelObject(pDict);
}

//请求股票信息
-(void)OnRefresh
{
    if (self.CurStockCode == nil || [self.CurStockCode length] < 6)
        return;
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:self.CurStockCode forKey:@"StockCode"];
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    [pDict setTztValue:@"1" forKey:@"StartPos"];
    [pDict setTztValue:@"1" forKey:@"NeedCheck"];
    [pDict setTztValue:@"100" forKey:@"Maxcount"];
    
    if(_tztTradeView)
    {
        NSString* strPrice =  [_tztTradeView GetEidtorText:kTagPrice];
        if(strPrice && [strPrice length] > 0 && [strPrice floatValue] > 0)
        {
            [pDict setTztValue:strPrice forKey:@"PRICE"];
        }
    }
    
    _ntztReqNo++;
    if (_ntztReqNo > UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqNo = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqNo forKey:@"Reqno"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    switch (_nMsgType) 
    {
        case WT_RZRQBUY:
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）
            [pDict setTztValue:@"1" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQSALE:
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
            [pDict setTztValue:@"2" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQRZBUY:
        case MENU_JY_RZRQ_XYBuy:// 融资买入
            [pDict setTztValue:@"3" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQRQSALE:
        case MENU_JY_RZRQ_XYSell://融券卖出
            [pDict setTztValue:@"4" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQBUYRETURN:
        case MENU_JY_RZRQ_BuyReturn://买券还券
            [pDict setTztValue:@"5" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQSALERETURN:
        case MENU_JY_RZRQ_SellReturn://卖券还款
            [pDict setTztValue:@"6" forKey:@"CREDITTYPE"];
            break;
        default:
            break;
    }
    
    NSString *strAction = @"";
    if (_bBuyFlag)
    {
        strAction = @"428";
        [pDict setTztValue:@"B" forKey:@"Direction"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    }
    else
    {
        strAction = @"429";
        [pDict setTztValue:@"S" forKey:@"Direction"];
        [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    }
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
  
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo]) 
        return 0;
    
    int nErrNo = [pParse GetErrorNo];
    NSString* strError = [pParse GetErrorMessage];

    if ([tztBaseTradeView IsExitError:nErrNo])
    {
        [self OnNeedLoginOut];
        if (strError)
            tztAfxMessageBox(strError);
        return 0;
    }
    
    if (nErrNo < 0)
    {
        if(strError)
        {
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        }
        return 0;
    }
    
    if ([pParse IsAction:@"400"] || [pParse IsAction:@"422"])
    {
        if (strError && [strError length] > 0)
            [self showMessageBox:strError nType_:TZTBoxTypeNoButton nTag_:0];
        
        //清理界面数据
        [self ClearData];
        return 0;
    }
    
    if ([pParse IsAction:@"402"])
    {
        int nUsableIndex = -1;      //可用余额
        
        NSString *strIndex = [pParse GetByName:@"UsableIndex"];
        TZTStringToIndex(strIndex, nUsableIndex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                if (nUsableIndex >= 0 && [ayData count] > nUsableIndex) 
                {
                    NSString *str = [ayData objectAtIndex:nUsableIndex];
                    if (str != NULL) 
                    {
                        NSString* nsValue = tztdecimalNumberByDividingBy(str, 2);
                      //  [_tztTradeView setLabelText:nsValue withTag_:kTagNewPrice];
                        [_tztTradeView setButtonTitle:nsValue
                                              clText_:[UIColor redColor]
                                            forState_:UIControlStateNormal
                                             withTag_:kTagNewPrice];

                    }
                }
                
            }
        }
    }
    
    if ([pParse IsAction:@"403"] || [pParse IsAction:@"416"] || [pParse IsAction:@"415"] || ([pParse IsAction:@"408"]&& _isShowDropList==NO) )
    {
        //isDebt用来查询买券还券代码
        if (_nMsgType == WT_RZRQBUYRETURN || _nMsgType == MENU_JY_RZRQ_BuyReturn)
        {
            _isShowDropList= YES;
        }
        
        int nStockName = -1;
        int nStockCodeIndex = -1;
        
        NSString *strIndex = [pParse GetByName:@"StockName"];
        TZTStringToIndex(strIndex, nStockName);
        if (nStockName < 0)
        {
            //STOCKCODEINDEX
            strIndex = [pParse GetByName:@"StockNameIndex"];
            TZTStringToIndex(strIndex, nStockName);
        }
        
        strIndex = [pParse GetByName:@"StockCodeIndex"];
        TZTStringToIndex(strIndex, nStockCodeIndex);
        if (nStockCodeIndex < 0)
        {
            strIndex = [pParse GetByName:@"StockIndex"];
            TZTStringToIndex(strIndex, nStockCodeIndex);
        }
        
        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        if (nStockName < 0){
//wry
            tztAfxMessageBox(@"查无可用证券代码");
                                    return 0;
        }

//        NSArray *pGridAy = [pParse GetArrayByName:@"Grid"];
        
        if (_ayData == NULL)
            _ayData = NewObject(NSMutableArray);
        [_ayData removeAllObjects];
        
        NSMutableArray *pAyTitle = NewObject(NSMutableArray);
        NSString* strCode = @"";
        NSString* strName = @"";
        for (int i = 1; i < [pGridAy count]; i++)
        {
            NSArray* pAy = [pGridAy objectAtIndex:i];
//wry 这种判断似乎不太对 但是安卓却要这样
            if (pAy.count < 3) {
                [pAy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSString* deal = obj;
                    if ([deal rangeOfString:@"处理成功"].length>0 || [deal rangeOfString:@"查无记录"].length>0) {
                        tztAfxMessageBox(@"查无可用证券代码");
                    }
                }];
                return  nil;
            }
            
            if(nStockCodeIndex >= 0 && nStockCodeIndex < [pAy count])
                strCode = [pAy objectAtIndex:nStockCodeIndex];
            if (strCode == NULL || [strCode length] <= 0)
                continue;
            
            NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
            [pDict setTztObject:strCode forKey:@""];
            
            if (nStockName >= 0 && nStockName < [pAy count])
                strName = [pAy objectAtIndex:nStockName];
            if (strName == NULL)
                strName = @"";
            [pDict setTztObject:strName forKey:@""];
            
            [_ayData addObject:pDict];
            NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", strCode, strName];
            [pAyTitle addObject:strTitle];
            DelObject(pDict);
        }
        if (([pParse IsAction:@"408"])) {
            [_tztTradeView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTagCode bDrop_:YES];
        }else if (_tztTradeView && [pAyTitle count] > 0)
        {
            //获取当前界面输入
            NSString* nsName = [_tztTradeView GetLabelText:3000];
            NSString* nsCode = [_tztTradeView getComBoxText:kTagCode];
            if (nsCode == NULL)
                nsCode = [_tztTradeView getComBoxText:kTagStockCode];
            if (nsName && nsCode && [nsCode length] == 6)
            {
//                NSString* nsDefault = [NSString stringWithFormat:@"%@(%@)", nsCode, nsName];
                [_tztTradeView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:_nCurrentSel withTag_:kTagStockCode bDrop_:YES];
                [_tztTradeView setComBoxText:nsCode withTag_:kTagStockCode];
            }
            else
            {

                [_tztTradeView setComBoxData:pAyTitle ayContent_:pAyTitle AndIndex_:-1 withTag_:kTagStockCode bDrop_:YES];
                //清空combox显示内容
                [_tztTradeView setComBoxText:@"" withTag_:kTagStockCode];
                [_tztTradeView setComBoxTextField:kTagStockCode];
            }
        }
    }

    
    if ([pParse IsAction:@"406"]) 
    {
        int nFzzjeindex = -1;//负债总金额
        
        NSString *strIndex = [pParse GetByName:@"fzzjeindex"];
        TZTStringToIndex(strIndex, nFzzjeindex);
        
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                if (nFzzjeindex >= 0 && [ayData count] > nFzzjeindex) 
                {
                    NSString *str = tztdecimalNumberByDividingBy([ayData objectAtIndex:nFzzjeindex], 2);
                    if (str != NULL && [str length]>0) 
                    {
//                        [_tztTradeView setLabelText:str withTag_:kTagNewPrice];
                        [_tztTradeView setButtonTitle:str
                                              clText_:[UIColor redColor]
                                            forState_:UIControlStateNormal
                                             withTag_:kTagNewPrice];
                    }
                    else
                    {
//                        [_tztTradeView setLabelText:@"0" withTag_:kTagNewPrice];
                        [_tztTradeView setButtonTitle:@"---"
                                              clText_:[UIColor blackColor]
                                            forState_:UIControlStateNormal
                                             withTag_:kTagNewPrice];
                    }
                }
            }
        }
    }
 
  
    
    if ([pParse IsAction:@"408"]&& _isShowDropList)
    {
        int nDebitamountindex = -1;//合约数量
        int nStockIndex = -1;
        int nStockNameIndex = -1;
        
        if (_ayAccountData==nil)
            _ayAccountData = NewObject(NSMutableArray);
        [_ayAccountData removeAllObjects];
        
        if (_priceData==nil) {
            _priceData = NewObject(NSMutableArray);
        }
        [_priceData removeAllObjects];
        
        NSString *strIndex = [pParse GetByName:@"CURRDEBITAMOUNTINDEX"]; //CURRDEBITAMOUNTINDEX
        //DebitaMountIndex
        TZTStringToIndex(strIndex, nDebitamountindex);
        
        strIndex = [pParse GetByName:@"stockindex"];
        TZTStringToIndex(strIndex, nStockIndex);

        strIndex = [pParse GetByName:@"stocknameindex"];
        TZTStringToIndex(strIndex, nStockNameIndex);
        
        int nMin = MIN(nDebitamountindex, nStockIndex);
        int nMax = MAX(nDebitamountindex, nStockIndex);
        if (nMin < 0)
        {
//            [_tztTradeView setLabelText:@"0" withTag_:kTagNewPrice];
            [_tztTradeView setButtonTitle:@"--"
                                  clText_:[UIColor blackColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewPrice];
            return 0;
        }
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
//        NSString* curStockCode = [_tztTradeView GetEidtorText:kTagCode];

       // BOOL bFind = FALSE;
        if (ayGrid)
        {
            for (int i = 1; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < nMax)
                    continue;
                
                NSString* nsCode = [ayData objectAtIndex:nStockIndex];
                if (nsCode == NULL || nsCode.length <= 0)
                    continue;
                NSString* nsCodeName = [ayData objectAtIndex:nStockNameIndex];
                if (nsCodeName == NULL || nsCodeName.length <= 0)
                    nsCodeName =@"";
            
                
                NSString* strTitle = [NSString stringWithFormat:@"%@(%@)", nsCode, nsCodeName];
                [_ayAccountData addObject:strTitle];
                
                
                NSString* str = [ayData objectAtIndex:nDebitamountindex];
                if ((str.length ==0 && [str intValue]<=0 )|| [str isEqualToString:@""]) {
                    str =@"0";
                }
                if ([str intValue] <=0) {
                    str =@"0";
                }
                [_priceData addObject:str];
//                if ([nsCode caseInsensitiveCompare:self.CurStockCode] == NSOrderedSame)
//                {
//                   
//                    if (str && str.length > 0)
//                    {
//                        [_priceData addObject:str];
//                    //    [_tztTradeView setLabelText:str withTag_:kTagNewPrice];
//                        bFind = TRUE;
//                    }
//                    break;
//                }
            }
        }
        if(_ayAccountData && _ayAccountData.count>0) {
           
                [_tztTradeView setComBoxData:_ayAccountData ayContent_:_ayAccountData AndIndex_:-1 withTag_:kTagCode bDrop_:YES];
                //清空combox显示内容
                [_tztTradeView setComBoxText:@"" withTag_:kTagCode];
                [_tztTradeView setComBoxTextField:kTagCode];
    
           
          }
    
//        if (!bFind)
//        {
//            [_tztTradeView setLabelText:@"0" withTag_:kTagNewPrice];
//        }
    }

    
    if ([pParse IsAction:@"150"] || [pParse IsAction:@"151"] 
        || [pParse IsAction:@"428"] || [pParse IsAction:@"429"])
    {   
        NSString* strCode = [pParse GetByName:@"StockCode"];
        if (strCode == NULL || [strCode length] <= 0)//错误
            return 0;
        //返回的跟当前的代码不一致
        if ([strCode compare:self.CurStockCode] != NSOrderedSame)
        {
            return 0;
        }
        
        //股票名称
        NSString* strName = [pParse GetByNameUnicode:@"Title"];
        if (strName && [strName length] > 0)
        {
            self.CurStockName = [NSString stringWithFormat:@"%@",strName];
            if (_tztTradeView)
            {
                [_tztTradeView setLabelText:strName withTag_:3000];
                //                [_tztTradeView setEditorText:self.CurStockCode nsPlaceholder_:NULL withTag_:2000];
            }
        }
        else
        {
            //[self showMessageBox:@"该证券代码不存在!" nType_:TZTBoxTypeNoButton nTag_:0];
            return 0;
        }
        
        //退市整理判断
        NSString* strTSFlag = [pParse GetByName:@"CommBatchEntrustInfo"]; 
        if (strTSFlag && [strTSFlag length] > 0)
            _nLeadTSFlag = [strTSFlag intValue];
        else
            _nLeadTSFlag = 1;
        
        NSString* strTSInfo = [pParse GetByName:@"BankMoney"];
        if (strTSInfo)
        {
            self.nsTSInfo = [NSString stringWithFormat:@"%@", strTSInfo];
        }
        else
            self.nsTSInfo = @"";
        //
        
        if (_ayAccount == nil)
            _ayAccount = NewObject(NSMutableArray);
        if (_ayType == nil)
            _ayType = NewObject(NSMutableArray);
        if (_ayStockNum == nil)
            _ayStockNum = NewObject(NSMutableArray);
        
        [_ayAccount removeAllObjects];
        [_ayType removeAllObjects];
        [_ayStockNum removeAllObjects];
        
        //股东账号及可卖可买
        NSArray *ayGrid = [pParse GetArrayByName:@"Grid"];
        if (ayGrid)
        {
            for (int i = 0; i < [ayGrid count]; i++)
            {
                NSArray *ayData = [ayGrid objectAtIndex:i];
                if (ayData == NULL || [ayData count] < 3)
                    continue;
                
                NSString* strAccount = [ayData objectAtIndex:0];
                if (strAccount == NULL || [strAccount length] <= 0)
                    continue;
                
                [_ayAccount addObject:strAccount];
                
                NSString* strType = [ayData objectAtIndex:1];
                if (strType == NULL || [strType length] <= 0)
                    strType = @"";
                
                [_ayType addObject:strType];
                
                NSString* strNum = [ayData objectAtIndex:2];
                if (strNum == NULL || [strNum length] <= 0)
                    strNum = @"";
                
                [_ayStockNum addObject:strNum];
            }
        }
        
        [_tztTradeView setComBoxData:_ayAccount ayContent_:_ayType AndIndex_:0 withTag_:1000];
        
        //可买、可卖显示
        NSString* nsValue = @"";
        if ([_ayStockNum count] > 0)
        {
            nsValue = tztdecimalNumberByDividingBy([_ayStockNum objectAtIndex:0], 2);
        }
        
        UIColor * color = [UIColor whiteColor];
        if (!g_nJYBackBlackColor)
            color = [UIColor blackColor];
        
        [_tztTradeView setButtonTitle:nsValue
                              clText_:color
                            forState_:UIControlStateNormal
                             withTag_:kTagNewCount];   
        
        //有效小数位
        NSString *nsDot = [pParse GetByName:@"Volume"];
        _nDotValid = [nsDot intValue];
        _fMoveStep = 1.0f/pow(10.0f, _nDotValid);
        
        [_tztTradeView setEditorDotValue:_nDotValid withTag_:kTagPrice];
        
        //可用资金
        NSString* nsMoney = [pParse GetByName:@"BankVolume"];
        if (nsMoney == NULL || [nsMoney length] < 1)
            nsMoney = @"";
        TZTNSLog(@"%@",nsMoney);
//        NSString* nsMoneyValue = tztdecimalNumberByDividingBy(nsMoney, 2);
//        [_tztTradeView setButtonTitle:nsMoneyValue
//                              clText_:[UIColor magentaColor]
//                            forState_:UIControlStateNormal
//                             withTag_:kTagStockInfo];
        
        nsMoney = [pParse GetByName:@"BankLsh"];
        TZTNSLog(@"%@",nsMoney);
        //买卖5档数据
        float dPClose = 0.0f;
        NSString *nsBuySell = [pParse GetByName:@"buysell"];
        if (nsBuySell && [nsBuySell length] > 0)
        {
            NSArray* ayGridRow = [nsBuySell componentsSeparatedByString:@"|"];
            //昨收
            if([ayGridRow count] > 5)
            {
                dPClose = [[ayGridRow objectAtIndex:5] floatValue];
            }
            
            for (int i = 0; i < [ayGridRow count]; i++)
            {
                NSString* nsValue = [ayGridRow objectAtIndex:i];
                
                UIColor* txtColor = ( ( dPClose == 0.0) || ([nsValue floatValue] == 0.0) ||([nsValue floatValue] == dPClose)) ? [UIColor colorWithRed:204.0/255 green:204.0/255 blue:204.0/255 alpha:1] :
                ( ([nsValue floatValue] > dPClose) ? [UIColor redColor] : [UIColor  colorWithRed:0.0 green:136.0/255.0 blue:26.0/255.0 alpha:1.0] );
                int nTag = 0;
                switch (i)
                {
                    case 0://现手
                    {
                        nTag = kTagStockInfo+1;
                        if (!g_nJYBackBlackColor)
                            txtColor = [UIColor blackColor];
                        else
                            txtColor = [UIColor whiteColor];
                    }
                        break;
                    case 1://买一
                    {
                        nTag = 5004;
                    }
                        break;
                    case 2://买一量
                    {
                        nTag = 5017;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 3://卖一
                    {
                        nTag = 5009;
                    }
                        break;
                    case 4://卖一量
                    {
                        nTag = 5022;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 5://昨收
                        break;
                    case 6://涨停
                    {
                        nTag = 5002;
                    }
                        break;
                    case 7://跌停
                    {
                        nTag = 5003;
                    }
                        break;
                    case 8://买二
                    {
                        nTag = 5005;
                    }
                        break;
                    case 9://买二量
                    {
                        nTag = 5018;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 10://买三
                    {
                        nTag = 5006;
                    }
                        break;
                    case 11://买三量
                    {
                        nTag = 5019;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 12://买四
                    {
                        nTag = 5007;
                    }
                        break;
                    case 13://买四量
                    {
                        nTag = 5020;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 14://买五
                    {
                        nTag = 5008;
                    }
                        break;
                    case 15://买五量
                    {
                        nTag = 5021;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 16://卖二
                    {
                        nTag = 5010;
                    }
                        break;
                    case 17://卖二量
                    {
                        nTag = 5023;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 18://卖三
                    {
                        nTag = 5011;
                    }
                        break;
                    case 19://卖三量
                    {
                        nTag = 5024;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 20://卖四
                    {
                        nTag = 5012;
                    }
                        break;
                    case 21://卖四量
                    {
                        nTag = 5025;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    case 22://卖五
                    {
                        nTag = 5013;
                    }
                        break;
                    case 23://卖五量
                    {
                        nTag = 5026;
                        nsValue = tztdecimalNumberByDividingBy(nsValue, 2);
                        txtColor = [UIColor orangeColor];
                    }
                        break;
                    default:
                        break;
                }
                
                [_tztTradeView setButtonTitle:nsValue
                                      clText_:txtColor
                                    forState_:UIControlStateNormal
                                     withTag_:nTag];
            }
        }
        
        //当前价格
        NSString* nsPrice = [pParse GetByName:@"Price"];
        if (nsPrice == NULL || nsPrice.length < 1)
            nsPrice = @"-";
        
        [_tztTradeView setButtonTitle:nsPrice clText_:[UIColor redColor] forState_:UIControlStateNormal withTag_:kTagStockInfo];
        
        nsPrice = [pParse GetByName:@"ContactID"];
        if (nsPrice && _tztTradeView)
        {
            NSString* nsNowPrice = [_tztTradeView GetEidtorText:2001];
            if (nsNowPrice == nil || [nsNowPrice length] <= 0 || [nsNowPrice floatValue] < _fMoveStep) //没有输入价格
            {
                UIView* pEditor = [_tztTradeView getViewWithTag:2001];
                if (pEditor != NULL && [pEditor isKindOfClass:[tztUITextField class]])
                {
                    [(tztUITextField*)pEditor setText:nsPrice];
                }
            }
        }
        
//     if (_nMsgType != WT_RZRQSALE) 
        {
         
             //_isShowDropList = YES;
        }
        //买券环圈

        if (!(_nMsgType == WT_RZRQBUYRETURN || _nMsgType == MENU_JY_RZRQ_BuyReturn))
        {
            [self OnInquireFund];
        }else{
            [self  OnSendRequestData];
        }
        
        if ( (!_priceData.count ==0) && _priceData.count>=_nCurrentSel) {
       // [_tztTradeView setLabelText:_priceData[_nCurrentSel] withTag_:kTagNewPrice];
            [_tztTradeView setButtonTitle:_priceData[_nCurrentSel]
                                  clText_:[UIColor whiteColor]
                                forState_:UIControlStateNormal
                                 withTag_:kTagNewPrice];
        }

    }
    return 1;
}

-(BOOL)CheckInput
{
    if (_tztTradeView == NULL || ![_tztTradeView CheckInput])
        return FALSE;
    
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
    
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return FALSE;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    //股票代码
    NSString* nsCode = @"";
    if (_nMsgType == WT_RZRQSALE || _nMsgType == WT_RZRQRQSALE || _nMsgType == WT_RZRQRZBUY
        || _nMsgType == WT_RZRQSALERETURN 
        ||_nMsgType == MENU_JY_RZRQ_PTSell || _nMsgType == MENU_JY_RZRQ_XYSell ||_nMsgType == MENU_JY_RZRQ_XYBuy||_nMsgType == MENU_JY_RZRQ_SellReturn || _nMsgType == MENU_JY_RZRQ_BuyReturn)
    {
        nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    }
    else
    {

        nsCode =[_tztTradeView GetEidtorText:kTagCode];
    }
    
    if (nsCode == NULL || [nsCode length] < 1)
        return FALSE;
    
    //委托价格
    NSString* nsPrice = [_tztTradeView GetEidtorText:2001];
    if (nsPrice == NULL || [nsPrice length] < 1 || [nsPrice floatValue] < 0.01f)
    {
        [self showMessageBox:@"委托价格输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //委托数量
    NSString* nsAmount = [_tztTradeView GetEidtorText:2002];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] < 1)
    {
        [self showMessageBox:@"委托数量输入有误!" nType_:TZTBoxTypeNoButton nTag_:0];
        return FALSE;
    }
    
    //股票名称
    NSString* nsName = [_tztTradeView GetLabelText:3000];
    if (nsName == NULL)
        nsName = @"";
    
    NSString* strInfo = @"";
    
    strInfo = [NSString stringWithFormat:@"委托账号: %@\r\n证券代码: %@\r\n证券名称: %@\r\n委托价格: %@\r\n委托数量: %@\r\n\r\n确认%@该证券？", nsAccount, nsCode, nsName, nsPrice, nsAmount, (_bBuyFlag?@"买入":@"卖出")];
    
    if (_nLeadTSFlag == 0)
    {
        if (self.nsTSInfo)
        {
            strInfo = [NSString stringWithFormat:@"%@\r\n%@", strInfo, self.nsTSInfo];
        }
    }
    
    NSString* nsTitle = @"系统提示";
    switch (_nMsgType)
    {
        case WT_RZRQRZBUY:
        case MENU_JY_RZRQ_XYBuy:// 融资买入
            nsTitle = @"融资买入";
            break;
        case WT_RZRQRQSALE:
        case MENU_JY_RZRQ_XYSell://融券卖出
            nsTitle = @"融券卖出";
            break;
            
        default:
            break;
    }
    [self showMessageBox:strInfo
                  nType_:TZTBoxTypeButtonBoth
                   nTag_:0x1111
               delegate_:self
              withTitle_:nsTitle
                   nsOK_:(_bBuyFlag?@"买入":@"卖出")
               nsCancel_:@"取消"];
    return TRUE;
}

-(void)goBuySell
{
    if (_nLeadTSFlag == -1)
    {
        if (self.nsTSInfo && [self.nsTSInfo length] > 0)
        {
            [self showMessageBox:self.nsTSInfo
                          nType_:TZTBoxTypeNoButton
                           nTag_:0
                       delegate_:nil
                      withTitle_:@"退市提醒"];
        }
        return;
    }
    else
        [self CheckInput];
}

//买卖确认
-(void)OnSendBuySell
{
    if (_tztTradeView == nil)
        return;
    //股东账户
    NSInteger nIndex = [_tztTradeView getComBoxSelctedIndex:1000];
    if (nIndex < 0 || nIndex >= [_ayAccount count] || nIndex >= [_ayType count])
        return;
    
    NSString* nsAccount = [_ayAccount objectAtIndex:nIndex];
    NSString* nsAccountType = [_ayType objectAtIndex:nIndex];
    //股票代码
    NSString* nsCode = @"";
    if (_nMsgType == WT_RZRQSALE || _nMsgType == WT_RZRQRQSALE || _nMsgType == WT_RZRQRZBUY
        || _nMsgType == WT_RZRQSALERETURN ||_nMsgType == MENU_JY_RZRQ_PTSell || _nMsgType == MENU_JY_RZRQ_XYSell ||_nMsgType == MENU_JY_RZRQ_XYBuy||_nMsgType == MENU_JY_RZRQ_SellReturn || _nMsgType == MENU_JY_RZRQ_BuyReturn )
    {
        nsCode = [NSString stringWithFormat:@"%@",self.CurStockCode];
    }
    else
    {
        nsCode = [_tztTradeView GetEidtorText:kTagCode];
    }
    if (nsCode == NULL || [nsCode length] < 1)
        return;
    
    //委托加个
    NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
    if (nsPrice == NULL || [nsPrice length] < 1 || [nsPrice floatValue] <= _fMoveStep)
    {
        [self showMessageBox:@"委托价格输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSString* nsAmount = [_tztTradeView GetEidtorText:kTagCount];
    if (nsAmount == NULL || [nsAmount length] < 1 || [nsAmount intValue] <= 0) 
    {
        [self showMessageBox:@"委托数量输入有误！" nType_:TZTBoxTypeNoButton nTag_:0];
        return;
    }
    
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString *strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsAccount forKey:@"WTAccount"];
    [pDict setTztValue:nsAccountType forKey:@"WTAccountType"];
    [pDict setTztValue:nsPrice forKey:@"Price"];
    [pDict setTztValue:nsAmount forKey:@"Volume"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    switch (_nMsgType) 
    {
        case WT_RZRQBUY:
        case MENU_JY_RZRQ_PTBuy://普通买入（信用买入）:
            [pDict setTztValue:@"1" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQSALE:
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
            [pDict setTztValue:@"2" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQRZBUY:
        case MENU_JY_RZRQ_XYBuy:// 融资买入
            [pDict setTztValue:@"3" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQRQSALE:
        case MENU_JY_RZRQ_XYSell://融券卖出
            [pDict setTztValue:@"4" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQBUYRETURN:
        case MENU_JY_RZRQ_BuyReturn://买券还券
            [pDict setTztValue:@"5" forKey:@"CREDITTYPE"];
            break;
        case WT_RZRQSALERETURN:
        case MENU_JY_RZRQ_SellReturn://卖券还款
            [pDict setTztValue:@"6" forKey:@"CREDITTYPE"];
            break;
        default:
            break;
    }
    
    if (_bBuyFlag)
    {
        [pDict setTztValue:@"B" forKey:@"Direction"];
    }
    else
        [pDict setTztValue:@"S" forKey:@"Direction"];
    
    [pDict setTztValue:@"1" forKey:@"CommBatchEntrustInfo"];
    
    if (_nMsgType == WT_RZRQFUNDRETURN || _nMsgType == MENU_JY_RZRQ_ReturnFunds) //直接还券确定
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"422" withDictValue:pDict];
    }
    else
    {
        [[tztMoblieStockComm getShareInstance] onSendDataAction:@"400" withDictValue:pDict];
    }
    DelObject(pDict);
}

//工具栏点击事件
-(BOOL)OnToolbarMenuClick:(id)sender
{
    UIButton* pBtn = (UIButton*)sender;
    if (pBtn == NULL)
        return FALSE;
    
    switch (pBtn.tag)
    {
        case TZTToolbar_Fuction_OK:
        {
            if (_tztTradeView)
            {
                if ([_tztTradeView CheckInput])
                {
                    [self goBuySell];
                    return TRUE;
                }
            }
        }
            break;
        case TZTToolbar_Fuction_Clear:
        {
            [self ClearData];
            return TRUE;
        }
            break;
        case TZTToolbar_Fuction_Refresh:
        {
            [self OnRefresh];
            return TRUE;
        }
            break;
        default:
            break;
    }
    return FALSE;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (alertView.tag)
        {
            case 0x1111:
            {
                [self OnSendBuySell];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)TZTUIMessageBox:(TZTUIMessageBox *)TZTUIMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        switch (TZTUIMessageBox.tag)
        {
            case 0x1111:
            {
                [self OnSendBuySell];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)OnButtonClick:(id)sender
{
    [self OnButton:sender];
}

-(void)OnButton:(id)sender
{
    if (sender == NULL)
        return;
    
	UIButton * pButton = (UIButton*)sender;
	NSInteger nTag = pButton.tag;
    if ([pButton isKindOfClass:[tztUIButton class]])
    {
        nTag = [((tztUIButton*)pButton).tzttagcode intValue];
    }
    
    NSString* nsString = [pButton titleForState:UIControlStateNormal];
    
    if (nTag == kTagOK)
    {
        if (_tztTradeView)
        {
            if ([_tztTradeView CheckInput])
            {
                [self goBuySell];
                return;
            }
        }
    }
    if (nTag == kTagRefresh)
    {
        [self OnRefresh];
    }
    if (nTag == kTagClear)
    {
        [self ClearData];
    }
    if (nTag == kTagNewCount)//约卖，约买数量点击
    {
        if (_tztTradeView)
        {
            if (_ayStockNum && [_ayStockNum count] > 0 )
                nsString = [_ayStockNum objectAtIndex:0];
            [_tztTradeView setEditorText:nsString nsPlaceholder_:NULL withTag_:2002];
        }
    }
    else if((nTag == 5000) || (nTag >= 5002 && nTag <= 5013))
    {
        //价格点击
        //价格输入框，填充数据
        [_tztTradeView setEditorText:nsString nsPlaceholder_:NULL withTag_:2001];
        if (!_bBuyFlag)
            return;
        [self OnRefresh];
    }
    else if(nTag >= 5014 && nTag <= 5023)
    {
        //量点击
    }
    else if(nTag == 8001 || nTag == 8000)//价格增加
    {
        NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
        //获取当前价格
        NSString* nsPrice = [_tztTradeView GetEidtorText:kTagPrice];
        
        float fPrice = [nsPrice floatValue];
        if (nTag == 8001)
            fPrice += _fMoveStep;
        else if(nTag == 8000)
            fPrice -= _fMoveStep;
        if (fPrice < _fMoveStep)
            fPrice = 0.0;
        
        nsPrice = [NSString stringWithFormat:strPriceformat, fPrice];
        [_tztTradeView setEditorText:nsPrice nsPlaceholder_:NULL withTag_:kTagPrice];
        
        if (_bBuyFlag)
        {
            if (nsPrice && [nsPrice length] > 0 && [nsPrice floatValue] >= _fMoveStep)
            {
                [self OnRefresh];
            }
        }
        
        NSString* strAmount = [_tztTradeView GetEidtorText:kTagCount];
        NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
        NSString* strMoney = @"";
        if ([strAmount intValue] > 0 && [nsPrice floatValue] >= _fMoveStep)
        {
            strMoney = [NSString stringWithFormat:strMoneyformat, [nsPrice floatValue] * [strAmount intValue]];
        }
        TZTNSLog(@"%@",strMoney);
//        [_tztTradeView setLabelText:strMoney withTag_:2020];
    }
    else if(nTag == 9001 || nTag == 9000)//数量增加
    {
        NSString* nsAmount = [_tztTradeView GetEidtorText:kTagCount];
        int nAmount = [nsAmount intValue];
        
        if (nTag == 9001)
        {
            if (_bBuyFlag)
                nAmount += 100;
            else
                nAmount += 100;
        }
        if (nTag == 9000)
        {
            if (_bBuyFlag)
                nAmount -= 100;
            else
                nAmount -= 100;
            
            if (nAmount <= 0)
                nAmount = 0;
        }
        nsAmount = [NSString stringWithFormat:@"%d", nAmount];
        [_tztTradeView setEditorText:nsAmount nsPlaceholder_:NULL withTag_:kTagCount];
        
        
        NSString* strPriceformat = [NSString stringWithFormat:@"%%.%df",_nDotValid];
        NSString* strMoneyformat = [NSString stringWithFormat:@" ¥%%.%df",_nDotValid];
        NSString* strPrice =  [_tztTradeView GetEidtorText:kTagPrice];
        NSString* nsPrice = [NSString stringWithFormat:strPriceformat, [strPrice floatValue]];
        
        NSString* strMoney = @"";
        if ([nsAmount intValue] > 0 && [nsPrice floatValue] >= _fMoveStep)
        {
            strMoney = [NSString stringWithFormat:strMoneyformat, [nsPrice floatValue] * [nsAmount intValue]];
        }
        TZTNSLog(@"%@",strMoney);
//        [_tztTradeView setLabelText:strMoney withTag_:2020];
    }
}

//选中list
-(void)tztDroplistViewGetData:(tztUIDroplistView*)droplistview
{
    if ([droplistview.tzttagcode intValue] == kTagStockCode )
    {
        [self OnSendRequestData];
    }
    if ([droplistview.tzttagcode intValue] == kTagCode)
    {
         _isShowDropList = YES;
       
        //融资买入
        if (_nMsgType == WT_RZRQBUYRETURN || _nMsgType == MENU_JY_RZRQ_BuyReturn) {
            _isShowDropList = NO;
        }
      [self OnSendRequestData];
    }}

- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(int)index
{
    if ([droplistview.tzttagcode intValue] == kTagStockCode)
    {
        _nCurrentSel = index;
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            //设置股票代码
            [_tztTradeView setComBoxText:strCode withTag_:kTagStockCode];

            self.CurStockCode = [NSString stringWithFormat:@"%@", strCode];
            [self ClearDataWithOutCode];
            [self OnRefresh];
        }
    }
    if ([droplistview.tzttagcode intValue] == kTagCode)
    {
        _nCurrentSel = index;
        NSString* strTitle = droplistview.text;
        
        if (strTitle == nil || [strTitle length] < 1)
            return;
        NSRange rangeLeft = [strTitle rangeOfString:@"("];
        if (rangeLeft.location > 0 && rangeLeft.location < [strTitle length])
        {
            NSString *strCode = [strTitle substringToIndex:rangeLeft.location];
            //设置股票代码kTagCode
            self.CurStockCode = [NSString stringWithFormat:@"%@", strCode];
            //设置股票代码
            [_tztTradeView setComBoxText:strCode withTag_:kTagCode];
           
            [self ClearDataWithOutCode];
           [self OnRefresh];
        }

    
    }
    
}

/*
 查询持仓信息
 */
//zxl 20131023 由于IPAD刷新都是用的OnRequestData 而当前界面不需要这个刷新请求 所以改了函数名
-(void)OnSendRequestData
{
    NSString* strAction = @"";
    switch (_nMsgType)
    {
        case WT_RZRQSALE://普通卖出
        case MENU_JY_RZRQ_PTSell://普通卖出（信用卖出）
        {
            strAction = @"403";
        }
            break;
        case WT_RZRQRQSALE://融券卖出
        case MENU_JY_RZRQ_XYSell://融券卖出
        {
            strAction = @"416";
        }
            break;
        case WT_RZRQSALERETURN://买券还款
        case MENU_JY_RZRQ_SellReturn://卖券还款
        {
            strAction = @"403";
        }
            break;
        case WT_RZRQRZBUY://融资买入
        case MENU_JY_RZRQ_XYBuy:// 融资买入
        {
            strAction = @"415";
        }
            break;
        case WT_RZRQBUYRETURN:
        case MENU_JY_RZRQ_BuyReturn://买券还券
        {
            strAction = @"408";
        }
            break;
        default:
            break;
    }
    
    if (strAction.length == 0) // 防止空请求
        return;
    
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztObject:strReqno forKey:@"Reqno"];
    [pDict setTztObject:@"0" forKey:@"StartPos"];
    [pDict setTztObject:@"1000" forKey:@"MaxCount"];
    [pDict setTztObject:self.CurStockCode forKey:@"Stockcode"];
    
    //增加账号类型获取token
    [pDict setTztObject:[NSString stringWithFormat:@"%d",TZTAccountRZRQType] forKey:tztTokenType];
    

    [[tztMoblieStockComm getShareInstance] onSendDataAction:strAction withDictValue:pDict];
    DelObject(pDict);
}

@end
