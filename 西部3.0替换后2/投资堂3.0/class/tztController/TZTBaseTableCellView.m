/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTBaseTableCellView.m
* 文件标识:
* 摘要说明:
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/


#import <QuartzCore/QuartzCore.h>
#import "TZTBaseTableCellView.h"
#import "TZTUICheckBox.h"
#import "TZTUIButtonView.h"

//默认左右间距
#define tztTableCellMargin 5
//Icon大小
#define tztTableCellIconWidth 32
//
#define tztTableCellIcon     24
//默认标题宽度
#define tztTableTitleWidth    60
//默认第一个控件宽度
#define tztTableFirstControl  40

enum tztTableCellTag
{
	kTZTTableCell_Icon = 0x1100,	//icon图片
	kTZTTableCell_Title,			//标题文字
	kTZTTableCell_ImgView,			//图片
	kTZTTableCell_Background		//背景
};

@implementation TZTBaseTableCellView
@synthesize expanded;
@synthesize m_pAyControl;
@synthesize m_nTitleWidth;
@synthesize m_nFirstControlWidth;
@synthesize m_nCellMargin;
@synthesize m_nIconWidth;
@synthesize m_nsIcon;

//创建cell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	//调用父类创建
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self)
	{
		//默认缩进距离
		self.indentationWidth = 20;
		self.m_nsIcon = @"";
		self.selectionStyle = UITableViewCellSelectionStyleBlue; 
		//默认不展开
		expanded = NO;
		//初始化参数
		m_pAyControl = NewObject(NSMutableArray);
		m_nTitleWidth = 0;
		m_nFirstControlWidth = tztTableFirstControl;
		m_nCellMargin = tztTableCellMargin;
		m_nIconWidth =  tztTableCellIconWidth;
	}
	return self;
}

//设置分割符
-(void)setGridLine:(NSString *)nsImg
{
	//是否使用图片
	BOOL bUseImg = TRUE;
	if (nsImg == NULL || [nsImg length] < 1)
	{
		bUseImg = FALSE;
	}
	else
	{
		//图片不存在，则也使用颜色填充
		if (![UIImage imageTztNamed:nsImg])
			bUseImg = FALSE;
	}
	//分割线view
	UIView *gridLine = [[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, TZTScreenWidth-4, 1)];
	//设置为半透明
	[gridLine setAlpha:0.5];
	if (bUseImg)
	{
		gridLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:nsImg]];
        [gridLine release];
        return;
	}
	else
	{
		gridLine.backgroundColor = [UIColor colorWithRGBULong:0x2f2f2f];////[UIColor darkGrayColor];
	}
	[self addSubview:gridLine];
    [gridLine release];
}

-(void)setIconGray
{
    UIImageView* pIconView = (UIImageView*)[self viewWithTag:kTZTTableCell_Icon];
    if (pIconView && bHaveIcon) //view是否存在
	{
        [pIconView setAlpha:0.1f];
        pIconView.image = [self getGrayImage:pIconView.image];
    }
}

-(void)setIconNormal
{
    UIImageView* pIconView = (UIImageView*)[self viewWithTag:kTZTTableCell_Icon];
    if (pIconView && bHaveIcon && self.m_nsIcon) //view是否存在
	{
        pIconView.image = [UIImage imageTztNamed:self.m_nsIcon];
    }
}

-(UIImage*)getGrayImage:(UIImage*)sourceImage
{
	int width = sourceImage.size.width;
	int height = sourceImage.size.height;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
	CGColorSpaceRelease(colorSpace);
	if (context == NULL) 
    {
		return nil;
	}
	CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    CGImageRef p = CGBitmapContextCreateImage(context);
	UIImage *grayImage = [UIImage imageWithCGImage:p] ;
    CGImageRelease(p);
	CGContextRelease(context);
	return grayImage;
}


//设置背景图片
-(void)setBackground:(NSString*)nsImg
{
	BOOL bUseImg = TRUE;
	if (nsImg == NULL || [nsImg length] < 1)
	{
		bUseImg = FALSE;
	}
	else
	{
		//图片读取失败或图片不存在
		if (![UIImage imageTztNamed:nsImg])
			bUseImg = FALSE;
	}
	
	//创建背景view
	UIImageView *pImgView = (UIImageView*)[self viewWithTag:kTZTTableCell_Background];
	if (pImgView == NULL)
	{
		pImgView = [[UIImageView alloc] initWithFrame:self.frame];
		pImgView.tag = kTZTTableCell_Background;
		[self addSubview:pImgView];
		[self sendSubviewToBack:pImgView];
		[pImgView release];
	}
	
	//使用图片
	if (bUseImg)
	{
		pImgView.image = [UIImage imageTztNamed:nsImg];
	}
	else
	{
		//使用透明色
		pImgView.backgroundColor = [UIColor clearColor];
	}
}

//重新布局各个view显示
-(void)layoutSubviews
{
	[super layoutSubviews];
	//当前view的高度，宽度
	float nHeight = self.frame.size.height;
	float width = self.frame.size.width;
	//当前view的缩进距离
	float indentation = self.indentationWidth * self.indentationLevel;
	//可用区域（总宽度 － 缩进距离 － 总间距 － 10）
	int nValidWidth = width - indentation - (m_nCount+1)*m_nCellMargin - 10;
	int nLeft = self.frame.origin.x + m_nCellMargin + indentation;
	//垂直居中
	int nTop;// = (nHeight - (m_nIconWidth > 0 ? m_nIconWidth : tztTableCellIconWidth)) / 2;
	
	//图标位置调整
	UIImageView* pIconView = (UIImageView*)[self viewWithTag:kTZTTableCell_Icon];
	if (pIconView && bHaveIcon) //view是否存在
	{
		//垂直居中
		nTop = (nHeight - /*pIconView.image.size.height*/tztTableCellIcon) / 2;
		if (nTop < 0)
		{
			nTop = (nHeight - (/*m_nIconWidth > 0 ? m_nIconWidth : */tztTableCellIcon)) / 2;
		}
		//设置区域
		pIconView.frame = CGRectMake(nLeft, nTop, 
									(pIconView.image.size.width > tztTableCellIcon ? tztTableCellIcon : pIconView.image.size.width),
									(pIconView.image.size.height > tztTableCellIcon ? tztTableCellIcon : pIconView.image.size.height));
		//偏移量添加
		nLeft += (pIconView.image.size.width > tztTableCellIcon ? tztTableCellIcon : pIconView.image.size.width);
	}
	
	//标题位置调整
	UILabel *pLabel = (UILabel*)[self viewWithTag:kTZTTableCell_Title];
	if (pLabel)
	{
		//加上间距
		nLeft += m_nCellMargin;
		//垂直居中
		nTop = (nHeight - tztTableCellIconWidth) / 2;
		if (nTop < 0)
			nTop = 0;
		
		//计算剩下的可用宽度
		int nW = (nValidWidth - m_nIconWidth * (m_nImage > 0 ? m_nImage : 1));
		//未设置标题宽度
		if (m_nTitleWidth <= 0)
		{
			if (bHaveControl)//存在控件
			{
				//标题占剩下可用宽度的1/3
				nW = (nValidWidth - m_nIconWidth * (m_nImage > 0 ? m_nImage : 1)) / 3;
                m_nTitleWidth = nW;
			}
		}
		else
		{
			//设置了标题宽度，则直接使用标题宽度
			nW = m_nTitleWidth;
		}

		//设置调整后的区域
		CGRect rc = CGRectMake(nLeft, nTop, nW, (m_nIconWidth > 0 ? m_nIconWidth : (self.frame.size.height - 2*nTop)));
		pLabel.frame = rc;
		//偏移量增加
		nLeft += nW;
	}
	
	//调整控件区域
	//垂直居中
	nTop = (nHeight - (m_nIconWidth > 0 ? m_nIconWidth : tztTableCellIconWidth)) / 2;
	//循环各个控件
	for (int i = 0; i < m_nControl; i++)
	{
		UIView* pView = nil;
		//越界判断，防止出错
		if (i < [m_pAyControl count])
		{
			pView = [m_pAyControl objectAtIndex:i];
		}
		
        if (pView && [pView isKindOfClass:[TZTUIButtonView class]])
        {
            TZTUIButtonView* pBtn = (TZTUIButtonView*)pView;
            if (pBtn && pBtn.m_pButton)
            {
                //按钮，使用现有图片
                UIImage *btnImg = [pBtn.m_pButton backgroundImageForState:UIControlStateNormal];
                if (btnImg)
                {
                    int n/*m_nIconWidth*/ = btnImg.size.height;
                    nTop = (nHeight - (n > 0 ? n : tztTableCellIconWidth)) / 2;
                }
            }
        }
        
		if (pView)
		{
			//得到剩余可用宽度
			int nW = (nValidWidth - m_nIconWidth * (m_nImage >= 0 ? m_nImage : 1));
			//有标题存在
			if (bHaveTitle )
			{
				//标题宽度<=0,则使用剩余的2/3的宽度，各个控件均分
				if (m_nTitleWidth <= 0)
					nW = (nValidWidth - m_nFirstControlWidth - m_nIconWidth * (m_nImage > 0 ? m_nImage : 1)) / 3 * 2 / m_nControl;
				else
				{
					//减去设置的标题宽度后，各个控件均分
					nW = (nValidWidth - m_nFirstControlWidth - m_nIconWidth * (m_nImage > 0 ? m_nImage : 1) - m_nTitleWidth) / (m_nControl);
				}

			}
			else
			{
				//没有标题
				//控件数量大于1
				if (m_nControl > 1)
				{
					//计算单个控件所占的宽度
					nW = (nValidWidth - m_nFirstControlWidth - m_nIconWidth * (m_nImage >= 0 ? m_nImage : 1) - m_nTitleWidth) / (m_nControl);
				}
			}
			
			//第一个，并且有标题显示
			if ( i == 0 && (m_nControl > 1 || bHaveTitle))
			{
				//直接使用设置的第一个控件的宽度
				nW += m_nFirstControlWidth;
			}
			
			//没有标题，并且控件数为2个(特殊处理)
			if (!bHaveTitle && m_nControl == 2)
			{
				if ([pView isKindOfClass:[TZTUICheckBox class]] || [pView isKindOfClass:[tztUIDroplistView class]])
				{
					//第一个控件设置的宽度
					if (m_nFirstControlWidth > 0)
					{
						if (i == 0)
						{
							nW = (m_nFirstControlWidth);
						}
						//使用剩下的宽度即可
						if (i == 1)
						{
							nW = (nValidWidth - m_nFirstControlWidth - m_nIconWidth * (m_nImage >= 0 ? m_nImage : 1) );
						}
					}
					else 
					{
						//否则平均分配宽度
						nW = (nValidWidth - m_nFirstControlWidth - m_nIconWidth * (m_nImage >= 0 ? m_nImage : 1) ) / m_nControl;
					}
				}
				else
				{
					nW = (nValidWidth - m_nIconWidth * (m_nImage >= 0 ? m_nImage : 1)) / m_nControl;
				}

			}
			
			//设置调整后的区域
			nLeft += m_nCellMargin;
			CGRect rc = CGRectMake(nLeft, nTop, nW, (m_nIconWidth > 0 ? m_nIconWidth : (nHeight - 2*nTop)));
			pView.frame = rc;
			//增加偏移量
			nLeft += nW;
		}
	}
	
	//右侧小图区域调整
	UIImageView * pImg = (UIImageView*)[self viewWithTag:kTZTTableCell_ImgView];
	if (pImg)
	{
		//垂直居中
		nLeft += tztTableCellIconWidth / 2;
		nTop = (nHeight - pImg.image.size.height) / 2;
		//间距
		nLeft += m_nCellMargin;
		if (nTop < 0)
			nTop = 0;
		CGRect rc = CGRectMake(nLeft, nTop, pImg.image.size.width, pImg.image.size.height);
		//重设区域
		pImg.frame = rc;
	}
}

//设置内容
/*
	nsIcon 图标 nsTitle 标题 pAyControl 控件数组 nsImg 右侧图片 bHaveChild 是否有子项
 */
-(void)setContent:(NSString *)nsIcon nsTitle_:(NSString *)nsTitle pControl_:(NSMutableArray *)pAyControl nsImg_:(NSString *)nsImg
{
	[self setContent:nsIcon nsTitle_:nsTitle pControl_:pAyControl nsImg_:nsImg bHaveChild_:NO];
}

//设置单元格内容（图标，标题，控件，图片）
-(void) setContent:(NSString*)nsIcon nsTitle_:(NSString*)nsTitle pControl_:(NSMutableArray*)pAyControl nsImg_:(NSString*)nsImg bHaveChild_:(BOOL)bHaveChild
{
	/*初始化*/
	bHaveControl = FALSE;
	bHaveTitle = FALSE;
	bHaveImage = FALSE;
	bHaveIcon = FALSE;
	m_nControl = 0;
	m_nImage = 0;
	int nCount = 0;
	//总数判断，用于总间距的计算
	//是否存在图标
    UIImage *pImg = nil;
	if (nsIcon && [nsIcon length] > 0)
	{
        self.m_nsIcon = nsIcon;
        NSString* imagename = nsIcon;
        if ([nsIcon rangeOfString:@"tzt" options:NSCaseInsensitiveSearch].location == NSNotFound)
        {
            imagename = [NSString stringWithFormat:@"tztimage_%@",nsIcon];
        }
		pImg = [UIImage imageTztNamed:imagename];
		if (pImg) 
		{
			bHaveIcon = TRUE;
			nCount++;
			m_nImage++;
		}
	}
	//是否存在标题
	if (nsTitle && [nsTitle length] > 0 && m_nTitleWidth > 0)
	{
		bHaveTitle = TRUE;
		nCount++;
	}
	//控件数
	if (pAyControl && [pAyControl count])
	{
		bHaveControl = TRUE;
		m_nControl = [pAyControl count];
		for (int i = 0; i < m_nControl; i++)
		{
			nCount++;
		}
	}
	//右侧图片
	if (nsImg && [nsImg length] > 0)
	{
		bHaveImage = TRUE;
		m_nImage++;
		nCount++;
	}
	m_nCount = nCount;
	
	//有图标,显示，否则不显示
	
	//icon
	if(nsIcon && [nsIcon length] > 0)
	{
		if (pImg)
		{
			m_nIconWidth = tztTableCellIconWidth;
		}
		else
			m_nIconWidth = 0;
		//添加icon显示
		UIImageView* pImgIcon = (UIImageView*)[self viewWithTag:kTZTTableCell_Icon];
		if (pImgIcon == NULL && pImg)//未创建，并且图片有效，则创建
		{
			pImgIcon = [[UIImageView alloc] init];
			pImgIcon.tag = kTZTTableCell_Icon;
			[self.contentView addSubview:pImgIcon];
			[pImgIcon release];
		}
		
		if (pImgIcon)
		{
			//设置图片
			[pImgIcon setImage:pImg];
		}
	}
	
	//标题处理
	if(nsTitle && [nsTitle length] > 0)
	{	
		UILabel *pLabel = (UILabel*)[self viewWithTag:kTZTTableCell_Title];
		//创建label显示标题文字
		if (pLabel == NULL)
		{
			pLabel = [[UILabel alloc] init];
			pLabel.tag = kTZTTableCell_Title;
			pLabel.textAlignment = UITextAlignmentLeft;
			pLabel.font = tztUIBaseViewTextFont(16.0f);
            if (g_nHQBackBlackColor)
            {
                pLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];   
            }
            else
            {
                pLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];;
            }
			pLabel.backgroundColor = [UIColor clearColor];
			pLabel.adjustsFontSizeToFitWidth = YES;
			pLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
			[self.contentView addSubview:pLabel];
			[pLabel release];
		}
		pLabel.text = nsTitle;
	}
	
	//控件
	//清空数组
	if (m_pAyControl == NULL)
		m_pAyControl = NewObject(NSMutableArray);
	[m_pAyControl removeAllObjects];
	//添加控件到view上
	for ( int i = 0; i < m_nControl; i++)
	{
		UIView* pTemp = [pAyControl objectAtIndex:i];
        if (pTemp != nil) // Avoid potential leak.  byDBQ20131031
        {
            [m_pAyControl addObject:pTemp];
        }
		
		UIView* pView = (UIView*)[self viewWithTag:(int)pTemp];
		if (pView == NULL)
		{
			pView = [pAyControl objectAtIndex:i];
			[self.contentView addSubview:pView];
		}
	}
	//右侧图片添加到view
	if (nsImg && [nsImg length] > 0)
	{
		UIImage *pImg = [UIImage imageTztNamed:nsImg];
		UIImageView *pImgView = (UIImageView*)[self viewWithTag:kTZTTableCell_ImgView];
		if (pImgView == NULL)
		{
			pImgView = [[UIImageView alloc] init];
			pImgView.frame = self.frame;
			//右侧箭头
			if (bHaveChild)
			{
				pImgView.layer.transform = CATransform3DMakeRotation((M_PI / 180) * 90, 0.0f, 0.0f, 1.0f);
			}
			pImgView.tag = kTZTTableCell_ImgView;
			[self addSubview:pImgView];
			[pImgView release];
		}
		[pImgView setImage:pImg];
	}
}

//设置标题文字
-(void)setTitleText:(NSString*)nsTitle
{
	UILabel *label = (UILabel*)[self viewWithTag:kTZTTableCell_Title];
	if (label)
		label.text = nsTitle;
}

- (void)dealloc
{
	DelObject(m_pAyControl);
    [super dealloc];
}
@end
