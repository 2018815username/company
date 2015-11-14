/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "TZTUITabBarItem.h"
#import "TZTTabBarProfile.h"

#define TZTTabBarItemMiniWidth (10)
#define TZTTabBarButtonHeight   30
#define TZTTabBarItemWidth      (768/12)
#define Max_Move_Step           (17)
#define Max_Move_Times          (Max_Move_Step * 3)

int MovePointArray[] = 
{
    //0 1   2   3   4   5   6   7   8   9  10  11 12 13 14 15 16
    0, -1, -2, -3, -4, -5, -6, -5, -4, -3, -2, -1, 0, 1, 2, 1, 0,
};

@interface TZTUITabBarItem(TZTPrivate)
-(void)DrawTitle:(CGRect)rcText color:(UIColor*)textColor fontSize:(int)nFontSize;
@end

@implementation TZTUITabBarItem
@synthesize action;
@synthesize target;
@synthesize defaultWidth;
@synthesize selectedImage;
@synthesize hightImage;
@synthesize unselectedImage;
@synthesize selectedColor;
@synthesize unselectedColor;
@synthesize backgroundImage;
@synthesize drawText;
@synthesize selectFont;
@synthesize unselectFont;
@synthesize drawRect;


-(void)dealloc
{
    self.selectedImage = NULL;
    self.hightImage = NULL;
    self.unselectedImage = NULL;
    self.selectedColor = NULL;
    self.unselectedColor = NULL;
    self.backgroundImage = NULL;
    
    [super dealloc];
}

-(int)GetWidth
{
	if (g_pTZTTabBarProfile && g_pTZTTabBarProfile.nFixedIconWidth > TZTTabBarItemMiniWidth)
	{
		return g_pTZTTabBarProfile.nFixedIconWidth;
	}
	if (defaultWidth < TZTTabBarItemMiniWidth)
		return TZTTabBarItemWidth;
	
	return defaultWidth;
}

-(void)setBadgeValue:(NSString *)badgeValue
{
    [super setBadgeValue:badgeValue];
}

-(id)initWithTitle:(NSString *)title image:(UIImage *)image target:(id)delegate action:(SEL)action1
{
    if (self = [super initWithTitle:title image:image tag:0]) 
    {
        self.target = delegate;
        self.action = action1;
        
        self.unselectedImage = image;
        if (g_pTZTTabBarProfile && g_pTZTTabBarProfile.nDrawNameColorSel > 0)
		{
			self.selectedColor = [UIColor colorWithRGBULong:g_pTZTTabBarProfile.nDrawNameColorSel];
		}
		else 
		{
            self.selectedColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
		}
        
		if (g_pTZTTabBarProfile && g_pTZTTabBarProfile.nDrawNameColor > 0)
		{
			self.unselectedColor = [UIColor colorWithRGBULong:g_pTZTTabBarProfile.nDrawNameColor];
		}
		else
		{
			self.unselectedColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];	
		}
		
		if (g_pTZTTabBarProfile)
		{
			self.drawText = g_pTZTTabBarProfile.nDrawName;
		}
		else
		{
			self.drawText = FALSE;
		}
        
		self.selectFont = 14;
		self.unselectFont = 14;
		
		self.drawRect = CGRectMake(0, 0, 0, 0);
    }
    return self;
}


-(void)DrawInRect:(int)nMove rect:(CGRect)rect selected:(int)select
{
    int nWidth = rect.size.width;
    //绘制背景
    if (self.backgroundImage && self.backgroundImage.CGImage != NULL)
    {
        CGRect rcMask = rect;
        
        rcMask.origin.y += (g_pTZTTabBarProfile.nDrawMiddleLine);
        rcMask.origin.x += (nWidth - backgroundImage.size.width) / 2;
        rcMask.size = backgroundImage.size;
        rcMask.origin.y -= nMove;
        
        [self.backgroundImage drawAtPoint:rcMask.origin];
    }
    
    //绘制图片
    if (select) //选中
    {
        if (hightImage && hightImage.CGImage != NULL)
        {
            CGRect rcHight = rect;
            if (g_pTZTTabBarProfile.nDrawSelectedStyle == 3)
            {
                rcHight.origin.y += (g_pTZTTabBarProfile.nDrawMiddleLine);
            }
            else if(g_pTZTTabBarProfile.nDrawSelectedStyle == 2)
            {
                rcHight.origin.y += (rect.size.height - hightImage.size.height);
            }
            else if(g_pTZTTabBarProfile.nDrawSelectedStyle == 1)
            {
                
            }
            else
            {
                rcHight.origin.y += (rect.size.height - hightImage.size.height) / 2;
            }
            
            rcHight.origin.x += (nWidth - hightImage.size.width) / 2;
            rcHight.size = hightImage.size;
            
            [hightImage drawAtPoint:rcHight.origin];
        }
        
        if (selectedImage && selectedImage.CGImage != NULL)
        {
            CGRect rcMask = rect;
            if (g_pTZTTabBarProfile.nDrawIconStyle == 3)
			{
				rcMask.origin.y += (g_pTZTTabBarProfile.nDrawMiddleLine-selectedImage.size.height);
			}
			else if (g_pTZTTabBarProfile.nDrawIconStyle == 2)
			{
				rcMask.origin.y += (rect.size.height-selectedImage.size.height);
			}
			else if(g_pTZTTabBarProfile.nDrawIconStyle == 1)
			{
				
			}
			else
			{
				rcMask.origin.y += (rect.size.height-selectedImage.size.height)/2;
			}
			
			rcMask.origin.y += nMove;
			rcMask.origin.x += (nWidth - selectedImage.size.width) / 2;
			rcMask.size = selectedImage.size;
            
			[selectedImage drawAtPoint:rcMask.origin];
        }
    }
    else
    {
        if (unselectedImage && unselectedImage.CGImage != NULL)
		{
			CGRect rcMask = rect;
			
			if (g_pTZTTabBarProfile.nDrawIconStyle == 3)
			{
				rcMask.origin.y += (g_pTZTTabBarProfile.nDrawMiddleLine-unselectedImage.size.height);
			}
			else if(g_pTZTTabBarProfile.nDrawIconStyle == 2)
			{
				rcMask.origin.y += (rect.size.height-unselectedImage.size.height);
			}
			else if(g_pTZTTabBarProfile.nDrawIconStyle == 1)
			{
				
			}
			else
			{
				rcMask.origin.y += (rect.size.height-unselectedImage.size.height)/2;
			}
			
			rcMask.origin.y += nMove;
			
			rcMask.origin.x += (nWidth - unselectedImage.size.width) / 2;
			rcMask.size = unselectedImage.size;
            
			[unselectedImage drawAtPoint:rcMask.origin];
		}
    }
    
    //绘制文字
	if (drawText)
	{
		CGRect rcText = rect;
		if (select)
		{
			rcText.origin.y += (rect.size.height - self.selectFont);
			rcText.size.height = self.selectFont;
			
			[self DrawTitle:rcText color:self.selectedColor fontSize:self.selectFont];
		}
		else
		{
			rcText.origin.y += (rect.size.height-self.unselectFont);
			rcText.size.height = self.unselectFont;
			
			[self DrawTitle:rcText color:self.unselectedColor fontSize:self.unselectFont];
		}
        
	}
}

//绘制item文字
-(void)DrawTitle:(CGRect)rcText color:(UIColor *)textColor fontSize:(int)nFontSize
{
    if (!drawText)
        return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 3.0);
	if (textColor == NULL)
	{
		textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	}
	
	CGContextSetStrokeColorWithColor(context, textColor.CGColor);
	CGContextSetFillColorWithColor(context, textColor.CGColor);
	NSString *text = self.title;
//	UIFont* pFont = [UIFont fontWithName:@"宋体" size:nFontSize];
	//计算输出高度
	CGSize szDrawSize = [text sizeWithFont:tztUIBaseViewTextFont(nFontSize)
						 constrainedToSize:rcText.size
							 lineBreakMode:NSLineBreakByCharWrapping];
	
	//调整输出位置
	int nBaseLine = (rcText.size.height-szDrawSize.height)/2.0 - 0.5;
	rcText.origin.y += nBaseLine;
	[text drawInRect:rcText
						 withFont:tztUIBaseViewTextFont(nFontSize)
					lineBreakMode:NSLineBreakByCharWrapping
						alignment:NSTextAlignmentCenter];
}

@end



//创建一个TabBarItem
@implementation TZTPageInfoItem(TabBarItem)

-(TZTUITabBarItem*)CreateTabBarItem
{
    TZTUITabBarItem *pNewItem = [[[TZTUITabBarItem alloc] initWithTitle:@""/*self.nsPageName*/
                                                                 image:nil//self.ImgNormal
                                                                target:NULL
                                                                action:NULL] autorelease];
    
    pNewItem.selectedImage = self.ImgSelected;
    pNewItem.backgroundImage = self.ImgBackground;
    pNewItem.hightImage = g_pTZTTabBarProfile.imgHight;
    return pNewItem;
}

@end


@implementation TZTUITabBar
@synthesize delegate;
@synthesize ayItemList;
@synthesize maxDisplay;
@synthesize movieTimer;


//显示个数
-(NSInteger)GetDisplayCount
{
    if (maxDisplay > 0)
        return maxDisplay;
    if (ayItemList)
        return [ayItemList count];
    else
        return 0;
}

-(void)dealloc
{
    [self EndMovieTimer];
    [super dealloc];
}

-(CGRect)InitDrawRect:(NSInteger*)nStep andWidth:(NSInteger*)nWidth
{
    NSInteger nCount = [self GetDisplayCount];
    int nBaseWidth = TZTTabBarItemWidth;
    if (g_pTZTTabBarProfile.nFixedIconWidth >= TZTTabBarItemMiniWidth) 
        nBaseWidth = g_pTZTTabBarProfile.nFixedIconWidth;
    
    int nXPos = g_pTZTTabBarProfile.nMarginHead;
    int nMaxDrawWidth = self.frame.size.width - nXPos - g_pTZTTabBarProfile.nMarginTail;
    
    NSInteger nSpace = (nMaxDrawWidth - nCount*nBaseWidth) / 2;
    if (nSpace < 0)
        nSpace = 0;
    
    CGRect rcText;
    rcText.size.height = self.frame.size.height;
    rcText.size.width = nBaseWidth;
    rcText.origin.x = nSpace + nXPos;
    rcText.origin.y = 0;
    
    *nWidth = nBaseWidth;
    *nStep = nSpace;
    return  rcText;
}

-(void)drawRect:(CGRect)rect
{
    NSInteger nCount = [self GetDisplayCount];
    CGRect rcText = rect;
    
    UIImage *pTabBG = [UIImage imageTztNamed:@"TZTTabBarBG.png"];
    if (pTabBG)
        [pTabBG drawInRect:rcText];
    
    NSInteger nBaseWidth = 0;
    NSInteger nStep = 0;
    
    rcText = [self InitDrawRect:&nStep andWidth:&nBaseWidth];
    
//#ifdef SupportLogo
    CGRect rcLogo = rcText;
    UIImage *pImgLogo = [UIImage imageTztNamed:@"TZTLogo.png"];
    
    if (pImgLogo)
    {
        rcLogo.origin.x = 10;
        if (rcLogo.size.height > pImgLogo.size.height)
            rcLogo.origin.y += (rcLogo.size.height - pImgLogo.size.height);
        rcLogo.size = pImgLogo.size;
        [pImgLogo drawInRect:rcLogo];
        rectLogo = rcLogo;
    }
    
//#endif
    
    for (int i = 0; i < nCount; i++, rcText.origin.x += (nStep+nBaseWidth)) 
    {
        UITabBarItem *pItem = [ayItemList objectAtIndex:i];
        if (pItem == NULL)
            continue;
        
        BOOL bSelect = (selectIndex == i);
        CGRect rcNewText = rcText;
        int nMoveOff = 0;
        
        if ([pItem isKindOfClass:[TZTUITabBarItem class]]) 
        {
            ((TZTUITabBarItem*)pItem).drawRect = rcNewText;
            if (bSelect && bMoveing && bDragged)
                rcNewText.origin.x = movingPoint.x;
            if ((i == moveClick) && moveOffset > 0)
                nMoveOff = MovePointArray[moveOffset%Max_Move_Step];
            
            [(TZTUITabBarItem*)pItem DrawInRect:nMoveOff rect:rcNewText selected:bSelect];
        }
    }
}

-(NSInteger)GetPointAtIndex:(CGPoint)point
{
    NSInteger nCount = [self.ayItemList count];
    NSInteger nBaseWidth = 0;
    NSInteger nSpace = 0;
    
    CGRect rcTect = [self InitDrawRect:&nSpace andWidth:&nBaseWidth];
    for (int i = 0; i < nCount; i++, rcTect.origin.x += (nSpace + nBaseWidth))
    {
        if (point.x > g_pTZTTabBarProfile.nMarginHead && point.x < rcTect.origin.x + nBaseWidth + nSpace / 2)
        {
            return i;
        }
    }
    return -1;
}


-(void)SetItemList:(NSMutableArray *)itemList
{
    self.ayItemList = itemList;
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.ayItemList == NULL)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSInteger nIndex = [self GetPointAtIndex:point];
    if (nIndex < 0 )
        return;
    
    preSelIndex = selectIndex;
    selectIndex = nIndex;
    
    moveClick = selectIndex;
    
    [self setNeedsDisplay];
    
    if (g_pTZTTabBarProfile && g_pTZTTabBarProfile.nHandleMove)
    {
        bDragged = TRUE;
        bMoveing = FALSE;
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarItemClicked:)]) 
        {
            moveOffset = 0;
            [self StartMovieTimer];
            [self.delegate tabBarItemClicked:[self.ayItemList objectAtIndex:selectIndex]];
        }
    }
    return;
}

-(void)UndoSelect
{
    selectIndex = preSelIndex;
    [self setNeedsDisplay];
}

-(void)ChangeSelect:(NSInteger)nIndex
{
    if (nIndex == selectIndex)
        return;
    
    preSelIndex = selectIndex;
    selectIndex = nIndex;
    [self setNeedsDisplay];
}

-(void)OnMoved
{
    [self EndMovieTimer];
    moveOffset++;
    [self setNeedsDisplay];
    if (moveOffset >= Max_Move_Times)
    {
        moveOffset = 0;
        return;
    }
    
    [self StartMovieTimer];
}

-(void)StartMovieTimer
{
    [self EndMovieTimer];
    self.movieTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                       target:self
                                                     selector:@selector(OnMoved)
                                                     userInfo:nil
                                                      repeats:NO];
}

-(void)EndMovieTimer
{
    if (self.movieTimer && [self.movieTimer isValid])
    {
        [self.movieTimer invalidate];
        self.movieTimer = NULL;
    }
}

-(BOOL)IsSelectTheSameItem
{
    return selectIndex == preSelIndex ?TRUE : FALSE;
}

@end































