//
//  TZTStockDetailTittleVeiw.m
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 4/3/14.
//
//

#import "TZTStockDetailTittleVeiw.h"

@interface TZTStockDetailTittleVeiw()
{
    UIImageView *_imgView;
    int         _nStatus;
    BOOL        bOffset;
}
@end

@implementation TZTStockDetailTittleVeiw

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    self.backgroundColor = [UIColor tztThemeBackgroundColorTitleTrend];
    CGRect rect = frame;
    rect.origin.y += (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
    rect.size.height -= (IS_TZTIOS(7) ? TZTStatuBarHeight : 0);
    rect.size.height = rect.size.height/2;
    
    CGRect rcName = rect;
    rcName.origin.y += 6;
    if (lbStock == nil) {
        lbStock = [[UILabel alloc] initWithFrame:rcName];
        lbStock.font = tztUIBaseViewTextFont(15);
        lbStock.textAlignment = NSTextAlignmentCenter;
        lbStock.adjustsFontSizeToFitWidth = YES;
        lbStock.backgroundColor = [UIColor clearColor];
        lbStock.textColor = [UIColor whiteColor];
        [self addSubview: lbStock];
        [lbStock release];
    }
    else
    {
        lbStock.frame = rcName;
    }
    
    rect.origin.y += rect.size.height;
    
    CGRect rcImg = rect;
    rcImg.size.width = 0;
    UIImage *image = [UIImage imageTztNamed:@"tztTitleRZRQ.png"];
    rcImg.size = image.size;
    if (_nStatus & 0xF000 || _nStatus & 0x0F00)
    {
        
    }
    else
    {
        rcImg.size.width = 0;
    }
    NSString* strLbState = lbState.text;
    CGSize szState = [strLbState sizeWithFont:lbState.font];
    
    rcImg.origin.x = (rect.size.width - (rcImg.size.width + szState.width+3)) / 2;
    rcImg.origin.y += (rect.size.height - image.size.height) / 2;
    if (_imgView == NULL)
    {
        _imgView = [[UIImageView alloc] initWithFrame:rcImg];
        _imgView.hidden = YES;
        [_imgView setImage:image];
        [self addSubview:_imgView];
        [_imgView release];
    }
    else
    {
        _imgView.frame = rcImg;
    }
    
    
    rect = CGRectMake(rcImg.origin.x + 3 + rcImg.size.width, rect.origin.y, szState.width, rect.size.height);
    if (lbState == nil) {
        lbState = [[UILabel alloc] initWithFrame:rect];
        lbState.font = tztUIBaseViewTextFont(13);
        lbState.textAlignment = NSTextAlignmentCenter;
        lbState.adjustsFontSizeToFitWidth = YES;
        lbState.backgroundColor = [UIColor clearColor];
        lbState.textColor = [UIColor whiteColor];
        [self addSubview: lbState];
        [lbState release];
    }
    else
    {
        lbState.frame = rect;
    }
    
    rect.origin.y += rect.size.height;
    
    rect.origin.x = 0;
    rect.size.width = self.bounds.size.width;
    if (lbData == nil) {
        lbData = [[UILabel alloc] initWithFrame:rect];
        lbData.font = tztUIBaseViewTextFont(13);
        lbData.textAlignment = NSTextAlignmentCenter;
        lbData.adjustsFontSizeToFitWidth = YES;
        lbData.backgroundColor = [UIColor clearColor];
        lbData.textColor = [UIColor whiteColor];
        [self addSubview: lbData];
        lbData.alpha = .0f;
        [lbData release];
    }
    else
    {
        lbData.frame = rect;
    }
}

- (void)setPStockInfo:(tztStockInfo *)pStockInfo
{
    if (self.pStockInfo != NULL && [self.pStockInfo.stockCode caseInsensitiveCompare:pStockInfo.stockCode] == NSOrderedSame
        && self.pStockInfo.stockType == pStockInfo.stockType)//完全相同，不再处理
        return;
    [_pStockInfo release];
    _pStockInfo = [pStockInfo retain];
    [self updateContent];
}

- (void)updateContent
{
    NSDictionary *stockDic = [TZTPriceData stockDic];
    NSMutableDictionary *pDictName = [stockDic objectForKey:tztName];
    NSMutableDictionary *pDictCode = [stockDic objectForKey:tztCode];
    NSMutableDictionary *pDictNewPrice = [stockDic objectForKey:tztNewPrice];
    NSMutableDictionary *pDictUpDown = [stockDic objectForKey:tztUpDown];
    NSMutableDictionary *pDictRange = [stockDic objectForKey:tztPriceRange];
    
    NSString* nsName = [pDictName objectForKey:tztValue];
    NSString* nsCode = [pDictCode objectForKey:tztValue];
    NSString* nsNewPrice = [pDictNewPrice objectForKey:tztValue];
    NSString* nsUpDown = [pDictUpDown objectForKey:tztValue];
    NSString* nsRange = [pDictRange objectForKey:tztValue];
    
    UIColor *pColor = [pDictUpDown objectForKey:tztColor];
    nsCode = [nsCode  stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* strCurrent = self.pStockInfo.stockCode;
    strCurrent = [strCurrent stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (nsCode && [nsCode caseInsensitiveCompare:strCurrent] != NSOrderedSame)
        return;
    
    if (nsCode == nil)
        nsCode = @"";
    if (nsName == nil)
        nsName = @"";
    
    nsName = [nsName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
#ifdef tzt_ZSSC
    lbStock.text = nsName;
#else
    lbStock.text = [NSString stringWithFormat:@"%@(%@)", nsName, nsCode];
#endif
    
#ifdef tzt_ZSSC
    lbState.text = [NSString stringWithFormat:@"%@", nsCode];
#else
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"MM-dd"];//设定时间格式 HH:mm:ss
    NSString *date = [dateFormat stringFromDate:[NSDate date]]; //求出当天的时间字符串，当更改时间
    
    [dateFormat setDateFormat:@"HH:mm:ss"];//设定时间格式
    NSString *time = [dateFormat stringFromDate:[NSDate date]]; //求出当天的时间字符串，当更改时间
    
    lbState.text = [NSString stringWithFormat:@"%@  %@", date, time];
    [dateFormat release];
#endif
    lbData.text = [NSString stringWithFormat:@"%@  %@  %@", nsNewPrice, nsUpDown, nsRange];
    if ([nsUpDown caseInsensitiveCompare:@"-.-"] == NSOrderedSame
        || [nsUpDown caseInsensitiveCompare:@"-"] == NSOrderedSame)
    {
        pColor = [UIColor whiteColor];
    }
    else if ([nsUpDown hasPrefix:@"-"])
    {
        UIColor *cl = [UIColor tztThemeHQTitleDownColor];
        if (cl)
            pColor = cl;
    }
    else
    {
        UIColor *cl = [UIColor tztThemeHQTitleUpColor];
        if (cl)
            pColor = cl;
    }
    lbData.textColor = pColor;

    [self setStockDetailInfo:self.pStockInfo.stockType nStatus:_nStatus];
}

- (void)SetDefaultState
{
    [self setFrame:self.frame];
    lbState.alpha = 1.0f;
    lbData.alpha = 0.f;
    _imgView.alpha = 1.0f;
}

- (void)updateUserStockTitle:(BOOL)hide
{
    CGPoint stateCen = lbState.center;
    CGPoint dataCen = lbData.center;
    CGPoint imgCen = _imgView.center;
    if (hide && (dataCen.y > self.frame.size.height)) {
        
        stateCen.y -= lbState.frame.size.height;
        imgCen.y -= _imgView.frame.size.height;
        dataCen.y -= lbData.frame.size.height;
        bOffset = hide;
        [UIView animateWithDuration:0.3f animations:^{
            lbState.center = stateCen;
            _imgView.center = imgCen;
            lbData.center = dataCen;
            lbData.alpha = 1.0f;
        }];
        [UIView animateWithDuration:0.2f animations:^{
            
            lbState.alpha = .0f;
            _imgView.alpha = .0f;
        }];
    }
    else if (!hide && (dataCen.y <= self.frame.size.height))
    {
        bOffset = hide;
        stateCen.y += lbState.frame.size.height;
        dataCen.y += lbData.frame.size.height;
        imgCen.y += _imgView.frame.size.height;
        [UIView animateWithDuration:0.3f animations:^{
            
            lbState.center = stateCen;
            lbState.alpha = 1.0f;
            _imgView.center = imgCen;
            _imgView.alpha = 1.0f;
            lbData.center = dataCen;
        }];
        [UIView animateWithDuration:0.2f animations:^{
            
            lbData.alpha = .0f;
        }];
        
    }
}

-(void)setStockDetailInfo:(NSInteger)nStockType nStatus:(int)nStatus
{
    _nStatus = nStatus;
    
    CGRect rcImg = _imgView.frame;
    UIImage *image = [UIImage imageTztNamed:@"tztTitleRZRQ.png"];
    rcImg.size = image.size;
    
    NSString* strLbState = lbState.text;
    CGSize szState = [strLbState sizeWithFont:lbState.font];
    
    
    if (_nStatus & 0xF000 || _nStatus & 0x0F00)
        rcImg.size = image.size;
    else
        rcImg.size.width = 0;
    
    rcImg.origin.x = (self.bounds.size.width - szState.width - rcImg.size.width - 3) / 2;
    _imgView.frame = rcImg;
    
    CGRect rcState = lbState.frame;
    
    rcState.origin.x = rcImg.origin.x + rcImg.size.width + 3;
    rcState.size.width = szState.width;
    lbState.frame = rcState;
    
    if (_nStatus & 0xF000 || _nStatus & 0x0F00)
        _imgView.hidden = NO;
    else
        _imgView.hidden = YES;
    
    if (self.pStockInfo == NULL || self.pStockInfo.stockType <  1)
        _imgView.hidden = YES;
}

@end
