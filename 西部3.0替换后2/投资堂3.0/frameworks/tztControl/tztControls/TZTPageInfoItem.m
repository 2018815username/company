/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：TZTPageInfoItem.m
 * 文件标识：
 * 摘    要：
 *
 * 当前版本：
 * 作    者：
 * 完成日期：
 *
 * 备	 注：
 *******************************************************************************/

#import "TZTPageInfoItem.h"

@implementation TZTPageInfoItem

@synthesize	nPageID = _nPageID;
@synthesize ImgNormal = _ImgNormal;
@synthesize ImgSelected = _ImgSelected;
@synthesize ImgBackground = _ImgBackground;
@synthesize nsPageName = _nsPageName;
@synthesize	pRev1 = _pRev1;
@synthesize	pRev2 = _pRev2;
@synthesize nsImgNormal = _nsImgNormal;
@synthesize nsImgSelected = _nsImgSelected;
@synthesize nStatus = _nStatus;

-(id) init
{
	if (self = [super init])
	{
		_nPageID = 0;
		self.ImgNormal = NULL;
        self.nsImgNormal = @"";
        self.nsImgSelected = @"";
		self.ImgSelected = NULL;
		self.ImgBackground = NULL;
		self.nsPageName = @"";
		_nStatus = 0;
		self.pRev1 = @"";
		self.pRev2 = @"";
	}
	
	return self;
}

-(void) dealloc
{
	self.ImgNormal = NULL;
	self.ImgSelected = NULL;
	self.ImgBackground = NULL;
	self.nsPageName = NULL;
	
	self.pRev1 = NULL;
	self.pRev2 = NULL;
	
	[super dealloc];
}
	
+(TZTPageInfoItem*) CreateByString:(NSString*)szInfo
{
	TZTPageInfoItem *pItem = NULL;
	if (szInfo == NULL || [szInfo length] < 1)
	{
		return pItem;
	}
	
	NSMutableArray* ayItem = (NSMutableArray*)[szInfo componentsSeparatedByString:@"|"];
	
	NSUInteger nCount = [ayItem count];
	if (nCount <= PII_PageID)
	{
        if (ayItem)
            [ayItem removeAllObjects];
		return pItem;
	}
	
	pItem = NewObjectAutoD(TZTPageInfoItem);
	
	NSString* strTemp = [ayItem objectAtIndex:PII_PageID];
	if (strTemp != NULL && [strTemp length] > 0)
	{
		int nID = 0;
		sscanf([strTemp UTF8String], "%x", &nID);
		pItem.nPageID = nID;
	}
	
	if (nCount > PII_NormalImg)
	{
		strTemp = [ayItem objectAtIndex:PII_NormalImg];
		if (strTemp != NULL && [strTemp length] > 0)
		{
            pItem.nsImgNormal = [NSString stringWithFormat:@"%@", strTemp];
			pItem.ImgNormal = [UIImage imageTztNamed:strTemp];
		}
	}
	
	if (nCount > PII_SelectedImg)
	{
		strTemp = [ayItem objectAtIndex:PII_SelectedImg];
		if (strTemp != NULL && [strTemp length] > 0)
		{
            pItem.nsImgSelected = [NSString stringWithFormat:@"%@", strTemp];
			pItem.ImgSelected = [UIImage imageTztNamed:strTemp];
		}		
	}
	
	if (nCount > PII_PageName)
	{
		strTemp = [ayItem objectAtIndex:PII_PageName];
		if (strTemp != NULL && [strTemp length] > 0)
		{
			pItem.nsPageName = [NSString stringWithFormat:@"%@",strTemp];
		}
	}
	
	if (nCount > PII_Rev1 && pItem.pRev1 != NULL)
	{
		strTemp = [ayItem objectAtIndex:PII_Rev1];
        pItem.pRev1 = [NSString stringWithFormat:@"%@", strTemp];
	}
	
	if (nCount > PII_Rev2 && pItem.pRev2 != NULL)
	{
		strTemp = [ayItem objectAtIndex:PII_Rev2];
        pItem.pRev2 = [NSString stringWithFormat:@"%@", strTemp];
	}
	// Rev2保留为背景色图片，可以附件判断Rev1是否有效
    if (pItem.pRev2 && [pItem.pRev2 length] > 0)
    {
        if ([pItem.pRev2 hasSuffix:@".png"])
        {
            pItem.ImgBackground = [UIImage imageTztNamed:pItem.pRev2];
        }
    }
	
    if (ayItem)
        [ayItem removeAllObjects];
	
	return pItem;
}

@end
