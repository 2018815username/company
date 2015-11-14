/*************************************************************
* Copyright (c)2009, 杭州中焯信息技术股份有限公司
* All rights reserved.
*
* 文件名称:		tztUIButton.m
* 文件标识:
* 摘要说明:		自定义按钮控件
* 
* 当前版本:	2.0
* 作    者:	yinjp
* 更新日期:	
* 整理修改:	
*
***************************************************************/

#import "tztUIButton.h"

@interface tztUIButton(TZTPrivate)
-(void)OnClickBtn:(id)sender;
-(void)OnClickBtnDown:(id)sender;
-(void)OnClickBtnUp:(id)sender;
@end


@implementation tztUIButton
@synthesize tztcheckdate = _tztcheckdate;
@synthesize tztdelegate = _tztdelegate;
@synthesize imagebtnname = _imagebtnname;
@synthesize tzttagcode = _tzttagcode;
@synthesize valuebtn = _valuebtn;
//;tag|区域|按钮类型|valueimage|title|textAlignment|font|enabled|进行检测|textcolor|backimage|image|imageAlignment|

-(id) initWithProperty:(NSString *)strProperty withCellWidth_:(float)fWidth
{
    _fCellWidth = fWidth;
    return [self initWithProperty:strProperty];
}

- (id)initWithProperty:(NSString*)strProperty
{
    self = [super init];
    if(self)
    {
        self.tztcheckdate = FALSE;
        NilObject(self.imagebtnname);
        NilObject(self.tztdelegate);
        NilObject(self.tzttagcode);
        _valuebtn = nil;
        _imagebtn = nil;
        [self setProperty:strProperty];
    }
    return self;
}

- (void)setProperty:(NSString*)strProperty
{
    if(_valuebtn)
    {
        [_valuebtn removeFromSuperview];
        _valuebtn = nil;
    }
    
    if(_imagebtn)
    {
        [_imagebtn removeFromSuperview];
        _imagebtn = nil;
    }
    _image = 0;
    _fontsize = 0;
    self.tztcheckdate = FALSE;
    NilObject(self.imagebtnname);
    NilObject(self.tzttagcode);
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
        if(strValue == nil || [strValue length] <= 0) //按钮类型
        {
            strValue = @"roundedrect";
        }
        if([strValue compare:@"imagebutton"] == NSOrderedSame)
        {
            _valuebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:_valuebtn];
            _imagebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _image = 2;
            [self addSubview:_imagebtn];
        }
        else if([strValue compare:@"roundedrect"] == NSOrderedSame)
        {
            _valuebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [self addSubview:_valuebtn];
        }
        else if([strValue compare:@"custom"] == NSOrderedSame)
        {
            _valuebtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:_valuebtn];
        } 
        else if([strValue compare:@"detaildisclosure"] == NSOrderedSame)
        {
            _valuebtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [self addSubview:_valuebtn];
        }
        else if([strValue compare:@"infolight"] == NSOrderedSame)
        {
            _valuebtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
            [self addSubview:_valuebtn];
        }
        else if([strValue compare:@"infodark"] == NSOrderedSame)
        {
            _valuebtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
            [self addSubview:_valuebtn];
        }
        else if([strValue compare:@"contactadd"] == NSOrderedSame)
        {
            _valuebtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [self addSubview:_valuebtn];
        }
        
        if(_valuebtn == nil)
        {
            _valuebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [self addSubview:_valuebtn];
        }
        
        //valueimage
        strValue = [Property objectForKey:@"valueimage"];
        if(_imagebtn && strValue && [strValue length] > 0)
        {
            self.imagebtnname = strValue;
            [_imagebtn setTztImage:[UIImage imageTztNamed:strValue]];
        }

        //title
        strValue = [Property objectForKey:@"title"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            [_valuebtn setTztTitle:strValue];
        }
        
        // 圆角
        strValue = [Property objectForKey:@"cornerradius"];
        if(strValue && [strValue length] > 0) //设置圆角
        {
            _valuebtn.layer.cornerRadius = [strValue floatValue];
        }
        
        // setBackgroundColor
        strValue = [Property objectForKey:@"backgroundcolor"];
        if(strValue && [strValue length] > 0) //设置setBackgroundColor
        {
            [_valuebtn setBackgroundColor:[UIColor colorWithTztRGBStr:strValue]];
        }
        
        //textAlignment 
        strValue = [Property objectForKey:@"textalignment"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            if([strValue compare:@"right"] == NSOrderedSame)
            {
                _valuebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                _valuebtn.titleLabel.textAlignment = NSTextAlignmentRight;
            }
            else if([strValue compare:@"center"] == NSOrderedSame)
            {
                _valuebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                _valuebtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
            else 
            {
                _valuebtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                _valuebtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            }
        }
        
        //font
        strValue = [Property objectForKey:@"font"];
        if(strValue && [strValue length] > 0)//设置字体大小
        {
            _fontsize = [strValue floatValue];
        }
        _valuebtn.titleLabel.font = tztUIBaseViewTextFont(_fontsize);
       
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
            [self setTztTitleColor:[UIColor colorWithTztRGBStr:strValue]];
        }
        
        //backimage
        strValue = [Property objectForKey:@"backimage"];
        if(strValue && [strValue length] > 0)
        {
            if(_image > 0) //只显示value
            {
                [self setTztBackgroundImage:[UIImage imageTztNamed:strValue]];
            }
            else
            {
                [_valuebtn setTztBackgroundImage:[UIImage imageTztNamed:strValue]];
            }
        }
        else
        {
            strValue = [Property objectForKey:@"radius"];
            if (strValue && [strValue length] > 0)
            {
//                if (_image > 0)
                {
                    self.layer.cornerRadius = [strValue floatValue];
                }
//                else
                {
                    _valuebtn.layer.cornerRadius = [strValue floatValue];
                }
            }
            
            strValue = [Property objectForKey:@"backcolor"];
            if (strValue && [strValue length] > 0)
            {
                if (_image > 0)
                {
                    [self setBackgroundColor:[UIColor colorWithTztRGBStr:strValue]];
                }
                else
                {
                    [_valuebtn setBackgroundColor:[UIColor colorWithTztRGBStr:strValue]];
                }
            }
        }
        
        //image
        strValue = [Property objectForKey:@"image"];
        if(strValue && [strValue length] > 0)
        {
            [_valuebtn setTztImage:[UIImage imageTztNamed:strValue]];
        }
                    
        //imageAlignment
        strValue = [Property objectForKey:@"imagealignment"];
        if(strValue == nil || [strValue length] <= 0)
            strValue = @"left";
        if(_imagebtn && strValue && [strValue length] > 0) //设置区域
        {
            if([strValue compare:@"right"] == NSOrderedSame)
            {
                _image = 2;
            }
            else if([strValue compare:@"left"] == NSOrderedSame)
            {
                _image = 1;
            }
        }
        
        //height
        strValue = [Property objectForKey:@"height"];
        if (strValue == nil || [strValue length] <= 0)
            _nHeight = tztUIBaseViewHeight;
        else
            _nHeight = [strValue intValue];
        
        strValue = [Property objectForKey:@"showstouchwhenhighlighted"];
        if (strValue && [strValue length] > 0)
            self.showsTouchWhenHighlighted = ([strValue intValue] > 0);
        DelObject(Property);
        
    }
    if(_valuebtn == nil)
    {
        _valuebtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview:_valuebtn];
    }
    _valuebtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if(_imagebtn)
    {
        [_imagebtn addTarget:self action:@selector(OnClickBtnDown:) forControlEvents:UIControlEventTouchDown];
        [_imagebtn addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchDragOutside];
        [_imagebtn addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchCancel];
        [_imagebtn addTarget:self action:@selector(OnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(_valuebtn)
    {
        [_valuebtn addTarget:self action:@selector(OnClickBtnDown:) forControlEvents:UIControlEventTouchDown];
        [_valuebtn addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchDragOutside];
        [_valuebtn addTarget:self action:@selector(OnClickBtnUp:) forControlEvents:UIControlEventTouchCancel];
        [_valuebtn addTarget:self action:@selector(OnClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(strRect && [strRect length] > 0)
    {        
        CGRect frame = CGRectMaketztNSString(strRect,tztUIBaseViewBeginBlank,tztUIBaseViewOrgY,tztUIBaseViewMaxWidth,/*tztUIBaseViewHeight*/_nHeight,_fCellWidth,tztUIBaseViewTableCellHeight);
        [self setFrame:frame];
    }
}

//重设置显示区域
-(void)setFrame:(CGRect)frame
{
	//设置自身区域
	[super setFrame:frame];
    CGRect rcFrame = self.bounds;
//    BOOL bHaveImage = FALSE;
    if(_image == 0)
    {
        _valuebtn.frame = rcFrame;
    }
    else if(self.bounds.size.width > 0)
    {
        CGSize szText = CGSizeZero;
        CGSize szImg = CGSizeZero;
        NSString* strTitle = [_valuebtn titleForState:UIControlStateNormal];
        szText = [strTitle sizeWithFont:tztUIBaseViewTextFont(_fontsize)];
        if(self.imagebtnname && [self.imagebtnname length] > 0)
        {
            UIImage* image = [UIImage imageTztNamed:self.imagebtnname];
            if (image)
            {
                szImg = image.size;
//                bHaveImage = TRUE;
            }
        }
        
        CGFloat fDiy = 1;
        CGFloat imagey = (rcFrame.size.height - szImg.height) / 2;
        if(imagey < 0 && szImg.height > 0)
        {
            imagey = 0;
            fDiy = (rcFrame.size.height / szImg.height);
            szImg.width *= fDiy;
            szImg.height *= fDiy; 
        }
        
        int nLength = szText.width + szImg.width;
        //都不存在的话，默认就按自身区域绘制
        if (nLength <= 0)
            nLength = self.bounds.size.width;
        
        BOOL haveLen = (self.bounds.size.width >= nLength);
        if(_image == 2) //right
        {
            if(haveLen)
            {
                _valuebtn.frame = CGRectMake(0, 0, self.bounds.size.width - szImg.width - (self.bounds.size.width - nLength)/4, rcFrame.size.height);
                _imagebtn.frame = CGRectMake(_valuebtn.frame.origin.x + _valuebtn.frame.size.width,imagey,szImg.width,szImg.height);
            }
            else if(haveLen)
            {
                _valuebtn.frame = CGRectMake(0, 0, self.bounds.size.width-szImg.width, rcFrame.size.height);
                _imagebtn.frame = CGRectMake(_valuebtn.frame.origin.x + _valuebtn.frame.size.width,imagey,szImg.width,szImg.height);
            }
        }
        else //left
        {
            if(haveLen)
            {
                _imagebtn.frame = CGRectMake((rcFrame.size.width - nLength) / 4, imagey, szImg.width, szImg.height);
                _valuebtn.frame = CGRectMake(_imagebtn.frame.origin.x + _imagebtn.frame.size.width,0,self.bounds.size.width - szImg.width - (self.bounds.size.width - nLength)/4,rcFrame.size.height);
            }
            else if(haveLen)
            {
                _imagebtn.frame = CGRectMake(0, imagey, szImg.width, szImg.height);
                _valuebtn.frame = CGRectMake(_imagebtn.frame.origin.x + _imagebtn.frame.size.width,0,self.bounds.size.width-szImg.width,rcFrame.size.height);
            }
        }
    }
    
}

- (void)dealloc 
{
    NilObject(self.imagebtnname);
    NilObject(self.tztdelegate);
    NilObject(self.tzttagcode);
    [super dealloc];
}

//按钮点击事件相应，调用delegate的按钮事件处理函数
-(void)OnClickBtn:(id)sender
{
	[self setHighlighted:NO];
    BOOL bOk = TRUE;//是否需验证数据
    if(_tztcheckdate)//需验证
    {
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(OnButtonClick:)]) 
        {
            bOk = [_tztdelegate OnCheckData:self];
        }
    }
    if(bOk)
    {
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(OnButtonClick:)]) 
        {
            [_tztdelegate OnButtonClick:self];
        }
    }
}

//按钮按下，相应的整个控件都显示为highlighted状态
-(void) OnClickBtnDown:(id)sender
{
	[self setHighlighted:YES];
}

//松开，或者移出按钮区域，取消当前的highlight状态
-(void) OnClickBtnUp:(id)sender
{
	[self setHighlighted:NO];
}

//重载设置标题函数
-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
	if (_valuebtn)
	{
		[_valuebtn setTitle:title forState:state];
	}
}

//重载设置标题颜色函数
-(void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
	if (_valuebtn)
	{
		[_valuebtn setTitleColor:color forState:state];
	}
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (_valuebtn == nil)
    {
        [super setBackgroundColor:backgroundColor];
    }
    else
    {
        [_valuebtn setBackgroundColor:backgroundColor];
    }
}

-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
	if (_image > 0 || _valuebtn == nil)
	{
		[super setBackgroundImage:image forState:UIControlStateNormal];
	}
    else if(_valuebtn)
    {
        [_valuebtn setBackgroundImage:image forState:UIControlStateNormal];
    }
}

-(void)setImagebtnname:(NSString*)imagename
{
    if(_imagebtnname)
    {
        [_imagebtnname release];
        _imagebtnname = nil;
    }
    if(imagename)
    {
        _imagebtnname = [imagename retain];
    }
    
	if (_imagebtn)
	{
		[_imagebtn setTztBackgroundImage:[UIImage imageTztNamed:_imagebtnname]];
	}
}

//重载获取标题内容函数
-(NSString*)titleForState:(UIControlState)state
{
	if (_valuebtn)
	{
		return [_valuebtn titleForState:state];
	}
	return @"";
}

- (BOOL)onCheckdata
{
    return TRUE;
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
    return [self titleForState:UIControlStateNormal];
}

- (void)settztUIBaseViewValue:(NSString*)strValue
{
    [self setTitle:strValue forState:UIControlStateNormal];
}

@end
