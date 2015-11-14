/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztUIEditValueView.h
 * 文件标识：
 * 摘    要：投资堂编辑器 编辑内容标题TitleTip 编辑内容数组 title(lable提示框) value(textfield 数据) key(数据标识)
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

#import "tztUIEditValueView.h"
#define _tagtztlineview 0x100000

#define _tagtztbtnok 0x200000
#define _tagtztbtncancel 0x200001
#define _tagtzttitletip 0x300000
#define _tagtztlable 10000
#define _tagtzttextfield 20000

@interface tztUIEditValueView ()
{
    NSMutableArray	*_arrayData;//内容数组
    NSString*   _titleTip;//内容标题
    UIScrollView* _scrollView;
    id<tztEditViewDelegate>  _delegate; //接口
}

- (void)CreateView;
- (void)onHideKeyBoard;
@end

@implementation tztUIEditValueView

@synthesize delegate = _delegate;
@synthesize arrayData = _arrayData;
@synthesize titleTip = _titleTip;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

- (void)dealloc 
{
    self.arrayData = nil;
	self.delegate = nil;
    self.titleTip = nil;
	[super dealloc];
    
}

-(id)init
{
	if (self = [super init]) 
    {
        
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
    
    if(_arrayData == nil || [_arrayData count] <= 0)
        return;
    
    if(_delegate == nil)
    {
        return;
    }
    [self CreateView];
}

- (void)setFrame:(CGRect)frame
{
    CGRect oldbounds = self.bounds;
    [super setFrame:frame];
    CGRect newbounds = self.bounds;
    if(!CGRectEqualToRect(oldbounds, newbounds))
        [self reloadAllComponents];
}

-(void)CreateView
{
    if(_arrayData == nil || [_arrayData count] <= 0)
        return;
    
    NSInteger count = [_arrayData count];
    
    if(_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        [_scrollView release];
    }
    _scrollView.hidden = NO;
    _scrollView.contentOffset = CGPointZero;
    for(int i = 0; i < [_scrollView.subviews count]; i++)
    {
        UIView* pView = [_scrollView.subviews objectAtIndex:i];
        pView.hidden = YES;
    }
    
	CGSize tempSize;
    CGFloat fViewWidth = self.frame.size.width;
    CGFloat fViewHeight = 30.f;
    CGFloat fLabHeight = 20.f;
    CGFloat fBtnWidth = 50.f;
    UIFont* txtFont = [tztTechSetting getInstance].drawTxtFont;
    if (IS_TZTIPAD)
    {
        fViewHeight = 45.f;
        fLabHeight = 30.f;
        fBtnWidth = 75.f;
    }
    BOOL bHaveTitle = FALSE;
    if(_titleTip && [_titleTip length] > 0)
    {
        bHaveTitle = TRUE;
    }
    
    CGFloat fHeight = 0;
    UILabel* labtitle = (UILabel*)[self viewWithTag:_tagtzttitletip];
    if(labtitle == nil)
    {
        labtitle = [[UILabel alloc] init];
        labtitle.tag = _tagtzttitletip;
        [labtitle setBackgroundColor:[UIColor clearColor]];
        [labtitle setTextAlignment:NSTextAlignmentCenter];
        [labtitle setTextColor:[UIColor whiteColor]];
        [_scrollView addSubview:labtitle];
        [labtitle release];
    }

    if(bHaveTitle)
    {
        fHeight +=  fViewHeight;
        [labtitle setFrame:CGRectMake(0, 0, self.frame.size.width, fViewHeight)];
        [labtitle setText:_titleTip];
        labtitle.hidden = NO;
    }
    else
    {
        [labtitle setText:@""];
        labtitle.hidden = YES;
    }
    
	tempSize.width = fViewWidth;
	tempSize.height = (fViewHeight + 2.f)*count + fHeight;
    
	if (tempSize.height + fViewHeight < self.frame.size.height) 
    {
        [super setFrame: CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tempSize.height + fViewHeight)];
        _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - fViewHeight );
		_scrollView.scrollEnabled = NO;
	}
    else 
    {
		_scrollView.scrollEnabled = YES;
        _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - fViewHeight);
		_scrollView.contentSize = tempSize;
	}
    
	self.backgroundColor = [UIColor colorWithTztRGBStr:@"59,59,59"];
    int nlinetag = 0;
    UIView *lineView = [self viewWithTag:_tagtztlineview + nlinetag];
    if(lineView == nil)
    {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(5, fHeight, fViewWidth-10, 1)];
        lineView.tag = _tagtztlineview + nlinetag;
        lineView.backgroundColor = [UIColor colorWithTztRGBStr:@"43,43,43"];
        [_scrollView addSubview:lineView];
        [lineView release];
    }
    else
    {
        lineView.hidden = NO;
    }
    
        
	for (int i = 0; i < [_arrayData count]; i++) 
    {
        NSDictionary* strValue = [_arrayData objectAtIndex:i];
        if(strValue)
        {
            NSString *labTitle = [strValue valueForKey:@"title"];
            NSString *txtTitle = [strValue valueForKey:@"value"];
            
            NSInteger labTag = _tagtztlable + i;
            UILabel *templab =  (UILabel *)[self viewWithTag:labTag];
            if(templab == nil)
            {
                templab = [[UILabel alloc] init];
                templab.font = txtFont;
                [templab setBackgroundColor:[UIColor clearColor]];
                [templab setTextColor:[UIColor whiteColor]];
//                [templab setTextAlignment:NSTextAlignmentRight];
                templab.tag = labTag;
                [_scrollView addSubview:templab];
                [templab release];
            }
            templab.frame = CGRectMake(5, fHeight + i * (fViewHeight) + (fViewHeight - fLabHeight)/2 - 1 , fViewWidth / 2 - 5, fLabHeight );
            [templab setText:labTitle];
            templab.hidden = NO;
            
            NSInteger txtTag = _tagtzttextfield + i;
            UITextField *txtField = (UITextField *)[self viewWithTag:txtTag];
            if(txtField == nil)
            {
                txtField = [[UITextField alloc] init];
                txtField.font = txtFont;
                txtField.delegate = self;
                txtField.keyboardType = UIKeyboardTypeNumberPad;
                [txtField setBorderStyle:UITextBorderStyleRoundedRect];
                txtField.tag = txtTag;
                [_scrollView addSubview:txtField];
                [txtField release];
            }
            txtField.frame = CGRectMake(fViewWidth / 2 + 3, fHeight + i * (fViewHeight) + (fViewHeight - fLabHeight)/2 - 1, fViewWidth / 2 - 8, fLabHeight);
            [txtField setText:txtTitle];
            txtField.enabled = TRUE;
            txtField.hidden = NO;
            
            nlinetag++;
            
            UIView *lineView = [self viewWithTag:_tagtztlineview + nlinetag];
            if(lineView == nil)
            {
                lineView = [[UIView alloc] initWithFrame:CGRectMake(5, (i+1) * (fViewHeight), fViewWidth-10, 1)];
                lineView.tag = _tagtztlineview + nlinetag;
                lineView.backgroundColor = [UIColor colorWithTztRGBStr:@"43,43,43"];
                [_scrollView addSubview:lineView];
                [lineView release];
            }
            else
            {
                lineView.hidden = NO;
            }
        }
	}
    
    UIButton* btnOk = (UIButton*)[self viewWithTag:_tagtztbtnok];
    if(btnOk == nil)
    {
        btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOk.tag = _tagtztbtnok;
        [btnOk setTztBackgroundImage:[UIImage imageTztNamed:@"TZT_hqbtn.png"]];
        [btnOk setTztTitle:@"确定"];
        [btnOk.titleLabel setFont:txtFont];
        [btnOk addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnOk];
    }
    btnOk.frame = CGRectMake(5, CGRectGetHeight(self.frame) - fViewHeight + (fViewHeight - fLabHeight) / 2, fBtnWidth, fLabHeight);
    btnOk.hidden = NO;
    
    UIButton* btnCancel = (UIButton*)[self viewWithTag:_tagtztbtncancel];
    if(btnCancel == nil)
    {
        btnCancel = [UIButton buttonWithType:UIButtonTypeCustom]; 
        btnCancel.tag = _tagtztbtncancel;
        [btnCancel setTztBackgroundImage:[UIImage imageTztNamed:@"TZT_hqbtn.png"]];
        [btnCancel setTztTitle:@"取消"];
        [btnCancel.titleLabel setFont:txtFont];
        [btnCancel addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCancel];
    }
    btnCancel.frame = CGRectMake(fViewWidth - 5 - fBtnWidth, CGRectGetHeight(self.frame) - fViewHeight + (fViewHeight - fLabHeight) / 2,fBtnWidth, fLabHeight);
    btnCancel.hidden = NO;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if(hidden)
    {
        [self onHideKeyBoard];
    }
}

- (void)onHideKeyBoard
{
    if(_scrollView)
    {
        for(int i = 0; i < [_scrollView.subviews count]; i++)
        {
            UIView* pView = [_scrollView.subviews objectAtIndex:i];
            if([pView isKindOfClass:[UITextField class]])
            {
                [(UITextField *)pView resignFirstResponder];
            }
        }
    }
}

- (void)onButtonPressed:(id)sender
{
    [self onHideKeyBoard];
    UIButton* btn = (UIButton *)sender;
    if(btn.tag == _tagtztbtnok)
    {
        if(_arrayData == nil || [_arrayData count] <=0)
            return;
        for (int i = 0; i < [_arrayData count]; i++)
        {
            NSMutableDictionary* values = [_arrayData objectAtIndex:i];
            NSInteger txtTag = _tagtzttextfield + i;
            UITextField *txtField = (UITextField *)[self viewWithTag:txtTag];
            NSString* strValue = @"";
            if(txtField && (!txtField.hidden))
            {
                strValue = [txtField text];
                [values setValue:strValue forKey:@"value"];
            }
        }
        if (_delegate && [_delegate respondsToSelector:@selector(tztEditView: didEditValue:)])
            [_delegate tztEditView:self didEditValue:_arrayData];
    }
    else
    {
        self.hidden = YES;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //
    if (_delegate && [_delegate respondsToSelector:@selector(tztEditView:shouldBeginEdit:)])
    {
        [_delegate tztEditView:self shouldBeginEdit:textField];
    }
//    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(tztEditView:shouldEndEdit:)])
    {
        [_delegate tztEditView:self shouldEndEdit:textField];
    }
    return YES;
}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(tztEditView:shouldEndEdit:)])
//    {
//        [_delegate tztEditView:self shouldEndEdit:nil];
//    }   
//}

@end
