/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		TZTUICheckButton.m
* 文件标识:
* 摘要说明:		自定义选择框控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/

/*选择框控件，只能是文字或者图片的一种，不能两者同时存在*/
#import "tztUICheckButton.h"

@interface tztUICheckButton (TZTPrivate)
-(void)checkboxButton:(id)sender;
@end

@implementation tztUICheckButton
@synthesize tztdelegate = _tztdelegate;
@synthesize notitle = _notitle;
@synthesize yestitle = _yestitle;
@synthesize messageinfo = _messageinfo;
@synthesize tztcheckdate = _tztcheckdate;
@synthesize tzttagcode = _tzttagcode;
//;tag|区域|控件类型|未选中信息|value|textAlignment|font|enabled|检测数据|选中信息|提示信息|
- (id)initWithProperty:(NSString*)strProperty
{
    self = [super init];
    if(self)
    {
        self.notitle = @"";
        self.yestitle = @"";
        self.messageinfo = @"";
        NilObject(self.tztdelegate);
        NilObject(self.tzttagcode);
        [self setProperty:strProperty];
    }
    return self;
}

- (BOOL)onCheckdata
{
    if(_tztcheckdate && (!self.hidden))
    {
        if(![self isSelected])
        {
            //弹出提示信息
            return FALSE;
        }
    }
    return TRUE;
}

- (void)setProperty:(NSString*)strProperty
{
    _checkleft = TRUE;
    self.notitle = @"";
    self.yestitle = @"";
    self.messageinfo = @"";
    self.tztcheckdate = FALSE;
    NilObject(self.tzttagcode);
    BOOL _bSelect = FALSE;
    if(_checkbtn == nil)
    {
        _checkbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkbtn addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_checkbtn];
    }
    
    if(_infolab == nil)
    {
        _infolab = [[UILabel alloc] init];
        _infolab.backgroundColor = [UIColor clearColor];
        _infolab.textColor = [UIColor tztThemeTextColorLabel];
//        _infolab.textColor = [UIColor whiteColor];
//        if (g_nSkinType == 1) {
//            _infolab.textColor = [UIColor blackColor];
//        }
        [self addSubview:_infolab];
        [_infolab release];
    }
    
    NSString* strRect = @",,,";
    if(strProperty && [strProperty length] > 0)
    {
        NSMutableDictionary* Property = NewObject(NSMutableDictionary);
        [Property settztProperty:strProperty];
        //tag
        NSString* strValue = [Property objectForKey:@"tag"];
        if(strValue && [strValue length] > 0)
            self.tzttagcode = strValue;
        
        //区域
        strValue = [Property objectForKey:@"rect"];
        if(strValue && [strValue length] > 0)
            strRect = strValue;
        
        //按钮类型
        strValue = [Property objectForKey:@"type"];
        if(strValue && [strValue length] <= 0) //按钮类型
        {
            strValue = @"left";
        }
        if(strValue && [strValue length] > 0) //设置区域
        {
            if([strValue compare:@"right"] == NSOrderedSame)
            {
                _checkleft = FALSE;
            }
            else if([strValue compare:@"left"] == NSOrderedSame)
            {
                _checkleft = YES;
            }
        }
        
        //左侧图片
        strValue = [Property objectForKey:@"image"];
        if (strValue.length > 0)
        {
            
        }
        else
        {
            [_checkbtn setImage:[UIImage imageTztNamed:@"tztcheckbox.png"] forState:UIControlStateNormal];
            [_checkbtn setImage:[UIImage imageTztNamed:@"tztcheckbox-pressed.png"] forState:UIControlStateHighlighted];
            [_checkbtn setImage:[UIImage imageTztNamed:@"tztcheckbox-checked.png"] forState:UIControlStateSelected];
        }
        
        //未选中信息
        strValue = [Property objectForKey:@"notitle"];
        if(strValue)
            self.notitle = strValue;
        else
            self.notitle = [Property objectForKey:@"title"];
        
        //选中信息
        strValue = [Property objectForKey:@"yestitle"];
        if(strValue)
            self.yestitle = [Property objectForKey:@"yestitle"];
        else
            self.yestitle = self.notitle;
        
        //value
        strValue = [Property objectForKey:@"text"];;
        if(strValue && [strValue length] > 0) //设置区域
        {
            _bSelect = ([strValue intValue] != 0);
        }
        
        //textAlignment 
        strValue = [Property objectForKey:@"textalignment"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            if([strValue compare:@"right"] == NSOrderedSame)
            {
                _infolab.textAlignment = NSTextAlignmentRight;
            }
            else if([strValue compare:@"center"] == NSOrderedSame)
            {
                _infolab.textAlignment = NSTextAlignmentCenter;
            }
            else 
            {
                _infolab.textAlignment = NSTextAlignmentLeft;
            }
        }
        
        //font
        CGFloat _fontsize = 0;
        strValue = [Property objectForKey:@"font"];
        if(strValue && [strValue length] > 0)//设置字体大小
        {
            _fontsize = [strValue floatValue];
        }
        _infolab.font = tztUIBaseViewTextFont(_fontsize);
        
        //enabled
        strValue = [Property objectForKey:@"enabled"];
        if(strValue && [strValue length] > 0) 
        {
            self.enabled = ([strValue intValue] != 0);
        }
        
        //检测数据
        strValue = [Property objectForKey:@"checkdata"];
        if(strValue && [strValue length] > 0)
        {
            self.tztcheckdate = ([strValue intValue] != 0);
        }
        
        //textcolor 文本颜色
        strValue = [Property objectForKey:@"textcolor"];
        if(strValue && [strValue length] > 0)
        {
            _infolab.textColor = [UIColor colorWithTztRGBStr:strValue];
        }

        //提示信息 10
        strValue = [Property objectForKey:@"messageinfo"];;
        if(strValue)
        {
            self.messageinfo = strValue;
        }
        DelObject(Property);
    }
    //zxl 20130730 设置选择的调用错误
    [self setSelected:_bSelect];
    _infolab.text = (_bSelect ? self.yestitle : self.notitle);

    
    if(strRect && [strRect length] > 0)
    {
        CGRect frame = CGRectMaketztNSString(strRect,tztUIBaseViewBeginBlank,tztUIBaseViewOrgY,tztUIBaseViewMaxWidth,tztUIBaseViewHeight,tztUIBaseViewMaxWidth,tztUIBaseViewTableCellHeight);
        [self setFrame:frame];
    }
}

//重设区域位置调整
-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
    CGSize szImg = CGSizeZero;
    UIImage* image = [UIImage imageTztNamed:@"tztcheckbox.png"];
    if (image)
    {
        szImg = image.size;
    }
    CGFloat imagey = (self.bounds.size.height - szImg.height)/2;
    if(_checkleft)
    {
        if(_checkbtn)
        {
            _checkbtn.frame = CGRectMake(0,imagey,szImg.width,szImg.height);
            if(_infolab)
            {
                _infolab.frame = CGRectMake(_checkbtn.frame.size.width + 3,0,self.bounds.size.width-_checkbtn.frame.size.width - 3,self.bounds.size.height);
            }
        }
    }
    else
    {
        if(_infolab)
        {
            _infolab.frame = CGRectMake(0,0,self.bounds.size.width-szImg.width-3,self.bounds.size.height);
            if(_checkbtn)
            {
                _checkbtn.frame = CGRectMake(_infolab.frame.size.width,imagey,self.bounds.size.width-_infolab.frame.size.width,szImg.height);
            }
        }
    }
}


//设置选中状态，以及当前状态下的文字显示
-(void)setSelected:(BOOL)selected
{
	if (_checkbtn)
	{
		[_checkbtn setSelected:selected];
        [super setSelected:selected];
	}
    if(_infolab)
        _infolab.text = (selected ? self.yestitle : self.notitle);
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:checked:)])
    {
        [_tztdelegate tztUIBaseView:self checked:self.selected];
    }
}

- (void)dealloc 
{
    NilObject(self.notitle);
    NilObject(self.yestitle);
    NilObject(self.messageinfo);
    NilObject(self.tztdelegate);
    NilObject(self.tzttagcode);
    [super dealloc];
}

- (void)setCheckButtonImage:(UIImage*)image forState:(UIControlState)state
{
    if (_checkbtn)
    {
        [_checkbtn setImage:image forState:state];
    }
}

- (void)setCheckButtonState:(BOOL)bSelect
{
    if (_checkbtn)
    {
        [_checkbtn setSelected:bSelect];
        [super setSelected:bSelect];
    }
}

-(void)checkboxButton:(id)sender
{
    BOOL bSelect = [self isSelected];
    bSelect = !bSelect;
    [self setSelected:bSelect];
}

-(BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    NSNotification* pNotifi = [NSNotification notificationWithName:TZTUIKeyboardDidHideNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
	return TRUE;
}

-(BOOL)resignFirstResponder
{
    NSNotification* pNotifi = [NSNotification notificationWithName:TZTUIKeyboardDidHideNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
	return [super resignFirstResponder];
}

#pragma tztUIBaseViewDelegate
- (NSString*)gettztUIBaseViewValue;
{
    return ([self isSelected]?@"1":@"0");
}

- (void)settztUIBaseViewValue:(NSString*)strValue
{
    BOOL bCheck = (strValue && [strValue compare:@"1"] == NSOrderedSame);
    [self setSelected:bCheck];
}

@end
