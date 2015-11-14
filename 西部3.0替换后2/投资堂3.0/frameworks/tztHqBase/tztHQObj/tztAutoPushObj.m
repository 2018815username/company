
#import "tztAutoPushObj.h"

@interface tztAutoPushObj()<tztSocketDataDelegate>
{
    UInt16          _nReqNo;
}

@property(nonatomic,assign)id<tztAutoPushDelegate> delegate;
@end

@implementation tztAutoPushObj
@synthesize delegate = _delegate;

+(tztAutoPushObj*)getShareInstance
{
    static dispatch_once_t once;
    static tztAutoPushObj *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[tztAutoPushObj alloc] init];
    });
    return sharedView;
}

+(void)freeInstance
{
    
}

-(id)init
{
    if (self = [super init])
    {
        _nReqNo = 1;
        [[tztMoblieStockComm getSharehqInstance] addObj:self];
    }
    return self;
}

-(void)cancelAutoPush:(id<tztAutoPushDelegate>)delegate
{
    if (g_bUseHQAutoPush)
        [self setAutoPushDataWithString:@"" andDelegate_:delegate];
    self.delegate = nil;
}

-(void)setAutoPushDataWithString:(NSString *)nsData andDelegate_:(id<tztAutoPushDelegate>)delegate
{
    if (!g_bUseHQAutoPush)
    {
#warning "当前不支持行情主推，请检查配置!!!!!"
        return;
    }
    if (nsData == nil)
        nsData = @"";
    NSMutableDictionary *sendValue = NewObject(NSMutableDictionary);
    self.delegate = delegate;
//    _nReqNo++;
//    if (_nReqNo >= UINT16_MAX)
        _nReqNo = 1;//主推，不处理reqno，直接固定
    
    NSString* strReqno = tztKeyReqno((long)self, _nReqNo);
    [sendValue setObject:strReqno forKey:@"Reqno"];
    [sendValue setObject:nsData forKey:@"Grid"];
    
    [[tztMoblieStockComm getSharehqInstance] onSendDataAction:@"20253" withDictValue:sendValue];
    [sendValue release];
}

-(void)setAutoPushDataWithArray:(NSArray *)ayData andDelegate_:(id<tztAutoPushDelegate>)delegate
{
    NSString* strData = @"";
    for (NSInteger i = 0; i < ayData.count; i++)
    {
        id sender = [ayData objectAtIndex:i];
        if (sender == nil)
            continue;
        
        if ([sender isKindOfClass:[tztStockInfo class]])
        {
            if (i == 0)
                strData = [NSString stringWithFormat:@"%d|%@", ((tztStockInfo*)sender).stockType, ((tztStockInfo*)sender).stockCode];
            else
                strData = [NSString stringWithFormat:@",%d|%@", ((tztStockInfo*)sender).stockType, ((tztStockInfo*)sender).stockCode];
        }
        else if ([sender isKindOfClass:[NSDictionary class]])
        {
            if (i == 0)
                strData = [NSString stringWithFormat:@"%@|%@", [(NSDictionary*)sender objectForKey:@"Market"], [sender objectForKey:@"Code"]];
            else
                strData = [NSString stringWithFormat:@",%@|%@", [(NSDictionary*)sender objectForKey:@"Market"], [sender objectForKey:@"Code"]];
        }
    }
    
    [self setAutoPushDataWithString:strData andDelegate_:delegate];
}

-(NSUInteger)OnRequestData:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    return 1;
}

-(NSUInteger)OnCommNotify:(NSUInteger)wParam lParam_:(NSUInteger)lParam
{
    tztNewMSParse *pParse = (tztNewMSParse*)wParam;
    if (pParse == nil)
        return 0;
    
    if (![pParse IsIphoneKey:(long)self reqno:_nReqNo])
        return 0;
    
    //解析数据
    if ([pParse IsAction:@"20253"])
    {
        //解析数据，得到具体的key句柄，发送到该界面进行数据的处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveAutoPushData:)])
        {
            [self.delegate didReceiveAutoPushData:self];
        }
    }
    return 1;
}
@end
