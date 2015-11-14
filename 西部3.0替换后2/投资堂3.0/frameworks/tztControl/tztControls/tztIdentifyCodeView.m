/*
 自动生成验证码，并且提供接口进行校验返回校验结果
 */
#import "tztIdentifyCodeView.h"

@interface tztIdentifyCodeView()<UIGestureRecognizerDelegate>

@property(nonatomic,assign)NSInteger nLength;
@property(nonatomic,assign)BOOL      bJustNumber;
/**
 *    @author yinjp
 *
 *    @brief  点击手势
 */
@property(nonatomic,retain)UITapGestureRecognizer *tap;

/**
 *    @author yinjp
 *
 *    @brief  生成的验证码
 */
@property(nonatomic,retain)NSString               *nsCode;
@end

@implementation tztIdentifyCodeView
-(id)init
{
    if (self = [super init])
    {
        if (_tap == nil)
        {
            _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tztRefresh)];
            [self addGestureRecognizer:_tap];
            [_tap release];
        }
        _nLength = 5;
        _bJustNumber = NO;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        if (_tap == nil)
        {
            _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tztRefresh)];
            [self addGestureRecognizer:_tap];
            [_tap release];
        }
        _nLength = 5;
        _bJustNumber = NO;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andLen:(NSInteger)nLen bJustNumber:(BOOL)bJustNumber
{
    if ([self initWithFrame:frame])
    {
        _nLength = nLen;
        _bJustNumber = bJustNumber;
    }
    return self;
}

-(void)tztRefresh
{
    // @{
    // @name 生成背景色
    if (self.clBackground)
    {
        [self setBackgroundColor:self.clBackground];
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    char data[_nLength];
    for (NSInteger x = 0; x < _nLength; x++)
    {
        if (_bJustNumber)
        {
            int j = '0' + (arc4random_uniform(10));
            data[x] = (char)j;
        }
        else
        {
            int j = '0' + (arc4random_uniform(75));
            if((j >= 58 && j <= 64) || (j >= 91 && j <= 96))
            {
                --x;
            }
            else
            {
                data[x] = (char)j;
            }
        }
    }
    NSString *text = [[NSString alloc] initWithBytes:data
                                              length:_nLength encoding:NSUTF8StringEncoding];
    self.nsCode = text;
    CGSize cSize = [@"S" sizeWithFont:[UIFont boldSystemFontOfSize:18]];
    int width = self.frame.size.width / text.length - cSize.width;
    int height = self.frame.size.height - cSize.height;
    CGPoint point;
    float pX, pY;
    for (NSInteger i = 0, count = text.length; i < count; i++)
    {
        pX = arc4random() % width + self.frame.size.width / text.length * i - 1;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, pY,
                                                       self.frame.size.width / 4,
                                                       self.frame.size.height - 12)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        // 字体颜色
        float red = arc4random() % 150 / 150.0;
        float green = arc4random() % 50 / 150.0;
        float blue = arc4random() % 100 / 150.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetFillColorWithColor(context, color.CGColor);
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        
        [textC drawInRect:CGRectMake(pX + (self.frame.size.width/4 - cSize.width) / 2,
                                     pY,
                                     self.frame.size.width / 4,
                                     self.frame.size.height - 12)
                 withFont:[UIFont boldSystemFontOfSize:18]];
//        
//        tempLabel.textColor = color;
//        tempLabel.text = textC;
//        [self addSubview:tempLabel];
    }
    
    // 干扰线
    CGContextSetLineWidth(context, .5f);
    
    
    CGFloat  lengths[] = {arc4random()%3,arc4random()%5,arc4random()%7,arc4random()%3,arc4random()%4};
    CGContextSetLineDash(context, 0, lengths, 5);
    for(int i = 0; i < 8; i++) {
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        float pX = arc4random() % (int)self.frame.size.width;
        float pY = arc4random() % (int)self.frame.size.height;
        CGContextMoveToPoint(context, pX, pY);
        float pXE = arc4random() % (int)self.frame.size.width;
        float pYE = arc4random() % (int)self.frame.size.height;
        
        CGContextAddLineToPoint(context, pXE, pYE);
        CGContextStrokePath(context);
    }
    return;
}

-(BOOL)isValid:(NSString *)nsData
{
    if (nsData.length <= 0)
        return FALSE;
    if ([self.nsCode caseInsensitiveCompare:nsData] == NSOrderedSame)
        return TRUE;
    return FALSE;
}
@end
