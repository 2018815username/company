/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTOutLineData.m
* 文件标识:
* 摘要说明:
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import "TZTOutLineData.h"


@implementation TZTOutLineData

//读取配置文件
-(id)initWithFile:(NSString *)strFile
{
	self = [super init];
	if (self)
	{
		Outlinelist = NULL;
		OutlineCell = NULL;
		//从配置文件获取数据
		if (strFile == NULL || [strFile length] < 1)
			return NULL;
        
        //获取路径对象 先从Document 读取
        NSString *tztPath = GetPathWithListName(strFile,FALSE);
        if(tztPath == NULL || [tztPath length] <= 0)
        {
            //从bundle读取
            tztPath = GetTztBundlePlistPath(strFile);
        }
		//读取到字典
		NSMutableDictionary* dictconf = [[[NSMutableDictionary alloc] initWithContentsOfFile:tztPath] autorelease];
        
		//获取tradelist关键字下的内容，并格式化到数组
		if(dictconf && [dictconf objectForKey:@"tradelist"])
		{
			Outlinelist = [[NSArray alloc] initWithArray:[dictconf objectForKey:@"tradelist"]];
		}
		
		//获取system关键字下的内容，并格式化到OutlineCell
		if(dictconf && [dictconf objectForKey:@"system"])
		{
			OutlineCell = NewObject(NSMutableDictionary);
			NSArray* aycell = [[NSMutableArray alloc] initWithArray:[dictconf objectForKey:@"system"]];
			for(int i = 0; i < [aycell count]; i++)
			{
				NSString* strcelldate = [aycell objectAtIndex:i];
				//通过竖线(|)分割字符串，并且存放到字典中
				NSArray* aycelldate = [[NSArray alloc] initWithArray:[strcelldate componentsSeparatedByString:@"|"]];
				if(aycelldate && [aycelldate count] > 0)
					[OutlineCell setObject:aycelldate forKey:[aycelldate objectAtIndex:0]];
				[aycelldate release];
			}
            [aycell release];
		}
	}
	return self;
}

-(id)initWithData:(NSMutableDictionary*)pDict
{
    self = [super init];
    if (self)
    {
		OutlineCell = nil;
		Outlinelist = nil;
        
        //获取tradelist关键字下的内容，并格式化到数组
		if(pDict && [pDict objectForKey:@"tradelist"])
		{
			Outlinelist = [[NSArray alloc] initWithArray:[pDict objectForKey:@"tradelist"]];
		}
		
		//获取system关键字下的内容，并格式化到OutlineCell
		if(pDict && [pDict objectForKey:@"system"])
		{
			OutlineCell = NewObject(NSMutableDictionary);
			NSArray* aycell = [[NSMutableArray alloc] initWithArray:[pDict objectForKey:@"system"]];
			for(int i = 0; i < [aycell count]; i++)
			{
				NSString* strcelldate = [aycell objectAtIndex:i];
				//通过竖线(|)分割字符串，并且存放到字典中
				NSArray* aycelldate = [[NSArray alloc] initWithArray:[strcelldate componentsSeparatedByString:@"|"]];
				if(aycelldate && [aycelldate count] > 0)
					[OutlineCell setObject:aycelldate forKey:[aycelldate objectAtIndex:0]];
				[aycelldate release];
			}
            [aycell release];
		}
    }
    return self;
}

//直接通过数据创建
-(id)initWithData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent
{
	self = [super init];
	if (self)
	{
		OutlineCell = nil;
		Outlinelist = nil;
		if (ayTitle && [ayTitle count] > 0)
		{
			OutlineCell = NewObject(NSMutableDictionary);
			NSMutableArray* pArray = [[NSMutableArray alloc] init];
			for (int i = 0; i < [ayTitle count]; i++)
			{
				//标题
				NSString *sNum = [NSString stringWithFormat:@"%d",i];
				NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   @"",  @"Image",
									   @"0", @"Expanded",
									   @"1", @"Show", nil,nil];
				[pDict setObject:sNum forKey:@"Image"];
				[pDict setObject:@"0" forKey:@"Expanded"];
				[pDict setObject:@"1" forKey:@"Show"];
				[pArray addObject:pDict];
				
				NSString* strValue = @"";
				if (ayContent && [ayContent count] > i)
				{
					strValue = [ayContent objectAtIndex:i];
				}
				
				NSString* strContent = [NSString stringWithFormat:@"%@|%@|||||TZTLabel=0^%@^Left^15",sNum,[ayTitle objectAtIndex:i], strValue];
				NSArray* aycelldate = [[NSArray alloc] initWithArray:[strContent componentsSeparatedByString:@"|"]];
				if (aycelldate && [aycelldate count] > 0)
					[OutlineCell setObject:aycelldate forKey:sNum];
				[aycelldate release];
			}
			Outlinelist = [[NSArray alloc] initWithArray:pArray];
			[pArray removeAllObjects];
			[pArray release];
		}
	}
	return self;
}

-(id)initWithData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent withButtonTag_:(int)nBeginTag bShowAdd_:(BOOL)bShow
{
    self = [super init];
	if (self)
	{
		OutlineCell = nil;
		Outlinelist = nil;
		if (ayTitle && [ayTitle count] > 0)
		{
			OutlineCell = NewObject(NSMutableDictionary);
			NSMutableArray* pArray = [[NSMutableArray alloc] init];
			for (int i = 0; i < [ayTitle count]; i++)
			{
				//标题
				NSString *sNum = [NSString stringWithFormat:@"%d",i+1024];
				NSMutableDictionary* pDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              @"",  @"Image",
                                              @"0", @"Expanded",
                                              @"1", @"Show", nil,nil];
				[pDict setObject:sNum forKey:@"Image"];
				[pDict setObject:@"0" forKey:@"Expanded"];
				[pDict setObject:@"1" forKey:@"Show"];
				[pArray addObject:pDict];
				
				NSString* strValue = @"";
				if (ayContent && [ayContent count] > i)
				{
					strValue = [ayContent objectAtIndex:i];
				}
				
				NSString* strContent = @"";
                if (i == 0 && bShow)//第一个，不显示按钮
                {
                    strContent = [NSString stringWithFormat:@"%@|%@|||||TZTLabel=0^%@^Left^15#TZTButton=0^^^^^Customer^15^0|||",sNum,[ayTitle objectAtIndex:i], strValue];
                }
                //最后一个，显示一个输入框和一个确定按钮
                else if (i == [ayTitle count] - 1 && bShow)
                {
                    strContent = [NSString stringWithFormat:@"%@|%@|||||TZTEditorSys=2000^%@^^Comm^16#TZTButton=%d^^TZTTradeSelectAccount.png^^^Customer^15^1|||",sNum,[ayTitle objectAtIndex:i], strValue, nBeginTag+i];
                }
                else
                {
                    strContent = [NSString stringWithFormat:@"%@|%@|||||TZTLabel=0^%@^Left^15#TZTButton=%d^^TZTBaseTextFieldClear.png^^^Customer^15^0|||",sNum,[ayTitle objectAtIndex:i], strValue, nBeginTag+i];
                }
				NSArray* aycelldate = [[NSArray alloc] initWithArray:[strContent componentsSeparatedByString:@"|"]];
				if (aycelldate && [aycelldate count] > 0)
					[OutlineCell setObject:aycelldate forKey:sNum];
				[aycelldate release];
			}
			Outlinelist = [[NSArray alloc] initWithArray:pArray];
			[pArray removeAllObjects];
			[pArray release];
		}
	}
	return self;
}

//为服务器设置特殊处理，其他地方使用要慎重
-(id)initWithData:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent withButtonTag_:(int)nBeginTag
{
    return [self initWithData:ayTitle ayContent_:ayContent withButtonTag_:nBeginTag bShowAdd_:TRUE];
}

-(void) dealloc
{
	DelObject(OutlineCell);
	DelObject(Outlinelist);
	[super dealloc];
}

//主列表个数
- (NSInteger) OutlineCount
{
	if(Outlinelist)
		return [Outlinelist count];
	return 0;
}

//主列表值
- (NSDictionary*)objectAtIndex:(NSInteger)index
{
	if(Outlinelist && [Outlinelist count] > index && index >= 0)
		return [Outlinelist objectAtIndex:index];
	return NULL;
}

//列表 第index列值
- (NSString*)objectForKey:(NSString*)strCell atIndex:(int)index
{
	if(OutlineCell)
	{
		NSArray* aycellvalue = [OutlineCell objectForKey:strCell];
		if(aycellvalue && [aycellvalue count] > index)
		{
			return [aycellvalue objectAtIndex:index];
		}
	}
	return @"";
}

-(NSArray*)arrayForKey:(NSString*)strCell
{
    if (OutlineCell)
    {
        return [OutlineCell objectForKey:strCell];
    }
    return NULL;
}

//设置某位置的值
-(void)setObjecyForKey:(NSString*)strCell atIndex:(int)index withValue:(NSString*)nsValue
{
	if (OutlineCell)
	{
		NSMutableArray* aycellvalue = [OutlineCell objectForKey:strCell];
		if (aycellvalue && [aycellvalue count] > index)
		{
			[aycellvalue replaceObjectAtIndex:index withObject:nsValue];
		}
	}
}

//列表标题
- (NSString*)titleForKey:(NSString*)strCell
{
	return [self objectForKey:strCell atIndex:1];
}

//列表功能号
- (int)msgTypeForKey:(NSString*)strCell
{
	NSString* strMsg = [self objectForKey:strCell atIndex:2];
	if(strMsg && [strMsg length] > 0)
		return [strMsg intValue];
	return 0;
}

//获取参数
-(NSString*)nsParamForKey:(NSString*)strCell
{
    NSString *strMsg = [self objectForKey:strCell atIndex:3];
    return strMsg;
}

//是否添加控件包含类型
-(NSMutableArray*)controlTypeForKey:(NSString*)strCell
{
	NSString* strMsg = [self objectForKey:strCell atIndex:6];
	if (strMsg == nil || [strMsg length] < 1)
		return nil;
	//通过井号(#)来分割字符串，判断数组中有多少个控件
	NSMutableArray* aycelldate = [[[NSMutableArray alloc] initWithArray:[strMsg componentsSeparatedByString:@"#"]] autorelease];
	return aycelldate;
}

-(UIColor*)BackColorForKey:(NSString*)strCell
{
    NSString *strMsg = [self objectForKey:strCell atIndex:9];
//    if (strMsg == NULL || [strMsg length] < 1)
//        return [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]];
    //使用图片
    if ([strMsg hasSuffix:@".png"]) 
    {
        return [UIColor colorWithPatternImage:[UIImage imageTztNamed:strMsg]];
    }
//    else//使用默认图片
//    {
//        return [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]];
//    }
    //通过逗号(,)分割
    NSMutableArray *ayCellData = [[[NSMutableArray alloc] initWithArray:[strMsg componentsSeparatedByString:@","]] autorelease];
    if (ayCellData == Nil || [ayCellData count] < 3)//数据错误
        return nil;
    NSString* nsRed = [ayCellData objectAtIndex:0];
    NSString* nsGreen = [ayCellData objectAtIndex:1];
    NSString* nsBlue = [ayCellData objectAtIndex:2];
    if (nsRed == Nil || [nsRed length] < 1 
        || nsGreen == Nil || [nsGreen length] < 1
        || nsBlue == Nil || [nsBlue length] < 1)
        return Nil;
    
    return [UIColor colorWithRed:[nsRed floatValue]/255.0 green:[nsGreen floatValue]/255.0 blue:[nsBlue floatValue]/255.0 alpha:1.0];
}

-(UIColor*)SelectColorForKey:(NSString*)strCell
{
    NSString *strMsg = [self objectForKey:strCell atIndex:10];
//    if (strMsg == NULL || [strMsg length] < 1)
//        return [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTMenuSelect.png"]];
    //使用图片
    if ([strMsg hasSuffix:@".png"]) 
    {
        return [UIColor colorWithPatternImage:[UIImage imageTztNamed:strMsg]];
    }
//    else
//    {
//        return [UIColor colorWithPatternImage:[UIImage imageTztNamed:@"TZTMenuSelect.png"]];
//    }
    //通过逗号(,)分割
    NSMutableArray *ayCellData = [[[NSMutableArray alloc] initWithArray:[strMsg componentsSeparatedByString:@","]] autorelease];
    if (ayCellData == Nil || [ayCellData count] < 3)//数据错误
        return nil;
    NSString* nsRed = [ayCellData objectAtIndex:0];
    NSString* nsGreen = [ayCellData objectAtIndex:1];
    NSString* nsBlue = [ayCellData objectAtIndex:2];
    if (nsRed == Nil || [nsRed length] < 1 
        || nsGreen == Nil || [nsGreen length] < 1
        || nsBlue == Nil || [nsBlue length] < 1)
        return Nil;
    
    return [UIColor colorWithRed:[nsRed floatValue]/255.0 green:[nsGreen floatValue]/255.0 blue:[nsBlue floatValue]/255.0 alpha:1.0];
}

//返回制定单元数据
-(NSString*)stringForKey:(NSString*)strCell atIndex:(int)index
{
	NSString *strMsg = [self objectForKey:strCell atIndex:index];
	if (strMsg == nil) 
		return nil;
	
	return strMsg;
}
@end
