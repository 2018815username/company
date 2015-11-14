/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTGridDataObj.m
 * 文件标识：
 * 摘    要：自定义Grid数据 (标题、数据)
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 *
 *******************************************************************************/


#import "TZTGridDataObj.h"
@interface TZTGridDataTitle (tztPrivate)
- (void)initdata;
@end

@implementation TZTGridDataTitle
@synthesize tag = _tag;//tag
@synthesize	text = _text;//名称
@synthesize textColor = _textColor;
@synthesize width = _width;
@synthesize enabled = _enabled;
@synthesize order = _order;

- (id)init
{
    self = [super init];
    if(self)
    {
        [self initdata];
    }
    return self;
}

- (void)initdata
{
    self.tag = -1;
    self.text = @"";
    self.textColor = [UIColor blackColor];
    self.width = 0.f;
    self.enabled = FALSE;
    self.order = 0;
}

- (void)dealloc
{
    self.tag = 0;
    NilObject(self.text);
    NilObject(self.textColor);
    self.width = 0.f;
    self.enabled = FALSE;
    self.order = 0;
    [super dealloc];
}

- (void)setTagValue
{
    //0涨幅1振幅2成交量3量比4总金额5委比6换手率7原序 8最新价 9不排序(Direction无效)
    if([_text compare:@"名称"] == NSOrderedSame 
       || [_text compare:@"股票简称"] == NSOrderedSame)
    {
        self.enabled = TRUE;
        self.tag = 7;
    }
    else if([_text compare:@"幅度"] == NSOrderedSame 
            || [_text compare:@"今日涨幅"] == NSOrderedSame
            || [_text compare:@"今日跌幅"] == NSOrderedSame
            || [_text compare:@"幅度"] == NSOrderedSame
            || [_text compare:@"涨幅"] == NSOrderedSame
            || [_text compare:@"涨跌幅"] == NSOrderedSame)
    {
        self.enabled = TRUE;
        self.tag = 0;
    }
    else if([_text compare:@"振幅"] == NSOrderedSame )
    {
        self.enabled = TRUE;
        self.tag = 1;
    }
    else if([_text compare:@"总手"] == NSOrderedSame
            || [_text compare:@"总量"] == NSOrderedSame)
    {
        self.enabled = TRUE;
        self.tag = 2;
    }
    else if([_text compare:@"量比"] == NSOrderedSame )
    {
        self.enabled = TRUE;
        self.tag = 3;
    }
    else if([_text compare:@"总额"] == NSOrderedSame )
    {
        self.enabled = TRUE;
        self.tag = 4;
    }
    else if([_text compare:@"委比"] == NSOrderedSame )
    {
        self.enabled = TRUE;
        self.tag = 5;
    }
    else if([_text compare:@"换手"] == NSOrderedSame
            || [_text compare:@"换手率"] == NSOrderedSame )
    {
        self.enabled = TRUE;
        self.tag = 6;
    }
    else if([_text compare:@"最新"] == NSOrderedSame
            || [_text compare:@"现价"] == NSOrderedSame)
    {
        self.enabled = TRUE;
        self.tag = 8;
    }
    else if([_text compare:@"买入人数"] == NSOrderedSame 
            || [_text compare:@"卖出人数"] == NSOrderedSame
            || [_text compare:@"关注人数"] == NSOrderedSame
            || [_text compare:@"上涨天数"] == NSOrderedSame
            || [_text compare:@"下跌天数"] == NSOrderedSame
            || [_text compare:@"总涨幅"] == NSOrderedSame
            || [_text compare:@"总跌幅"] == NSOrderedSame
            )
    {
        self.enabled = TRUE;
        self.tag = 7;
    }
    else if ([_text compare:@"净流入"] == NSOrderedSame)
    {
        self.enabled = TRUE;
        self.tag = 41;
    }
    else if ([_text compare:@"增仓比例"] == NSOrderedSame
             || [_text compare:@"增仓占比"] == NSOrderedSame)
    {
        self.enabled = TRUE;
        self.tag = 50;
    }
    else if ([_text compare:@"排名"] == NSOrderedSame)
    {
        self.enabled = TRUE;
        self.tag = 60;
    }
    else if ([_text compare:@"3日涨幅"] == NSOrderedSame)
    {
        self.enabled = TRUE;
        self.tag = 72;
    }
    else if ([_text compare:@"10日涨幅"] == NSOrderedSame)
    {
        self.enabled = TRUE;
        self.tag = 73;
    }
    else
    {
        self.enabled = FALSE;
        self.tag = -1;
    }
}
@end

@interface TZTGridData (tztPrivate)
- (void)initdata;
@end

@implementation TZTGridData

@synthesize text=_text;
@synthesize textColor = _textColor;
@synthesize cChanged = _cChanged;

- (id)init
{
    self = [super init];
    if(self)
    {
        [self initdata];
    }
    return self;
}

- (void)initdata
{
    self.text = @"";
    self.textColor = [UIColor whiteColor];
    self.cChanged = FALSE;
}

- (void)dealloc
{
    NilObject(self.text);
    NilObject(self.textColor);
    self.cChanged = FALSE;
    [super dealloc];
}

@end

