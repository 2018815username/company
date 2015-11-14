//
//  tztUITextField.m
//  tztMobileApp
//
//  Created by yangdl on 13-2-22.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import "tztUITextField.h"
#import "tztKeyboardView.h"

@interface tztUITextField()

@property(nonatomic,retain)UIColor *clBackGroundColor;
@end

@implementation tztUITextField
@synthesize maxlen = _maxlen;
@synthesize tztcheckdate = _tztcheckdate;
@synthesize tztdelegate = _tztdelegate;
@synthesize tztsendaction = _tztsendaction;
@synthesize tzttagcode = _tzttagcode;
@synthesize tztKeyboardType = _tztKeyboardType;
@synthesize tztdotvalue = _tztdotvalue;
@synthesize tztalignment = _tztalignment;
@synthesize tztBPlaceChange = _tztBPlaceChange;
@synthesize clPlaceHolder = _clPlaceHolder;
@synthesize clBackGroundColor = _clBackGroundColor;
@synthesize tztHasTips = _tztHasTips;

- (id)init
{
    self = [super init];
    if(self)
    {
        NilObject(self.tztdelegate);
        NilObject(self.tzttagcode);
        [self setProperty:@""];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NilObject(self.tztdelegate);
        NilObject(self.tzttagcode);
        [self setProperty:@""];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        NilObject(self.tztdelegate);
        NilObject(self.tzttagcode);
        [self setProperty:@""];
    }
    return self;
}

- (id)initWithProperty:(NSString*)strProperty
{
    self = [super init];
    if(self)
    {
        NilObject(self.tztdelegate);
        NilObject(self.tzttagcode);
        [self setProperty:strProperty];
    }
    return self;
}

-(void)drawPlaceholderInRect:(CGRect)rect
{
    if (self.clPlaceHolder)
    {
        [self.clPlaceHolder setFill];
        CGRect rc = CGRectMake(rect.origin.x, (rect.size.height - self.font.lineHeight) / 2 , rect.size.width, self.font.lineHeight);
        [[self placeholder] drawInRect:rc withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
    }
    else
    {
        CGRect rc = CGRectMake(rect.origin.x, (rect.size.height - self.font.lineHeight) / 2 , rect.size.width, self.font.lineHeight);
        CGFloat fSize = 0;
        [[UIColor grayColor] setFill];
        CGSize sz = [self.placeholder sizeWithFont:self.font
                                       minFontSize:9
                                    actualFontSize:&fSize
                                          forWidth:rc.size.width
                                     lineBreakMode:NSLineBreakByCharWrapping];
        if (self.textAlignment == NSTextAlignmentCenter)
        {
            rc.origin.x += (rc.size.width - sz.width) / 2;
            rc.origin.y += (rc.size.height - sz.height) / 2;
            [self.placeholder drawAtPoint:rc.origin forWidth:rc.size.width withFont:self.font minFontSize:9 actualFontSize:&fSize lineBreakMode:NSLineBreakByCharWrapping baselineAdjustment:UIBaselineAdjustmentAlignCenters];
        }
        else
        {
            [self.placeholder drawAtPoint:rc.origin
                                 forWidth:rc.size.width
                                 withFont:self.font
                              minFontSize:9
                           actualFontSize:&fSize
                            lineBreakMode:NSLineBreakByCharWrapping
                       baselineAdjustment:UIBaselineAdjustmentAlignCenters];
        }
//        [super drawPlaceholderInRect:rect];
    }
}

//;tag|区域|键盘类型|placeholder|text|textAlignment|font|enabled|检测数据|是否加密|MaxLen|输入满触发事件|
- (void)setProperty:(NSString*)strProperty
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    self.tztcheckdate = FALSE;
    self.tztsendaction = FALSE;
    self.tztKeyboardType = 0;
    self.clPlaceHolder = nil;
    self.tztdotvalue = 2;
    _tztalignment = FALSE;
    self.font = tztUIBaseViewTextFont(0);
	self.borderStyle = UITextBorderStyleNone;// UITextBorderStyleRoundedRect;
//	self.layer.borderWidth = .5;
	self.layer.cornerRadius = 1.2;
	self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.textAlignment = NSTextAlignmentLeft;
	self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    UIKeyboardType nkeyboardType = UIKeyboardTypeNumbersAndPunctuation;
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
        
        //键盘类型 
        strValue = [Property objectForKey:@"keyboardtype"];
        if(strValue && [strValue length] > 0)
        {
            if ([strValue caseInsensitiveCompare:@"number"] == NSOrderedSame)
            {
                self.tztKeyboardType &= ~tztKeyBoardViewIsSys;
                nkeyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
            else
            {
                self.tztKeyboardType |= tztKeyBoardViewIsSys;
                if ([strValue caseInsensitiveCompare:@"chinese"] == NSOrderedSame)
                {
                    nkeyboardType = UIKeyboardTypeDefault;
                }
                else if([strValue caseInsensitiveCompare:@"numberonly"] == NSOrderedSame)
                {
                    nkeyboardType = UIKeyboardTypeNumberPad;
                }
                else if([strValue caseInsensitiveCompare:@"email"] == NSOrderedSame)
                {
                    nkeyboardType = UIKeyboardTypeEmailAddress;
                }
            }
        }
        else
        {
            self.tztKeyboardType &= ~tztKeyBoardViewIsSys;
            nkeyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        //placeholder
        strValue = [Property objectForKey:@"placeholder"];
        if(strValue && [strValue length] > 0)
        {
            self.placeholder = strValue;
        }
        
        //cornerRadius
        strValue = [Property objectForKey:@"cornerradius"];
        if(strValue && [strValue length] > 0)
        {
            self.layer.cornerRadius = [strValue floatValue];
        }
        
        //textcolor
        strValue = [Property objectForKey:@"textcolor"];
        if(strValue && [strValue length] > 0)
        {
            self.textColor = [UIColor colorWithTztRGBStr:strValue];
        }
        else
        {
            self.textColor = [UIColor tztThemeTextColorEditor];
        }
        
        //text
        self.text = [Property objectForKey:@"text"];
        if(self.text && [self.text length] > 0)
        {
            self.textAlignment = NSTextAlignmentCenter;// NSTextAlignmentLeft;
        }
        //textAlignment
        strValue = [Property objectForKey:@"textalignment"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            _tztalignment = TRUE;
            if([strValue caseInsensitiveCompare:@"right"] == NSOrderedSame)
            {
                self.textAlignment = NSTextAlignmentRight;
            }
            else if([strValue caseInsensitiveCompare:@"center"] == NSOrderedSame)
            {
                self.textAlignment = NSTextAlignmentCenter;
            }
            else 
            {
                self.textAlignment = NSTextAlignmentLeft;
            }
        }
        
        //font
        strValue = [Property objectForKey:@"font"];
        if(strValue && [strValue length] > 0) //设置字体大小
        {
            CGFloat fontsize = [strValue floatValue];
            self.font = tztUIBaseViewTextFont(fontsize);
        }
        
        //enabled
        strValue = [Property objectForKey:@"enabled"];
        if(strValue && [strValue length] > 0)
        {
            self.enabled = ([strValue intValue] != 0);
        }
        
        //是否加密
        strValue = [Property objectForKey:@"password"];
        if(strValue && [strValue length] > 0)
        {
            self.secureTextEntry = ([strValue intValue] != 0);
        }
        
        //检测数据
        strValue = [Property objectForKey:@"checkdata"];
        if(strValue && [strValue length] > 0)
        {
            self.tztcheckdate = ([strValue intValue] != 0);
        }
        
        //MaxLen 10
        strValue = [Property objectForKey:@"maxlen"];
        if(strValue && [strValue length] > 0)
        {
            self.maxlen = [strValue intValue];
        }
        
        //placechange
        strValue = [Property objectForKey:@"placechange"];
        if(strValue && [strValue length] > 0 && [strValue intValue])
        {
            _tztBPlaceChange = YES;
        }
        
        //是否有边框
        strValue = [Property objectForKey:@"borderwidth"];
        if([strValue length] > 0)
        {
            self.layer.borderWidth = [strValue floatValue];
        }
        else
        {
            self.layer.borderWidth = .5f;
        }
        
        CGRect rcFrame = self.rightView.frame;
        rcFrame.size.width = 10;
        self.rightView.frame = rcFrame;
        //背景色
        strValue = [Property objectForKey:@"backgroundcolor"];
        if(strValue && [strValue length] > 0)
        {
            NSString* temp = [strValue lowercaseString];
            if ([strValue hasSuffix:@".png"])
            {
                self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:strValue]];
            }
            else if([temp compare:@"clearcolor"] == NSOrderedSame)
            {
                self.backgroundColor = [UIColor clearColor];
            }
            else
            {
                self.backgroundColor = [UIColor colorWithTztRGBStr:strValue];
            }
        }
        else
        {
            self.backgroundColor = [UIColor tztThemeBackgroundColorEditor];
        }
        
        
        //边框颜色
        strValue = [Property objectForKey:@"bordercolor"];
        if (strValue && [strValue length] > 0)
        {
            self.layer.borderColor = [UIColor colorWithTztRGBStr:strValue].CGColor;
        }
        else
        {
            self.layer.borderColor = [UIColor tztThemeBorderColorEditor].CGColor;
        }
        
        //输入满触发事件
        strValue = [Property objectForKey:@"maxaction"];
        if(strValue && [strValue length] > 0)
        {
            self.tztsendaction = (([strValue intValue] != 0 ) && self.maxlen > 0);
        }
        
        //类型 IsNumber(纯数字) NOABC(不允许ABC切换) NODot(不允许小数点) IsSys(不允许切换到自定义键盘)
        strValue = [Property objectForKey:@"type"];
        if (strValue && [strValue length] > 0)
        {
            strValue = [strValue lowercaseString];
            NSArray* ayListType = [strValue componentsSeparatedByString:@"&"];
            for (int i = 0; i < [ayListType count]; i++)
            {
                NSString* strType = [ayListType objectAtIndex:i];
                if (strType && [strType length] > 0)
                {
                    if ([strType caseInsensitiveCompare:@"isnumber"] == NSOrderedSame)
                    {
                        self.tztKeyboardType |= tztKeyboardViewIsNumber;
                    }
                    else if([strType caseInsensitiveCompare:@"noabc"] == NSOrderedSame)
                    {
                        self.tztKeyboardType |= tztKeyboardViewNOABC;
                    }
                    else if([strType caseInsensitiveCompare:@"nodot"] == NSOrderedSame)
                    {
                        self.tztKeyboardType |= tztKeyboardViewNODot;
                    }
                    else if([strType caseInsensitiveCompare:@"issys"] == NSOrderedSame)
                    {
                        self.tztKeyboardType |= tztKeyBoardViewIsSys;
                    }
                }
            }
        }
        self.keyboardType = nkeyboardType;
        self.adjustsFontSizeToFitWidth = YES;
        DelObject(Property);
        
    }
    
    if(strRect && [strRect length] > 0)
    {
        CGRect frame = CGRectMaketztNSString(strRect,tztUIBaseViewBeginBlank,tztUIBaseViewOrgY,tztUIBaseViewMaxWidth,tztUIBaseViewHeight,tztUIBaseViewMaxWidth,tztUIBaseViewTableCellHeight);
        [self setFrame:frame];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
    NilObject(self.tztdelegate);
    NilObject(self.tzttagcode);
    [super dealloc];
}

- (BOOL)onCheckdata
{
    if(_tztcheckdate && (!self.hidden))
    {
        if(self.text == nil || [self.text length] <= 0)
        {
            return FALSE;
        }
    }
    return TRUE;
}

//控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds 
{
//    if (self.editing && (self.clearButtonMode == UITextFieldViewModeWhileEditing || self.clearButtonMode == UITextFieldViewModeAlways))
//    {
    float leftWidth = self.leftView.frame.size.width;
    float rightWidth = self.rightView.frame.size.width;
    float cancelBtnWidth = 15;
//    float marginWidth = (leftWidth >= rightWidth ? leftWidth : rightWidth);
//    return CGRectInset(CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width , bounds.size.height), marginWidth , 0);
    return CGRectMake(bounds.origin.x + leftWidth + self.layer.cornerRadius + 3, bounds.origin.y, bounds.size.width - leftWidth - rightWidth - self.layer.cornerRadius * 2 - cancelBtnWidth - 3, bounds.size.height);
//    }
//    else

}

//控制文本的位置 
- (CGRect)editingRectForBounds:(CGRect)bounds 
{
    {
//    return CGRectInset(bounds, 2, 0);
        return [self textRectForBounds:bounds];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.33 blue:0.66 alpha:1.0].CGColor;
//    self.layer.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:1.0 alpha:1.0].CGColor;	
}

-(BOOL)becomeFirstResponder
{
    if(!_tztalignment)
        self.textAlignment = NSTextAlignmentLeft;
    BOOL bflag = [super becomeFirstResponder];
    if(bflag)
    {
        [[UIApplication sharedApplication] sendAction:@selector(tztUITextFieldGainedFocus:) to:nil from:self forEvent:nil];
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTUIKeyboardDidShowNotification object:self];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        
        
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:beginEditText:)])
        {
            [_tztdelegate tztUIBaseView:self beginEditText:self.text];
        }
    }
//  self.placeholder = @"";
	return bflag;
}

- (void)tztUITextFieldGainedFocus:(tztUITextField*)sender
{
    if(IS_TZTIPAD )
        return;
    tztKeyboardView* ppKeyboard = [tztKeyboardView shareKeyboardView];
    if(ppKeyboard)
    {
        ppKeyboard.textView =  sender;
        if((self.tztKeyboardType & tztKeyBoardViewIsSys) != tztKeyBoardViewIsSys)
            [ppKeyboard addCustomButton:@"More-Key" title:@"123"];
        ppKeyboard.keyboardViewType = self.tztKeyboardType;
        ppKeyboard.tztdotvalue = self.tztdotvalue;//小数点位数
    }
    
}

-(BOOL)resignFirstResponder
{
    if(!IS_TZTIPAD)
    {
        tztKeyboardView* ppKeyboard = [tztKeyboardView shareKeyboardView];
        if(ppKeyboard && ppKeyboard.textView == self)
        {
            [ppKeyboard removeCustomButton];
            ppKeyboard.textView = nil;
            /*放到外面，不然ipad不会根据价格重新请求可买数量*/
//            if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:focuseChanged:)])
//            {
//                [_tztdelegate tztUIBaseView:self focuseChanged:self.text];
//            }
        }
    }
    
    if ([self isFirstResponder])
    {
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:focuseChanged:)])
        {
            [_tztdelegate tztUIBaseView:self focuseChanged:self.text];
        }
    }
    NSNotification* pNotifi = [NSNotification notificationWithName:TZTUIKeyboardDidHideNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
    if ((self.text == nil || [self.text length] <= 0) && (!_tztalignment))
    {
//        self.textAlignment = NSTextAlignmentCenter;
    }
	return [super resignFirstResponder];
}

-(void)setTztdelegate:(id<tztUIBaseViewTextDelegate>)tztdelegate
{
    _tztdelegate = tztdelegate;
    self.delegate = tztdelegate;
}

//add by yinjp 20131028
-(BOOL)CheckValid:(NSString*)nsText
{
    //数字键盘判断,iPad使用系统的数字键盘，数字键盘输入规则统一
    if (tztKeyboardViewIsNumber &  self.tztKeyboardType)
    {
        if ([nsText rangeOfString:@"."].length > 0)//已经输入过小数点
        {
//            int nCount = 10;
//            if (self.tztdotvalue < 1)
//            {
//                nCount = 1;
//            }
//            else
//            {
//                for (int i = 1; i < self.tztdotvalue; i++)
//                {
//                    nCount *= 10;
//                }
//            }
            
//            NSString* nsFormat = [NSString stringWithFormat:@"%%.%df",self.tztdotvalue];
            //
            NSArray *ay = [nsText componentsSeparatedByString:@"."];
//            int nNum = [[ay objectAtIndex:0] intValue];
            NSString *str = [ay objectAtIndex:1];
            if (str && [str length] > 0)
            {
                if ([str length] > self.tztdotvalue)
                    return FALSE;
            }
        }
    }
    return TRUE;
}

- (void)textFieldDidChange:(NSNotification *)notification  
{
    NSObject* obj = [notification object];  
    if (obj && [obj isKindOfClass:[tztUITextField class]])  
    {  
        tztUITextField* textField = (tztUITextField*)obj;
        if(textField == self)
        {
            NSString* text = self.text;
            if (text && [text length] > 0)
            {
                if (![self CheckValid:self.text] && IS_TZTIPAD)
                {
                    [super setText:[text substringToIndex:self.text.length-1]];
                    [self resignFirstResponder];
                    
                    if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:textchange:)])
                    {
                        [_tztdelegate tztUIBaseView:self textchange:self.text];
                    }
                    
                    if(_tztsendaction)
                    {
                        if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:textmaxlen:)])
                        {
                            [_tztdelegate tztUIBaseView:self textmaxlen:self.text];
                        }
                    }
                    
                    return;
                }
                
                if (_maxlen > 0 && ([text length] >= _maxlen))
                {
                    if([text length] > _maxlen)
                    {
                        [super setText:[text substringToIndex:_maxlen]];
//                        return;
                    }
                    [self resignFirstResponder];
                    
                    if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:textchange:)])
                    {
                        [_tztdelegate tztUIBaseView:self textchange:self.text];
                    }
                    
                    if(_tztsendaction)
                    {
                        if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:textmaxlen:)])
                        {
                            [_tztdelegate tztUIBaseView:self textmaxlen:self.text];
                        }
                    }
                    return;
                }
            }
            if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:textchange:)])
            {
                [_tztdelegate tztUIBaseView:self textchange:self.text];
            }
        }
    }  
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    BOOL btztKeyboard = FALSE;
    if((!IS_TZTIPAD) && ((self.tztKeyboardType & tztKeyBoardViewIsSys) != tztKeyBoardViewIsSys))
    {
        if(keyboardType == UIKeyboardTypeNumbersAndPunctuation ||
           keyboardType == UIKeyboardTypeDecimalPad ||
           keyboardType == UIKeyboardTypePhonePad )
        {
            btztKeyboard = TRUE;
            keyboardType = UIKeyboardTypeASCIICapable;
        }
    }
    [super setKeyboardType:keyboardType];
    if(btztKeyboard)
    {
        tztKeyboardView* ppKeyboard = [tztKeyboardView shareKeyboardView];
        if(ppKeyboard)
        {
            self.inputView = ppKeyboard;
            if((self.tztKeyboardType & tztKeyBoardViewIsSys) != tztKeyBoardViewIsSys)
                [ppKeyboard addCustomButton:@"More-Key" title:@"123"];
        }
    }
    else
    {
        self.inputView = nil;
    }
}

#pragma tztUIBaseViewDelegate
- (NSString*)gettztUIBaseViewValue;
{
    return self.text;
}

- (void)settztUIBaseViewValue:(NSString*)strValue
{
    self.text = strValue;
}

@end


@implementation TZTUITextField
@synthesize bNeedCheck;
@synthesize nNumberofRow;
@synthesize m_pDelegate;

- (CGRect)textRectForBounds:(CGRect)bounds
{
	{
        return CGRectMake(bounds.origin.x + 5,
                          bounds.origin.y ,
                          bounds.size.width - 5, bounds.size.height);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//if ([self isFirstResponder])
	{
		self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.33 blue:0.66 alpha:1.0].CGColor;
        //		self.layer.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:1.0 alpha:1.0].CGColor;
        self.layer.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:1.0 alpha:1.0].CGColor;
	}
	//[super touchesBegan:touches withEvent:event];
}

-(BOOL)becomeFirstResponder
{
    //    BOOL b =
    [super becomeFirstResponder];
	self.layer.borderColor = [UIColor grayColor].CGColor;
	self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    NSNotification* pNotifi = [NSNotification notificationWithName:TZTUIKeyboardDidShowNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
//	self.placeholder = @"";
	self.textAlignment = NSTextAlignmentCenter;// NSTextAlignmentLeft;
	return TRUE;
}

-(BOOL)resignFirstResponder
{
	return [super resignFirstResponder];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//if ([self isFirstResponder])
	{
        //		self.layer.borderColor = [UIColor grayColor].CGColor;
        //		self.layer.backgroundColor = [UIColor lightTextColor].CGColor;
        
		self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.33 blue:0.66 alpha:1.0].CGColor;
        //		self.layer.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:1.0 alpha:1.0].CGColor;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
	}
	[super touchesEnded:touches withEvent:event];
}
@end