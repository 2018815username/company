/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztSendToFriendView.h"

@implementation tztSendToFriendView
@synthesize ayPhoneAy = _ayPhoneAry;

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
    DelObject(_ayPhoneAry);
    [super dealloc];
}

- (void)removeFromSuperview
{
    [[tztMoblieStockComm getShareInstance] removeObj:self];
    [super removeFromSuperview];
}


-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    [self onSetTableConfig:@"tztUISendToFriend"];
}

-(void)tztDroplistViewGetData:(tztUIDroplistView*)view
{
#if 1
    [self getPhoneList];
#endif
}

-(void)OnButtonClick:(id)sender
{
    tztUIButton *pBtn = (tztUIButton*)sender;
    switch ([[pBtn tzttagcode] intValue])
    {
        case 6000:
        {
            [self sendTo];
        }
            break;
        case 6001:
        {
            [self getPhoneList];
        }
            break;
            
        default:
            break;
    }
}

- (void)sendTo
{
    NSString *nsCode = [_tztTableView GetEidtorText:3000];
    _ntztReqNo++;
    if (_ntztReqNo >= UINT16_MAX)
        _ntztReqNo = 1;
    NSString* strReqno = tztKeyReqno((long)self, _ntztReqNo);
    NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
    [pDict setTztValue:strReqno forKey:@"Reqno"];
    [pDict setTztValue:nsCode forKey:@"StockCode"];
    [[tztMoblieStockComm getShareInstance] onSendDataAction:@"48" withDictValue:pDict];
    DelObject(pDict);
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == NULL)
        return 0;
    if (![pParse IsIphoneKey:(long)self reqno:_ntztReqNo])
        return 0;
    
    NSString* strMsg = [pParse GetErrorMessage];
    [self showMessageBox:strMsg nType_:TZTBoxTypeNoButton nTag_:0];

    return 1;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
}

// 选中列表
- (void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(NSInteger)index
{
    NSString *phone = [_ayPhoneAry objectAtIndex:index];
    if ([_tztTableView getViewWithTag:3001].hidden == YES)
    {
        [_tztTableView setEditorText:phone nsPlaceholder_:nil withTag_:3000];
    }
    else
    {
        [_tztTableView setComBoxText:phone withTag_:3001];
    }
}

#pragma mark - AddressBook

// 获取通讯录内容，避免提示重复byDBQ20131008；iOS6以后有隐私保护，不开启询问隐私不能访问通讯录 byDBQ20130910
- (NSMutableArray*)getAddressBookPeople
{
    ABAddressBookRef addressBook = NULL;
    NSMutableArray* peopleArray = nil;
    
    BOOL agree = NO;
    
    if (IS_TZTIOS(6))
    {
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus addressAccessStatus = ABAddressBookGetAuthorizationStatus();
        switch (addressAccessStatus)
        {
            case kABAuthorizationStatusAuthorized: // 请求访问后同意
            {
                agree = YES;
            }
                break;
            case kABAuthorizationStatusNotDetermined: // 没决定
            {
                ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error){}); // 第一次请求访问通讯录
            }
                break;
            case kABAuthorizationStatusRestricted: // 请求访问后拒绝
            {
                agree = NO;
            }
                break;
            case kABAuthorizationStatusDenied: // 在隐私中将本程序的访问权限关闭
            {
                agree = NO;
            }
                break;
            default:
            {
                agree = NO;
            }
                break;
        }
        if (agree)
        {
            
            addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            
        }
        else
        {
            [self showMessageBox:[NSString stringWithFormat:@"您还未开启“%@”的通讯录访问权限，请到设置->隐私->通讯录中把“%@”的通讯录访问开启吧", g_pSystermConfig.strMainTitle, g_pSystermConfig.strMainTitle] nType_:TZTBoxTypeNoButton nTag_:0 delegate_:self withTitle_:@"访问受限制"];
            return nil;
        }
        
    }
    else{
        addressBook = ABAddressBookCreate();
        
    }
    
    peopleArray = (NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    if(peopleArray == nil || peopleArray.count < 1)
    {
        [self showMessageBox:@"通讯录没有相关好友号码,您可以直接手动输入!" nType_:TZTBoxTypeNoButton nTag_:0];
    }
    if (addressBook)
        CFRelease(addressBook);
    
    return peopleArray;
}

// 获取手机号码 
- (void)getPhoneList
{
    if (_ayPhoneAry == NULL)
        _ayPhoneAry = NewObject(NSMutableArray);
	NSMutableArray* peopleArray = [self getAddressBookPeople];
    
    if (peopleArray == nil)
        return;
    
    NSMutableArray *tempAry = [[[NSMutableArray alloc]init]autorelease];   
    [_ayPhoneAry  removeAllObjects];
    for (int np = 0; np < [peopleArray count]; np++)
    {
        ABRecordRef people = [peopleArray objectAtIndex:np];
        if(people == NULL)
            continue;
		NSString * firstName = (NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
        firstName = [firstName stringByAppendingFormat:@" "];
        NSString * lastName = (NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);    
        NSString * fullName = [firstName stringByAppendingFormat:@"%@",lastName];
		
        
		NSString* strName = @"";
		if(fullName)
            strName = [NSString stringWithFormat:@"%@",fullName];
		ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(people, kABPersonPhoneProperty);		
		CFIndex nCount = ABMultiValueGetCount(phones);
    	for(NSInteger i = 0 ;i < nCount;i++)
		{
			NSString *phoneNO   = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);  // 这个就是电话号码
            NSString *phone1  = [phoneNO stringByReplacingOccurrencesOfString:@"(" withString:@""];
            NSString *phone2  = [phone1 stringByReplacingOccurrencesOfString:@")" withString:@""];
            NSString *phone3  = [phone2 stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *tempStr  = [phone3 stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            [_ayPhoneAry addObject:[NSString stringWithFormat:@"%@",tempStr]];
			[tempAry addObject:[NSString stringWithFormat:@"%@   %@",strName,tempStr]];
        }
	}	
	
	if (_tztTableView)
	{
		[_tztTableView setComBoxData:tempAry ayContent_:_ayPhoneAry AndIndex_:-1 withTag_:3001 bDrop_:FALSE];
	}

}

@end
