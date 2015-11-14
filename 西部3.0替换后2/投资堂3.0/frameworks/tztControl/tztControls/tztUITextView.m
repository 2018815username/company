//
//  tztUITextView.m
//  tztMobileApp
//
//  Created by yangdl on 13-2-22.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import "tztUITextView.h"
#import "tztKeyboardView.h"

@implementation tztUITextView

@synthesize maxNumberOfLines = _maxNumberOfLines;
@synthesize minNumberOfLines = _minNumberOfLines;
@synthesize maxlen = _maxlen;
@synthesize tztcheckdate = _tztcheckdate;
@synthesize tztdelegate = _tztdelegate;
@synthesize tztsendaction = _tztsendaction;
@synthesize tzttagcode = _tzttagcode;
@synthesize tztKeyboardType = _tztKeyboardType;

- (id)initWithProperty:(NSString*)strProperty
{
    self = [super init];
    if(self)
    {
        NilObject(self.tztdelegate);
        NilObject(self.tzttagcode);
        [[NSNotificationCenter defaultCenter] addObserver:self  
                                                 selector:@selector(textViewDidChange:)  
                                                     name:UITextViewTextDidChangeNotification  
                                                   object:nil]; 
        [self setProperty:strProperty];
    }
    return self;
}

//;tag|区域|键盘类型|最小行数,最大行数|text|textAlignment|font|enabled|检测数据|是否加密|MaxLen|输入满触发事件|
- (void)setProperty:(NSString*)strProperty
{
    NilObject(self.tzttagcode);
    self.tztcheckdate = FALSE;
    self.tztsendaction = FALSE;
    self.tztKeyboardType = tztKeyBoardViewIsSys;
	self.layer.cornerRadius = 5.0;
	self.textAlignment = NSTextAlignmentLeft;
	self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    UIKeyboardType nkeyboardType = UIKeyboardTypeDefault;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    _animateHeightChange = YES;
    _minNumberOfLines = 0;
    _maxNumberOfLines = 0;
    _minHeight = 0;
    _maxHeight = CGFLOAT_MAX;
    UIFont* textviewfont = tztUIBaseViewTextFont(0);
    NSMutableDictionary* Property = NewObject(NSMutableDictionary);
    [Property settztProperty:strProperty];
    
    NSString* strRect = @",,,";
    if(strProperty && [strProperty length] > 0)
    {
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
        if(strValue && [strValue length] > 0 && [strValue compare:@"number"] == NSOrderedSame)
        {
            self.tztKeyboardType &= ~tztKeyBoardViewIsSys;
            nkeyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        //最大行数
        strValue = [Property objectForKey:@"maxlines"];
        if(strValue && [strValue length] > 0)
        {
            _maxNumberOfLines = [strValue intValue];
        }
        
        //最小行数
        strValue = [Property objectForKey:@"minlines"];
        if(strValue && [strValue length] > 0)
        {
            _minNumberOfLines = [strValue intValue];
        }
        
        //text
        strValue = [Property objectForKey:@"text"];
        if(strValue && [strValue length] > 0)
        {
            NSArray* ay = [strValue componentsSeparatedByString:@"\\n"];
            strValue = [ay componentsJoinedByString:@"\n"];
            ay = [strValue componentsSeparatedByString:@"\\r"];
            strValue = [ay componentsJoinedByString:@"\r"];
        }
        self.text = strValue;
        
        //textAlignment
        strValue = [Property objectForKey:@"textalignment"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            if([strValue compare:@"right"] == NSOrderedSame)
            {
                self.textAlignment = NSTextAlignmentRight;
            }
            else if([strValue compare:@"center"] == NSOrderedSame)
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
            textviewfont = [textviewfont fontWithSize:fontsize];
            
        }
        
        //enabled
        strValue = [Property objectForKey:@"enabled"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            self.editable = ([strValue intValue] != 0);
            self.userInteractionEnabled = ([strValue intValue] != 0);
        }
        //字体颜色
        strValue = [Property objectForKey:@"textcolor"];
        if (strValue && [strValue length] > 0)
        {
            UIColor *pTxtColor = [UIColor colorWithTztRGBStr:strValue];
            if (pTxtColor)
                self.textColor = pTxtColor;
        }
        
        //检测数据
        strValue = [Property objectForKey:@"checkdata"];
        if(strValue && [strValue length] > 0)
        {
            self.tztcheckdate = ([strValue intValue] != 0);
        }
        
        //是否加密
        strValue = [Property objectForKey:@"password"];
        if(strValue && [strValue length] > 0)
        {
            self.secureTextEntry = ([strValue intValue] != 0);
        }
        
        //MaxLen 10
        strValue = [Property objectForKey:@"maxlen"];
        if(strValue && [strValue length] > 0)
        {
            self.maxlen = [strValue intValue];
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
                    if ([strType compare:@"isnumber"] == NSOrderedSame)
                    {
                        self.tztKeyboardType |= tztKeyboardViewIsNumber;
                    }
                    else if([strType compare:@"noabc"] == NSOrderedSame)
                    {
                        self.tztKeyboardType |= tztKeyboardViewNOABC;
                    }
                    else if([strType compare:@"nodot"] == NSOrderedSame)
                    {
                        self.tztKeyboardType |= tztKeyboardViewNODot;
                    }
                    else if([strType compare:@"issys"] == NSOrderedSame)
                    {
                        self.tztKeyboardType |= tztKeyBoardViewIsSys;
                    }
                }
            }
        }
        self.keyboardType = nkeyboardType;
    }
    self.font = textviewfont;
    if(strRect && [strRect length] > 0)
    {
        CGRect frame = CGRectMaketztNSString(strRect,tztUIBaseViewBeginBlank,tztUIBaseViewOrgY/2,tztUIBaseViewMaxWidth,tztUIBaseViewHeight+tztUIBaseViewOrgY,tztUIBaseViewMaxWidth,tztUIBaseViewTableCellHeight);
        [self setFrame:frame];
    }
    DelObject(Property);
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    BOOL btztKeyboard = FALSE;
    if((!IS_TZTIPAD) && ((self.tztKeyboardType & tztKeyBoardViewIsSys) != tztKeyBoardViewIsSys))
    {
        if(keyboardType == UIKeyboardTypeNumbersAndPunctuation ||
           keyboardType == UIKeyboardTypeNumberPad ||
           keyboardType == UIKeyboardTypeDecimalPad ||
           keyboardType == UIKeyboardTypePhonePad )
        {
            btztKeyboard = TRUE;
            keyboardType = UIKeyboardTypeDefault;
        }
    }
    [super setKeyboardType:keyboardType];
    if(btztKeyboard)
    {
        tztKeyboardView* ppKeyboard = [tztKeyboardView shareKeyboardView];
        if(ppKeyboard)
        {
            self.inputView = ppKeyboard;
        }
    }
    else
    {
        self.inputView = nil;
    }
}

- (void)setEditable:(BOOL)editable
{
    [super setEditable:editable];
    if(!editable)
    {
        self.backgroundColor = [UIColor clearColor];
    }
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setMaxNumberOfLines:_maxNumberOfLines];
	[self setMinNumberOfLines:_minNumberOfLines];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self  
                                                    name:UITextViewTextDidChangeNotification  
                                                  object:nil]; 
    NilObject(self.tzttagcode);
    NilObject(self.tztdelegate);
    [super dealloc];
}

- (BOOL)onCheckdata
{
    return TRUE;
}

- (CGRect)textRectForBounds:(CGRect)bounds 
{
    return CGRectMake(bounds.origin.x + 5, 
                      bounds.origin.y , 
                      bounds.size.width - 5, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds 
{
    return [self textRectForBounds:bounds];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if(self.editable)
//    {
//        self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.33 blue:0.66 alpha:1.0].CGColor;
//        self.layer.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:1.0 alpha:1.0].CGColor;	
//    }
//}

-(BOOL)becomeFirstResponder
{
    BOOL bflag = [super becomeFirstResponder];
    if(bflag)
    {
        [[UIApplication sharedApplication] sendAction:@selector(tztUITextViewGainedFocus:) to:nil from:self forEvent:nil];
        NSNotification* pNotifi = [NSNotification notificationWithName:TZTUIKeyboardDidShowNotification object:self];
        [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
    }
	return bflag;
}

- (void)tztUITextViewGainedFocus:(tztUITextView*)sender
{
    if(IS_TZTIPAD)
        return;
    tztKeyboardView* ppKeyboard = [tztKeyboardView shareKeyboardView];
    if(ppKeyboard)
    {
        ppKeyboard.textView =  sender;
        if((self.tztKeyboardType & tztKeyBoardViewIsSys) != tztKeyBoardViewIsSys)
            [ppKeyboard addCustomButton:@"More-Key" title:@"123"];
        ppKeyboard.keyboardViewType = self.tztKeyboardType;
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
        }
    }
	return [super resignFirstResponder];
}

//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if(self.editable)
//    {
//        self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.33 blue:0.66 alpha:1.0].CGColor;
//        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
//    }
//	[super touchesEnded:touches withEvent:event];
//}

-(void)setTztdelegate:(id<tztUITextViewDelegate>)tztdelegate
{
    _tztdelegate = tztdelegate;
    self.delegate = _tztdelegate;
}

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    [super setFrame:frame];
    CGFloat nowheight = self.contentSize.height;
#ifdef __IPHONE_7_0
    if (IS_TZTIOS(7))
    {
        
        CGRect frame = self.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = self.textContainerInset;
        UIEdgeInsets contentInsets = self.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + self.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: self.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        nowheight = measuredHeight;
    }
#endif
    if(_minNumberOfLines && _minHeight > 0)
    {
        nowheight = MAX(self.contentSize.height,_minHeight);
    }
    else
    {
        _minHeight = 0;
    }
    
    if(_maxNumberOfLines && _maxHeight > 0)
    {
        nowheight = MIN(nowheight, _maxHeight);
    }
    else
    {
        _maxHeight = CGFLOAT_MAX;
    }
    
    if(_minNumberOfLines || _maxNumberOfLines) //支持可变高度
    {
        if (self.frame.size.height != nowheight)
        {
            if ([_tztdelegate respondsToSelector:@selector(tztUIBaseView:willChangeHeight:)]) {
                [_tztdelegate tztUIBaseView:self willChangeHeight:nowheight + self.frame.origin.y * 2 ];
            }
            
            CGRect nowframe = self.frame;
            if (nowheight > self.frame.size.height)
                nowframe.size.height = nowheight;
            else
            {
                CGFloat fHeight = [self.text sizeWithFont:self.font forWidth:self.frame.size.width lineBreakMode:NSLineBreakByWordWrapping].height;
                nowframe.size.height = fHeight;
            }
            [super setFrame:nowframe];
            if (self.contentSize.height >= _maxHeight) 
            {
                if(!self.scrollEnabled) 
                {
                    [self flashScrollIndicators];
                }
            } 
        }
    }
}

- (void)textViewDidChange:(NSNotification *)notification  
{
    TZTLogInfo(@"%@",notification);
    NSObject* obj = [notification object];  
    if (obj && [obj isKindOfClass:[tztUITextView class]])  
    {  
        tztUITextView* textView = (tztUITextView*)obj;
        if(textView == self)
        {
            [self setFrame:self.frame];
            NSString* text = self.text;  
            if (text && [text length] > 0)
            {
                if (_maxlen > 0 && ([text length] >= _maxlen))
                {
                    if([text length] > _maxlen)
                    {
                        [super setText:[text substringToIndex:_maxlen]];
                        return;
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

- (void)setMaxNumberOfLines:(int)maxNumberOfLines
{
    if(maxNumberOfLines > 0)
    {
        _maxNumberOfLines = maxNumberOfLines;
        UITextView *test = [[UITextView alloc] init];	
        test.font = self.font;
        test.hidden = YES;
        NSMutableString *newLines = [NSMutableString string];
        if(_maxNumberOfLines == 1) 
        {
            [newLines appendString:@"-"];
        } 
        else 
        {
            for(int i = 1; i < _maxNumberOfLines; i++) 
            {
                [newLines appendString:@"\n"];
            }
        }
        test.text = newLines;
        [test sizeToFit];
        [self addSubview:test];
        _maxHeight = test.contentSize.height;
#ifdef __IPHONE_7_0
        if (IS_TZTIOS(7))
        {
            CGRect frame = self.bounds;
            
            // Take account of the padding added around the text.
            
            UIEdgeInsets textContainerInsets = test.textContainerInset;
            UIEdgeInsets contentInsets = test.contentInset;
            
            CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + test.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
            CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
            
            frame.size.width -= leftRightPadding;
            frame.size.height -= topBottomPadding;
            
            NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
            
            NSDictionary *attributes = @{ NSFontAttributeName: self.font, NSParagraphStyleAttributeName : paragraphStyle };
            
            CGRect size = [test.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
            
            CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
            _maxHeight = measuredHeight;
        }
#endif
        [test removeFromSuperview];
        [test release];
    }
    else
    {
        _maxNumberOfLines = 0;
        _maxHeight = CGFLOAT_MAX;
    }
}

- (void)setMinNumberOfLines:(int)minNumberOfLines
{
    if(minNumberOfLines > 0)
    {
        _minNumberOfLines = minNumberOfLines;
        UITextView *test = [[UITextView alloc] init];	
        test.font = self.font;
        test.hidden = YES;
        NSMutableString *newLines = [NSMutableString string];
        if(_minNumberOfLines == 1) 
        {
            [newLines appendString:@"-"];
        } 
        else 
        {
            for(int i = 1; i < _minNumberOfLines; i++) 
            {
                [newLines appendString:@"\n"];
            }
        }
        test.text = newLines;
        [self addSubview:test];
        _minHeight = test.contentSize.height;
        [test removeFromSuperview];
        [test release];	
    }
    else
    {
        _minNumberOfLines = 0;
        _minHeight = 0;
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