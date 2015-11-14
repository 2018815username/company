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
 *xinlan 添加修改服务器地址
 ***************************************************************/

#import "tztAddOrDeletServerView.h"

@implementation tztTouchTableView
@synthesize touchDelegate = _touchDelegate;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(tztTouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
    {
        [_touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(tztTouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesCancelled:withEvent:)])
    {
        [_touchDelegate tableView:self touchesCancelled:touches withEvent:event];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(tztTouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)])
    {
        [_touchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if ([_touchDelegate conformsToProtocol:@protocol(tztTouchTableViewDelegate)] &&
        [_touchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)])
    {
        [_touchDelegate tableView:self touchesMoved:touches withEvent:event];
    }
}
@end


@interface tztAddOrDeletTableCell : UITableViewCell
{
    NSInteger _section;
    id _tztdelegate;
}
@property(nonatomic,assign) id tztdelegate;//服务器地址
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section;
-(void)SetLabel:(int)nPoint first:(int)nFirstWidth second:(int)nSecondWidth;
-(void)SetContentText:(NSString*)first secondTitle:(NSString*)second;
-(void)SetContentTextColor:(UIColor*)clFirst secondColor:(UIColor*)clSecond;
@end

@implementation tztAddOrDeletTableCell
@synthesize tztdelegate = _tztdelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSection:(NSInteger)section
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
//        self.backgroundColor = [UIColor colorWithTztRGBStr:@"26,26,26"];
        _section = section;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(200, 8, 15, 24)];
        title.adjustsFontSizeToFitWidth = TRUE;
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = [UIColor blackColor];
        title.font = tztUIBaseViewTextBoldFont(15.0f);
        title.backgroundColor = [UIColor clearColor];
        [title setTag:0x1000 + _section * 100];
        [self addSubview:title];
        [title release];
        
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(200+150*2, 8, 150, 24)];
        content.textAlignment = NSTextAlignmentLeft;
        content.textColor = [UIColor blackColor];
        content.font = tztUIBaseViewTextBoldFont(15.0f);
        content.backgroundColor = [UIColor clearColor];
        [content setTag:0x1001 + _section * 100];
        [self addSubview:content];
        [content release];
        
        tztUITextField* editText = [[tztUITextField alloc] initWithProperty:@"textAlignment=left|keyboardtype=chinese"];
        editText.frame = CGRectMake(200,8,200,24);
        editText.tag = 0x1002 + _section * 100;
//        editText.keyboardType = UIKeyboardTypeDefault;
        editText.returnKeyType = UIReturnKeyJoin;
        editText.layer.borderWidth = 0;
        editText.delegate = _tztdelegate;
        editText.textColor = [UIColor blackColor];
        editText.font = tztUIBaseViewTextBoldFont(15.0f);
        editText.backgroundColor = [UIColor clearColor];
        editText.hidden = YES;
        [self addSubview:editText];
        [editText release];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)SetLabel:(int)nPoint first:(int)nFirstWidth second:(int)nSecondWidth
{
    UILabel *firstText = (UILabel*)[self viewWithTag:0x1000 + _section * 100];
    CGRect frame = firstText.frame;
    frame.origin.x = nPoint;
    frame.size.width = nFirstWidth;
    firstText.frame = frame;
    firstText.hidden = NO;
    
    UILabel *secondText = (UILabel*)[self viewWithTag:0x1001 + _section * 100];
    frame = secondText.frame;
    frame.origin.x = firstText.frame.origin.x + nFirstWidth + tztUIBaseViewMidBlank;
    frame.size.width = nSecondWidth;
    secondText.frame = frame;
    secondText.hidden = NO;
    
    tztUITextField* editText = (tztUITextField*)[self viewWithTag:0x1002 + _section * 100];
    editText.delegate = _tztdelegate;
    frame = editText.frame;
    frame.origin.x = nPoint;
    frame.size.width = nFirstWidth + nSecondWidth;
    editText.frame = frame;
    editText.hidden = YES;
}

-(void)SetTextField:(int)nPoint first:(int)nFirstWidth second:(int)nSecondWidth
{
    [self SetLabel:nPoint first:nFirstWidth second:nSecondWidth];
    UILabel *firstText = (UILabel*)[self viewWithTag:0x1000 + _section * 100];
    firstText.hidden = YES;
    UILabel *secondText = (UILabel*)[self viewWithTag:0x1001 + _section * 100];
    secondText.hidden = YES;
    
    tztUITextField* editText = (tztUITextField*)[self viewWithTag:0x1002 + _section * 100];
    editText.delegate = _tztdelegate;
    editText.hidden = NO;
}

-(void)SetContentText:(NSString *)first secondTitle:(NSString *)second
{
    UILabel *firstText = (UILabel*)[self viewWithTag:0x1000 + _section * 100];
    firstText.text = first;
    
    UILabel *secondText = (UILabel*)[self viewWithTag:0x1001 + _section * 100];
    secondText.text = second;
    
    tztUITextField* editText = (tztUITextField*)[self viewWithTag:0x1002 + _section * 100];
    editText.text = @"";
    editText.delegate = _tztdelegate;
    editText.placeholder = first;
}

-(void)SetContentTextColor:(UIColor *)clFirst secondColor:(UIColor *)clSecond
{
    UILabel *firstText = (UILabel*)[self viewWithTag:0x1000 + _section * 100];
    firstText.textColor = clFirst;
    
    UILabel *secondText = (UILabel*)[self viewWithTag:0x1001 + _section * 100];
    secondText.textColor = clSecond;
    
    tztUITextField* editText = (tztUITextField*)[self viewWithTag:0x1002 + _section * 100];
    editText.delegate = _tztdelegate;
    editText.textColor = clSecond;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(keyboardDidHide)])
    {
        [_tztdelegate keyboardDidHide];
    }
}

-(void)dealloc
{
    NilObject(self.tztdelegate);
    [super dealloc];
}
@end


@implementation tztAddOrDeletServerView
@synthesize tableView = _tableView;
-(id)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:TZTUIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasHidden:)
                                                     name:TZTUIKeyboardDidHideNotification object:nil];
    }
    return self;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame)) 
        return;
    
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    //服务器地址
    if (_tableView == NULL)
    {
        _tableView = [[tztTouchTableView alloc] initWithFrame:rcFrame style:UITableViewStyleGrouped];
        _tableView.touchDelegate = self;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setEditing:YES animated:YES];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageview setImage:[UIImage imageTztNamed:@"TZTNiceBack.png"]];
        _tableView.backgroundView = imageview;
        [imageview release];
        [self addSubview:_tableView];
        [_tableView release];
    }
    else
    {
        _tableView.frame = rcFrame;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel* sectionView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
//    
//    [sectionView setText:(section ? @"    服务器端口":@"    服务器地址")];
//    [sectionView setTextColor:[UIColor darkTextColor]];
//    sectionView.userInteractionEnabled = FALSE;
//    [sectionView setBackgroundColor:[UIColor clearColor]];
//    [sectionView setFont:tztUIBaseViewTextFont(15.0f)];
//    return [sectionView autorelease];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"行情地址";
    }
    else if(section == 1)
    {
        return @"交易地址";
    }
    else if(section == 2)
    {
        return @"资讯地址";
    }
//    else if (section == 3)
//    {
//        return @"开户地址";
//    }
    else if (section == 3)
    {
        return @"均衡地址";
    }
    
	return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)//行情
	{
        NSMutableArray *array = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeHQ];
//        NSMutableArray *array = [TZTServerListDeal getShareClass].ayAddList;
        if (array == NULL)
            return 1;
        
		return [array count] + 1;
	}
	else if(section == 1)//交易
	{
        NSMutableArray *array = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_Exchange];
//        [TZTServerListDeal getShareClass].ayPortList;
        if (array == NULL)
            return 1;
		return [array count] + 1;
	}
    else if (section == 2)//资讯
    {
        NSMutableArray *array = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeZX];
        if (array == NULL)
            return 1;
        return array.count + 1;
    }
    else if (section == 3)//开户
    {
        NSMutableArray *array = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeKH];
        if (array == NULL)
            return 1;
        return array.count + 1;
    }
    else if (section == 4)//均衡
    {
        NSMutableArray *array = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeJH];
        if (array == NULL)
            return 1;
        return array.count + 1;
    }
	return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = NULL;
    
    int nType = 0;
    switch (indexPath.section)
    {
        case 0://行情
            nType = tztSession_ExchangeHQ;
            break;
        case 1://交易
            nType = tztSession_Exchange;
            break;
        case 2://资讯
            nType = tztSession_ExchangeZX;
            break;
        case 3://开户
            nType = tztSession_ExchangeKH;
            break;
        case 4://均衡
            nType = tztSession_ExchangeJH;
            break;
        default:
            break;
    }
    array = [[TZTServerListDeal getShareClass] GetAddressList:nType];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if ([array count] <= 1)
        {
            return;
        }
        if (indexPath.row >= 0 && indexPath.row < [array count])
        {
            NSString* nsServer = [array objectAtIndex:indexPath.row];
            BOOL bSucc = [[TZTServerListDeal getShareClass] RemoveAddressInfo:nType address:nsServer];
            //[[TZTServerListDeal getShareClass] RemoveAddress:nsServer];
            if (!bSucc)
            {
                [self showMessageBox:@"删除失败，该地址正在使用中!" nType_:TZTBoxTypeNoButton nTag_:0];
                return;
            }
            [[TZTServerListDeal getShareClass] SaveAndLoadServerList:TRUE];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
    }
	[_tableView reloadData];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"Cell%d%d",(int)indexPath.section,(int)indexPath.row]; // 避免cell的重用问题
	tztAddOrDeletTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(cell == nil)
	{
		cell = [[[tztAddOrDeletTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withSection:indexPath.section ]autorelease];
        cell.tztdelegate = self;
	}
    
    NSMutableArray *arrayip = nil;//[TZTServerListDeal getShareClass].ayAddList;
//    NSMutableArray *arraydk = [TZTServerListDeal getShareClass].ayPortList;
    switch (indexPath.section)
    {
        case 0:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeHQ];
            break;
        case 1:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_Exchange];
            break;
        case 2:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeZX];
            break;
        case 3:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeKH];
            break;
        case 4:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeJH];
            break;
        default:
            break;
    }
    if(indexPath.row < [arrayip count])
    {
        if (IS_TZTIPAD)
        {
            [cell SetLabel:100 first:60 second:160];
        }
        else
        {
            [cell SetLabel:60 first:60 second:tableView.frame.size.width - 140];
        }
        [cell SetContentText:[NSString stringWithFormat:@"服务器%d:",(int)(indexPath.row+1)] secondTitle:[arrayip objectAtIndex:indexPath.row]];
    }
    else
    {
        if (IS_TZTIPAD)
        {
            [cell SetTextField:100 first:60 second:160];
        }
        else
        {
            [cell SetTextField:60 first:60 second:tableView.frame.size.width - 140];
        }
        [cell SetContentText:@"添加地址(格式：ip:端口)" secondTitle:@""];
    }
	return cell;
}

-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    NSMutableArray *arrayip = nil;
    switch (indexPath.section)
    {
        case 0:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeHQ];
            break;
        case 1:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_Exchange];
            break;
        case 2:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeZX];
            break;
        case 3:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeKH];
            break;
        case 4:
            arrayip = [[TZTServerListDeal getShareClass] GetAddressList:tztSession_ExchangeJH];
            break;
        default:
            break;
    }
    
    if(indexPath.row < [arrayip count])
        style = UITableViewCellEditingStyleDelete;
    else
        style = UITableViewCellEditingStyleInsert;
    return style;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self keyboardDidHide];
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger nTag = textField.tag;
    nTag -= 0x1002;
    nTag /= 100;
    
    NSString* nsServer = textField.text;
    if (nsServer && nsServer.length < 1)
    {
//        tztAfxMessageBox(@"输入地址不合法，请重新输入!\r\n格式(ip:端口)");
        return;
    }
    switch (nTag)
    {
        case 0://行情
        {
            [[TZTServerListDeal getShareClass] AddAddressInfo:tztSession_ExchangeHQ address:nsServer];
        }
            break;
        case 1://交易
        {
            [[TZTServerListDeal getShareClass] AddAddressInfo:tztSession_Exchange address:nsServer];
        }
            break;
        case 2://资讯
        {
            [[TZTServerListDeal getShareClass] AddAddressInfo:tztSession_ExchangeZX address:nsServer];
        }
            break;
        case 3://开户
        {
            [[TZTServerListDeal getShareClass] AddAddressInfo:tztSession_ExchangeKH address:nsServer];
        }
            break;
        case 4:
        {
            [[TZTServerListDeal getShareClass] AddAddressInfo:tztSession_ExchangeJH address:nsServer];
        }
            break;
        default:
            break;
    }
    [[TZTServerListDeal getShareClass] SaveAndLoadServerList:TRUE];
    [_tableView reloadData];
}

- (void)keyboardDidHide
{
   [self OnCloseKeybord:_tableView];
}

-(void) keyboardWasShown:(NSNotification*)notifaction
{
    //UIKeyboardDidShowNotification
    if (notifaction == nil || notifaction.name == nil ||  [notifaction.name compare:TZTUIKeyboardDidShowNotification] != NSOrderedSame)
    {
        return;
    }
    CGFloat nHeight = 0;
    UIView* keyboardview = (UIView *)notifaction.object;
    if(keyboardview && [keyboardview isKindOfClass:[UIView class]])
    {
        UIView* textview = (UIView *)keyboardview;
        nHeight = [textview gettztwindowy:nil]+textview.frame.size.height;
    }
    else
    {
        return;
    }
    
    BOOL bShowKeyboard = FALSE;
    int nkeyboardHeight = 350;
    if (!IS_TZTIPAD)
        nkeyboardHeight = 216;
    
    if ([keyboardview isKindOfClass:[tztUITextField class]]
        || [keyboardview isKindOfClass:[tztUITextView class]])
    {
        bShowKeyboard = TRUE;
    }
    
    if(bShowKeyboard )
    {
        int nTemp = keyboardHeight;
        if (nHeight > TZTScreenHeight - nkeyboardHeight - TZTNavbarHeight)
        {
            keyboardHeight = nHeight - TZTScreenHeight + nkeyboardHeight+TZTNavbarHeight;
            int nScrollHeight = keyboardHeight;
            keyboardHeight += nTemp;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3f];
            CGRect rcSub = self.frame;
            CGRect rcTest = rcSub;
            rcTest.origin.y -= nScrollHeight;
            self.frame = rcTest;
            TZTNSLog(@"keyboardWillShow :%d",nScrollHeight);
            [UIView commitAnimations];
        }
    }
}

-(void)keyboardWasHidden:(NSNotification*)notifaction
{
    if (notifaction == nil || notifaction.name == nil ||  [notifaction.name compare:TZTUIKeyboardDidHideNotification] != NSOrderedSame)
    {
        return;
    }
    if (keyboardHeight > 0)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        CGRect rcSub = self.frame;
        CGRect rcTest = rcSub;
        rcTest.origin.y += keyboardHeight; //下移
        self.frame = rcTest;
        keyboardHeight = 0;
        [UIView commitAnimations];
        TZTNSLog(@"keyboardWillHideEx");
    }
}

- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyboardDidHide];
}

@end
