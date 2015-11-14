/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztStockInfo.m
 * 文件标识：
 * 摘    要：股票信息
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

#import "tztStockInfo.h"

@implementation tztStockInfo
@synthesize stockCode = _stockCode;
@synthesize stockName = _stockName;
@synthesize stockType = _stockType;
-(id)init
{
    self = [super init];
    if (self)
    {
        self.stockCode = @"";
        self.stockName = @"";
        self.stockType = 0;
    }
    return self;
}

-(void)dealloc
{
    NilObject(self.stockCode);
    NilObject(self.stockName);
    self.stockType = 0;
    [super dealloc];
}

- (BOOL)isVaildStock
{
    return (self.stockCode && [self.stockCode length] > 0); 
}

-(NSMutableDictionary*)GetStockDict
{
    NSMutableDictionary* pDict = NewObject(NSMutableDictionary);   
    if (self.stockName)
        [pDict setTztValue:self.stockName forKey:@"Name"];
    if (self.stockCode)
        [pDict setTztValue:self.stockCode forKey:@"Code"];
    
    [pDict setTztValue:[NSString stringWithFormat:@"%d",self.stockType] forKey:@"StockType"];
    return [pDict autorelease];
}

- (void)setStockDict:(NSDictionary*)stockDict
{
    self.stockName =  [stockDict tztValueForKey:@"Name"];
    self.stockCode = [stockDict tztValueForKey:@"Code"];
    NSString* strType = [stockDict tztValueForKey:@"StockType"];
    if(strType && [strType length] > 0)
        self.stockType = [strType intValue];
}
@end
