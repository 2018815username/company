/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztUIPickerView.h
 * 文件标识：
 * 摘    要：投资堂选择器
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


#import "tztUIPickerView.h"

#define _tagtztlineview 0x200000
#define _tagtztbtn 100000

@interface tztUIPickerView ()
{
    NSMutableArray	*_arrayData;//数据数组
    NSMutableDictionary       *_selectionBars;//选中列数组
    NSInteger                  _numberOfComponents;//分类数
    id<tztPickerViewDelegate>  _pickerDelegate; //接口
}
-(void)CreateView;
@end

@implementation tztUIPickerView

@synthesize pickerDelegate = _pickerDelegate;

- (void)dealloc 
{
    DelObject(_arrayData);
    DelObject(_selectionBars);
	self.pickerDelegate = nil;
	[super dealloc];

}

-(id)init
{
	if (self = [super init]) 
    {
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor tztThemeBorderColor].CGColor;
	}
	return self;
}

-(void)reloadAllComponents
{
    for(int i = 0; i < [self.subviews count]; i++)
    {
        UIView* pView = [self.subviews objectAtIndex:i];
        pView.hidden = YES;
    }
    
    if(_arrayData == nil)
        _arrayData = NewObject(NSMutableArray);
    
    if(_selectionBars == nil)
    {
        _selectionBars = NewObject(NSMutableDictionary);
    }
    
    if(_pickerDelegate == nil)
    {
        return;
    }
    
    for (int i = 0; i < [_arrayData count]; i++)
    {
        NSMutableArray* ay = [_arrayData objectAtIndex:i];
        [ay removeAllObjects];
    }
    [_arrayData removeAllObjects];
    [_selectionBars removeAllObjects];
    
    _numberOfComponents = 1;
    if ([_pickerDelegate respondsToSelector:@selector(numberOfComponentsIntztPickerView:)])
		 _numberOfComponents = [_pickerDelegate numberOfComponentsIntztPickerView:self];
    
    long lMaxLen = 0;
    for (NSInteger i = 0; i < _numberOfComponents; i++)
    {
        NSInteger numberOfValues = 0;
        NSMutableArray* ayValues = NewObject(NSMutableArray);
        if ([_pickerDelegate respondsToSelector:@selector(tztPickerView: numberOfRowsInComponent:)])
        {
            numberOfValues = [_pickerDelegate tztPickerView:self numberOfRowsInComponent:i];
        }
        
        for (int j = 0; j < numberOfValues; j++)
        {
            NSString* strValue = @"";
            if ([_pickerDelegate respondsToSelector:@selector(tztPickerView: titleForRow: forComponent:)])
                strValue = [_pickerDelegate tztPickerView:self titleForRow:j forComponent:i];
            
            if ([_pickerDelegate respondsToSelector:@selector(tztPickerView: isSelectForRow: forComponent:)] )
            {
                if([_pickerDelegate tztPickerView:self isSelectForRow:j forComponent:i])
                {
                    [_selectionBars setValue:@"1" forKey:[NSString stringWithFormat:@"%d,%d",(int)i,j]];
                }
            }
            
            if(strValue)
            {
                if(strlen([strValue UTF8String]) > lMaxLen)
                {
                    lMaxLen = strlen([strValue UTF8String]);
                }
                [ayValues addObject:strValue];
            }
        }
        [_arrayData addObject:ayValues];
        [ayValues release];
    }
    [self CreateView];
}

-(void)CreateView
{
	if (!_arrayData && [_arrayData count] < 1) {
		return;
	}
    int count = 0;
    for (int i = 0; i < [_arrayData count]; i++)
    {
        NSMutableArray* ayValues = [_arrayData objectAtIndex:i];
        if(ayValues)
            count += [ayValues count];
    }
    if (count <= 0)
        return;
    
    for(int i = 0; i < [self.subviews count]; i++)
    {
        UIView* pView = [self.subviews objectAtIndex:i];
        pView.hidden = YES;
    }
    
    
	CGSize tempSize;
    CGFloat fViewWidth = self.frame.size.width;
    CGFloat fViewHeight = 35.f;
	tempSize.width = fViewWidth;
	tempSize.height = (fViewHeight + 2.f)*count - 1;
    
	if (tempSize.height < self.frame.size.height) {
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tempSize.height);
		self.scrollEnabled = NO;
	}else {
		self.scrollEnabled = YES;
		self.contentSize = tempSize;
	}
    
	self.backgroundColor = [UIColor tztThemeBackgroundColor];
    
//	self.layer.borderWidth = 1.0f;
//	self.layer.masksToBounds=YES;
//	self.layer.cornerRadius=5.0;

	CGFloat fHeight = 1;
    CGFloat fBtnHeight = MIN(fViewHeight,35);
    int nlinetag = 0;
    UIView *lineView = [self viewWithTag:_tagtztlineview + nlinetag];
    if(lineView == nil)
    {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(5, fHeight, fViewWidth-10, 1)];
        lineView.tag = _tagtztlineview + nlinetag;
        lineView.backgroundColor = [UIColor tztThemeBorderColorGrid];
        [self addSubview:lineView];
        [lineView release];
    }
    else
    {
        lineView.hidden = NO;
    }
    
	for (int i = 0; i < [_arrayData count]; i++) 
    {
        NSMutableArray* ayValues = [_arrayData objectAtIndex:i];
        if(ayValues)
        {
            for (int j = 0; j < [ayValues count]; j++)
            {
                NSString *btTitle = [ayValues objectAtIndex:j];
                NSInteger btnTag = _tagtztbtn * (i+1) + j;
                UIButton *tempbt =  (UIButton *)[self viewWithTag:btnTag];
                if(tempbt == nil)
                {
                    tempbt = [UIButton buttonWithType:UIButtonTypeCustom];
                    tempbt.titleLabel.font = tztUIBaseViewTextFont(12.0);
                    tempbt.backgroundColor = [UIColor clearColor];
                    tempbt.tag = _tagtztbtn * (i+1) + j;
                    tempbt.layer.cornerRadius=5.0;
                    [tempbt addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:tempbt];
                }
                NSString* bSelect = [_selectionBars objectForKey:[NSString stringWithFormat:@"%d,%d",i,j]];
                if(bSelect && [bSelect intValue] > 0 )
                {
                    tempbt.backgroundColor = [UIColor tztThemeBackgroundColorSectionSel];
                    [tempbt setTztTitleColor:[UIColor tztThemeTextColorForSectionSel]];
                }
                else
                {
                    tempbt.backgroundColor = [UIColor clearColor];
                    [tempbt setTztTitleColor:[UIColor tztThemeTextColorForSection]];
                }
                
                tempbt.frame = CGRectMake(5, fHeight+(fViewHeight-fBtnHeight)/2, fViewWidth -10, fBtnHeight);
                fHeight += fViewHeight+1;
                [tempbt setTztTitle:btTitle];
                tempbt.hidden = NO;
                
                nlinetag++;
                
                UIView *lineView = [self viewWithTag:_tagtztlineview + nlinetag];
                if(lineView == nil)
                {
                    lineView = [[UIView alloc] initWithFrame:CGRectMake(5, fHeight-1, fViewWidth-10, 1)];
                    lineView.tag = _tagtztlineview + nlinetag;
                    lineView.backgroundColor = [UIColor tztThemeBorderColorGrid];
                    [self addSubview:lineView];
                    [lineView release];
                }
                else
                {
                    lineView.hidden = NO;
                }
            }
        }
	}
    
}

-(void)onButtonPressed:(id)sender
{
	UIButton *bt = (UIButton *)sender;
    NSInteger tag = bt.tag;
    NSInteger iComponent = tag / _tagtztbtn;
    NSInteger iRow = tag % _tagtztbtn;
    if ([_pickerDelegate respondsToSelector:@selector(tztPickerView: didSelectRow: inComponent:)])
        [_pickerDelegate tztPickerView:self didSelectRow:iRow inComponent:iComponent];
}
////选中行
//- (NSInteger)selectedRowInComponent:(NSInteger)component
//{
//    return 0;
//}
//
////设置选中行
//- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//}
@end
