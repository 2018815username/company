//
//  AccountAddView.m
//  tzt_xbzq_3.0
//
//  Created by wry on 15/6/12.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import "AccountAddView.h"
#import "AccountTableViewCell.h"
#define Widht    TZTScreenWidth

#define rgbColor(r,g,b)    [UIColor  colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
@interface AccountAddView() {
    NSArray* accountTypeData;
    NSMutableArray*rzrqLogin;

    NSMutableArray*ptLogin;
    
    NSString*selectAccount;
    NSInteger  selectIndex;
}

@end
@implementation AccountAddView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         [[tztMoblieStockComm getShareInstance] addObj:self];
        selectAccount = NewObject(NSString);
        [self layoutView:frame];
    }
    return self;
}
-(void)layoutView:(CGRect)frame{
    frame.origin.y = 0;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
     accountTypeData = [[NSArray alloc] initWithObjects:@"普通交易账号",@"融资融券账号", nil];
    if (ptLogin==nil) {
        ptLogin =NewObject(NSMutableArray);
    }
    if (rzrqLogin ==nil) {
        rzrqLogin  =NewObject(NSMutableArray);
    }
    

    [self getZHxinxi];
}

#pragma mark 207
//获取用户预设账号信息
-(void)getZHxinxi
{
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    NSString* mobil = [tztKeyChain load:tztLogMobile];
    if (mobil) {
        [pDict setValue:mobil forKey:@"MobileCode"];
    }
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"207" withDictValue:pDict];
    DelObject(pDict);
    

}
#pragma mark  OnCommNotify
-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    [self dealAccount:pParse];
    
    return 0;
}


-(void)dealAccount:(tztNewMSParse*)pParse{

    [tztJYLoginInfo SetAccountList:pParse];
    [ptLogin removeAllObjects];
    [rzrqLogin removeAllObjects];
    for (int i=0; i<g_ZJAccountArray.count; i++) {
        tztZJAccountInfo *save = g_ZJAccountArray[i];
        if ([save.nsAccountType rangeOfString:@"RZRQ"].length>0) {
            [rzrqLogin addObject:save];
        }else {
            [ptLogin addObject:save];
        }
    }
    [self.tableView reloadData];
}
#pragma mark DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return accountTypeData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {

        return ptLogin.count;

    }else{
        
        return rzrqLogin.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        
    }
    NSString* tagValue = [[NSString stringWithFormat:@"%ld",(long)indexPath.section+1] stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]];
    cell.tag = [tagValue integerValue];
    tztJYLoginInfo*rzrqLoginInfo=[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountRZRQType];
    tztJYLoginInfo*ptLoginInfo=[tztJYLoginInfo GetCurJYLoginInfo:TZTAccountPTType];

    if (indexPath.section == 0) {
        [cell setLoginOrNologin:ptLoginInfo RzrqLoin:rzrqLoginInfo andCurrentCellData:ptLogin[indexPath.row]];
    }else {
        [cell setLoginOrNologin:ptLoginInfo RzrqLoin:rzrqLoginInfo andCurrentCellData:rzrqLogin[indexPath.row]];
    }


    
//    cell.selectAccount = ^(tztJYLoginInfo*info){
//        selectAccount = info.nsAccount;
//    };
    return cell;
}


#pragma mark tableViewdelgate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     if (section == accountTypeData.count-1) {
             return SectionHeight-20;
     }
    return 0;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<g_ZJAccountArray.count) {
     tztJYLoginInfo*info =g_ZJAccountArray[indexPath.row];
     selectAccount = info.nsAccount;
    selectIndex = indexPath.row;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView*Header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Widht, SectionHeight)];
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(leftWidht, 12, Widht-leftWidht*2, 40)];
    backView.layer.cornerRadius = 5;
    backView.backgroundColor =  [UIColor colorWithRed:175.0/255.0f green:182.0/255.0f blue:196.0/255.0f alpha:1];//175 182 197
    [Header addSubview:backView];
    
    UILabel*lable = [[UILabel alloc] initWithFrame:Header.frame];
    lable.center = Header.center;
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = UITextAlignmentCenter;
    lable.text = accountTypeData[section];
    [Header addSubview:lable];
    return Header;
}
-(void)initButtomSubView:(UIView*)view{
    
    int width = view.frame.size.width/2;
    int height = 34;
    int  top =5;
    UIButton*addAccount =[UIButton buttonWithType:UIButtonTypeCustom];
    addAccount.frame = CGRectMake(10, top, width, height);
    addAccount.layer.cornerRadius = 5;
    [addAccount setTitle:@"添加账号" forState:UIControlStateNormal];
    [addAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addAccount.tag = 101;
    [addAccount setBackgroundColor:[UIColor colorWithRed:71.0/255.0f green:150.0/255.0f blue:247.0/255.0f alpha:1]];
    [addAccount addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addAccount];

    UIButton*hiddenAccount =[UIButton buttonWithType:UIButtonTypeCustom];
    hiddenAccount.frame = CGRectMake(10+width+5, top, width, height);
    hiddenAccount.layer.cornerRadius = 5;
    [hiddenAccount setTitle:@"隐藏账号" forState:UIControlStateNormal];
    [hiddenAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hiddenAccount setBackgroundColor:[UIColor colorWithRed:71.0/255.0f green:150.0/255.0f blue:247.0/255.0f alpha:1]];
    hiddenAccount.tag = 102;
    [hiddenAccount addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:hiddenAccount];
    
    UIButton*dealAccount =[UIButton buttonWithType:UIButtonTypeCustom];
    dealAccount.frame = CGRectMake(10+width+10, top, width, height);
    dealAccount.layer.cornerRadius = 5;
    dealAccount.tag = 103;
    [dealAccount setTitle:@"删除账号" forState:UIControlStateNormal];
    [dealAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dealAccount setBackgroundColor:[UIColor colorWithRed:71.0/255.0f green:150.0/255.0f blue:247.0/255.0f alpha:1]];
    [dealAccount addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:dealAccount];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == accountTypeData.count-1) {
        UIView*bottomView = [[UIView alloc] initWithFrame:CGRectMake(leftWidht, 0, Widht-leftWidht*2, 44)];
        [self initButtomSubView:bottomView];
        return bottomView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)click:(UIButton*)bn{
    switch (bn.tag) {
        case 101:
            [TZTUIBaseVCMsg OnMsg:MENU_SYS_JYAddAccount wParam:0 lParam:0];
            break;
        case 102:{
            if (selectAccount.length>0) {
             NSString*account = [tztJYLoginInfo HideFund:selectAccount];
                g_ZJAccountArray[selectIndex] = account;
                [self.tableView reloadData];
            }else {
              tztAfxMessageBox(@"请选择一只股票");
            }
        }
            break;
        case 103:
            if (selectAccount.length>0) {
                tztAfxMessageBlock(@"确定删除", @"温馨提示",nil , TZTBoxTypeButtonBoth,  ^(NSInteger nIndex){
                    if (nIndex == 0)
                    {
                        [self OnDelAccount];
                    }
                });

            }else {
                tztAfxMessageBox(@"请选择一只股票");
            }

            break;
        default:
            break;
    }
}

-(void)OnDelAccount
{
    //检查有效性
    if (selectIndex < 0 || selectIndex >= [g_ZJAccountArray count])
    {
        [self showMessageBox:@"没有账号可以操作!" nType_:TZTBoxTypeNoButton delegate_:self];
        return;
    }
    
    //得到账户
    tztZJAccountInfo *pZJAccount = [g_ZJAccountArray objectAtIndex:selectIndex];
    
    //
    if (pZJAccount.nsCellIndex == NULL || [pZJAccount.nsCellIndex length] < 1)
        return;
    if (pZJAccount.nsAccount == NULL || [pZJAccount.nsAccount length] < 1)
        return;
    if (pZJAccount.nsAccountType == NULL || [pZJAccount.nsAccountType length] < 1)
        return;
    //向服务器发送删除账号请求
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    
    [pDict setTztValue:pZJAccount.nsCellIndex forKey:@"YybCode"];
    [pDict setTztValue:pZJAccount.nsAccount forKey:@"account"];
    [pDict setTztValue:pZJAccount.nsAccountType forKey:@"accounttype"];
    
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"209" withDictValue:pDict];
    DelObject(pDict);
    [self getZHxinxi];
}



@end
