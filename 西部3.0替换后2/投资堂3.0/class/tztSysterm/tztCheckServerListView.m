/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztCheckServerListView.m
 * 文件标识：
 * 摘    要：服务器检测
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2013.05.15
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/

#import "tztCheckServerListView.h"

@implementation tztCheckServerListView

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initdata];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
    }
    return self;
}

- (void)initdata
{
//    self.layer.borderColor = [UIColor colorWithRGBULong:0x262626].CGColor;
//    self.layer.backgroundColor = [UIColor colorWithRGBULong:0x262626].CGColor;
//    self.layer.borderWidth = 1;
//    self.layer.cornerRadius = tztUIBaseViewTableRadius;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    [super setFrame:frame];
    CGRect rcFrame = self.bounds;
    rcFrame = CGRectInset(rcFrame,10,5);
    _tztTableView.hidden = YES;
    if (IS_TZTIPAD) //调整iPad版本的宽度
        rcFrame.size.width = CGRectGetWidth(rcFrame) / 2;
    CGRect btnframe = rcFrame;
    btnframe.origin.x = btnframe.size.width - 90;
    btnframe.origin.y = 5;
    btnframe.size.width = 80;
    btnframe.size.height = 30;
    if(_btnTest == nil)
    {
        _btnTest = [[tztUIButton alloc] initWithProperty:@"title=检测排序"];
        _btnTest.tztdelegate = self;
        [self addSubview:_btnTest];
        [_btnTest release];
    }
    _btnTest.frame = btnframe;
    
    CGRect scrollframe = CGRectInset(rcFrame, tztUIBaseViewTableBlank, tztUIBaseViewTableBlank);
    scrollframe.origin.y = btnframe.origin.y + btnframe.size.height + 5;
    scrollframe.size.height -= scrollframe.origin.y;
    if(_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] init];
        //    self.layer.borderColor = [UIColor colorWithRGBULong:0x262626].CGColor;
        if (g_nThemeColor == 1 || g_nSkinType == 1)
        {
            _scrollView.layer.backgroundColor = [UIColor colorWithTztRGBStr:@"255,2552,55"].CGColor;
            _scrollView.layer.borderColor = [UIColor colorWithTztRGBStr:@"200,200,200"].CGColor;
        }
        else
        {
            _scrollView.layer.backgroundColor = [UIColor colorWithRGBULong:0x262626].CGColor;
        }
        _scrollView.layer.borderWidth = 1;
        _scrollView.layer.cornerRadius = tztUIBaseViewTableRadius;
        [self addSubview:_scrollView];
        [_scrollView release];
    }
    _scrollView.frame = scrollframe;
    
    if(_ayLabel == nil)
        _ayLabel = NewObject(NSMutableArray);
    
    NSInteger nLableCout = [_ayLabel count];
    NSMutableArray* ayServer = [[TZTServerListDeal getShareClass] ayAddList];
    NSInteger nServerCount = [ayServer count];
    CGRect labelframe = CGRectZero;
    for (int i = 0; i < nServerCount; i++)
    {
        labelframe = CGRectMake(0, i * 40 , scrollframe.size.width, 40);
        tztCheckServerListCell* pCell;
        if(i >= nLableCout)
        {
            pCell = [[tztCheckServerListCell alloc] init];
            [_scrollView addSubview:pCell];
            [_ayLabel addObject:pCell];
            [pCell release];
        }
        else
        {
            pCell = [_ayLabel objectAtIndex:i];
        }
        pCell.frame = labelframe;
        pCell.nIndex = i;
        [pCell setServer:[ayServer objectAtIndex:i] withPort:[[TZTServerListDeal getShareClass] GetJyPort]];
    }
    if (CGRectGetMaxY(labelframe) > CGRectGetHeight(rcFrame))
    {
        _scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(labelframe));
    }
    else
    {
        scrollframe.size.height = CGRectGetMaxY(labelframe);
        _scrollView.frame = scrollframe;
        _scrollView.contentSize = CGSizeZero;
    }
}

////排序
//NSComparisonResult compareServerDateCount(NSMutableDictionary *firstValue, NSMutableDictionary *secondValue, void *context)
//{
//    NSString* strfirst = [firstValue objectForKey:@"DateCount"];
//    NSString* strsecond =  [secondValue objectForKey:@"DateCount"];
//    if ([strfirst floatValue] < [strsecond floatValue])
//        return NSOrderedAscending;
//    else if ([strfirst floatValue]> [strsecond floatValue])
//        return NSOrderedDescending;
//    else
//    {
//        return NSOrderedSame;
//    }
//}


- (void)OnButtonClick:(id)sender
{
    UIButton* btn = (UIButton *)sender;
    if(btn == _btnTest)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_t group = dispatch_group_create();
        for(tztCheckServerListCell* pCell in _ayLabel)
            dispatch_group_async(group, queue, ^{
                [pCell onTestServer];
                sleep(2);
            });
        //等group里的task都执行完后执行notify方法里的内容,相当于把wait方法及之后要执行的代码合到一起了
        dispatch_group_notify(group, queue, ^{
            NSMutableArray* ayServerCount = NewObject(NSMutableArray);
            for(tztCheckServerListCell* pCell in _ayLabel)
            {
                NSString* strServer = pCell.hostname;
                NSString* theDateCount = [pCell getDateCount];
                NSMutableDictionary* serValue = NewObject(NSMutableDictionary);
                [serValue setObject:[NSString stringWithFormat:@"%@",theDateCount] forKey:@"DateCount"];
                [serValue setObject:[NSString stringWithFormat:@"%@",strServer] forKey:@"Server"];
                [ayServerCount addObject:serValue];
                [serValue release];
            }
            [ayServerCount sortUsingFunction:compareServerDateCount context:NULL];
            NSMutableArray* ayServer = [[TZTServerListDeal getShareClass] ayAddList];
            NSInteger nMaxCount = [ayServer count] - 1;
            if(nMaxCount > 0)
            {
                for (int i = 0; i < [ayServerCount count]; i++)
                {
                    NSMutableDictionary* serValue = [ayServerCount objectAtIndex:i];
                    NSString* strServer = [serValue objectForKey:@"Server"];
                    NSInteger nIndex = [ayServer indexOfObject:strServer];
                    if(nIndex != NSNotFound)
                    {
                        [ayServer moveObjectFromIndex:nIndex toIndex:nMaxCount];
                    }
                }
                TZTNSLog(@"%@",ayServer);
            }
//            [[TZTServerListDeal getShareClass] SetAllAddress:[ayServer objectAtIndex:0]];
            DelObject(ayServerCount);
        });
        dispatch_release(group);
    }
}

- (void)dealloc
{
    DelObject(_ayLabel);
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

@implementation tztCheckServerListCell
@synthesize hostname = _hostname;
@synthesize hostport = _hostport;
@synthesize nIndex = _nIndex;
- (id)init
{
    self = [super init];
    if (self)
    {
         theDateCount = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        theDateCount = 0;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (CGRectIsNull(frame) || CGRectIsEmpty(frame))
        return;
    CGRect labelframe = self.bounds;
    labelframe.origin.x = 10;
    labelframe.origin.y = 5;
    labelframe.size.width = 20;
    labelframe.size.height = 30;
    //分割线view
    if(_gridLine == nil)
    {
        _gridLine = [[UIView alloc]init];
        [self addSubview:_gridLine];
        [_gridLine release];
        //设置为半透明
        [_gridLine setAlpha:0.5];
        if (g_nSkinType == 1 || g_nThemeColor == 1)
            _gridLine.backgroundColor = [UIColor colorWithTztRGBStr:@"200,200,200"];
        else
            _gridLine.backgroundColor = [UIColor colorWithRGBULong:0x2f2f2f];////[UIColor darkGrayColor];
        _gridLine.hidden = NO;
    }
    CGRect lineframe = self.bounds;
    lineframe.size.height = 1;
    _gridLine.frame = lineframe;
    if(_labelindex == nil)
    {
        _labelindex = [[tztUILabel alloc] init];
        _labelindex.textAlignment = NSTextAlignmentLeft;
        [self addSubview: _labelindex];
        if (g_nSkinType == 1 || g_nThemeColor == 1)
            _labelindex.textColor = [UIColor darkTextColor];
        [_labelindex release];
    }
    _labelindex.frame = labelframe;
    [_labelindex setText:[NSString stringWithFormat:@"%d.",_nIndex+1]];
    
    labelframe.origin.x += labelframe.size.width + 5;
    labelframe.size.width = 160;
    if(_labelname == nil)
    {
        _labelname = [[tztUILabel alloc] init];
        _labelname.textAlignment = NSTextAlignmentRight;
        if (g_nSkinType == 1 || g_nThemeColor == 1)
            _labelname.textColor = [UIColor darkTextColor];
        [self addSubview: _labelname];
        [_labelname release];
    }
    _labelname.frame = labelframe;
    
    
    labelframe.origin.x += labelframe.size.width + 5;
    labelframe.size.width = self.bounds.size.width - labelframe.origin.x - 10;
    if(_labelinfo == nil)
    {
        _labelinfo = [[tztUILabel alloc] init];
        _labelinfo.textAlignment = NSTextAlignmentCenter;
        if (g_nSkinType == 1 || g_nThemeColor == 1)
            _labelinfo.textColor = [UIColor darkTextColor];
        [_labelinfo setText:@"待检测"];
        [self addSubview: _labelinfo];
        [_labelinfo release];
    }
    _labelinfo.frame = labelframe;
    
//    labelframe.origin.x += labelframe.size.width + 5;
//    labelframe.size.width = 40;
//    if(_btnSet == nil)
//    {
//        _btnSet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [_btnSet addTarget:self action:@selector(onSetServer:) forControlEvents:UIControlEventTouchUpInside];
//        _btnSet.titleLabel.font = tztUIBaseViewTextFont(0);
//        [_btnSet setTztTitle:@"设置"];
//        [self addSubview:_btnSet];
//    }
//    _btnSet.frame = labelframe;
}

- (NSString *)getDateCount
{
    return [NSString stringWithFormat:@"%.3f",theDateCount];
}

- (void)onSetServer:(id)sender
{
    [[TZTServerListDeal getShareClass] SetJYAddress:_hostname];
    [[TZTServerListDeal getShareClass] SetServerOK:tztSession_Exchange];
}

- (void)setServer:(NSString*)strServer withPort:(int)nPort
{
    self.hostname = [NSString stringWithFormat:@"%@",strServer];
    self.hostport = nPort;
    [_labelindex setText:[NSString stringWithFormat:@"%d.",_nIndex+1]];
    [_labelname setText:[NSString stringWithFormat:@"%@:%d",strServer,nPort]];
}

- (void)setServerInfo:(NSString*)strInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(_labelinfo)
            [_labelinfo setText:[NSString stringWithFormat:@"%@",strInfo]];
            }
                           );
}

- (void)onTestServer
{
    theDateCount = 100.0f;
    [self freeDataSocket];
    const char* dataqueuelable = [[_labelname text] UTF8String];
    dataSocketQueue = dispatch_queue_create(dataqueuelable, nil);
    
    const char* queuelable = [self.hostname UTF8String];
    dispatch_queue_t network_queue = dispatch_queue_create(queuelable, nil);
    
    _tztAsyncSocket = [[tztGCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dataSocketQueue socketQueue:network_queue];
    
    dispatch_release(network_queue);
    
    NSError *error = nil;
    theOnlineDate = [[NSDate date] timeIntervalSince1970];
    [_tztAsyncSocket connectToHost:_hostname onPort:_hostport withTimeout:-1 error:&error];
}

- (void)freeDataSocket
{
//    [self setServerInfo:@""];
    if(_tztAsyncSocket)
    {
        [_tztAsyncSocket setDelegate:nil delegateQueue:nil];
        [_tztAsyncSocket disconnect];
    }
    DelObject(_tztAsyncSocket);
    if(dataSocketQueue && dataSocketQueue != dispatch_get_main_queue())
    {
        dispatch_release(dataSocketQueue);
        dataSocketQueue = nil;
    }
}

- (void)dealloc
{
    [self freeDataSocket];
    [super dealloc];
}

/////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Socket事件
/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
//收到服务器数据
- (void)socket:(tztGCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    dispatch_block_t block = ^{ @autoreleasepool {
        TZTNSLog(@"%@=%@",[_labelname text],@"接收数据");
        theDateCount = [[NSDate date] timeIntervalSince1970]-theOnlineDate;
        [self setServerInfo:[NSString stringWithFormat:@"%.3f",theDateCount]];
        [sock readDataWithTimeout:-1 tag:0];
    }};
    
    if (dispatch_get_current_queue() == dataSocketQueue)
		block();
	else
		dispatch_sync(dataSocketQueue, block);
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
//已发送数据
- (void)socket:(tztGCDAsyncSocket *)sock didWriteDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
//    TZTNSLog(@"%@=%@",[_labelname text],@"数据已经发送成功");
    [self setServerInfo:@"发送检测包"];
    [sock readDataWithTimeout:-1 tag:0];
}

//数据已经部分发送
- (void)socket:(tztGCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
	//TZTNSLog(@"%@",@"部分数据已经发送!");
}

//建立连接
- (void)socket:(tztGCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
//    TZTNSLog(@"%@=%@",[_labelname text],@"连接建立");
    [self setServerInfo:@"连接建立"];
    NSMutableData* SendData = NewObject(NSMutableData);
    [SendData appendData:[tztGCDDataSocket JYData2003]];
    NSString* strTest = @"Action=46\r\n";
    NSInteger nDataLen = strlen([strTest UTF8String]);
    [SendData appendBytes:&nDataLen length:4];
    [SendData appendBytes:[strTest UTF8String] length:nDataLen];
    [_tztAsyncSocket writeData:SendData withTimeout:-1 tag:3];
    [SendData release];
    [sock readDataWithTimeout:-1 tag:0];
}

//连接中断
- (void)socketDidDisconnect:(tztGCDAsyncSocket *)sock withError:(NSError *)err
{
//    TZTLogWarn(@"%@=%@",[_labelname text],@"连接中断");
    [self setServerInfo:@"连接中断"];
}
@end
