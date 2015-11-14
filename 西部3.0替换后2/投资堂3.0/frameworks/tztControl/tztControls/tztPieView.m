/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztPieView
 * 文件标识：
 * 摘    要：
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/
#if TARGET_OS_IPHONE

#define tztPi   3.15

#import <QuartzCore/QuartzCore.h>
#import "tztPieView.h"

@interface tztArrowLayer : CATextLayer

@property(nonatomic)CGPoint ptCenter;
@property(nonatomic,retain)UIColor *drawColor;
@property(nonatomic)int nPosition;
@end

@implementation tztArrowLayer
@synthesize ptCenter = _ptCenter;
@synthesize drawColor = _drawColor;
@synthesize nPosition = _nPosition;
-(void)drawInContext:(CGContextRef)ctx
{
    UIGraphicsPushContext(ctx);
    [super drawInContext:ctx];
    //抗锯齿效果
    //设置背景颜色
    [[UIColor clearColor] set];
    UIRectFill([self bounds]);
    //利用path进行绘制三角形
    CGContextBeginPath(ctx);//标记
//    CGPoint pt = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    switch (_nPosition)
    {
        case 0://，向右
        {
            CGContextMoveToPoint(ctx, 5, self.frame.origin.y);//设置起点
            CGContextAddLineToPoint(ctx, self.bounds.size.width / 2, self.bounds.size.height-10);
            CGContextAddLineToPoint(ctx, self.bounds.size.width / 2 - 10, self.frame.origin.y);
        }
            break;
        case 3://向右
        {
            CGContextMoveToPoint(ctx, 5, self.frame.origin.y);//设置起点
            CGContextAddLineToPoint(ctx, self.bounds.size.width / 2, self.bounds.size.height);
            CGContextAddLineToPoint(ctx, self.bounds.size.width / 2 - 10, self.frame.origin.y);
        }
            break;
        case 1://向左
        {
            CGContextMoveToPoint(ctx, self.bounds.size.width/2 , self.frame.origin.y);//设置起点
            CGContextAddLineToPoint(ctx, self.bounds.size.width / 2 - 15, self.bounds.origin.y);
            CGContextAddLineToPoint(ctx, self.bounds.size.width / 2 - 5, self.bounds.size.height);
        }
            break;
        case 2://向左
        {
            CGContextMoveToPoint(ctx, 25, self.frame.origin.y);//设置起点
            CGContextAddLineToPoint(ctx, self.bounds.size.width / 2 - 8, self.bounds.origin.y);
            CGContextAddLineToPoint(ctx, self.bounds.size.width / 2 - 13, self.bounds.size.height);
        }
            break;
            
        default:
            break;
    }
    
	CGContextSetAllowsAntialiasing(ctx, TRUE);
    CGContextClosePath(ctx);//路径结束标志，不写默认封闭
    [self.drawColor setFill]; //设置填充色
    [self.drawColor setStroke]; //设置边框颜色
    CGContextDrawPath(ctx, kCGPathFillStroke);//绘制路径path
}
-(void)displayLayer:(CALayer *)layer
{
    [super displayLayer:layer];
}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	//抗锯齿效果
    CGContextRef context = UIGraphicsGetCurrentContext();
    [super drawLayer:layer inContext:ctx];
    
	CGContextSetAllowsAntialiasing(ctx, TRUE);
    //设置背景颜色
    [[UIColor clearColor] set];
    UIRectFill([self bounds]);
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context, 5, 0);//设置起点
    CGPoint pt = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    if (pt.y < _ptCenter.y)//向下箭头
    {
        if (pt.x < _ptCenter.x)//向右
        {
            CGContextAddLineToPoint(context, self.bounds.size.width / 2, self.bounds.size.height);
            CGContextAddLineToPoint(context, self.bounds.size.width / 2 - 10, 0);
        }
        else//向左
        {
            CGContextAddLineToPoint(context, 0, self.bounds.size.height);
            CGContextAddLineToPoint(context, 0 + 5, 0);
        }
    }
    else//向上
    {
        if (pt.x < _ptCenter.x)//向右
        {
            CGContextAddLineToPoint(context, self.bounds.size.width / 2, -self.bounds.size.height);
            CGContextAddLineToPoint(context, self.bounds.size.width / 2 - 10, 0);
        }
        else//向左
        {
            CGContextAddLineToPoint(context, 0, -self.bounds.size.height);
            CGContextAddLineToPoint(context, 0 + 5, 0);
        }
    }
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [self.drawColor setFill]; //设置填充色
    [self.drawColor setStroke]; //设置边框颜色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
	CGContextSetAllowsAntialiasing(context, NO);
}
@end

@interface tztSliceLayer : CAShapeLayer

@property(nonatomic, assign)CGFloat value;
@property(nonatomic, assign)CGFloat percentage;
@property(nonatomic, assign)double  startAngle;
@property(nonatomic, assign)double  endAngle;
@property(nonatomic, assign)BOOL    isSelected;
@property(nonatomic, retain)NSString    *text;
-(void)createArcAnimationForKey:(NSString*)key fromValue:(NSNumber*)from toValue:(NSNumber*)to Delegate:(id)delegate;
@end

@implementation tztSliceLayer
@synthesize value = _value;
@synthesize percentage = _percentage;
@synthesize startAngle = _startAngle;
@synthesize endAngle = _endAngle;
@synthesize isSelected = _isSelected;
@synthesize text = _text;

-(NSString*)tztDescription
{
    return [NSString stringWithFormat:@"value:%f, percentage:%0.2f, start:%f, end:%f", _value, _percentage, _startAngle/M_PI*180, _endAngle/M_PI*180];
}

+(BOOL)needsDisplayForKey:(NSString *)key
{
    if([key isEqualToString:@"startAngle"] || [key isEqualToString:@"tztEndAngle"])
        return YES;
    else
        return [super needsDisplayForKey:key];
}

-(id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer:layer])
    {
        if ([layer isKindOfClass:[tztSliceLayer class]])
        {
            self.startAngle = [(tztSliceLayer*)layer startAngle];
            self.endAngle = [(tztSliceLayer*)layer endAngle];
        }
    }
    return self;
}

-(void)createArcAnimationForKey:(NSString *)key fromValue:(NSNumber *)from toValue:(NSNumber *)to Delegate:(id)delegate
{
    CABasicAnimation *arcAnimation = [CABasicAnimation animationWithKeyPath:key];
    NSNumber *currentAngle = [[self presentationLayer] valueForKey:key];
    if (!currentAngle)
        currentAngle = from;
    
    [arcAnimation setFromValue:currentAngle];
    [arcAnimation setToValue:to];
    [arcAnimation setDelegate:delegate];
    [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:arcAnimation forKey:key];
    [self setValue:to forKey:key];
}

//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//	//抗锯齿效果
//    CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetAllowsAntialiasing(context, TRUE);
//    [super drawLayer:layer inContext:ctx];
//	CGContextSetAllowsAntialiasing(context, NO);
//}
@end

@interface tztPieView(tztPrivate)
-(void)updateTimerFired:(NSTimer*)timer;
-(tztSliceLayer*)createSliceLayer;
-(CGSize)sizeThatFitsString:(NSString*)string;
-(void)updateLabelForLayer:(tztSliceLayer*)pieLayer value:(CGFloat)value;
-(void)nofifyDelegateOfSectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection;
@end

@implementation tztPieView
{
    NSInteger   _nSelectSliceIndex;
    UIView      *_pieView;
    NSTimer     *_animationTimer;
    NSMutableArray *_animations;
}

static NSUInteger tztkDefaultSliceZOrder = 100;

@synthesize tztDataSource = _tztDataSource;
@synthesize tztDelegate = _tztDelegate;
@synthesize fStartPieAngle = _fStartPieAngle;
@synthesize fAnimationSpeed = _fAnimationSpeed;
@synthesize fPieCener = _fPieCenter;
@synthesize fPieRadius = _fPieRadius;
@synthesize bShowLabel = _bShowLabel;
@synthesize labelFont = _labelFont;
@synthesize labelColor = _labelColor;
@synthesize labelShadowColor = _labelShadowColor;
@synthesize fLabelRadius = _fLabelRadius;
@synthesize fSelectedSliceStroke = _fSelectedSliceStroke;
@synthesize fSelectedSliceOffsetRadius = _fSelectedSliceOffsetRadius;
@synthesize bShowPercentage = _bShowPercentage;


static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
    CGPathCloseSubpath(path);
    
    return path;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _pieView = [[UIView alloc] initWithFrame:frame];
        [_pieView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_pieView];
        
        _nSelectSliceIndex = -1;
        _animations = [[NSMutableArray alloc] init];
        
        _fAnimationSpeed = 0.5;
        _fStartPieAngle = M_PI_2*3;
        _fSelectedSliceStroke = 3.0;
        
        self.fPieRadius = MIN(frame.size.width / 2, frame.size.height / 2) - 10;
        self.fPieCener = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        self.labelFont = tztUIBaseViewTextFont(MAX(self.fPieRadius / 10.f,5.f));
        self.labelColor = [UIColor whiteColor];
        _fLabelRadius = _fLabelRadius / 2;
        _fSelectedSliceOffsetRadius = MAX(10, _fPieRadius/10);
        
        _bShowLabel = YES;
        _bShowPercentage = YES;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame Center:(CGPoint)center Rafius:(CGFloat)radius
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.fPieRadius = radius;
        self.fPieCener = center;
    }
    return self;
}

-(void)setFPieCener:(CGPoint)center
{
    [_pieView setCenter:center];
    _fPieCenter = CGPointMake(_pieView.frame.size.width / 2, _pieView.frame.size.height / 2);
}

-(void)setFPieRadius:(CGFloat)radius
{
    _fPieRadius = radius;
    CGRect frame = CGRectMake(_fPieCenter.x - radius, _fPieCenter.y - radius, radius * 2, radius * 2);
    _fPieCenter = CGPointMake(frame.size.width / 2, frame.size.height / 2);
    [_pieView setFrame:frame];
    [_pieView.layer setCornerRadius:_fPieRadius];
}

-(void)addUserSubView:(UIView *)view
{
    if (view == nil)
        return;
    [_pieView addSubview:view];
}

-(void)setPieBackgroudColor:(UIColor *)color
{
    [_pieView setBackgroundColor:color];
}

#pragma mark - manage settings

-(void)setBShowPercentage:(BOOL)bShow
{
    _bShowPercentage = bShow;
    for(tztSliceLayer *layer in _pieView.layer.sublayers)
    {
        CATextLayer *textLayer = [[layer sublayers] objectAtIndex:0];
        [textLayer setHidden:!_bShowLabel];
        if (!_bShowLabel)
            return;
        
        NSString* label;
        if (_bShowPercentage)
            label = [NSString stringWithFormat:@"%.2f%%", layer.percentage*100];
        else
            label = [NSString stringWithFormat:@"%.2f", layer.value];
        
        CGSize size = [label sizeWithFont:self.labelFont];
        if (M_PI*2*_fLabelRadius*layer.percentage < MAX(size.width, size.height))
        {
            [textLayer setString:@""];
        }
        else
        {
            [textLayer setString:layer];
            [textLayer setBounds:CGRectMake(0, 0, size.width, size.height)];
        }
    }
}

#pragma mark - Pie Reload Data With Animation

- (void)reloadData
{
    if (_tztDataSource)
    {
        CALayer *parentLayer = [_pieView layer];
        NSArray *slicelayers = [parentLayer sublayers];
        
        _nSelectSliceIndex = -1;
        [slicelayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            tztSliceLayer *layer = (tztSliceLayer*)obj;
            if (layer.isSelected)
                [self setSliceDeselectedAtIndex:idx];
        }];
        
        double startToAngle = 0.0;
        double endToAngle = startToAngle;
        
        NSUInteger sliceCount = [_tztDataSource numberOfSlicesInPieView:self];
        double sum = 0.0;
        
        double values[sliceCount];
        
        //计算总数
        for (int index = 0; index < sliceCount; index++)
        {
            values[index] = [_tztDataSource tztPieView:self valueForSliceAtIndex:index];
            sum += values[index];
        }
        
        //计算比例
        double angles[sliceCount];
        for (int index = 0; index < sliceCount; index++)
        {
            double div;
            if (sum == 0)
                div = 0;
            else
                div = values[index] / sum;
            
            angles[index] = M_PI * 2 * div;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:_fAnimationSpeed];//
        
        [_pieView setUserInteractionEnabled:NO];
        
        __block NSMutableArray *layersToRemove = nil;
        BOOL isOnStart = ([slicelayers count] == 0 && sliceCount);
        NSInteger diff = sliceCount - [slicelayers count];
        layersToRemove = [NSMutableArray arrayWithArray:slicelayers];
        
        BOOL isOnEnd = ([slicelayers count] && (sliceCount == 0 || sum == 0));
        if (isOnEnd)
        {
            for (int index = 0; index < sliceCount; index++)
            {
                tztSliceLayer *layer;
                layer = [slicelayers objectAtIndex:index];
                [self updateLabelForLayer:layer value:0];
                
                CATextLayer *textLayer = [[layer sublayers] objectAtIndex:0];
                [textLayer setHidden:!_bShowLabel];
                CATextLayer *textLayerEx = [[textLayer sublayers] objectAtIndex:0];
                tztArrowLayer* arrLayer = [[textLayer sublayers] objectAtIndex:1];
                [textLayer setHidden:(sum <= 0||values[index] <= 0.001)];
                [textLayerEx setHidden:(sum <= 0||values[index] <= 0.001)];
                [arrLayer setHidden:(sum <= 0||values[index] <= 0.001)];
                
                [layer createArcAnimationForKey:@"startAngle"
                                      fromValue:[NSNumber numberWithDouble:_fStartPieAngle]
                                        toValue:[NSNumber numberWithDouble:_fStartPieAngle]
                                       Delegate:self];
                [layer createArcAnimationForKey:@"endAngle"
                                      fromValue:[NSNumber numberWithDouble:_fStartPieAngle]
                                        toValue:[NSNumber numberWithDouble:_fStartPieAngle]
                                       Delegate:self];
                
            }
            [CATransaction commit];
            return;
        }
        
        for (int index = 0; index < sliceCount; index++)
        {
            tztSliceLayer *layer;
            double angle = angles[index];
            endToAngle += angle;
            double startFromAngle = _fStartPieAngle + startToAngle;
            double endFromAngle = _fStartPieAngle + endToAngle;
            
            if (index >= [slicelayers count])
            {
                layer = [self createSliceLayer];
                if (isOnStart)
                    startFromAngle = endFromAngle = _fStartPieAngle;
                
                [parentLayer addSublayer:layer];
                diff--;
            }
            else
            {
                tztSliceLayer *onelayer = [slicelayers objectAtIndex:index];
                if (diff == 0 || onelayer.value == (CGFloat)values[index])
                {
                    layer = onelayer;
                    [layersToRemove removeObject:layer];
                }
                else if (diff > 0)
                {
                    layer = [self createSliceLayer];
                    [parentLayer insertSublayer:layer atIndex:index];
                    diff--;
                }
                else if (diff < 0)
                {
                    while (diff < 0)
                    {
                        [onelayer removeFromSuperlayer];
                        [parentLayer addSublayer:onelayer];
                        diff++;
                        onelayer = [slicelayers objectAtIndex:index];
                        if (onelayer.value == (CGFloat)values[index] || diff == 0)
                        {
                            layer = onelayer;
                            [layersToRemove removeObject:layer];
                            break;
                        }
                    }
                }
            }
            
            layer.value = values[index];
            layer.percentage = (sum)?layer.value/sum:0;
            UIColor *color = nil;
            if ([_tztDataSource respondsToSelector:@selector(tztPieView:colorForSliceAtIndex:)])
            {
                color = [_tztDataSource tztPieView:self colorForSliceAtIndex:index];
            }
            
            if (!color)
            {
                color = [UIColor colorWithHue:((index/8)%20)/20.0+0.02 saturation:(index%8+3)/10.0 brightness:91/100.0 alpha:1];
            }
            
            [layer setFillColor:color.CGColor];
            if ([_tztDataSource respondsToSelector:@selector(tztPieChart:textForSliceAtIndex:)])
            {
                layer.text = [_tztDataSource tztPieChart:self textForSliceAtIndex:index];
            }
            
            [self updateLabelForLayer:layer value:values[index]];
            
            
            CATextLayer *textLayer = [[layer sublayers] objectAtIndex:0];
            [textLayer setHidden:!_bShowLabel];
            CATextLayer *textLayerEx = [[textLayer sublayers] objectAtIndex:0];
            tztArrowLayer* arrLayer = [[textLayer sublayers] objectAtIndex:1];
            
            [textLayer setHidden:(sum <= 0 || values[index] <= 0.001)];
            [textLayerEx setHidden:(sum <= 0 || values[index] <= 0.001)];
            [arrLayer setHidden:(sum <= 0|| values[index] <= 0.001)];
            
            if (layer.percentage*100 < 1)
            {
                [textLayer setHidden:YES];
                [textLayerEx setHidden:YES];
                [arrLayer setHidden:YES];
            }
            
            if(_bShowLabel && sum > 0)
            {
//                CATextLayer *textLayerEx = [[textLayer sublayers] objectAtIndex:0];
                [textLayerEx setString:layer.text];
                textLayer.backgroundColor = color.CGColor;
                
                if (_bShowInfo)
                {
//                    tztArrowLayer* arrLayer = [[textLayer sublayers] objectAtIndex:1];
                    arrLayer.ptCenter = _fPieCenter;
                    arrLayer.drawColor = color;
                    if (endToAngle <= (tztPi/2))//第四区间，上、右
                    {
                        arrLayer.nPosition = 0;
                        [textLayerEx setPosition:CGPointMake(0, 0)];
                        arrLayer.position = CGPointMake(0, arrLayer.frame.size.height);
                    }
                    else if (endToAngle <= tztPi)//第一区间，上、左
                    {
                        if (startToAngle <= (tztPi/4))//
                        {
                            arrLayer.nPosition = 0;
                            if (endToAngle >= tztPi/4 * 3)
                                arrLayer.nPosition = 1;
                        }
                        else
                        {
                            arrLayer.nPosition = 1;
                        }
                        [textLayerEx setPosition:CGPointMake(0, 0)];
                        arrLayer.position = CGPointMake(0, arrLayer.frame.size.height);
                    }
                    else//下、右
                    {
//                        CGRect rc = textLayerEx.frame;
                        if (startToAngle <= tztPi / 2)
                            arrLayer.nPosition = 1;
                        else if (startToAngle <= tztPi)
                        {
                            arrLayer.position = CGPointMake(0, -arrLayer.frame.size.height);
                            arrLayer.nPosition  = 2;
                        }
                        else/* if (startToAngle <= (tztPi / 2 * 3) + 0.1)*/
                        {
                            arrLayer.position = CGPointMake(0, -arrLayer.frame.size.height);
                            arrLayer.nPosition = 3;
                        }
                        [textLayerEx setPosition:CGPointMake(0, textLayerEx.frame.size.height * 2 + 5)];
                        
                    }
                    
                    [arrLayer setNeedsDisplay];
                }
            }
            
            
            [layer createArcAnimationForKey:@"startAngle"
                                  fromValue:[NSNumber numberWithDouble:startFromAngle]
                                    toValue:[NSNumber numberWithDouble:startToAngle+_fStartPieAngle]
                                   Delegate:self];
            [layer createArcAnimationForKey:@"endAngle"
                                  fromValue:[NSNumber numberWithDouble:endFromAngle]
                                    toValue:[NSNumber numberWithDouble:endToAngle+_fStartPieAngle]
                                   Delegate:self];
            
            startToAngle = endToAngle;
        }
        [CATransaction setDisableActions:YES];
        
        for (tztSliceLayer *layer in layersToRemove)
        {
            [layer setFillColor:[self backgroundColor].CGColor];
            [layer setDelegate:nil];
            [layer setZPosition:0];
            CATextLayer *textLayer = [[layer sublayers] objectAtIndex:0];
            if (layer.sublayers.count > 1)
            {
                CATextLayer *textLayerEx = [[layer sublayers] objectAtIndex:1];
                [textLayer setHidden:YES];
                [textLayerEx setHidden:YES];
            }
        }
        
        [layersToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [obj removeFromSuperlayer];
        }];
        
        [layersToRemove removeAllObjects];
        
        for (tztSliceLayer *layer in _pieView.layer.sublayers)
        {
            [layer setZPosition:tztkDefaultSliceZOrder];
        }
        
        [_pieView setUserInteractionEnabled:YES];
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }
}


#pragma mark - Animation Delegate + Run Loop Timer

-(void)updateTimerFired:(NSTimer *)timer
{
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    [pieLayers enumerateObjectsUsingBlock:^(CAShapeLayer * obj, NSUInteger idx, BOOL *stop)
     {
         NSNumber *presentationLayerStartAngle = [[obj presentationLayer] valueForKey:@"startAngle"];
         CGFloat interpolatedStartAngle = [presentationLayerStartAngle doubleValue];
         
         NSNumber *presentationLayerEndAngle = [[obj presentationLayer] valueForKey:@"endAngle"];
         CGFloat interpolatedEndAngle = [presentationLayerEndAngle doubleValue];
         
         CGPathRef path = CGPathCreateArc(_fPieCenter, _fPieRadius, interpolatedStartAngle, interpolatedEndAngle);
         [obj setPath:path];
         CFRelease(path);
         
         {
             CALayer *labelLayer = [[obj sublayers] objectAtIndex:0];
             CGFloat interpolatedMidAngle = (interpolatedEndAngle + interpolatedStartAngle) / 2;
             [CATransaction setDisableActions:YES];
             [labelLayer setPosition:CGPointMake(_fPieCenter.x + (_fLabelRadius * cos(interpolatedMidAngle)), _fPieCenter.y + (_fLabelRadius * sin(interpolatedMidAngle)))];
             [CATransaction setDisableActions:NO];
         }
     }];
}

-(void)animationDidStart:(CAAnimation *)anim
{
    if (_animationTimer == nil)
    {
        static float timeInterval = 1.0/60.0;
        
        _animationTimer = [NSTimer timerWithTimeInterval:timeInterval
                                                  target:self
                                                selector:@selector(updateTimerFired:)
                                                userInfo:nil
                                                 repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
    }
    [_animations addObject:anim];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_animations removeObject:anim];
    if ([_animations count] == 0)
    {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
}

#pragma mark - Touch Handing (Selection Notification)
-(NSInteger)getCurrentSelectedOnTouch:(CGPoint)point
{
    __block NSUInteger selectedIndex = -1;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    [pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         tztSliceLayer *pieLayer = (tztSliceLayer *)obj;
         CGPathRef path = [pieLayer path];
         
         if (CGPathContainsPoint(path, &transform, point, 0))
         {
             [pieLayer setLineWidth:_fSelectedSliceStroke];
             [pieLayer setStrokeColor:[UIColor whiteColor].CGColor];
             [pieLayer setLineJoin:kCALineJoinBevel];
             [pieLayer setZPosition:MAXFLOAT];
             selectedIndex = idx;
         }
         else
         {
             [pieLayer setZPosition:tztkDefaultSliceZOrder];
             [pieLayer setLineWidth:0.0];
         }
     }];
    return selectedIndex;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_pieView];
    [self getCurrentSelectedOnTouch:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_pieView];
    NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
    [self notifyDelegateOfSelectionChangeFrom:_nSelectSliceIndex to:selectedIndex];
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    CALayer *parentLayer = [_pieView layer];
    NSArray *pieLayers = [parentLayer sublayers];
    
    for (tztSliceLayer *pieLayer in pieLayers)
    {
        [pieLayer setZPosition:tztkDefaultSliceZOrder];
        [pieLayer setLineWidth:0.0];
    }
}

#pragma mark - Selection Notification

- (void)notifyDelegateOfSelectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection
{
    if (previousSelection != newSelection)
    {
        if (previousSelection != -1 && [_tztDelegate respondsToSelector:@selector(tztPieView:willDeselectSliceAtIndex:)])
        {
            [_tztDelegate tztPieView:self willDeselectSliceAtIndex:previousSelection];
        }
        
        _nSelectSliceIndex = newSelection;
        
        if (newSelection != -1)
        {
            if ([_tztDelegate respondsToSelector:@selector(tztPieView:willSelectSlictAtIndex:)])
                [_tztDelegate tztPieView:self willSelectSlictAtIndex:newSelection];
            if(previousSelection != -1 && [_tztDelegate respondsToSelector:@selector(tztPieView:didDeselectSliceAtIndex:)])
                [_tztDelegate tztPieView:self didDeselectSliceAtIndex:previousSelection];
            if([_tztDelegate respondsToSelector:@selector(tztPieView:didSelectSliceAtIndex:)])
                [_tztDelegate tztPieView:self didSelectSliceAtIndex:newSelection];
            [self setSliceSelectedAtIndex:newSelection];
        }
        
        if(previousSelection != -1)
        {
            [self setSliceDeselectedAtIndex:previousSelection];
            if([_tztDelegate respondsToSelector:@selector(tztPieView:didDeselectSliceAtIndex:)])
                [_tztDelegate tztPieView:self didDeselectSliceAtIndex:previousSelection];
        }
    }
    else if (newSelection != -1)
    {
        tztSliceLayer *layer = [_pieView.layer.sublayers objectAtIndex:newSelection];
        if(_fSelectedSliceOffsetRadius > 0 && layer)
        {
            if (layer.isSelected)
            {
                if ([_tztDelegate respondsToSelector:@selector(tztPieView:willDeselectSliceAtIndex:)])
                    [_tztDelegate tztPieView:self willDeselectSliceAtIndex:newSelection];
                [self setSliceDeselectedAtIndex:newSelection];
                if (newSelection != -1 && [_tztDelegate respondsToSelector:@selector(tztPieView:didDeselectSliceAtIndex:)])
                    [_tztDelegate tztPieView:self didDeselectSliceAtIndex:newSelection];
            }
            else {
                if ([_tztDelegate respondsToSelector:@selector(tztPieView:willSelectSliceAtIndex:)])
                    [_tztDelegate tztPieView:self willSelectSlictAtIndex:newSelection];
                [self setSliceSelectedAtIndex:newSelection];
                if (newSelection != -1 && [_tztDelegate respondsToSelector:@selector(tztPieView:didSelectSliceAtIndex:)])
                    [_tztDelegate tztPieView:self didSelectSliceAtIndex:newSelection];
            }
        }
    }
}
#pragma mark - Selection Programmatically Without Notification

-(void)setSliceSelectedAtIndex:(NSUInteger)nIndex
{
    if (_fSelectedSliceOffsetRadius <= 0)
        return;
    
    tztSliceLayer* layer = [_pieView.layer.sublayers objectAtIndex:nIndex];
    if (layer && !layer.isSelected)
    {
        CGPoint currPos = layer.position;
        double middleAngle = (layer.startAngle + layer.endAngle) / 2.0;
        CGPoint newPos = CGPointMake(currPos.x + _fSelectedSliceOffsetRadius * cos(middleAngle), currPos.y + _fSelectedSliceOffsetRadius * sin(middleAngle));
        layer.position = newPos;
        layer.isSelected = YES;
    }
}

-(void)setSliceDeselectedAtIndex:(NSUInteger)nIndex
{
    if (_fSelectedSliceOffsetRadius <= 0)
        return;
    tztSliceLayer *layer = [_pieView.layer.sublayers objectAtIndex:nIndex];
    if (layer && layer.isSelected)
    {
        layer.position = CGPointMake(0, 0);
        layer.isSelected = NO;
    }
}

#pragma mark - Pie Layer Creation Method

-(tztSliceLayer*)createSliceLayer
{
    tztSliceLayer *pieLayer = [tztSliceLayer layer];
    pieLayer.borderWidth = 2.0;
    pieLayer.borderColor = [UIColor grayColor].CGColor;
    [pieLayer setZPosition:0];
    [pieLayer setStrokeColor:NULL];
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    CGFontRef font = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        font = CGFontCreateCopyWithVariations((__bridge CGFontRef)(self.labelFont), (__bridge CFDictionaryRef)(@{}));
    } else {
        font = CGFontCreateWithFontName((__bridge CFStringRef)[self.labelFont fontName]);
    }
    if (font) {
        [textLayer setFont:font];
        CFRelease(font);
    }
    [textLayer setFontSize:self.labelFont.pointSize];
    [textLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setBackgroundColor:[UIColor clearColor].CGColor];
    if (self.labelShadowColor) {
        [textLayer setShadowColor:self.labelShadowColor.CGColor];
        [textLayer setShadowOffset:CGSizeZero];
        [textLayer setShadowOpacity:.0f];
        [textLayer setShadowRadius:0.5f];
    }
    CGSize size = [@"100%\r\n主力流入" sizeWithFont:self.labelFont];
    [CATransaction setDisableActions:YES];
    [textLayer setFrame:CGRectMake(0, 0, size.width, size.height)];
    [textLayer setPosition:CGPointMake(_fPieCenter.x + (_fLabelRadius * cos(0)), _fPieCenter.y + (_fLabelRadius * sin(0)))];
    [CATransaction setDisableActions:NO];
    [pieLayer addSublayer:textLayer];
    
    
    if (!_bShowInfo)
        return pieLayer;
    //名称
    CATextLayer *textLayName = [CATextLayer layer];
    
    textLayName.contentsScale = [UIScreen mainScreen].scale;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        font = CGFontCreateCopyWithVariations((__bridge CGFontRef)(self.labelFont), (__bridge CFDictionaryRef)(@{}));
    } else {
        font = CGFontCreateWithFontName((__bridge CFStringRef)[self.labelFont fontName]);
    }
    if (font) {
        [textLayName setFont:font];
        CFRelease(font);
    }
    
    [textLayName setFontSize:12.f];
    [textLayName setAnchorPoint:CGPointMake(0, 1)];
    [textLayName setAlignmentMode:kCAAlignmentCenter];
    [textLayName setBackgroundColor:[UIColor clearColor].CGColor];
    
    size = [@"主力流入" sizeWithFont:self.labelFont];
    [textLayName setForegroundColor:[UIColor grayColor].CGColor];
    [CATransaction setDisableActions:YES];
    [textLayName setFrame:CGRectMake(textLayer.frame.origin.x, 0, size.width, size.height)];
    [textLayName setPosition:CGPointMake(0, size.height)];
    [CATransaction setDisableActions:NO];
    [textLayer addSublayer:textLayName];
    
    
    //箭头
    tztArrowLayer *arrowLayer = [tztArrowLayer layer];
    [arrowLayer setFontSize:12.f];
    [arrowLayer setAnchorPoint:CGPointMake(0, 0)];
    [arrowLayer setAlignmentMode:kCAAlignmentCenter];
    [arrowLayer setBackgroundColor:[UIColor clearColor].CGColor];
    
    size = [@"主力流入" sizeWithFont:self.labelFont];
    [arrowLayer setForegroundColor:[UIColor grayColor].CGColor];
    [CATransaction setDisableActions:YES];
    [arrowLayer setFrame:CGRectMake(0, 0, size.width, size.height)];
    [arrowLayer setPosition:CGPointMake(0, size.height)];
    [CATransaction setDisableActions:NO];
    [textLayer addSublayer:arrowLayer];
    
    return pieLayer;
}

- (void)updateLabelForLayer:(tztSliceLayer *)pieLayer value:(CGFloat)value
{
    CATextLayer *textLayer = [[pieLayer sublayers] objectAtIndex:0];
    [textLayer setHidden:!_bShowLabel];
    if(!_bShowLabel)
        return;
    NSString *label;
    if(_bShowPercentage)
        label = [NSString stringWithFormat:@"%0.0f%%", pieLayer.percentage*100];
    else
        label = [NSString stringWithFormat:@"%0.0f", value];
    CGSize size = [label sizeWithFont:self.labelFont];
    size.width += 10;
    size.height += 2;
    
    textLayer.hidden = NO;
    [CATransaction setDisableActions:YES];
    if(/*M_PI*2*_fLabelRadius*pieLayer.percentage < MAX(size.width,size.height) || */value <= 0 || pieLayer.percentage*100 < 1)
    {
        [textLayer setString:@""];
        textLayer.hidden = YES;
    }
    else
    {
        [textLayer setString:label];
        [textLayer setBounds:CGRectMake(0, 0, size.width, size.height)];
    }
    
    [CATransaction setDisableActions:NO];
}
@end

#endif