/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		tztUIControlsProperty.m
* 文件标识:
* 摘要说明:
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import "tztUIControlsProperty.h"

@implementation NSMutableDictionary (tztUIControlsProperty)
-(void) settztProperty:(NSString*)strproperty
{
    [self removeAllObjects];
    if(strproperty == nil || [strproperty length] <= 0)
        return;
    NSArray* ayProperty = [strproperty componentsSeparatedByString:@"|"];
    for (int i = 0; i < [ayProperty count]; i++)
    {
        NSString* strParam = [ayProperty objectAtIndex:i];
        if(strParam == nil || [strParam length] <= 0)
            continue;
        NSArray* ayParam = [strParam componentsSeparatedByString:@"="];
        if(ayParam && [ayParam count] >= 2)
        {
            NSString* strCode = [ayParam objectAtIndex:0];
            NSString* strValue = [strParam substringFromIndex:[strCode length]+1];
            NSString* code = [strCode lowercaseString];
            [self setObject:strValue forKey:code];
        }
    }
}
@end

