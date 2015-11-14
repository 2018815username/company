/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUIBaseTableView.m
* 文件标识:
* 摘要说明:		自定义表格控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/

#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

#import "TZTUIBaseTableView.h"
#import "TZTBaseTableCellView.h"
#import "TZTUICheckBox.h"
#import "TZTUIButtonView.h"


@implementation TZTDatePicker
@synthesize m_pDelegate;
@end


@interface TZTUIBaseTableView(TZTPrivate)
//创建控件函数
-(UIView*)CreateControlForTable:(NSString*)strControl indexPath:(NSUInteger)indexPath;
//创建自定义编辑框
-(UIView*)CreateEditorControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions;
//创建系统编辑框
-(UIView*)CreateEditorControlSys:(NSUInteger)indexPath withOptions:(NSString*)nsOptions;
//创建下拉框
-(UIView*)CreateComBoxControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions;
//创建系统switch
-(UIView*)CreateSwitchControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions;
//创建文本框
-(UIView*)CreateLabelControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions;
//创建按钮
-(UIView*)CreateButtonControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions;
//
-(UIView*)CreateCheckBoxControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions;
//点击事件
-(void)BtnHeaderClick:(id)sender;
//按钮事件响应
-(void)OnButton:(id)sender;
//检查下拉框数据有效性
-(void)CheckSlidView:(UIView*)pView pt_:(CGPoint)point nCount_:(int*)nCount;
//关闭键盘
-(void) OnCloseKeybord;

-(void) showSysKeyboard:(id)keyboardview Show:(BOOL)bShow;

-(void)keyboardWillShow:(NSNotification *)note;
-(void)keyboardWillHide:(NSNotification*)notification;
-(BOOL)TouchInInputField:(CGPoint)pt pView_:(UIView*)pView;
//判断点是不是在输入框内
//
-(BOOL)TouchInButton:(CGPoint)pt pView_:(UIView*)pView;
-(void)OnSelected:(NSDictionary*)pDict;
-(NSDictionary*)GetSubDictTitle:(NSDictionary*)pDict nsMenuName_:(NSString*)nsMenuName nPos_:(int*)nPos;

@end

@implementation TZTMyTableView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
}

@end


@implementation TZTUIBaseTableView
@synthesize m_pTableView;
@synthesize m_pDelegate;
@synthesize m_bOnlyRead;
@synthesize m_bShowIcon;
@synthesize m_bShowImage;
@synthesize m_bScrollEnable;
@synthesize m_nTitleWidth;
@synthesize m_nRowHeight;
@synthesize m_pBackColor;
@synthesize m_nFirstControlWidth;
@synthesize m_nCellMargin;
@synthesize m_nCellIconWidth;
@synthesize m_tztDatePicker;
@synthesize m_pViewStyle;
@synthesize m_nSectionHeight;
@synthesize m_nTableMaxHeight;
@synthesize m_bSeperatorLine;
@synthesize m_bNeedSelected;
@synthesize m_pCurrentTextField;
@synthesize m_bRoundRect;
@synthesize m_pCurrentSelect;
@synthesize bOpenSubMenuNew = _bOpenSubMenuNew;
@synthesize m_pCurrentSelected;
//创建表格控件
/*
	frame 区域 style 类型 bRoundRect 是否圆角 delegate代理
 */
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style bRoundRect:(BOOL)bRound delegate_:(id)pDelegate
{
	self = [super initWithFrame:frame];
	if (self)
	{
        m_nHideNum = 0;
        m_nSliderCount = 0;
        m_nSectionHeight = 0;
		m_nCurrentNum = 0;
        m_bRoundRect = bRound;
		self.m_pViewStyle = style;
		self.m_pDelegate = pDelegate;
        _bOpenSubMenuNew = FALSE;
        m_nTableMaxHeight = (bRound ? frame.size.height - 20 : frame.size.height);//默认就按照传递进来的高度
		//创建表格
		//圆角上下左右自动间距
		if (bRound)
		{
			m_pTableView = [[[TZTMyTableView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20) style:style] autorelease];
		}
		else
		{
			m_pTableView = [[[TZTMyTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:style] autorelease];
		}

		//表格属性设置
		self.m_pTableView.dataSource = self;
		self.m_pTableView.delegate = self;
        if (g_nJYBackBlackColor)
        {
            self.m_pBackColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.6 alpha:1.0];
        }
        else
        {
            self.m_pBackColor = [UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:0xf7/255.0 alpha:1.0];
        }
		self.m_pTableView.backgroundColor = self.m_pBackColor;//[UIColor Color];
		self.m_pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
		m_nRowHeight = 0;
		//圆角
		if (bRound)
		{
			self.m_pTableView.layer.cornerRadius = 10;
			
		}
        self.m_bSeperatorLine = TRUE;//默认显示分割线
        self.m_bNeedSelected = TRUE;//是否有选中状态
		[self addSubview:m_pTableView];
		
        //键盘系统键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		
		
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
		[self addGestureRecognizer:singleTap];
		singleTap.delegate = self;
		[singleTap release];
		[singleTap setNumberOfTouchesRequired:1];//触摸点个数
		[singleTap setNumberOfTapsRequired:1];//点击次数
		
        self.m_pCurrentSelect = nil;
		//添加手势，判断界面的点击事件
		UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelSingleTap:)];
		[self addGestureRecognizer:panRecognizer];
		panRecognizer.maximumNumberOfTouches = 1;
		panRecognizer.delegate = self;
		[panRecognizer release];
		
//		UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
//		[self addGestureRecognizer:panRecognizer];
//		panRecognizer.maximumNumberOfTouches = 1;
//		panRecognizer.delegate = self;
//		[panRecognizer release];
	}
	return self;
}

//设置背景色
-(void)setTableBackgroundColor:(UIColor*)pColor
{
	//设置表格的背景色
	self.m_pBackColor = pColor;
	self.m_pTableView.backgroundColor = pColor;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	if (self.m_pTableView)
	{
		if (m_bRoundRect)
		{
			self.m_pTableView.frame = CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20);
		}
		else
		{
			self.m_pTableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		}
	}
    
    /*m_nTableMaxHeight*/int nHeight = (m_bRoundRect ? frame.size.height - 20 : frame.size.height);//默认就按照传递进来的高度
    m_nTableMaxHeight = MAX(m_nTableMaxHeight, nHeight);
}

//设置边框的宽度和颜色
-(void)setBorderStyle:(int)nBorderWidth cColor_:(CGColorRef)cColor
{
	if (self.m_pTableView)
	{
		self.m_pTableView.layer.borderWidth = nBorderWidth;
		self.m_pTableView.layer.borderColor = cColor;
	}
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	DelObject(_tztOutlineData);
    [super dealloc];
}

-(void)ResetTableStatus
{
    if (m_nTableMaxHeight <= 0)
    {
        m_nTableMaxHeight = TZTValidHeightWithToolBar;
    }
    
    NSUInteger nTotalHeight = self.m_nRowHeight * [self getSectionCount];
    if (m_bRoundRect)
        nTotalHeight += 20;
    if (nTotalHeight > self.frame.size.height/*m_nTableMaxHeight*/)
    {
        self.m_bScrollEnable = TRUE;
        CGRect rcFrame = self.frame;
        CGRect rcTemp = rcFrame;
        NSInteger nHeight = m_nTableMaxHeight;
        rcTemp.size.height = (m_nTableMaxHeight < nTotalHeight ? m_nTableMaxHeight : nTotalHeight);
        //重设界面显示区域;
        self.frame = rcTemp;
        if (nHeight < nTotalHeight)
        {
            m_nTableMaxHeight = nHeight;
        }
        
    }
    else if(nTotalHeight <= m_nTableMaxHeight || (nTotalHeight > m_nTableMaxHeight && nTotalHeight < self.frame.size.height))
    {
        if (!IS_TZTIPAD)
        {
            self.m_bScrollEnable = FALSE;
            CGRect rcFrame = self.frame;
            CGRect rcTemp = rcFrame;
            //        if (nTotalHeight > rcTemp.size.height)
            {
                rcTemp.size.height = nTotalHeight;
            }
            //重设界面显示区域
            self.frame = rcTemp;
        }
        else
        {
            NSInteger nHeight = m_nTableMaxHeight;
            m_nTableMaxHeight = nTotalHeight;
            self.m_bScrollEnable = FALSE;
            CGRect rcFrame = self.frame;
            CGRect rcTemp = rcFrame;
//            if (IS_TZTIPAD && nTotalHeight > rcTemp.size.height)
            {
                rcTemp.size.height = nTotalHeight;
            }
            //重设界面显示区域
            self.frame = rcTemp;
            if (IS_TZTIPAD && nHeight > nTotalHeight)
            {
                m_nTableMaxHeight = nHeight;
            }
        }
    }
}

-(void)setTableDataNoReset:(NSString *)nsName
{
	if (nsName == NULL || [nsName length] < 1)
		return;
	
	_tztOutlineData = [[TZTOutLineData alloc] initWithFile:nsName];
}

//读取配置的表格数据
-(void)setTableData:(NSString *)nsName
{
	if (nsName == NULL || [nsName length] < 1)
		return;
	
	_tztOutlineData = [[TZTOutLineData alloc] initWithFile:nsName];
    
    [self ResetTableStatus];
//    if (m_pTableView)
//    {
//        [self reloadTableData];
//    }
}


-(void)setTableDataEx:(NSMutableDictionary *)pDict
{
    if (pDict == NULL)
        return;
    
    _tztOutlineData = [[TZTOutLineData alloc] initWithData:pDict];
    
    [self ResetTableStatus];
    
}

-(void)setTableData:(NSMutableArray*)ayTitleData ayContent_:(NSMutableArray*)ayContent
{
	if (ayTitleData == NULL || [ayTitleData count] < 1)
		return;
	if (_tztOutlineData)
	{
		DelObject(_tztOutlineData);
	}
	_tztOutlineData = [[TZTOutLineData alloc] initWithData:ayTitleData ayContent_:ayContent];
	if (m_pTableView)
	{
		[self reloadTableData];
	}
    [self ResetTableStatus];
}

-(void)setTableData:(NSMutableArray *)ayTitleData ayContent_:(NSMutableArray *)ayContent withButtonTag_:(int)nBeginTag bShowAdd_:(BOOL)bShow
{
    if (ayTitleData == NULL || [ayTitleData count] < 1)
        return;
    
    if (_tztOutlineData)
        DelObject(_tztOutlineData);
    
    _tztOutlineData = [[TZTOutLineData alloc] initWithData:ayTitleData ayContent_:ayContent withButtonTag_:nBeginTag bShowAdd_:bShow];
    if (m_pTableView)
    {
        [self reloadTableData];
    }
    [self ResetTableStatus];
}


-(void)setTableData:(NSMutableArray *)ayTitleData ayContent_:(NSMutableArray *)ayContent withButtonTag_:(int)nBeginTag
{
    [self setTableData:ayTitleData ayContent_:ayContent withButtonTag_:nBeginTag bShowAdd_:TRUE];
}

//设置表格是否可以滚动
-(void)setM_bScrollEnable:(BOOL)bEnable
{
	if (m_pTableView)
		m_pTableView.scrollEnabled = bEnable;
}

-(void)reloadTableData
{
    if (m_pTableView)
        [m_pTableView reloadData];
}

-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    m_nCurrentNum = 0;
    m_nHideNum = 0;
}

//设置指定行是否显示
-(void)setRowShow:(BOOL)bShow withRowNum_:(int)nRowNum
{
	if (_tztOutlineData && [_tztOutlineData OutlineCount] > nRowNum && nRowNum >= 0)
	{
		NSDictionary* pDict = [_tztOutlineData objectAtIndex:nRowNum];
		if (pDict)
		{
			if (bShow) 
			{
				[pDict setValue:@"1" forKey:@"Show"];
			}
			else
			{
				[pDict setValue:@"0" forKey:@"Show"];
			}
		}
	}
}

-(void)setRowEnabled:(BOOL)bEnable withRowNum:(int)nRowNum
{
	UIView *pView = (UIView*)[self viewWithTag:nRowNum + 2048];
    for (int i = 0; i < [pView.subviews count]; i++)
    {
        UIView *subView = [pView.subviews objectAtIndex:i];
        if (subView && [subView isKindOfClass:[UIButton class]])
        {
            UIButton *pBtn = (UIButton*)subView;
            [pBtn setEnabled:bEnable];
        }
    }
	pView = (TZTBaseTableCellView*)[self viewWithTag:nRowNum + 1024];
    if (!bEnable)
    {
        [pView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1f]];
    }
    else
    {
        [pView setBackgroundColor:[UIColor whiteColor]];
    }
}

-(void)SetCellBackground:(UIColor*)color nsIndexPath_:(NSIndexPath*)nsIndexPath
{
    if (nsIndexPath == Nil)
    {
        return;
    }
    TZTBaseTableCellView *pCell = (TZTBaseTableCellView*)[self.m_pTableView cellForRowAtIndexPath:nsIndexPath];
    if (pCell == nil)
    {
        pCell.backgroundColor = color;
    }
}

//获取选中cell显示名称
-(NSString*)GetCurrentCellTitle:(NSString*)nsID
{
    if (nsID == NULL)
    {
        //默认返回当前选中的
        if (self.m_pCurrentSelect)
        {
            NSString* strCell = [self.m_pCurrentSelect objectForKey:@"Image"];
            return [_tztOutlineData titleForKey:strCell];
        }
        return nil;
    }
	return [_tztOutlineData titleForKey:nsID];
}

//获取选中cell的行情第一个显示菜单key
-(NSString*)GetHQMenuFirstMarket:(NSString*)nsID
{
    if (nsID == NULL)
        return nil;
    return [_tztOutlineData objectForKey:nsID atIndex:11];
}

//获取父类的行情菜单id
-(NSString*)GetHQMenuParentMarket:(NSString*)nsID
{
    if (nsID == NULL)
        return nil;
    return [_tztOutlineData objectForKey:nsID atIndex:12];
}

-(NSArray*)GetMenuDataByID:(NSString*)nsID
{
    if (nsID == NULL)
        return nil;
    return [_tztOutlineData arrayForKey:nsID];
}

//设置选中菜单
-(void)setCurrentSelected:(NSString*)nsMenuName
{
    if (nsMenuName == nil || [nsMenuName length] < 1)
        return;
    
    nsMenuName = [nsMenuName lowercaseString];
    for (int i = 0; i < [_tztOutlineData OutlineCount]; i++)
    {
        NSDictionary* pDict = [_tztOutlineData objectAtIndex:i];
		if (pDict)
		{
			BOOL bShow = [[pDict objectForKey:@"Show"] boolValue];
            if (!bShow) 
                continue;
            
            NSString* strCell = [pDict objectForKey:@"Image"];
            strCell = [strCell lowercaseString];
            if (strCell && [strCell compare:nsMenuName] == NSOrderedSame)
            {
                self.m_pCurrentSelect = (NSMutableDictionary*)pDict;
                //找到菜单项了
                UIView *pView = (UIView*)[self viewWithTag:i+2048];
                UIButton *pBtn = (UIButton*)[pView viewWithTag:i+4096];
                if (pBtn && [pBtn isKindOfClass:[UIButton class]])
                    [self BtnHeaderClick:pBtn];
                else
                    [self OnSelected:pDict];
                return;
            }
            int nIndex = -1;
            NSDictionary* pSubDict = [self GetSubDictTitle:pDict nsMenuName_:nsMenuName nPos_:&nIndex];
            if (pSubDict && nIndex >= 0)
            {
                self.m_pCurrentSelect = (NSMutableDictionary*)pSubDict;
                if (IS_TZTIPAD)
                {
                    //找到菜单,先展开父类的菜单
                    [pDict setValue:@"1" forKey:@"Expanded"];
                    [m_pTableView reloadData];
                    [self ResetTableStatus];
                }
                
                NSIndexPath *pIndexPath = [NSIndexPath indexPathForRow:nIndex inSection:i];
                [self.m_pTableView scrollToRowAtIndexPath:pIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                [self tableView:self.m_pTableView didSelectRowAtIndexPath:pIndexPath];
                
                return;
            }
        }
    }
}

-(NSDictionary*)GetSubDictTitle:(NSDictionary*)pDict nsMenuName_:(NSString*)nsMenuName nPos_:(int*)nPos
{
    *nPos = -1;
    if (pDict == NULL)
        return NULL;
    BOOL bShow = [[pDict objectForKey:@"Show"] boolValue];
    if (!bShow) 
        return nil;
    
    NSString* strCell = [pDict objectForKey:@"Image"];
    strCell = [strCell lowercaseString];
    if (strCell && [strCell compare:nsMenuName] == NSOrderedSame)
    {
        *nPos = 0;
        return pDict;
    }
    //查找子项
    NSArray *pAy = [pDict objectForKey:@"children"];
    if (pAy && [pAy count] > 0)
    {
        for (int i = 0; i < [pAy count]; i++)
        {
            int nIndex = 0;
            NSDictionary *pSubDict = [pAy objectAtIndex:i];
            NSDictionary *pp = [self GetSubDictTitle:pSubDict nsMenuName_:nsMenuName nPos_:&nIndex];
            if (pp && nIndex >= 0)
            {
                *nPos = i;
                return pp;
            }
        }
    }
    return nil;
}

#pragma mark 表格处理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (self.m_pViewStyle == UITableViewStylePlain)
	{
		m_nCurrentNum = 0;
        m_nHideNum = 0;
		if (_tztOutlineData == NULL || [_tztOutlineData OutlineCount] < 1)
		{
			m_nSectionNum = 1;
			return 1;
		}
		m_nSectionNum = [_tztOutlineData OutlineCount];
		return m_nSectionNum;
	}
	else
	{
		return [_tztOutlineData OutlineCount];
	}

}

-(NSInteger)getSectionCount
{
	int nCount = 0;
	
	for (int i = 0; i < [_tztOutlineData OutlineCount]; i++)
	{
		NSDictionary* pDict = [_tztOutlineData objectAtIndex:i];
		if (pDict)
		{
			BOOL bShow = [[pDict objectForKey:@"Show"] boolValue];
			NSArray *pAy = [pDict objectForKey:@"children"];
			if (bShow)
				nCount++;
			
			BOOL bExpanded = [[pDict objectForKey:@"Expanded"] boolValue];
            if (bExpanded)
//			if (self.m_pViewStyle == UITableViewStyleGrouped)
			{
//				nCount++;
				if (pAy && [pAy count] > 0)
				{
					nCount += [pAy count];
				}
			}
		}
		
	}
	m_nSectionNum = nCount;
	return m_nSectionNum;
}

//缩进值
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	NSInteger indent = 1;
	NSDictionary* pDict = [_tztOutlineData objectAtIndex:indexPath.section];
	NSArray* pAy = [pDict objectForKey:@"children"];
	//是否存在子项
	if (pAy && [pAy count] > indexPath.row)
	{
		NSDictionary *pItem = [pAy objectAtIndex:indexPath.row];
		if (pItem)
		{
			//配置的子项的level值，用于缩进距离计算
			NSString* str = [pItem objectForKey:@"Level"];
			if (str && [str length] > 0)
				indent = [str intValue];
		}
	}
	return indent; 
}

-(NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
	if (_tztOutlineData == NULL || [_tztOutlineData OutlineCount] <= section)
	{
		return 0;
	}
	NSInteger nNum = 0;
	NSDictionary* pItem = [_tztOutlineData objectAtIndex:section];
	NSArray *pAy = [pItem objectForKey:@"children"];
	if (pAy)
	{
		NSString* str = [pItem objectForKey:@"Expanded"];
		//是否是展开的
		if (str && [str length] > 0)
		{
			int n = [str intValue];
			if (n > 0)
			{
				nNum = [pAy count];
			}
			else
			{
				nNum = 0;
			}
		}
	}

	if (self.m_pViewStyle == UITableViewStyleGrouped && nNum == 0)
	{
		nNum = 1;
	}
	return nNum;
}

-(void)GetExpandedNum:(NSDictionary*)pDict nCount_:(int*)nCount
{
    int nNum = 0;
    *nCount = 0;
    if (pDict == NULL)
    {
        return;
    }
    NSArray *pAy = [pDict objectForKey:@"children"];
	if (pAy)
    {
        int nExpanded = [[pDict objectForKey:@"Expanded"] intValue];
        if (nExpanded)
        {
            *nCount += [pAy count];
        }
        
        for (int i = 0 ; i < [pAy count]; i++)
        {
            NSDictionary *pSubDict = [pAy objectAtIndex:i];
            nNum = 0;
            [self GetExpandedNum:pSubDict nCount_:&nNum];
            *nCount += nNum;
        }
    }
    
    return;
    
}

//表格行数据
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSString* cellIdentifier = [NSString stringWithFormat:@"CellIdentifier%ld",(long)indexPath.row];// @"CellIdentifier";
	//创建自定义的cell
	TZTBaseTableCellView* cell = (TZTBaseTableCellView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell removeFromSuperview];
    cell = nil;
	if (cell == nil /*&& cell.tag != (indexPath.section+1)*(indexPath.row+1)+4096*/)
	{
		cell = [[[TZTBaseTableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        [cell setFrame:CGRectMake(0, 0, m_pTableView.frame.size.width, m_nCurHeight)];
        cell.tag = (indexPath.section+1)*(indexPath.row+1)+4096;
        if(!self.m_bNeedSelected)//不显示选中
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//设置分割线
		if (self.m_pViewStyle == UITableViewStylePlain && self.m_bSeperatorLine)
        {
//            [tableView setSeparatorColor:[UIColor colorWithRGBULong:0x2f2f2f]];
//            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
			[cell setGridLine:@""];
        }
        [cell setSelected:NO];
        [cell setHighlighted:NO];
        //把参数传递进去，标题宽度、第一个控件的宽度、间距
        cell.m_nTitleWidth = m_nTitleWidth;
        cell.m_nFirstControlWidth = m_nFirstControlWidth;
        cell.m_nCellMargin = m_nCellMargin;
        NSDictionary *pItem = [_tztOutlineData objectAtIndex:indexPath.section];
        NSArray *pAy = [pItem objectForKey:@"children"];
        //不存在子项直接不操作
        //得到当前的数据
        NSDictionary *pp = pItem;
        if (pAy == NULL || [pAy count] < 1)
        {
            if (self.m_pViewStyle == UITableViewStyleGrouped)
            {
                
            }
            else
                return cell;
        }
        else
            pp = [pAy objectAtIndex:indexPath.row];
        //icon名称
        NSString* strCell = [pp objectForKey:@"Image"];
        //标题文字
        NSString* strTitle = [_tztOutlineData titleForKey:strCell];
        //子项数组
    //	NSArray * pSubAy = [pp objectForKey:@"children"];


        UIView *pBG = [[UIView alloc] initWithFrame:cell.frame];
        UIView *pSelView = [[UIView alloc] initWithFrame:cell.frame];
        UIColor* nsColor = [_tztOutlineData BackColorForKey:strCell];
        UIColor* nsSelColor = [_tztOutlineData SelectColorForKey:strCell];
        if (nsColor)
        {
            pBG.backgroundColor = nsColor;
        }
        if (nsSelColor)
        {
            pSelView.backgroundColor = nsSelColor;
        }
        cell.backgroundView = pBG;
        cell.selectedBackgroundView = pSelView;
        [pBG release];
        [pSelView release];
        
        //右侧图片
        NSString *strImg = @"TZTTableArrorRight.png";
        //右侧图片是否显示
        if (!m_bShowImage) 
        {
            strImg = @"";
        }
        
        //得到控件数组
        NSMutableArray *pAyType = [_tztOutlineData controlTypeForKey:strCell];
        NSMutableArray *pAyControl = nil;
        if (pAyType && [pAyType count] > 0)
        {
            pAyControl = [[NSMutableArray alloc] init];
            for ( int i = 0; i < [pAyType count]; i++)
            {
                //根据类型创建控件
                NSUInteger nTag = indexPath.section;
                UIView* pView = [self CreateControlForTable:[pAyType objectAtIndex:i] indexPath:nTag];
                if (pView)
                    [pAyControl addObject:pView];
            }
        }
        
        
        //自定义cell内容填充
        [cell setContent:strCell nsTitle_:strTitle pControl_:pAyControl nsImg_:strImg];
        
        //清空数组，移除数据
        if (pAyControl)
        {
            [pAyControl removeAllObjects];
            [pAyControl release];
        }
    }
    else
        [cell setFrame:CGRectMake(0, 0, m_pTableView.frame.size.width, m_nCurHeight)];

    //由于界面有时需要直接加载数据，但可能出现通过tag去取界面view控件时，由于表格控件的原因，
    //控件尚未创建到view上，导致无法将数据填充进去，所以在加载指定数据条数后，向界面发送一个消息通知
    //控件已经创建，可以填充数据
    
    if (IS_TZTIPAD && self.m_pCurrentSelected != NULL && [self.m_pCurrentSelected compare:indexPath] == NSOrderedSame)
    {
        cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuSelect.png"]] autorelease];
    }
    
	m_nCurrentNum++;
	if (m_nCurrentNum >= ([self getSectionCount] > 8 ? 8 : [self getSectionCount]))
	{
		if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(SetDefaultData)])
		{
			[m_pDelegate SetDefaultData];
		}
		m_nCurrentNum = 0;
	}
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

//获取下一个可以显示的cell
-(int)GetNextShowCell:(NSInteger)section
{
    int nCount = 0;
    if (section >= [_tztOutlineData OutlineCount])
    {
        return 0;
    }
    
    NSDictionary *pItem = [_tztOutlineData objectAtIndex:section];
    if (pItem)
    {
        BOOL bShow = [[pItem objectForKey:@"Show"] boolValue];
        if (!bShow)
        {
            //不显示，继续查找下一个
            nCount++;
            nCount += [self GetNextShowCell:section + 1];
        }
    }
    return nCount;
}
//创建表头数据
/*注:1、目前的表格第一级都是放在这里进行处理显示的
	 2、不能直接使用TZTBaseTableCellView，否则会出现部分控件无法响应的问题*/
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	if (self.m_pViewStyle == UITableViewStyleGrouped)
	{
		return NULL;
	}
    
    NSString *lSystemVersion = [[UIDevice currentDevice] systemVersion]; 
    float fVersion = [lSystemVersion floatValue];
    if (fVersion >= 5.0)
    {        
        if ((section + m_nHideNum) >= [_tztOutlineData OutlineCount])
        {
            return NULL;
        }
        section += m_nHideNum;
    }
	NSDictionary *pItem = [_tztOutlineData objectAtIndex:section];
	
	BOOL bShow = [[pItem objectForKey:@"Show"] boolValue];
    
    //不显示。取下一个
    if (!bShow)
    {
        if (fVersion < 5.0)
        {
            return NULL;
        }
        int nCount = [self GetNextShowCell:section];
        m_nHideNum += nCount;
        section += nCount;
        if (section < [_tztOutlineData OutlineCount])
        {
            pItem = [_tztOutlineData objectAtIndex:(section)];
        }
    }

	UIView* ptableSubView = [[[UIView alloc] init] autorelease];
    ptableSubView.tag = section + 2048;

	//创建自定义的view
	NSString *cellIdentifier = @"HeaderIdentifier";
	TZTBaseTableCellView* cell = nil;
    UIColor *nsColor = nil;
	if(cell == nil)
	{
		cell = [[[TZTBaseTableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        if (self.m_bSeperatorLine)
        {
//            [tableView setSeparatorColor:[UIColor colorWithRGBULong:0x2f2f2f]];
//            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [cell setGridLine:@""];//设置分割线
        }
		cell.backgroundColor = self.m_pBackColor;//使用跟表格一致的背景色
		cell.m_nTitleWidth = m_nTitleWidth;		 //标题宽度	
		cell.m_nFirstControlWidth = m_nFirstControlWidth;//第一个控件的宽度
		cell.m_nCellMargin = m_nCellMargin;		//间距
		cell.tag = section + 1024;
		
		//icon名称
		NSString* strCell = [pItem objectForKey:@"Image"];
		//标题
		NSString* strTitle = [_tztOutlineData titleForKey:strCell];
		//子项数组
		NSArray*  pChild = [pItem objectForKey:@"children"];
		//右侧图片
		NSString *strImg = @"TZTTableArrorRight.png";
		//当前是否是展开的
		BOOL bExpanded = [[pItem objectForKey:@"Expanded"] boolValue];
        //
        nsColor = [_tztOutlineData BackColorForKey:strCell];
        
        
        UIView *pSelView = [[UIView alloc] initWithFrame:cell.frame];
        UIColor* nsSelColor = [_tztOutlineData SelectColorForKey:strCell];
        
        if (nsColor)
        {
            cell.backgroundColor = nsColor;
        }
        if (nsSelColor)
        {
            pSelView.backgroundColor = nsSelColor;
            cell.selectedBackgroundView = pSelView;
        }
        [pSelView release];
		//图片是否显示
		if (!m_bShowImage) 
		{
			strImg = @"";
		}
		//是否存在子项
		BOOL bHaveChild = (/*bExpanded &&*/ pChild != NULL && [pChild count] > 0);
		
		//得到控件数组
		NSMutableArray *pAyType = [_tztOutlineData controlTypeForKey:strCell];
		NSMutableArray *pAyControl = nil;
		if (pAyType && [pAyType count] > 0)
		{
			pAyControl = [[NSMutableArray alloc] init];
			for ( int i = 0; i < [pAyType count]; i++)
			{
				//根据类型创建各个控件
				NSUInteger nTag = section;
				UIView* pView = [self CreateControlForTable:[pAyType objectAtIndex:i] indexPath:nTag];
				if (pView)
					[pAyControl addObject:pView];
			}
		}
		
        if (bHaveChild)
        {
			if (bExpanded)
			{
				//填充view内容
				[cell setContent:strCell nsTitle_:strTitle pControl_:pAyControl nsImg_:strImg bHaveChild_: TRUE];
			}
			else
			{
				//填充view内容
				[cell setContent:strCell nsTitle_:strTitle pControl_:pAyControl nsImg_:strImg bHaveChild_: FALSE];
			}

        }
        else
        {
            //填充view内容
            [cell setContent:strCell nsTitle_:strTitle pControl_:pAyControl nsImg_:strImg bHaveChild_: bHaveChild];
        }
		//释放数组空间
		if (pAyControl)
		{
			[pAyControl removeAllObjects];
			[pAyControl release];
		}
		[ptableSubView addSubview:cell];
	}
	cell.frame = CGRectMake(0, 0, m_pTableView.frame.size.width, m_nCurHeight);
	
	
	//是否只读
	if (!m_bOnlyRead)
	{
		//可点击的话，在上面覆盖了一个透明的button，用于处理点击事件
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(0, 0, m_pTableView.frame.size.width, m_nCurHeight)];
		[ptableSubView addSubview:btn];
        for (int i = 0; i < [[cell subviews] count]; i++)
        {
            UIView *psub = [[cell subviews] objectAtIndex:i];
            if ( psub && [psub isKindOfClass:[TZTUIButtonView class]])
            {
                [cell bringSubviewToFront:psub];
            }
        }
		[btn setTag:section+4096];
		
		[btn addTarget:self action:@selector(OnClickBtnDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchDragOutside];
		[btn addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchCancel];
		[btn addTarget:self action:@selector(BtnHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	ptableSubView.frame = cell.frame;
	
	
    //由于界面有时需要直接加载数据，但可能出现通过tag去取界面view控件时，由于表格控件的原因，
    //控件尚未创建到view上，导致无法将数据填充进去，所以在加载指定数据条数后，向界面发送一个消息通知
    //控件已经创建，可以填充数据

	m_nCurrentNum++;
	if (m_nCurrentNum >= ([self getSectionCount] > 10 ? 10 : [self getSectionCount]))
	{
		if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(SetDefaultData)])
		{
			[m_pDelegate SetDefaultData];
		}
		m_nCurrentNum = 0;
	}
	return ptableSubView;
}

//section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.m_pViewStyle == UITableViewStyleGrouped)
    {
        if (m_nSectionHeight < 0)
            return 10;
        else
            return m_nSectionHeight;
    }
	//若没有配置，使用默认
	if (m_nRowHeight <= 0)
	{
		m_nCurHeight = 44.0;
		return 44.0;
	}
	else
	{
		m_nCurHeight = m_nRowHeight;
		return m_nRowHeight;
	}

}

//行高（同section）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (m_nRowHeight <= 0)
	{
		m_nCurHeight = 44.0;
		return 44.0;
	}
	else
	{
		m_nCurHeight = m_nRowHeight;
		return m_nRowHeight;
	}
}

//选中行处理
/*只对row有效，对section无效，section的选中事件在BtnHeaderClick中处理*/
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell *pCell = [tableView cellForRowAtIndexPath:indexPath];
	if (pCell == nil)
		return;
	[pCell setSelected:NO];
    //设置选中的背景色
    if (IS_TZTIPAD)
    {
        if (self.m_pCurrentSelected)
        {
            UITableViewCell *pPreCell = [tableView cellForRowAtIndexPath:self.m_pCurrentSelected];
            if (pPreCell)
            {
                if (IS_TZTIPAD)
                {
                    pPreCell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]] autorelease];
                }
                else
                {
                    UIView *pView = [[UIView alloc] init];
                    pView.backgroundColor = [UIColor colorWithRed:26/255.0f green:26/255.0f blue:26/255.0f alpha:1.0f];
                    pPreCell.backgroundView = pView;//[[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]] autorelease];
                    [pView release];
                    
                }
            }
        }
        
        TZTBaseTableCellView *pPreView = (TZTBaseTableCellView*)[self viewWithTag:m_nCurrentSelected + 1024];
        if (pPreView)
        {
            if (IS_TZTIPAD)
            {
                pPreView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]] autorelease];
            }
            else
            {
                UIView *pView = [[UIView alloc] init];
                pView.backgroundColor = [UIColor colorWithRed:26/255.0f green:26/255.0f blue:26/255.0f alpha:1.0f];
                pPreView.backgroundView = pView;//[[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]] autorelease];
                [pView release];
                
            }
        }
        m_nCurrentSelected = -1;
        self.m_pCurrentSelected = indexPath;
    }
    
    pCell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuSelect.png"]] autorelease];
	//获取改行的数据
	NSDictionary *pDict = [_tztOutlineData objectAtIndex:indexPath.section];
	if (pDict == NULL)
		return;
	//子项数组
	NSMutableArray *pAy = [pDict objectForKey:@"children"];
	NSDictionary* pSubDict = [pAy objectAtIndex:indexPath.row];
	NSMutableArray *pSubAy = [pSubDict objectForKey:@"children"];
	if (pSubAy && [pSubAy count] > 0)//还存在子项
	{
		//判断展开状态
		NSString *str = [pSubDict objectForKey:@"Expanded"];
		int nExpand = 0;
		if (str && [str length] > 0)
		{
			nExpand = [str intValue];
		}
		
		NSInteger nNow = indexPath.row+1;
        
        if (_bOpenSubMenuNew)
        {
            if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(OpenSubMenuInNewWindow:)])
            {
                [m_pDelegate OpenSubMenuInNewWindow:pSubDict];
                return;
            }
        }
        
		if (nExpand <= 0)//需要展开
		{
			//设置展开状态
			[pSubDict setValue:@"1" forKey:@"Expanded"];
			NSMutableArray *array = [[NSMutableArray alloc] init];
			//将子项中的内容添加到当前的数组中
			for (int i = 0; i < [pSubAy count]; i++)
			{
				NSIndexPath *pNewIndex = [NSIndexPath indexPathForRow:nNow+i inSection:indexPath.section];
				[pAy insertObject:[pSubAy objectAtIndex:i] atIndex:nNow+i];
				[array addObject:pNewIndex];
			}
			//重新加载数据
			[m_pTableView reloadData];
            [self ResetTableStatus];
			[m_pTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
			[array removeAllObjects];
			[array release];
            
            //zxl 20130927 3级菜单打开直接选择3级菜单的子菜单
            pSubDict = [pSubAy objectAtIndex:0];
            pSubAy = [pSubDict objectForKey:@"children"];
            if (pSubAy== NULL)
            {
                [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:nNow inSection:indexPath.section]];
                return;
            }
		}
		else//收拢
		{
			//否则收拢菜单
			int nCount = 0;
			[self collapseBranchAtIndex:pSubDict index_:indexPath.row nCount_:&nCount];
			//设置展开状态
			[pSubDict setValue:@"0" forKey:@"Expanded"];
			NSRange range;
			range.location = indexPath.row+1;
			range.length = nCount;
			[pAy removeObjectsInRange:range];
			//重新加载数据
			[m_pTableView reloadData];
            [self ResetTableStatus];
			return;
		}	
	}
	
	//没有子项，则直接处理点击事件
    self.m_pCurrentSelect = (NSMutableDictionary*)pSubDict;
	NSString* strCell = [pSubDict objectForKey:@"Image"];
	//得到配置的该处的功能号
	int nMsgType = [_tztOutlineData msgTypeForKey:strCell];
    NSString* nsName = @"";
    nsName = [_tztOutlineData nsParamForKey:strCell];
    NSArray *pAyCell = [_tztOutlineData arrayForKey:strCell];
    if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(DealWithMenu:nsParam_:pAy_:)]) 
    {
        [m_pDelegate DealWithMenu:nMsgType nsParam_:nsName pAy_:pAyCell];
        return;
    }
}

//收拢当前点击菜单的所有子项（递归，统计了总共有多少个展开的子项）
-(void)collapseBranchAtIndex:(NSDictionary*)pDict index_:(NSInteger)index nCount_:(int*)nCount
{
	if (pDict == NULL)
		return;
	NSMutableArray *pAy = [pDict objectForKey:@"children"];//是否存在子项
	if (pAy == NULL || [pAy count] < 1)
	{
		*nCount+=1;
		return;	
	}

	NSString *str = [pDict objectForKey:@"Expanded"];
	//未展开，则只加上自身
	if (str && [str length] <= 0)
	{
		*nCount+=1;
		return;
	}
	
	int nFlag = [str intValue];
	if (nFlag <= 0)
	{
		*nCount+=1;
		return;	
	}
	
	//递归调用
	for (int i = 0; i < [pAy count]; i++)
	{
		NSDictionary* pSubDict = [pAy objectAtIndex:i];
		NSMutableArray *pSubAy = [pSubDict objectForKey:@"children"];//是否存在子项
		NSString* str = [pSubDict objectForKey:@"Expanded"];
		int nFlag = 0;
		if (str && [str length] > 0)
		{
			nFlag = [str intValue];
		}
		if (pSubAy && [pSubAy count] > 0 && nFlag > 0)
		{
			*nCount += 1;
		}
		[self collapseBranchAtIndex:pSubDict index_:index+i nCount_:nCount];
		[pDict setValue:@"0" forKey:@"Expanded"];
	}
	[pDict setValue:@"0" forKey:@"Expanded"];
	
}

-(void)OnClickBtnDown:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	NSInteger nTag = btn.tag;
	TZTBaseTableCellView *pView = (TZTBaseTableCellView*)[self viewWithTag:nTag + 1024];
	if (pView)
	{
		[pView setHighlighted:YES];
	}
}

-(void)OnClickBtnUp:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	NSInteger nTag = btn.tag;
	TZTBaseTableCellView *pView = (TZTBaseTableCellView*)[self viewWithTag:nTag + 1024];
	if (pView)
	{
		[pView setHighlighted:NO];
	}
	[btn setBackgroundColor:[UIColor clearColor]];
	[btn setHighlighted:NO];
}

//点击表格（section）事件处理
-(void)BtnHeaderClick:(id)sender
{
	UIButton *btn = (UIButton*)sender;
	int nTag = (int)btn.tag;
    nTag -= 4096;
	
	TZTBaseTableCellView *pView = (TZTBaseTableCellView*)[self viewWithTag:nTag + 1024];
	if (pView)
	{
		[pView setHighlighted:NO];
	}
	[btn setBackgroundColor:[UIColor clearColor]];
	[btn setHighlighted:NO];
    
	//根据tag来取当前的数据
	NSDictionary* pDict = [_tztOutlineData objectAtIndex:nTag];
	if (pDict == NULL)
		return;
	//子项数组
    self.m_pCurrentSelect = (NSMutableDictionary*)pDict;
	[self OnSelected:pDict];
    
    if (IS_TZTIPAD)
    {
        if (m_nCurrentSelected > -1)
        {
            TZTBaseTableCellView *pPreView = (TZTBaseTableCellView*)[self viewWithTag:m_nCurrentSelected + 1024];
            if (pPreView)
            {
                if (IS_TZTIPAD)
                {
                    pPreView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]] autorelease];
                }
                else
                {
                    UIView *pView = [[UIView alloc] init];
                    pView.backgroundColor = [UIColor colorWithRed:26/255.0f green:26/255.0f blue:26/255.0f alpha:1.0f];
                    pPreView.backgroundView = pView;//[[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]] autorelease];
                    [pView release];
                    
                }
            }
        }
        
        if (self.m_pCurrentSelected && m_pTableView)
        {
            UITableViewCell *pPreCell = [m_pTableView cellForRowAtIndexPath:self.m_pCurrentSelected];
            if (pPreCell)
            {
                if (IS_TZTIPAD)
                {
                    pPreCell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]] autorelease];
                }
                else
                {
                    UIView *pView = [[UIView alloc] init];
                    pView.backgroundColor = [UIColor colorWithRed:26/255.0f green:26/255.0f blue:26/255.0f alpha:1.0f];
                    pPreCell.backgroundView = pView;//[[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuCellColor.png"]] autorelease];
                    [pView release];
                    
                }
            }
        }
        
        m_nCurrentSelected = nTag;
        pView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageTztNamed:@"TZTMenuSelect.png"]] autorelease];
    }
}

-(void)OnSelected:(NSDictionary*)pDict
{
	//展开判断
	NSString *str = [pDict objectForKey:@"Expanded"];
	if (str == NULL || [str length] < 1)
		return;
    NSMutableArray *pAy = [pDict objectForKey:@"children"];
	if (pAy == NULL || [pAy count] < 1)//直接点击处理
	{
		//当前行的key
		NSString* strCell = [pDict objectForKey:@"Image"];
		//得到功能号
		int nMsgType = [_tztOutlineData msgTypeForKey:strCell];
		
		if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(sendActionFromId:)]) 
		{
			[m_pDelegate sendActionFromId:nMsgType];
			return;
		}
        NSString* nsName = @"";
        nsName = [_tztOutlineData nsParamForKey:strCell];
        NSArray *pAyCell = [_tztOutlineData arrayForKey:strCell];
        if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(DealWithMenu:nsParam_:pAy_:)]) 
        {
            [m_pDelegate DealWithMenu:nMsgType nsParam_:nsName pAy_:pAyCell];
            return;
        }
        
		[TZTUIBaseVCMsg OnMsg:nMsgType wParam:(NSUInteger)nsName lParam:0];
		return;
	}
    
    //新建窗口打开子菜单
    if (_bOpenSubMenuNew)
    {
        if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(OpenSubMenuInNewWindow:)])
        {
            [m_pDelegate OpenSubMenuInNewWindow:pDict];
            return;
        }
    }
	//设置展开状态
	int nFlag = [str intValue];
	if (nFlag <= 0)
		[pDict setValue:@"1" forKey:@"Expanded"];
	else
		[pDict setValue:@"0" forKey:@"Expanded"];
	//刷新表格
	[m_pTableView reloadData];
    [self ResetTableStatus];
}

//创建控件
-(UIView*)CreateControlForTable:(NSString*)strControl indexPath:(NSUInteger)indexPath
{
	if (strControl == NULL || [strControl length] < 1)
		return nil;
	
	//解析数据中的等于(=)号，截取等于号前的数据（等于号前的数据是对应的控件类型）
	NSMutableArray* aycelldate = [[[NSMutableArray alloc] initWithArray:[strControl componentsSeparatedByString:@"="]] autorelease];
	//不存在，直接返回
	if (aycelldate == NULL || [aycelldate count] < 1)
		return nil;
	//得到类型
	NSString* strType = [aycelldate objectAtIndex:0];
	//等于号(=)后面的是该控件对应的属性
	NSString* strOptions = nil;
	if ([aycelldate count] > 1)
		strOptions = [aycelldate objectAtIndex:1];
	if([strType compare:@"TZTEditor"] == NSOrderedSame)
        strType = @"TZTEditorSys";
	if ([strType compare:@"TZTEditor"] == NSOrderedSame)//自定义编辑框
	{
		return [self CreateEditorControl:indexPath  withOptions:strOptions];
	}
	else if([strType compare:@"TZTComBox"] == NSOrderedSame)//下拉框
	{
		return [self CreateComBoxControl:indexPath  withOptions:strOptions];
	}
	else if([strType compare:@"TZTSwitch"] == NSOrderedSame)//按钮
	{
		return [self CreateSwitchControl:indexPath  withOptions:strOptions];
	}
	else if([strType compare:@"TZTLabel"] == NSOrderedSame)//文本
	{
		return [self CreateLabelControl:indexPath  withOptions:strOptions];
	}
	else if([strType compare:@"TZTButton"] == NSOrderedSame)//按钮
	{
		return [self CreateButtonControl:indexPath  withOptions:strOptions];
	}
	else if([strType compare:@"TZTEditorSys"] == NSOrderedSame)//系统编辑框
	{
		return [self CreateEditorControlSys:indexPath withOptions:strOptions];
	}
	else if([strType compare:@"TZTCheckBox"] == NSOrderedSame)//选择框控件
	{
		return [self CreateCheckBoxControl:indexPath withOptions:strOptions];
	}
	else//其它
	{
		return nil;
	}
}

//创建选择框控件
-(UIView*)CreateCheckBoxControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions
{
	//数据数组
	NSMutableArray* aycelldate = nil;
	//控件对应的tag（配置文件配置）
	int nTag = 0;
	//默认显示文字
	NSString* strPlacorText = @"";
	//选中后显示的文字
	NSString* strPlacorText1 = @"";
	//警告文字，用于在点击界面按钮时，判断是否选择了该控件，若该控件要强制选择的，用户却未选择，则弹出该提示信息
	NSString* strMsgInfo = @"";
	//该控件的值是否需要判断，用户点击按钮时判断
	BOOL bNeedCheck = FALSE;
	//属性解析
	if (nsOptions != nil && [nsOptions length] > 0)
	{
		aycelldate = [[[NSMutableArray alloc] initWithArray:[nsOptions componentsSeparatedByString:@"^"]] autorelease];
		if (aycelldate)
		{
			NSInteger nCount = [aycelldate count];
			//输入框tag
			if (nCount > 0)
				nTag = [[aycelldate objectAtIndex:0] intValue];
			//默认显示文本
			if (nCount > 1)
			{
				strPlacorText = [aycelldate objectAtIndex:1];
			}
			//选中时的文本
			if (nCount > 2)
			{
				strPlacorText1 = [aycelldate objectAtIndex:2];
			}
			//是否需要校验有效性
			if (nCount > 5)
			{
				bNeedCheck = [[aycelldate objectAtIndex:5] boolValue];
			}
			//提示信息文本
			if (nCount > 6)
			{
				strMsgInfo = [aycelldate objectAtIndex:6];
			}
		}
	}
	
	//创建自定义的选择框控件
	TZTUICheckBox *pField = [[[TZTUICheckBox alloc] initWithFrame:CGRectZero withTitle:strPlacorText andCheckedTitle_:strPlacorText1] autorelease];
	//代理
	pField.m_pDelegate = m_pDelegate;
	//默认不选中
	pField.m_bChecked = FALSE;
	//是否需要有效性判断
	pField.m_bNeedCheckValue = bNeedCheck;
	//提示信息文本
	pField.m_nsMsgInfo = strMsgInfo;
	//控件的tag值
	pField.tag = nTag;
	return (UIView*)pField;
}

//创建系统输入框
-(UIView*)CreateEditorControlSys:(NSUInteger)indexPath withOptions:(NSString*)nsOptions
{	
	NSMutableArray* aycelldate = nil;
	//tag值
	int nTag = 0;
	int nType = 0;
	int nMaxLen = 20;
	NSString* strPlacorText = @"";
	BOOL bNeedCheck = TRUE;
	if (nsOptions != nil && [nsOptions length] > 0)
	{
		aycelldate = [[[NSMutableArray alloc] initWithArray:[nsOptions componentsSeparatedByString:@"^"]] autorelease];
		if (aycelldate)
		{
			NSInteger nCount = [aycelldate count];
			//输入框tag
			if (nCount > 0)
				nTag = [[aycelldate objectAtIndex:0] intValue];
			//默认显示文本
			if (nCount > 1)
			{
				strPlacorText = [aycelldate objectAtIndex:1];
			}
			//输入框类型,调用相应键盘
			if (nCount > 3)
			{
				NSString* strType = [aycelldate objectAtIndex:3];
				if ([strType compare:@"Number"] == NSOrderedSame)//数字键盘
				{
					nType = 0;
				}
				else if([strType compare:@"Password"] == NSOrderedSame)//密码输入
				{
					nType = 2;
				}
                else
                {
                    nType = -1;
                }
			}
			//最大输入长度
			if (nCount > 4)
			{
				nMaxLen = [[aycelldate objectAtIndex:4] intValue];
			}
			//是否需要校验
			if (nCount > 5)
			{
				bNeedCheck = [[aycelldate objectAtIndex:5] boolValue];
			}
		}
	}
	
	TZTUITextField * pField = [[[TZTUITextField alloc] initWithFrame:CGRectZero] autorelease];
	pField.bNeedCheck = bNeedCheck;
	pField.nNumberofRow = indexPath;
	pField.m_pDelegate = self;
    pField.tztdelegate = self;
	pField.placeholder = strPlacorText;
    pField.maxlen = nMaxLen;
//	pField.delegate = self;
	pField.borderStyle = UITextBorderStyleNone;// UITextBorderStyleRoundedRect;
	pField.layer.borderWidth = 1;
	pField.layer.cornerRadius = 5.0;
	pField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	pField.textAlignment = UITextAlignmentCenter;
	pField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    pField.backgroundColor = [UIColor whiteColor];
    pField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    if (nType == 2)
    {
        pField.secureTextEntry = YES;
    }
//    if (nType == -1 || nType == 0)
//    {
//        pField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        nType = 0;
//    }
//	pField.secureTextEntry = nType;
	pField.placeholder = strPlacorText;
	pField.font = tztUIBaseViewTextFont(0);
	pField.tag = nTag;
	return (UIView*)pField;
}

//创建下拉框控件
-(UIView*)CreateComBoxControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions
{
	NSMutableArray* aycelldate = nil;
	//tag值
	int nTag = 0;
	//默认文本
	NSString* strPlacorText = @"";
	//右侧是否带删除按钮
	BOOL bJY = FALSE;
	//类型 0－普通下拉框 1－带编辑功能 2－日期选择
	int nType = 0;
	BOOL bHaveRight = YES;
    int nWidth = 150;
	if (nsOptions != nil && [nsOptions length] > 0)
	{
		aycelldate = [[[NSMutableArray alloc] initWithArray:[nsOptions componentsSeparatedByString:@"^"]] autorelease];
		if (aycelldate)
		{
			NSInteger nCount = [aycelldate count];
			//输入框tag
			if (nCount > 0)
				nTag = [[aycelldate objectAtIndex:0] intValue];
			//默认文本
			if (nCount > 1)
				strPlacorText = [aycelldate objectAtIndex:1];
            if (nCount > 2)
                nWidth = [[aycelldate objectAtIndex:2] intValue];
			//右侧是否带删除按钮
			if (nCount > 3)
				bJY = [[aycelldate objectAtIndex:3] boolValue];
			if (nCount > 4)
				nType = [[aycelldate objectAtIndex:4] intValue];
			if (nCount > 5)
				bHaveRight = [[aycelldate objectAtIndex:5] boolValue];
		}
	}

	tztUIDroplistView* droplistview = [[[tztUIDroplistView alloc]initWithFrame:CGRectZero]autorelease];
    
    droplistview.droplistViewType = nType;
    droplistview.dropbtnMode = bHaveRight;
    if (nWidth < 150)
        nWidth = 150;
    droplistview.listviewwidth = nWidth;
	//默认文本
    droplistview.placeholder = strPlacorText;
	droplistview.text = @"";
    //是否带删除按钮
    droplistview.droplistdel = bJY;
	droplistview.tag = nTag;
	droplistview.tztdelegate = self;
    droplistview.frame = CGRectMake(0, 0, nWidth, 44);
	//背景图
	return (UIView*)droplistview;
}

//创建switch控件（未扩展，暂未使用）
-(UIView*)CreateSwitchControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions
{
//	TZT_GTSwitchView *pSwitch = [[[TZT_GTSwitchView alloc] init] autorelease];
//	pSwitch.delegate = m_pDelegate;
//	pSwitch.tag = (UINT)pSwitch;
//	return (UIView*)pSwitch;
    return NULL;
}

//创建文本框控件
-(UIView*)CreateLabelControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions
{
	NSMutableArray* aycelldate = nil;
	//tag值
	int nTag = 0;
	//默认文本
	NSString* strPlacorText = @"";
	//对齐方式
	NSString* nsAlignment = @"";
	//默认居中对齐
	int nType = UITextAlignmentCenter;
    UIColor *clText = [UIColor whiteColor];
    if (!g_nJYBackBlackColor)
    {
        clText = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    }
	//字体大小，默认15号字体
	int nFontSize = 15;
	if (nsOptions != nil && [nsOptions length] > 0)
	{
		aycelldate = [[[NSMutableArray alloc] initWithArray:[nsOptions componentsSeparatedByString:@"^"]] autorelease];
		if (aycelldate)
		{
			NSInteger nCount = [aycelldate count];
			//输入框tag
			if (nCount > 0)
				nTag = [[aycelldate objectAtIndex:0] intValue];
			//默认文本
			if (nCount > 1)
				strPlacorText = [aycelldate objectAtIndex:1];
			//对齐方式
			if (nCount > 2)
				nsAlignment = [aycelldate objectAtIndex:2];
			//字体大小
			if (nCount > 3)
				nFontSize = [[aycelldate objectAtIndex:3] floatValue];
            if (nCount > 4)
            {
                NSString* nsColor = [aycelldate objectAtIndex:4];
                NSArray *pAy = [nsColor componentsSeparatedByString:@","];
                float r = 0.0;
                float g = 0.0;
                float b = 0.0;
                float alpha = 1.0f;
                for (int i = 0; i < MIN(4, [pAy count]); i++)
                {
                    float nValue = [[pAy objectAtIndex:i] floatValue];
                    if (i == 0)
                        r = nValue;
                    if (i == 1)
                        g = nValue;
                    if (i == 2)
                        b = nValue;
                    if (i == 3)
                        alpha = nValue;
                }
                
                clText = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
            }
		}
	}
	
	//对齐方式判断
	if ([nsAlignment compare:@"Center"] == NSOrderedSame)
		nType = UITextAlignmentCenter;
	else if([nsAlignment compare:@"Left"] == NSOrderedSame)
		nType = UITextAlignmentLeft;
	else if([nsAlignment compare:@"Right"] == NSOrderedSame)
		nType = UITextAlignmentRight;
	
	//创建label
	UILabel* pLabel = [[[UILabel alloc] init] autorelease];
	//对齐方式
	pLabel.textAlignment = nType;
	//自适应字体
    pLabel.lineBreakMode = UILineBreakModeCharacterWrap;
	pLabel.adjustsFontSizeToFitWidth = YES;
	//背景色，与表格保持一致
	pLabel.backgroundColor = [UIColor clearColor];//self.m_pBackColor;
	//字体颜色
   
    pLabel.textColor = clText;
	//字体大小
	pLabel.font = tztUIBaseViewTextFont(nFontSize);
	//默认文字
	[pLabel setText:strPlacorText];
	//tag值
	pLabel.tag = nTag;
	return (UIView*)pLabel;
}

//创建自定义按钮控件
-(UIView*)CreateButtonControl:(NSUInteger)indexPath withOptions:(NSString*)nsOptions
{
	//tag值
	int nTag = 0;
	//显示文本
	NSString *strPlacorText = @"";
	//背景图
	NSString *nsImage = @"";
	//按钮类型
//	NSString *nsType = @"";
	//按钮上的小图（效果见买卖界面按钮）
	NSString *nsSubImage = @"";
	//文字颜色
	NSString *nsColor= @"";
	//是否需要校验页面数据，默认不校验
	BOOL bNeedCheck = FALSE;
	//默认圆角按钮类型
//	int nType = UIButtonTypeRoundedRect;
	//默认15号字体
	int nFontSize = 15;
	if (nsOptions != nil && [nsOptions length] > 0)
	{
		NSMutableArray* aycelldate = [[[NSMutableArray alloc] initWithArray:[nsOptions componentsSeparatedByString:@"^"]] autorelease];
		if (aycelldate)
		{
			NSInteger nCount = [aycelldate count];
			//输入框tag
			if (nCount > 0)
				nTag = [[aycelldate objectAtIndex:0] intValue];
			//显示文字
			if (nCount > 1)
				strPlacorText = [aycelldate objectAtIndex:1];
			//背景图
			if (nCount > 2)
				nsImage = [aycelldate objectAtIndex:2];
			//小图
			if (nCount > 3)
				nsSubImage = [aycelldate objectAtIndex:3];
			//类型
//			if (nCount > 5)
//				nsType = [aycelldate objectAtIndex:5];
			//字体大小
			if (nCount > 6)
				nFontSize = [[aycelldate objectAtIndex:6] floatValue];
			//校验标识
			if (nCount > 7)
				bNeedCheck = [[aycelldate objectAtIndex:7] boolValue];
			//文字颜色
			if (nCount > 8)
				nsColor = [aycelldate objectAtIndex:8];
		}
	}
	
	//颜色值
	UIColor* pColor = [UIColor blackColor];
	if ([nsColor compare:@"Red"] == NSOrderedSame)
	{
		pColor = [UIColor redColor];
	}
	if ([nsColor compare:@"Green"] == NSOrderedSame)
	{
		pColor = [UIColor  colorWithRed:0.0 green:136.0/255.0 blue:26.0/255.0 alpha:1.0];
	}
    if ([nsColor compare:@"White"] == NSOrderedSame)
    {
        pColor = [UIColor whiteColor];
    }
	
	//创建
//	TZTUIButtonView *pButton = [TZTUIButtonView buttonWithType:UIButtonTypeCustom];
    TZTUIButtonView *pButton = [[[TZTUIButtonView alloc] CreateButtonViewWithFrame:CGRectZero nsImgBack_:nsImage nsImage_:nsSubImage nsTitle_:strPlacorText] autorelease];
    //[[TZTUIButtonView alloc] CreateButtonViewWithFrame:CGRectZero nsImgBack_:nsImage nsImage_:nsSubImage nsTitle_:strPlacorText];
	pButton.m_pDelegate = self;
	//字体大小
	pButton.m_nFontSize = nFontSize;
	//tag值
	pButton.tag = nTag;
    pButton.m_nNumberOfRow = indexPath;
	//校验标识
	pButton.bNeedCheck = bNeedCheck;
	//文字颜色
	pButton.m_pColor = pColor;
	//添加按钮响应
//    [pButton addTarget:self action:@selector(OnButton:)];
	[pButton addTarget:self action:@selector(OnButton:) forControlEvents:UIControlEventTouchUpInside];
	return (UIView*)pButton;
}

//校验数据有效性
-(BOOL)CheckInput:(UIView*)pView
{
	//判断下拉框
	if (pView && [pView isKindOfClass:[tztUIDroplistView class]])
	{
		tztUIDroplistView *pDroplist = (tztUIDroplistView*)pView;
		NSString *nsValue = pDroplist.text;
		if (nsValue == NULL || [nsValue length] <= 0)
		{
			//弹出提示信息框
			CGRect appRect = [[UIScreen mainScreen] bounds];
			TZTUIMessageBox *pMessage = [[[TZTUIMessageBox alloc] initWithFrame:appRect nBoxType_:TZTBoxTypeNoButton delegate_:nil] autorelease];
			pMessage.m_nsContent = pDroplist.placeholder;
			[pMessage showForView:self];
			return FALSE;
		}
	}
	//
	if (pView && [pView isKindOfClass:[TZTUITextField class]])
	{
		if (!((TZTUITextField*)pView).enabled || !((TZTUITextField*)pView).bNeedCheck)
		{
			return TRUE;
		}
		NSString *nsValue = ((UITextField*)pView).text;
		if (nsValue == NULL || [nsValue length] < 1)
		{
			//弹出提示信息框
			CGRect appRect = [[UIScreen mainScreen] bounds];
			TZTUIMessageBox *pMessage = [[[TZTUIMessageBox alloc] initWithFrame:appRect nBoxType_:TZTBoxTypeNoButton delegate_:nil] autorelease];
			pMessage.m_nsContent = ((TZTUITextField*)pView).placeholder;
			[pMessage showForView:self];
			return FALSE;
		}
	}
	
	//判断选择框
	if (pView && [pView isKindOfClass:[TZTUICheckBox class]])
	{
		//选择框需要校验，但没选择的，弹出提示信息
		BOOL bNeedCheck = ((TZTUICheckBox*)pView).m_bNeedCheckValue;
		if (bNeedCheck && !((TZTUICheckBox*)pView).m_bChecked)
		{
//            AfxMessageTipBox( [((TZTUICheckBox*)pView).m_nsMsgInfo UTF8String], "系统提示");
            return FALSE;
//			CGRect appRect = [[UIScreen mainScreen] bounds];
//			TZTUIMessageBox *pMessage = [[[TZTUIMessageBox alloc] initWithFrame:appRect nBoxType_:TZTBoxTypeNoButton delegate_:nil] autorelease];
//			pMessage.m_nsContent = ((TZTUICheckBox*)pView).m_nsMsgInfo;
//			[pMessage showForView:self];
//			return FALSE;
		}
	}
	
	//递归判断
	for (int i = 0; i < [pView.subviews count]; i++)
	{
		UIView* pSubView = [pView.subviews objectAtIndex:i];
		if (pSubView)
		{
			BOOL bSucc = [self CheckInput:pSubView];
			if (!bSucc)//只要有一个没有输入，后面的不再判断，直接弹出提示信息
			{
				return FALSE;
			}
		}
	}
	return TRUE;
}

//按钮事件处理
-(void)OnButton:(id)sender
{
	TZTUIButtonView* pButton = (TZTUIButtonView*)sender;
	//判断该按钮是不是要校验页面数据，若要校验，则检查数据有效性
	if (pButton.bNeedCheck && ![self CheckInput:self]) 
		return;
	
    [self OnCloseKeybord];
	//返回页面view去处理各自的按钮事件，页面通过tag值来区分各个控件
	if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(OnButton:)])
	{
		[m_pDelegate OnButton:sender];
	}
}


#pragma mark 文本值获取
-(void)SetSysEditorText:(NSString*)nsValue withTag:(int)nTag
{
	if (nsValue == nil)return;
	
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[UITextField class]])
	{
		return;
	}
	UITextField *pField = (UITextField*)view;
	if (pField)
	{
		pField.text = nsValue;
	}
}

-(NSString*)GetSysEditorTextWithTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[UITextField class]])
	{
		return nil;
	}
	
	UITextField *pField = (UITextField*)view;
	if (pField)
	{
		return pField.text;
	}
	else
	{
		return nil;
	}

}

-(void)SetSysEditorEditable:(BOOL)bEdit withTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[UITextField class]])
	{
		return;
	}
	UITextField* pField = (UITextField*)view;
	if (pField)
	{
		pField.enabled = bEdit;
	}
    
}

-(void)SetEditorText:(NSString *)nsValue withTag:(int)nTag
{
	if (nsValue == nil)return;
	
	UIView* view = (UIView*)[self viewWithTag:nTag];
    if([view isKindOfClass:[UITextField class]])
    {
        UITextField *pField = (UITextField*)view;
        if (pField)
        {
            pField.text = nsValue;
        }
    }
}

-(NSString*)GetEditorTextWithTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
    if([view isKindOfClass:[UITextField class]])
    {
        return ((UITextField*)view).text;
    }
    
    return nil;
}

-(void)SetEditorEditable:(BOOL)bEdit withTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if([view isKindOfClass:[UITextField class]])
    {
        UITextField* pField = (UITextField*)view;
        if (pField)
        {
            pField.enabled = bEdit;
        }
    }
}

-(void)SetLabelText:(NSString *)nsValue withTag:(int)nTag
{
	if (nsValue == nil)return;
	
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[UILabel class]])
	{
		return;
	}
	UILabel *pLabel = (UILabel*)view;
	if (pLabel)
	{
		pLabel.text = nsValue;
	}
}

-(NSString*)GetLabelTextWithTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[UILabel class]])
	{
		return nil;
	}
	UILabel *pLabel = (UILabel*)view;
	if (pLabel)
		return pLabel.text;
	else
		return nil;
}

-(void)SetComBoxDataWith:(int)nTag ayTitle_:(NSMutableArray *)ayTitle ayContent_:(NSMutableArray *)ayContent AndIndex_:(int)nIndex bShow_:(BOOL)bShow
{
	if (ayTitle != nil && ayContent != nil)
	{
		//数据不匹配
		if ([ayTitle count] != [ayContent count])
			return;
	}
	
	if (nIndex < 0)
	{
		nIndex = 0;
	}
	if (ayTitle && nIndex >= [ayTitle count])
	{
		nIndex = 0;
	}
	
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[tztUIDroplistView class]])
	{
		return;
	}
	tztUIDroplistView* pDroplist = (tztUIDroplistView*)view;//[self viewWithTag:nTag];
	
	if (pDroplist)
	{
        pDroplist.ayData = ayTitle;
        pDroplist.ayValue = ayContent;
        pDroplist.selectindex = nIndex;
        if (ayTitle == nil || [ayTitle count] <= 0 || [ayTitle count] < nIndex)
        {
            pDroplist.text = @"";
        }
        else
            pDroplist.text = [ayTitle objectAtIndex:nIndex];
		
		if (bShow)
		{
			[pDroplist doShowList:TRUE];
		}
	}
	
}

-(void)SetComBoxDataWith:(int)nTag ayTitle_:(NSMutableArray*)ayTitle ayContent_:(NSMutableArray*)ayContent AndIndex_:(int)nIndex
{
	[self SetComBoxDataWith:nTag ayTitle_:ayTitle ayContent_:ayContent AndIndex_:nIndex bShow_:FALSE];
}

-(void)SetComBoxTitleWithTag:(NSString*)nsTitle nTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[tztUIDroplistView class]])
	{
		return;
	}
	tztUIDroplistView* pSlider = (tztUIDroplistView*)view;
	pSlider.text = nsTitle;
}

-(void)SetComBoxEditable:(BOOL)bEnabled withTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[tztUIDroplistView class]])
	{
		return;
	}
	
	tztUIDroplistView* pSlider = (tztUIDroplistView*)view;
	if (pSlider.droplistViewType == tztDroplistNon) 
		return;
    if(bEnabled)
    {
        pSlider.droplistViewType |= tztDroplistEdit;
    }
    else
    {
        pSlider.droplistViewType = pSlider.droplistViewType & (~tztDroplistEdit);
    }
    NSString* strText = pSlider.text;
    pSlider.text = strText;
}

-(NSString*)GetComBoxTextWithTag:(int)nTag nSelectIndex:(NSInteger*)nIndex
{
	*nIndex = -1;
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[tztUIDroplistView class]])
	{
		return nil;
	}
	tztUIDroplistView* pSlider = (tztUIDroplistView*)view;//[self viewWithTag:nTag];
	if (pSlider)
	{
		*nIndex = pSlider.selectindex;
		return pSlider.text;	
	}
	else
		return nil;
}

-(NSInteger) GetComBoxSelectedIndex:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[tztUIDroplistView class]])
	{
		return -1;
	}
	
	tztUIDroplistView* pSlider = (tztUIDroplistView*)view;//[self viewWithTag:nTag];
	
	if (pSlider)
	{
		return pSlider.selectindex;	
	}
	else
		return -1;
}

-(void)SetComBoxSelectWithValue:(NSString*)nsValue nTag_:(int)nTag
{
	if (nsValue == nil)
		return;
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[tztUIDroplistView class]])
	{
		return;
	}
	tztUIDroplistView* pSlider = (tztUIDroplistView*)view;
	
	if (pSlider && pSlider.ayValue)
	{
		for (int i = 0; i < [pSlider.ayValue count]; i++)
		{
			NSString *nsData = [pSlider.ayValue objectAtIndex:i];
			if (nsData && [nsData compare:nsValue] == NSOrderedSame)
			{
				pSlider.text = nsData;
				pSlider.selectindex = i;
				break;
			}
		}
	}
}

-(id)GetComBoxSelectedCellDataWithTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[tztUIDroplistView class]])
	{
		return nil;
	}
	tztUIDroplistView* pSlider = (tztUIDroplistView*)view;//[self viewWithTag:nTag];
	
	if (pSlider && pSlider.ayData)
	{
		NSInteger nIndex = pSlider.selectindex;
		if (nIndex < 0 || nIndex >= [pSlider.ayData count])
			return nil;
		
		return (id)[pSlider.ayData objectAtIndex:nIndex];
	}
	else
		return nil;
}

-(void)SetCheckBoxValue:(BOOL)bChecked WithTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[TZTUICheckBox class]])
	{
		return;
	}
	TZTUICheckBox *pCheckBox = (TZTUICheckBox*)view;
	if (pCheckBox)
	{
		pCheckBox.m_bChecked = bChecked;
		[pCheckBox setSelected:bChecked];
	}
}

-(BOOL)GetCheckBoxValueWithTag:(int)nTag
{
	UIView* view = (UIView*)[self viewWithTag:nTag];
	if (![view isKindOfClass:[TZTUICheckBox class]])
	{
		return FALSE;
	}
	
	TZTUICheckBox *pCheckBox = (TZTUICheckBox*)view;
	if (pCheckBox)
	{
		return pCheckBox.m_bChecked;
	}
	return FALSE;
}
//自定义输入框协议处理
#pragma mark NumberInputField delegate
-(void) showSysKeyboard:(id)keyboardview Show:(BOOL)bShow;
{
    TZTNSLog(@"%@",@"showSysKeyboard");
    if (bShow && [keyboardview isKindOfClass:[TZTUITextField class]])
    {
        if (self.m_pCurrentTextField != keyboardview)
        {
            self.m_pCurrentTextField = keyboardview;
            //重新计算高度
            [self keyboardWillShow:nil];
        }
    }
    else
    {
        self.m_pCurrentTextField = nil;
        [self keyboardWillHide:nil];
    }
    return;
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textmaxlen:(NSString *)text
{

}


- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    if(tztUIBaseView && [tztUIBaseView isKindOfClass:[TZTUITextField class]])
    {
        TZTUITextField *pTextField = (TZTUITextField*)tztUIBaseView;
        NSString* nsString = pTextField.text;
        if (([nsString length] >= pTextField.maxlen))
        {
            [pTextField resignFirstResponder];
        }
        //各自的view去记录当前的数据，此处不做处理
        if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(DealWithSysTextField:)])
        {
            [m_pDelegate DealWithSysTextField:pTextField];
        }
        return;
        
    }
}
//系统编辑框编辑数据
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    TZTUITextField *pTextField = (TZTUITextField*)textField;
//    
//    NSString* nsString = pTextField.text;
//    if (([nsString length] >= pTextField.maxlen) && (string.length > 0))
//    {
//        [pTextField resignFirstResponder];
//        //各自的view去记录当前的数据，此处不做处理
//        if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(DealWithSysTextField:)])
//        {
//            [m_pDelegate DealWithSysTextField:pTextField];
//        }
//        return NO;
//    }
//    else if (([nsString length] + [string length] ) > pTextField.maxlen)
//    {
//        pTextField.text = [nsString stringByReplacingCharactersInRange:range withString:string];
//        //
//        nsString = pTextField.text;
//        if (nsString.length > pTextField.maxlen)
//        {
////            nsString = [nsString substringToIndex:pTextField.maxlen];
//        }
//        [pTextField resignFirstResponder];
//        //各自的view去记录当前的数据，此处不做处理
//        if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(DealWithSysTextField:)])
//        {
//            [m_pDelegate DealWithSysTextField:pTextField];
//        }
//        return NO;
//    }
//    else if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(DealWithSysTextField:)])
//    {
//        pTextField.text = [nsString stringByReplacingCharactersInRange:range withString:string];
//        [m_pDelegate DealWithSysTextField:pTextField];
//        return NO;
//    }
//        
//    return TRUE;
//}

//设置下一个ComBox Title
-(void)SetNextComBoxTitle:(id)sender Fonttitle:(NSString *)fonttitle
{
    if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(SetNextComBoxTitle:Fonttitle:)])
	{
		[m_pDelegate SetNextComBoxTitle:sender Fonttitle:fonttitle];
	}
}

//设置显示数组 和标题
-(void)ShowData:(tztUIDroplistView *)pSlider _Title:(NSString *)title _Data:(NSMutableArray *)data
{
    pSlider.text = title;
    pSlider.ayValue = data;
}

//显示日期选择
-(void)tztDroplistViewWithDataview:(tztUIDroplistView*)pSlider
{
	if (pSlider == nil)
		return;
	
    UIActionSheet* pActionSheet = [[[UIActionSheet alloc] 
                         initWithTitle:@"  "
                         delegate:self 
                         cancelButtonTitle:nil 
                         destructiveButtonTitle:nil
                         otherButtonTitles:nil] autorelease];
    
    [pActionSheet addButtonWithTitle:@""];
    [pActionSheet addButtonWithTitle:@""];        
    [pActionSheet addButtonWithTitle:@""];
//    [pActionSheet addButtonWithTitle:@""];
//    [pActionSheet addButtonWithTitle:@"确定"];
//    [pActionSheet addButtonWithTitle:@"取消"];
//    [pActionSheet setCancelButtonIndex:5];
    
//    CGRect frame;
////    if (g_bIsIPhone4OS)
////    {
////        frame = CGRectMake(0, 22, 275, 220);
////    }
////    else
//    {
//        frame = CGRectMake(0, 25, 320, 180);
//    }
    
    
	UIView *pView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, TZTScreenWidth, TZTScreenHeight)] autorelease];
	[pView setBackgroundColor:[UIColor clearColor]];
	//创建子控件 包括datepiker buttton dengwei 
	NSString *strDate = pSlider.text;
	
	NSDateFormatter *dateformatter=nil;
	NSDate *date = nil;
    if(dateformatter==nil && strDate && [strDate length] == 8)
	{
        dateformatter = [[NSDateFormatter alloc] init];
        NSTimeZone *tz = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        [dateformatter setTimeZone:tz];
        [dateformatter setDateFormat:@"yyyyMMdd"];
		
		date = [dateformatter dateFromString:strDate];
        [dateformatter release];
    }
	
	self.m_tztDatePicker = [[[TZTDatePicker alloc] init] autorelease];
	self.m_tztDatePicker.m_pDelegate = pSlider;
	m_tztDatePicker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
	m_tztDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];       
	if (date == nil)
	{
		date = [NSDate date];     
        dateformatter = [[NSDateFormatter alloc] init];	
		//设定时间格式,这里可以设置成自己需要的格式
		[dateformatter setDateFormat:@"yyyyMMdd"];
        [pSlider setText:[dateformatter stringFromDate:date]];
        [dateformatter release];
	}
    
    m_tztDatePicker.date = date;
	[m_tztDatePicker addTarget:self action:@selector(shouldDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
	[m_tztDatePicker setFrame:CGRectMake(0, 0, 280,300)] ;
	m_tztDatePicker.datePickerMode = UIDatePickerModeDate;
    [pActionSheet addSubview:self.m_tztDatePicker];
#pragma 注意未测试，可能会有问题
    CGFloat nHeight = [pSlider gettztwindowy:nil];
    CGRect rcFrame = pSlider.frame;//
    rcFrame.origin.y = nHeight;
    
    if (m_pDelegate)
    {
        if ([m_pDelegate isKindOfClass:[UIView class]])
        {
            [pActionSheet showFromRect:rcFrame inView:m_pDelegate animated:YES];
        }
        if ([m_pDelegate isKindOfClass:[UIViewController class]])
        {
            [pActionSheet showFromRect:rcFrame inView:((UIViewController*)m_pDelegate).view animated:YES];
        }
    }
    else
        [pActionSheet showFromRect:rcFrame inView:self animated:YES];
    
    return;
}

//日期发生变化
-(void)shouldDatePickerChanged:(UIDatePicker*)picker
{
	if (self.m_tztDatePicker == nil || self.m_tztDatePicker.m_pDelegate == nil)  
		return;
	
	if ([self.m_tztDatePicker.m_pDelegate isKindOfClass:[tztUIDroplistView class]])
	{
		tztUIDroplistView *pSlider = (tztUIDroplistView*)self.m_tztDatePicker.m_pDelegate;
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];	
		//设定时间格式,这里可以设置成自己需要的格式
		
		[dateFormatter setDateFormat:@"yyyyMMdd"];
		
		NSString * nowDate = [dateFormatter stringFromDate:picker.date];
		
		if (pSlider)
			[pSlider setText:nowDate];
		[dateFormatter release];
	}
}

//请求下拉框数据
-(void)tztDroplistViewGetData:(tztUIDroplistView*)pSliderView
{
	if (pSliderView == NULL)
		return;
	if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(tztDroplistViewGetData:)])
	{
		[m_pDelegate tztDroplistViewGetData:pSliderView];
	}
}

//下拉框选中行
- (void)tztDroplistView:(tztUIDroplistView *)view didSelectIndex:(NSInteger)index//选中
{
	//发送到各自view上处理，此处不处理
	if (m_pDelegate && [m_pDelegate respondsToSelector:@selector(tztDroplistView: didSelectIndex:)])
	{
		[m_pDelegate tztDroplistView:view didSelectIndex:index];
	}
}

//删除选中行
- (BOOL)tztDroplistView:(tztUIDroplistView *)droplistview didDeleteIndex:(NSInteger)index//删除
{
	//发送到各自view上处理，此处不处理
	if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(tztDroplistView:didDeleteIndex:)])
		[m_pDelegate tztDroplistView:droplistview didDeleteIndex:index];
    return TRUE;
}

//获取下拉框的位置点
-(CGPoint)tztDroplistView:(tztUIDroplistView*)pSliderView point:(CGPoint)point
{
	if (pSliderView == NULL)
		return point;
    
	int nMargin = 0;
    int nLeftMargin = 0;
    if( pSliderView.frame.size.width < pSliderView.listviewwidth)
        nLeftMargin = (pSliderView.frame.size.width - pSliderView.listviewwidth) / 2;
    
	if (pSliderView.droplistViewType & tztDroplistEdit)
	{
		nMargin = pSliderView.textfield.frame.size.height;
	}
	else
	{
		nMargin = pSliderView.textbtn.frame.size.height;
	}
    int nLeft = nLeftMargin;
    int nHeight = nMargin;
    if([m_pDelegate isKindOfClass:[UIView class]])
    {
        nLeft += [pSliderView gettztwindowx:m_pDelegate];
        nHeight += [pSliderView gettztwindowy:m_pDelegate];
        point.x = nLeft;
        point.y = nHeight;
    }
	else if([m_pDelegate isKindOfClass:[UIViewController class]])
    {
        nLeft += [pSliderView gettztwindowx:((UIViewController*)m_pDelegate).view];
        nHeight += [pSliderView gettztwindowy:((UIViewController*)m_pDelegate).view];
        point.x = nLeft;
        point.y = nHeight;
    }	
	int nWidth = MAX(pSliderView.frame.size.width, pSliderView.listviewwidth);
	//右侧无法全部显示
	if (point.x + nWidth > TZTScreenWidth)
	{
		point.x -= ((point.x + nWidth) - TZTScreenWidth);
	}
    return point;
}

//显示下拉框，表格内不能直接弹出，放在此处处理
-(BOOL)tztDroplistView:(tztUIDroplistView*)pSliderView showlistview:(UITableView*)pView
{
    CGPoint point = pView.frame.origin;
    point = [self tztDroplistView:pSliderView point:point];
    //设置弹出的frame
    pView.frame = CGRectMake(point.x, point.y, pView.frame.size.width, pView.frame.size.height);
	if (m_pDelegate)
	{
		CGRect rc = pView.frame;
		CGRect appRect = [[UIScreen mainScreen] bounds];
		if ((rc.origin.y + rc.size.height + 10) > (appRect.size.height - 20 - 50))
		{
			rc.size.height -= (rc.origin.y + rc.size.height + 10 - appRect.size.height + 20 + 50 );
		}
		pView.frame = rc;
		if([m_pDelegate isKindOfClass:[UIView class]])
			[m_pDelegate addSubview:pView];
		else if([m_pDelegate isKindOfClass:[UIViewController class]])
			[((UIViewController*)m_pDelegate).view addSubview:pView];
	}
	else
	{
		[self addSubview:pView];
	}
    pSliderView.nShowSuper = TRUE;
    m_nSliderCount++;
    m_pFocuesSlider = pSliderView;
    return TRUE;
}

//判断下拉框的显示
-(void)CheckSlidView:(UIGestureRecognizer *)gestureRecognizer forView_:(UIView*)pView pt_:(CGPoint)point nCount_:(int*)nCount
{
	if (pView && [pView isKindOfClass:[tztUIDroplistView class]]) 
	{
		tztUIDroplistView *pSlider = (tztUIDroplistView*)pView;
		UIView* pTempView = (UIView*)pSlider.listView;//下拉框显示区域，判断是否已经显示
		CGPoint pt = [gestureRecognizer locationInView:self];
		CGRect rc = pView.frame;
		//表示下拉显示的时候才进行处理
		if (pTempView.frame.size.height > 0 )//对应的是下拉控件没展开时的高度cellH，修改请注意
		{
			if (!CGRectContainsPoint(rc, pt))
			{
				[pSlider doHideList];
				*nCount+=1;
			}
		}
	}
	else
	{
		for (int i = 0; i < [pView.subviews count]; i++)
		{
			UIView* pSubView = [pView.subviews objectAtIndex:i];
			if (pSubView)
			{
				[self CheckSlidView:gestureRecognizer forView_:pSubView pt_:point nCount_:nCount];
			}
		}
	}
}

-(void)animationDidStop
{
	[self.m_tztDatePicker removeFromSuperview];
	self.m_tztDatePicker = nil;	
	
	CGRect frame = m_pTableView.frame; 
	frame.origin.y += keyboardHeight;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES]; 
	[UIView setAnimationDuration:0.3f]; 
	m_pTableView.frame = frame;
	[UIView commitAnimations];
	keyboardHeight = 0;
}

//处理手势事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch 
{
	CGPoint location = [touch locationInView:self];
    if (/*!bHidden && */[self TouchInInputField:location pView_:self] || [self TouchInButton:location pView_:self])
    {
        return NO;
    }
    [self OnCloseKeybord];
	int nCount = 0;
	if ([touch.view isKindOfClass:[UIButton class]])
	{
		[self OnCloseKeybord];
		UIButton *pButton = (UIButton*)touch.view;
		NSSet* pSet = [pButton allTargets];
		if (pSet)
		{
			for (int i = 0; i < [[pSet allObjects] count]; i++)
			{
				id pTarget = [[pSet allObjects] objectAtIndex:i];
				if (![pTarget isKindOfClass:[tztUIDroplistView class]])
				{
					[self CheckSlidView:gestureRecognizer forView_:self pt_:location nCount_:&nCount];
				}
				else
				{
					tztUIDroplistView* pSlider = (tztUIDroplistView*)pTarget;
					if ((pSlider != m_pFocuesSlider) && (pButton == pSlider.textbtn
						|| pButton == pSlider.dropbtn))
					{
						[self CheckSlidView:gestureRecognizer forView_:self pt_:location nCount_:&nCount];
					}
				}

			}
		}
		if (self.m_tztDatePicker) 
		{
			[self animationDidStop];
		}
		return NO;
	}
	
	if (self.m_tztDatePicker) 
	{
        [self CheckSlidView:gestureRecognizer forView_:self pt_:location nCount_:&nCount];
		[self animationDidStop];
	}
	[self OnCloseKeybord];
	//列表功能界面，可以直接进行点击
	[self CheckSlidView:gestureRecognizer forView_:self pt_:location nCount_:&nCount];
	if (!m_bOnlyRead)
	{
		return NO;
	}
    return YES;
	
}

- (void)handelSingleTap:(UIPanGestureRecognizer *)recognizer 
{
	if (self.m_tztDatePicker) 
	{
		[self animationDidStop];
	}
	[self OnCloseKeybord];
	//获取坐标点
	CGPoint location = [recognizer locationInView:self];
	location.y += self.frame.origin.y;
	int nCount = 0;
	[self CheckSlidView:recognizer forView_:self pt_:location nCount_:&nCount];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer 
{        
	//拿到手指目前的位置
	CGPoint location = [recognizer locationInView:self];
	UIView *aview = [self viewWithTag:1000];
	// 如果UIGestureRecognizerStateEnded的話...你是拿不到location的
	// 不判斷的話,底下改frame會讓這個subview消失,因為origin的x和y就不見了!!!
	if(recognizer.state != UIGestureRecognizerStateEnded)
	{
		aview.frame = CGRectMake(location.x, location.y, aview.frame.size.width, aview.frame.size.height);
	}
}

//关闭键盘
-(void) OnCloseKeybord
{
	//关闭系统键盘
    if (self.m_pDelegate)
    {
        if ([self.m_pDelegate isKindOfClass:[UIView class]])
        {
            [TZTUIBaseTableView OnCloseKeybord:self.m_pDelegate];
        }
        else if ([self.m_pDelegate isKindOfClass:[UIViewController class]])
        {
            [TZTUIBaseTableView OnCloseKeybord:((UIViewController*)self.m_pDelegate).view];
        }
    }
    else
        [TZTUIBaseTableView OnCloseKeybord:self];
}

//判断点是不是在输入框内
-(BOOL)TouchInInputField:(CGPoint)pt pView_:(UIView*)pView
{
    if (pView && [pView isKindOfClass:[TZTUITextField class]]) 
    {
        TZTUITextField* pField = (TZTUITextField*)pView;
        CGRect rc = pView.frame;
        rc.origin.y += pField.nNumberofRow * m_nRowHeight;
        if (CGRectContainsPoint(rc, pt))
        {
            return TRUE;
        }
    }
    for (int i = 0; i < [pView.subviews count]; i++)
    {
        UIView *pSubView = [pView.subviews objectAtIndex:i];
        BOOL bSucc = [self TouchInInputField:pt pView_:pSubView];
        if (bSucc)
        {
            return TRUE;
        }
        
    }
    return FALSE;
}
-(BOOL)TouchInButton:(CGPoint)pt pView_:(UIView*)pView
{
    if (pView && [pView isKindOfClass:[TZTUIButtonView class]]) 
    {
        TZTUIButtonView* pField = (TZTUIButtonView*)pView;
        CGRect rc = pView.frame;
        rc.origin.y += pField.m_nNumberOfRow * m_nRowHeight;
        if (CGRectContainsPoint(rc, pt))
        {
            return TRUE;
        }
    }
    for (int i = 0; i < [pView.subviews count]; i++)
    {
        UIView *pSubView = [pView.subviews objectAtIndex:i];
        BOOL bSucc = [self TouchInButton:pt pView_:pSubView];
        if (bSucc)
        {
            return TRUE;
        }
        
    }
    return FALSE;
}

//关闭系统键盘
+(BOOL) OnCloseKeybord:(UIView*)pView
{
	if(pView && [pView isKindOfClass:[UIResponder class]] )
	{
		[pView resignFirstResponder];		
	}
	NSArray* pAyView = [pView subviews];
	for(int i = 0; i< [pAyView count]; i++)
	{
		UIView* pSubView = [pAyView objectAtIndex:i];
		if(pSubView)
		{
			[TZTUIBaseTableView OnCloseKeybord:pSubView];
		}
	}
	return FALSE;
}

-(void) keyboardWillShow:(NSNotification *)note
{
    if (self.m_pCurrentTextField && [self.m_pCurrentTextField isKindOfClass:[TZTUITextField class]])
    {
        m_bShowSysKeybord = YES;
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardWillShowNotification] getValue: &keyboardBounds];
        int nkeyboardHeight = 350;
        if (!IS_TZTIPAD)
            nkeyboardHeight = 216;
        
        CGFloat nHeight = [self.m_pCurrentTextField gettztwindowy:nil]+self.m_pCurrentTextField.frame.size.height;

        int nTemp = keyboardHeight;
        if (nHeight > TZTScreenHeight - nkeyboardHeight)
        {
            keyboardHeight = nHeight - TZTScreenHeight + nkeyboardHeight;
            int nScrollHeight = keyboardHeight - nTemp;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3f];
            if (m_pDelegate && [m_pDelegate isKindOfClass:[UIView class]])
            {
                UIView* pView = (UIView*)m_pDelegate;
                for (int i = 0; i < [[pView subviews] count]; i++)
                {
                    UIView* pSub = [[pView subviews] objectAtIndex:i];
                    if (pSub && [pSub isKindOfClass:[TZTUIBaseTableView class]])
                    {
                        CGRect rcSub = pSub.frame;
                        CGRect rcTest = rcSub;
                        rcTest = CGRectMake(rcTest.origin.x, rcTest.origin.y - nScrollHeight, rcSub.size.width, rcSub.size.height);
                        pSub.frame = rcTest;
                    }
                }
            }
            if (m_pDelegate && [m_pDelegate isKindOfClass:[UIViewController class]])
            {
                UIView* pView = ((UIViewController*)m_pDelegate).view;
                for (int i = 0; i < [[pView subviews] count]; i++)
                {
                    UIView* pSub = [[pView subviews] objectAtIndex:i];
                    if (pSub && [pSub isKindOfClass:[TZTUIBaseTableView class]])
                    {
                        CGRect rcSub = pSub.frame;
                        CGRect rcTest = rcSub;
                        rcTest = CGRectMake(rcTest.origin.x, rcTest.origin.y - nScrollHeight, rcSub.size.width, rcSub.size.height);
                        pSub.frame = rcTest;
                    }
                }
            }
            TZTNSLog(@"keyboardWillShow :%d",nScrollHeight);
            [UIView commitAnimations];
        }
    }
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    if (keyboardHeight > 0)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        if (m_pDelegate && [m_pDelegate isKindOfClass:[UIView class]])
        {
            UIView* pView = (UIView*)m_pDelegate;
            for (int i = 0; i < [[pView subviews] count]; i++)
            {
                UIView* pSub = [[pView subviews] objectAtIndex:i];
                if (pSub && [pSub isKindOfClass:[TZTUIBaseTableView class]])
                {
                    CGRect rcSub = pSub.frame;
                    CGRect rcTest = rcSub;
                    rcTest.origin.y += keyboardHeight; //下移
                    pSub.frame = rcTest;
                }
            }
        }
        else if (m_pDelegate && [m_pDelegate isKindOfClass:[UIViewController class]])
        {
            UIView* pView = ((UIViewController*)m_pDelegate).view;
            for (int i = 0; i < [[pView subviews] count]; i++)
            {
                UIView* pSub = [[pView subviews] objectAtIndex:i];
                if (pSub && [pSub isKindOfClass:[TZTUIBaseTableView class]])
                {
                    CGRect rcSub = pSub.frame;
                    CGRect rcTest = rcSub;
                    rcTest.origin.y += keyboardHeight;  //下移
                    pSub.frame = rcTest;
                }
            }
        }
        [UIView commitAnimations];
        TZTNSLog(@"%@",@"keyboardWillHideEx");
    }
//    nHeight = 0;
    
}
@end

