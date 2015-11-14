/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztTradeSegment
 * 文件标识：
 * 摘    要：   交易标题栏栏目切换view
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

#import "tztTradeSegment.h"

#define tztTradeItemWidth 100
#define tztButtonTag 0x3000
#define tztTradeListCount 9
@interface tztTradeSegment()
{
    
    NSMutableArray      *_ayButtons;
    NSInteger     _nPreIndex;
}

@end

@implementation tztTradeSegment
@synthesize tztdelegate = _tztdelegate;
@synthesize nPreIndex = _nPreIndex;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initdata];
    }
    return self;
}

-(void)initdata
{
    _ayButtons = NewObject(NSMutableArray);
    _nPreIndex = 0;
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"tztTradeSegmentBg.png"]];
}

-(void)dealloc
{
    DelObject(_ayButtons);
    [super dealloc];
}


-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
//zxl 20130927 由原来的 UISegmentedControl 改成了现在的按钮队列
    if ([_ayButtons count] > 0)
    {
        CGRect btnFrame = frame;
        btnFrame.size.height -= 5;
        btnFrame.origin = CGPointZero;
        btnFrame.size.width = frame.size.width / tztTradeListCount;
        for (int i = 0; i < [_ayButtons count]; i++)
        {
            UIButton * Button = (UIButton *)[self viewWithTag:tztButtonTag + i];
            btnFrame.origin.x = i*(frame.size.width / tztTradeListCount);
            if (Button == NULL)
            {
                Button = [UIButton buttonWithType:UIButtonTypeCustom];
                [Button addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
                Button.tag = tztButtonTag + i;
                Button.showsTouchWhenHighlighted = YES;
                Button.frame = btnFrame;
                [self addSubview:Button];
            }else
                Button.frame = btnFrame;
        }
        [self OnButton:(UIButton *)[self viewWithTag:tztButtonTag + self.nPreIndex]];
    }
    
    //zxl 20131011 添加了新的界面中的下面的颜色条
    UIView *lineview = [self viewWithTag:0x10000];
    CGRect lineframe = CGRectMake(0, frame.size.height - 5, frame.size.width, 5);
    if (lineview == NULL)
    {
        lineview = [[UIView alloc] initWithFrame:lineframe];
        lineview.backgroundColor = [UIColor colorWithTztRGBStr:@"255,64,0"];
        [self addSubview:lineview];
        [lineview release];
    }else
    {
        lineview.frame = lineframe;
    }
}

-(void)setJyType:(int)nType
{
    if (nType <= 0)
        return;
    
    for (int i = 0; i < [_ayButtons count]; i++)
    {
        NSMutableDictionary *pDict = [_ayButtons objectAtIndex:i];
        NSString *strIDType = [pDict objectForKey:tztTradeSegmentID];
        if ([strIDType intValue] == nType)
        {
            self.nPreIndex = i;
        }
    }
}
-(void)OnButton:(id)sender
{
    UIButton * button = (UIButton *)sender;
    NSInteger  nIndex= button.tag - tztButtonTag;
    NSMutableDictionary *pDict = [_ayButtons objectAtIndex:nIndex];
    
    BOOL bSelect = TRUE;
    NSInteger PreIndex = _nPreIndex;
    _nPreIndex = nIndex;
    if (_tztdelegate)
    {
        if ([_tztdelegate respondsToSelector:@selector(tztTradeSegment:ShouldSelectAtIndex:)])
        {
            bSelect = [_tztdelegate tztTradeSegment:self ShouldSelectAtIndex:pDict];
        }
        
        if (bSelect)
        {
            if ( [_tztdelegate respondsToSelector:@selector(tztTradeSegment:OnSelectAtIndex:)])
                [_tztdelegate tztTradeSegment:self OnSelectAtIndex:pDict];
        }else
        {
            _nPreIndex = PreIndex;
        }
    }    
    [self SetButtonBG];
}

-(void)SetButtonBG
{
    //zxl 20131011 修改了按钮的设置图片直接设置配置中的图片名称
    for (int i = 0; i < [_ayButtons count]; i++)
    {
        UIButton * Button = (UIButton *)[self viewWithTag:tztButtonTag + i];
        if (Button)
        {
            NSMutableDictionary *pDict = [_ayButtons objectAtIndex:i];
            NSString *strName = [pDict objectForKey:tztTradeSegmentName];
            if (_nPreIndex == i)
            {
                NSString *strIndexSelBg = [pDict objectForKey:tztTradeSegmentBtnSelBg];
                if (strIndexSelBg&& [strIndexSelBg length])
                    [Button setTztBackgroundImage:[UIImage imageTztNamed:strIndexSelBg]];
                else
                    [Button setTztTitle:strName];
            }else
            {
                NSString *strIndexBg = [pDict objectForKey:tztTradeSegmentBtnOnBg];
                if (strIndexBg&& [strIndexBg length])
                    [Button setTztBackgroundImage:[UIImage imageTztNamed:strIndexBg]];
                else
                    [Button setTztTitle:strName];
            }
        }
    }
}
//zxl 20131012 添加了获取当前交易类型的按钮信息
-(NSMutableDictionary *)GetCurIndexJYDict
{
    if (self.nPreIndex >= 0 && self.nPreIndex < [_ayButtons count])
    {
        return [_ayButtons objectAtIndex:self.nPreIndex];
    }
    return nil;
}
-(void)setItems:(NSMutableArray *)ayItems
{
    if (_ayButtons == NULL)
        _ayButtons = NewObject(NSMutableArray);
    
    for (int i = 0; i < [_ayButtons count]; i++)
    {
        UIView *pView = [_ayButtons objectAtIndex:i];
        if (pView && [pView respondsToSelector:@selector(removeFromSuperview)])
        {
            [pView removeFromSuperview];
        }
    }
    [_ayButtons removeAllObjects];
    
    for (int i = 0; i < [ayItems count]; i++)
    {
        NSString *strValue = [ayItems objectAtIndex:i];
        if (strValue == NULL)
            return;
        NSArray *ay = [strValue componentsSeparatedByString:@"|"];
        if (ay == NULL || [ay count] < 4)
            continue;
        
        NSString* nsOnBg = [ay objectAtIndex:0];
        NSString* nsSelBg = [ay objectAtIndex:1];
        NSString* nsTitle = [ay objectAtIndex:2];
        NSString* nsID = [ay objectAtIndex:3];
        NSString* nsProfile = [ay objectAtIndex:4];
        if (nsTitle == NULL)
            nsTitle = @"";
        if (nsID == NULL)
            nsID = @"";
        if (nsProfile == NULL)
            nsProfile = @"";
        
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        [pDict setTztObject:nsOnBg forKey:tztTradeSegmentBtnOnBg];
        [pDict setTztObject:nsSelBg forKey:tztTradeSegmentBtnSelBg];
        [pDict setTztObject:nsTitle forKey:tztTradeSegmentName];
        [pDict setTztObject:nsID    forKey:tztTradeSegmentID];
        [pDict setTztObject:nsProfile forKey:tztTradeSegmentPro];
        
        [_ayButtons addObject:pDict];
        DelObject(pDict);
    }
}
@end
