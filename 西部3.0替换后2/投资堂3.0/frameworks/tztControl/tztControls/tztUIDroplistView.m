//
//  tztUIDroplistView.m
//  tztMobileApp
//
//  Created by yangdl on 13-2-8.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//


#import "tztUIBaseControlsView.h"
#import "tztUIDroplistView.h"


@interface tztUIDroplistView()
@property(nonatomic,assign)BOOL bTransfom;
- (void)initdata;
- (void)initsubframe;
- (NSString*)securetext:(NSString*)str;
@end

@implementation tztUIDroplistView
@synthesize enabled = _enabled;
@synthesize textfield = _textfield;
@synthesize textbtn = _textbtn;
@synthesize dropbtn = _dropbtn;
@synthesize listView = _listView;
@synthesize ayData = _ayData;
@synthesize ayValue = _ayValue;
@synthesize title = _title;
@synthesize placeholder = _placeholder;
@synthesize text = _text;
@synthesize textColor = _textColor;
@synthesize tztdelegate = _tztdelegate;
@synthesize selectindex = _selectindex;
@synthesize listviewwidth = _listviewwidth;
@synthesize tztcheckdate = _tztcheckdate;
@synthesize dropbtnMode = _dropbtnMode;
@synthesize droplistdel = _droplistdel;
@synthesize droplistViewType = _droplistViewType;
@synthesize tzttagcode = _tzttagcode;
@synthesize nShowSuper = _nShowSuper;
@synthesize nsData = _nsData;
@synthesize pBackView = _pBackView;
- (id)initWithProperty:(NSString*)strProperty
{
    self = [super init];
    if(self)
    {
        [self initdata];
        [self setProperty:strProperty];
    }
    return self;
}

//;tag|区域|控件类型|placeholder|text|textAlignment|font|enabled|检测数据|title|是否显示下拉按钮|是否可删除下拉数据|初始数据|
- (void)setProperty:(NSString*)strProperty
{
    UIColor *pBackCl = [UIColor whiteColor];
    NSString* strRect = @",,,";
    if(strProperty && [strProperty length] > 0)
    {
       
        NSMutableDictionary* Property = NewObject(NSMutableDictionary);
        [Property settztProperty:strProperty];
        //tag
        NSString* strValue = [Property objectForKey:@"tag"];
        if(strValue && [strValue length] > 0)
            self.tzttagcode = strValue;
        
        //背景色
        strValue = [Property objectForKey:@"backgroundcolor"];
        if (strValue && [strValue length] > 0)
        {
            pBackCl = [UIColor colorWithTztRGBStr:strValue];
            self.backgroundColor = pBackCl;
        }
        
        //边框色
        strValue = [Property objectForKey:@"bordercolor"];
        if (strValue && [strValue length] > 0)
            self.layer.borderColor = [UIColor colorWithTztRGBStr:strValue].CGColor;
        
        //区域
        strValue = [Property objectForKey:@"rect"];
        if(strValue && [strValue length] > 0)
            strRect = strValue;
            
        //控件类型 2 ListDate:下拉选择日期; ListSecure:加密显示;ListEdit:可编辑下拉框; 可&
        strValue = [Property objectForKey:@"type"];
        self.droplistViewType = 0;
        if(strValue && [strValue length] > 0)
        {
            strValue = [strValue lowercaseString];
            NSArray* aylistType = [strValue componentsSeparatedByString:@"&"];
            for (int i = 0; i < [aylistType count]; i++)
            {
                NSString* strType = [aylistType objectAtIndex:i];
                if(strType && [strType length] > 0)
                {
                    if([strType compare:@"listdate"] == NSOrderedSame)
                    {
                        self.droplistViewType |= tztDroplistDate;
                    }
                    else if([strType compare:@"listhour"] == NSOrderedSame)
                    {
                        self.droplistViewType |= tztDroplistHour;
                    }
                    else if([strType compare:@"listsecure"] == NSOrderedSame)
                    {
                        self.droplistViewType |= tztDroplistSecure;
                    }
                    else if([strType compare:@"listedit"] == NSOrderedSame)
                    {
                        self.droplistViewType |= tztDroplistEdit;
                        
                        //区域
                        strValue = [Property objectForKey:@"textlen"];
                        if(strValue && [strValue length] > 0)
                            _nTextMaxLen = [strValue intValue];
                        if (_nTextMaxLen <= 0)
                            _nTextMaxLen = 6;
                    }
                }
            }
        }
        
        //键盘类型
        strValue = [Property objectForKey:@"keyboardtype"];
        if(strValue && [strValue length] > 0)
        {
            if ([strValue compare:@"number"] == NSOrderedSame)
                _textfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            else if ([strValue compare:@"chinese"] == NSOrderedSame)
                _textfield.keyboardType = UIKeyboardTypeDefault;
            else if([strValue compare:@"numberonly"] == NSOrderedSame)
                _textfield.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        _textfield.layer.backgroundColor = pBackCl.CGColor;
        _pBackView.layer.backgroundColor = pBackCl.CGColor;
        _textbtn.layer.backgroundColor = pBackCl.CGColor;
        _pBackView.layer.borderColor = pBackCl.CGColor;
        _textfield.layer.borderColor = pBackCl.CGColor;
//        _textbtn.layer.borderColor = self.layer.borderColor;
        
        
        //边框色
        strValue = [Property objectForKey:@"bordercolor"];
        if (strValue && [strValue length] > 0)
        {
            _pBackView.layer.borderColor = [UIColor colorWithTztRGBStr:strValue].CGColor;
        }
        else
        {
            self.layer.borderColor = [UIColor tztThemeBorderColorEditor].CGColor;
            _pBackView.layer.borderColor = [UIColor tztThemeBorderColorEditor].CGColor;
        }
        
        //背景色
        strValue = [Property objectForKey:@"backgroundcolor"];
        if (strValue && [strValue length] > 0)
        {
            NSString* temp = [strValue lowercaseString];
            if ([strValue hasSuffix:@".png"])
            {
                self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageTztNamed:strValue]];
            }
            else if([temp compare:@"clearcolor"] == NSOrderedSame)
            {
                self.backgroundColor = [UIColor clearColor];
                self.pBackView.backgroundColor = [UIColor clearColor];
                self.textfield.backgroundColor = [UIColor clearColor];
//                self.listView.backgroundColor = [UIColor clearColor];
                self.textbtn.backgroundColor = [UIColor clearColor];
                self.dropbtn.backgroundColor = [UIColor clearColor];
                self.textfield.layer.backgroundColor = [UIColor clearColor].CGColor;
                self.textbtn.layer.backgroundColor = [UIColor clearColor].CGColor;
            }
            else
            {
                self.backgroundColor = [UIColor colorWithTztRGBStr:strValue];
            }
        }
        else
        {
            self.backgroundColor = [UIColor tztThemeBackgroundColor];
        }
        
        //是否有边框
        strValue = [Property objectForKey:@"borderwidth"];
        if([strValue length] > 0)
        {
            _pBackView.layer.borderWidth = [strValue floatValue];
            _textfield.layer.borderWidth = 0; // needed
            self.layer.borderWidth = [strValue floatValue];
        }
        else
        {
            _pBackView.layer.borderWidth = .5f;
        }
        
        //圆角
        strValue = [Property objectForKey:@"cornerradius"];
        if([strValue length] > 0)
        {
            self.layer.cornerRadius = [strValue floatValue];
            _pBackView.layer.cornerRadius = [strValue floatValue];
            _textfield.layer.cornerRadius = [strValue floatValue];
            _textfield.layer.borderColor = pBackCl.CGColor;
        }
        
        //placechange
        strValue = [Property objectForKey:@"placechange"];
        if(strValue && [strValue length] > 0 && [strValue intValue])
        {
            self.textfield.tztBPlaceChange = YES;
        }
        
        //placeholder
        strValue = [Property objectForKey:@"placeholder"];
        if(strValue && [strValue length] > 0)
        {
            self.placeholder = strValue;
        }
        
        //text
        self.text = [Property objectForKey:@"text"];
        self.nsData = self.text;
        
        //textcolor
        strValue = [Property objectForKey:@"textcolor"];
        if(strValue && [strValue length] > 0)
        {
            self.textColor = [UIColor colorWithTztRGBStr:strValue];
            self.textfield.textColor = [UIColor colorWithTztRGBStr:strValue];
        }
        else
        {
            self.textColor = [UIColor tztThemeTextColorEditor];
            self.textfield.textColor = [UIColor tztThemeTextColorEditor];
        }
        
        //textAlignment 
        strValue = [Property objectForKey:@"textalignment"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            if (_textfield)
                _textfield.tztalignment = TRUE;
            if([strValue compare:@"right"] == NSOrderedSame)
            {
                if(_textfield)
                    _textfield.textAlignment = NSTextAlignmentRight;
                if(_textbtn)
                    _textbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//                    _textbtn.titleLabel.textAlignment = NSTextAlignmentRight;
            }
            else if([strValue compare:@"center"] == NSOrderedSame)
            {
                if(_textfield)
                    _textfield.textAlignment = NSTextAlignmentCenter;
                if(_textbtn)
                    _textbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//                    _textbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
            else 
            {
                if(_textfield)
                    _textfield.textAlignment = NSTextAlignmentLeft;
                if(_textbtn)
                    _textbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                    _textbtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            }
        }
        
        
        //font
        strValue = [Property objectForKey:@"font"];
        if(strValue && [strValue length] > 0) //设置字体大小
        {
            CGFloat _fontsize = [strValue floatValue];
            if(_textfield)
            {
                _textfield.font = tztUIBaseViewTextFont(_fontsize);
            }
            if(_textbtn)
            {
                _textbtn.titleLabel.font = tztUIBaseViewTextFont(_fontsize);
            }
        }
        
        //enabled
        strValue = [Property objectForKey:@"enabled"];
        if(strValue && [strValue length] > 0)
        {
            _enabled = ([strValue intValue] != 0);
        }
        
        //title
        strValue = [Property objectForKey:@"title"];
        if(strValue && [strValue length] > 0)
        {
            self.title = strValue;
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
            self.droplistViewType |= tztDroplistSecure;
        }
        //ques
        // 是否显示下拉按钮
        strValue = [Property objectForKey:@"dropbtn"];
        if(strValue && [strValue length] > 0)
        {
            self.dropbtnMode = ([strValue intValue]!=0);
        }
        
        //下拉框箭头图片
        strValue = [Property objectForKey:@"dropimage"];
        if (strValue && [strValue length] > 0)
        {
            UIImage *pImage = [UIImage imageTztNamed:strValue];
            if (pImage.size.width > 0 && pImage.size.height > 0)
            {
                [_dropbtn setTztBackgroundImage:nil];
                [_dropbtn setTztBackgroundImage:pImage];
                szDropImg = pImage.size;
            }
        }
        
        //是否可删除下拉数据
        strValue = [Property objectForKey:@"dropdelete"];
        if(strValue && [strValue length] > 0)
        {
            self.droplistdel = ([strValue intValue]!=0);
        }
        
        //数据列表 12
        strValue = [Property objectForKey:@"listvalue"];
        if(strValue && [strValue length] > 0)
        {
            self.ayValue = [NSMutableArray arrayWithArray:[strValue componentsSeparatedByString:@","]];
        }
        
        //数据列表 12
        strValue = [Property objectForKey:@"listdata"];
        if(strValue && [strValue length] > 0)
        {
            self.ayData = [NSMutableArray arrayWithArray:[strValue componentsSeparatedByString:@","]];
        }
        else
        {
            self.ayData = self.ayValue;
        }
        
        strValue = [Property objectForKey:@"transform"];
        if (strValue && strValue.length > 0)
            self.bTransfom = ([strValue intValue] > 0);
        DelObject(Property);
    }
  
    self.enabled = _enabled;
    //这一段有什么作用啊
    if(strRect && [strRect length] > 0)
    {
        CGRect frame = CGRectMaketztNSString(strRect,tztUIBaseViewBeginBlank,tztUIBaseViewOrgY,tztUIBaseViewMaxWidth,tztUIBaseViewHeight,tztUIBaseViewMaxWidth,tztUIBaseViewTableCellHeight);
        [self setFrame:frame];
    }
}

- (BOOL)onCheckdata
{
    if(_tztcheckdate && (!self.hidden))
    {
        if (self.text == nil || [self.text length]<= 0)
        {
            //提示信息
            return FALSE;
        }
    }
    return TRUE;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initdata];
        [self initsubframe];
    }
    return self;
}

#if 1
- (void)initdata
{
    self.backgroundColor = [UIColor clearColor]; //设置背景颜色
    self.placeholder = @"";
    self.text = @"";
    self.title = @"";
    self.nsData = @"";
    self.textColor = [UIColor blackColor];
    self.dropbtnMode = YES;
    self.droplistdel = FALSE; //question 这些是做什么用的
    self.tztcheckdate = FALSE; //question 同上
    _bShowList = FALSE;
    NilObject(self.tzttagcode);
    NilObject(self.tztdelegate);
    self.droplistViewType = tztDroplistEdit;
    _enabled = TRUE; 
    _nShowListRow = 0;
    _nShowSuper = FALSE;
    szDropImg = [UIImage imageTztNamed:@"TZTSelectBtnBack_dropDown.png"].size; //（32,37）
    if (szDropImg.width <= 20)
        szDropImg.width = 20;
    if (szDropImg.height <= 20)
        szDropImg.height = 20;
    
    if (_pBackView == nil)
    {
        self.pBackView = [[[UIView alloc] init] autorelease];
        self.pBackView.layer.borderWidth = 1.0;
        self.pBackView.layer.cornerRadius = 2.0f;
        _textfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textfield.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self addSubview:_pBackView];
    }
    
    if(_textfield == nil)
    {
        self.textfield = [[[tztUITextField alloc] init] autorelease];
        _textfield.keyboardType = UIKeyboardTypeDefault;
        _textfield.font = tztUIBaseViewTextFont(0);
        _textfield.textColor = _textColor;
        _textfield.tztdelegate = self;
        _textfield.borderStyle = UITextBorderStyleNone;// UITextBorderStyleRoundedRect;
        _textfield.layer.borderWidth = .5f;
        _textfield.layer.cornerRadius = 2.0;
        _textfield.adjustsFontSizeToFitWidth = YES;
        _textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textfield.textAlignment = NSTextAlignmentLeft;
        _textfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textfield.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self addSubview:self.textfield];
    }
    
    //这个地方尝试改一下
    if(self.textbtn == nil)
    {
        self.textbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _textbtn.titleLabel.font = tztUIBaseViewTextFont(0);
        _textbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _textbtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_textbtn setTztTitleColor:_textColor];
        _textbtn.layer.cornerRadius = 2.0;
//        _textbtn.layer.borderWidth = 1;
//        _textbtn.layer.borderColor = [UIColor grayColor].CGColor;
      //  [ _textbtn setTztTitle:@"1231231"];
        _textbtn.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [_textbtn addTarget:self action:@selector(doShowList) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.textbtn];
    }
    
    
    if(self.dropbtn == nil)
    {
        self.dropbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dropbtn setTztBackgroundImage:[UIImage imageTztNamed:@"TZTSelectBtnBack_dropDown.png"]];
        [_dropbtn addTarget:self action:@selector(doShowList) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.dropbtn];
        _dropbtn.layer.backgroundColor = [UIColor clearColor].CGColor;
    }
    
    if(self.listView == nil)
    {
        self.listView = [[[UITableView alloc] init] autorelease];
        _listView.delegate = self;
        _listView.dataSource = self;
        [_listView flashScrollIndicators];
        [_listView setBackgroundColor:[UIColor colorWithTztRGBStr:@"236,236,236"]];
        _listView.layer.cornerRadius = 2;//设置那个圆角的有多圆
		_listView.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
//        _listView.layer.borderColor = [UIColor blackColor].CGColor;
//		_listView.layer.masksToBounds = YES;
        [self addSubview:self.listView];
    }
//    源代码
    //这里面设置隐藏
   self.listView.hidden = YES;
//   自己写的代码
    
    // self.listView.hidden =NO;
    self.ayData = nil; //question why
    self.ayValue = nil;//question why
    self.selectindex = -1;//question why
    self.listviewwidth = 0;//question why
    
}

- (void)dealloc
{
    NilObject(self.tzttagcode);
    NilObject(self.title);
    NilObject(self.placeholder);
    NilObject(self.text);
    NilObject(self.nsData);
    NilObject(self.textColor);
    NilObject(self.textfield);
    NilObject(self.textbtn);
    NilObject(self.dropbtn);
    NilObject(self.listView);
    
    NilObject(self.ayData);
    NilObject(self.ayValue);
    NilObject(self.tztdelegate);
    [super dealloc];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initsubframe];
}

- (void)initsubframe
{
    CGRect viewframe = self.bounds;
    if ( CGRectIsNull(viewframe) || CGRectIsEmpty(viewframe) )
    {
        return;
    }
    BOOL bedit = (self.droplistViewType & tztDroplistEdit);
    CGFloat fRightW = 0.f;
    if(self.dropbtnMode)
    {
        fRightW = szDropImg.width - 7; //25
    }
    _fCellHeight = viewframe.size.height / ((_nShowSuper ? 0 : _nShowListRow) + 1);
    CGRect textframe = CGRectMake(0, 0, viewframe.size.width-fRightW, _fCellHeight); //(0,0,265,30)
    if (self.pBackView)
    {
        self.pBackView.hidden = NO;
        CGRect rcFrame = textframe; //(0,0,265,30) ,(0,0,255,44)
        rcFrame.size.width += fRightW;//(0,0,280,44)
        self.pBackView.frame = rcFrame;//(0,0,290,30),(0,0,280,44)
        _pBackView.backgroundColor = self.textfield.backgroundColor;
       
    }
    if(self.textfield)
    {
        self.textfield.hidden = (!bedit); //no
        self.textfield.frame = textframe; //(0,0,255,44)
        //question 2  tzttagcode 有什么作用
        self.textfield.tzttagcode = [NSString stringWithFormat:@"%@",self.tzttagcode]; //tzttagcode=220
        if (self.textfield.textAlignment == NSTextAlignmentCenter)
        {
            CGRect rc = self.textfield.frame;
            rc.origin.x = fRightW;
            rc.size.width -= fRightW;
            self.textfield.frame = rc;
        }
    }
    
    if(self.textbtn)
    {
        self.textbtn.hidden = bedit;
        self.textbtn.frame = CGRectInset(textframe, 5, 2);// textframe;
        if (_textbtn.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter)
        {
            CGRect rc = self.textbtn.frame;
            rc.origin.x = fRightW;
            rc.size.width -= fRightW;
            self.textbtn.frame = rc;
        }
    }

    if(self.dropbtn)
    {
        self.dropbtn.hidden = !self.dropbtnMode;
        if (self.droplistViewType & tztDroplistEdit)
        {
            self.dropbtn.frame = CGRectMake(textframe.origin.x+viewframe.size.width-szDropImg.width-1 , textframe.origin.y , szDropImg.width, textframe.size.height); //(257,0,32,30),(247,0,32,44)
        }
        else
        {
            self.dropbtn.frame = CGRectMake(textframe.origin.x+viewframe.size.width-szDropImg.width-1 , self.textbtn.frame.origin.y , szDropImg.width, self.textbtn.frame.size.height);
        }
    }
    
    if(self.listView)
    {
        CGPoint pt = CGPointMake(textframe.origin.x, textframe.origin.y+_fCellHeight);
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistView:point:)]) 
        {
            pt = [_tztdelegate tztDroplistView:self point:pt];
        }
        CGRect listframe = self.listView.frame;
        listframe.size.width = MAX(_listviewwidth,viewframe.size.width);
        listframe.origin.x = pt.x;
        listframe.origin.y = pt.y;
        self.listView.frame = listframe;
    }
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    if(_textbtn)
    {
        _textbtn.enabled = _enabled;
    }
    if(_textfield)
    {
        _textfield.enabled = _enabled;
    }
    if(_dropbtn)
    {
        _dropbtn.userInteractionEnabled = _enabled;
//        _dropbtn.enabled = _enabled;
//        _dropbtn.alpha = 1.0f;
    }
}
-(BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    if(_droplistViewType & tztDroplistEdit)
    {
        if(_textfield)
        {
            [_textfield becomeFirstResponder]; 
            NSNotification* pNotifi = [NSNotification notificationWithName:TZTUIKeyboardDidShowNotification object:self];
            [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
        }
    }
    else 
    {
        if(_textbtn)
        {
            [_textbtn becomeFirstResponder];
        }
    }
    
   
	return TRUE;
}

-(BOOL)resignFirstResponder
{
    [self doHideList];
    if(_textbtn)
    {
        [_textbtn resignFirstResponder];
    }
    if(_textfield)
    {
        [_textfield resignFirstResponder];
    }
	return [super resignFirstResponder];
    
}

-(void)setPlaceholder:(NSString *)placeholder
{
    if(_placeholder)
    {
        [_placeholder release];
        _placeholder = nil;
    }
    if(placeholder)
        _placeholder = [placeholder retain];
    [self onSetPlaceholder];
}

- (void)onSetPlaceholder
{
    if (self.droplistViewType & tztDroplistEdit)
	{
//        if (self.textfield.text.length > 0)
//            self.textfield.text = @"";//????这个原先为什么注释掉？？？(下拉可输入的时候，清空会导致死循环)
		self.textfield.placeholder = _placeholder;
	}
	else
	{
		[self.textbtn setTztTitle:_placeholder]; 
        [self.textbtn setTztTitleColor:[UIColor lightGrayColor]];
	}
    [self setNeedsDisplay];
}

//设置_text为空
-(void)setTextFieldText
{
    if (self.droplistViewType & tztDroplistEdit)
        self.textfield.text = @"";
}

-(void)tztUIBaseView:(UIView *)tztUIBaseView beginEditText:(NSString *)text
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:beginEditText:)])
    {
        [_tztdelegate tztUIBaseView:tztUIBaseView beginEditText:_text];
    }
}

-(void)tztUIBaseView:(UIView *)tztUIBaseView focuseChanged:(NSString *)text
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:focuseChanged:)])
    {
        [_tztdelegate tztUIBaseView:tztUIBaseView focuseChanged:_text];
    }
}

- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text
{
    NSString* nsString = text;// textField.text;
    if(_text)
    {
        [_text release];
        _text = nil;
    }
    if(nsString)
    {
        _text = [nsString retain];
    }
    
    if (_text && [_text length] > 0)
    {
        if (_nTextMaxLen > 0 && [_text length] >= _nTextMaxLen)
        {
            if(self.textfield && [_text length] > _nTextMaxLen)
            {
                [self.textfield setText:[_text substringToIndex:_nTextMaxLen]];
                return;
            }
            [self resignFirstResponder];
        }
        
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:textchange:)])
        {
            [_tztdelegate tztUIBaseView:tztUIBaseView textchange:_text];
        }
        return;
        
    }
    else
    {
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:textchange:)])
        {
            [_tztdelegate tztUIBaseView:tztUIBaseView textchange:_text];
        }
    }
    
	if(_text == nil || [_text length] <= 0)
    {
        [self onSetPlaceholder];
        return;
    }
    return;
}

- (void)setText:(NSString *)text
{
    if(_text)
    {
        [_text release];
        _text = nil;
    }
    if(text)
    {
        _text = [text retain];
    }
    
	BOOL bSecure = (self.droplistViewType & tztDroplistSecure);
    BOOL bedit = (self.droplistViewType & tztDroplistEdit);
    
	if(_text == nil || [_text length] <= 0)
    {
       [self onSetPlaceholder];
        if (!bedit)
            return;
    }
    
	if (bedit)
	{
		if (bSecure)
		{
            _textfield.text = [self securetext:self.text];
		}
		else
		{
            _textfield.text = self.text;
		}
	}
	else
	{
		if(bSecure)
		{
			[_textbtn setTztTitle:[self securetext:self.text]];
            [_textbtn setTztTitleColor:_textColor];
		}
		else
		{
			[_textbtn setTztTitle:self.text];
            [_textbtn setTztTitleColor:_textColor];
		}
	}
	[self setNeedsDisplay];
}

- (void)doShowList:(int)nShow
{
    [_textfield resignFirstResponder];
    if(nShow == 0)
    {
        [self doHideList];
        _bShowList = !self.listView.hidden;
        return;
    }
    [self doHideList];
	//是选择日期的
	if ((tztDroplistDate & self.droplistViewType) || (tztDroplistHour & self.droplistViewType))
	{
		if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistViewWithDataview:)])
		{
			[_tztdelegate tztDroplistViewWithDataview:self];
		}
        _bShowList = !self.listView.hidden;
		return;
	}
	if(self.ayValue == NULL || [self.ayValue count] <= 0)
    {
		if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistViewGetData:)])
		{
			[_tztdelegate tztDroplistViewGetData:self];
		}
		return;
    }
    if(self.listView.hidden || nShow == 1 )
    {
        self.listView.hidden = NO;
        if (_selectindex < 0 || _selectindex > [self.ayValue count])
			_selectindex = 0;
        _nShowListRow = 0;
        _nShowSuper = FALSE;
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _fCellHeight)];
        CGRect listframe = self.listView.frame;
        listframe.size.height = 0;
        self.listView.frame = listframe;
        _nShowListRow = MIN(4, [self.ayValue count]);
        [UIView beginAnimations:@"ainimage" context:nil];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationRepeatCount:NO];
        listframe.size.height = _fCellHeight * _nShowListRow;
        self.listView.frame = listframe;
        
        if (self.bTransfom)
        {
            CGAffineTransform at = CGAffineTransformMakeRotation(M_PI);
            [_dropbtn setTransform:at];
        }
        
        [UIView commitAnimations];
        if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistView:showlistview:)])
        {
            [_tztdelegate tztDroplistView:self showlistview:self.listView];
        }
        if(!_nShowSuper)//显示在self 变更self的frame
        {
            [super setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _fCellHeight*(_nShowListRow+1))];
        }
    }
    else
    {
        [self doHideList];
    }
	[self.listView reloadData];
    
    if ([self.ayValue count] < 1)
	{
		if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistViewGetData:)])
		{
			[_tztdelegate tztDroplistViewGetData:self];
		}
	}
//    _bShowList = !self.listView.hidden;
}

- (void)doShowList
{
    //zxl 20131022 开始显示数据前处理
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistViewBeginShowData:)])
    {
        [_tztdelegate tztDroplistViewBeginShowData:self];
    }
    
    _bShowList = self.listView.hidden;
    if(_bShowList)
        [self doShowList:1];
    else
        [self doHideList];

}

- (void)doHideList
{
    NSNotification* pNotifi = [NSNotification notificationWithName:TZTUIKeyboardDidHideNotification object:self];
    [[NSNotificationCenter defaultCenter] postNotification:pNotifi];
    _nShowListRow = 0;
    CGRect listframe = self.listView.frame;
    listframe.size.height = 0;
    self.listView.frame = listframe;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _fCellHeight)];
    [UIView beginAnimations:@"ainimage" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationRepeatCount:NO];
    self.listView.hidden = YES;
    
    if (self.bTransfom)
    {
        CGAffineTransform at = CGAffineTransformMakeRotation(0);
        [_dropbtn setTransform:at];
    }
    
	[UIView commitAnimations];
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistViewWithDataviewHide:)])
    {
        [_tztdelegate tztDroplistViewWithDataviewHide:self];
    }
}

//只关闭下拉框
- (void)doHideListEx
{
    _nShowListRow = 0;
    CGRect listframe = self.listView.frame;
    listframe.size.height = 0;
    self.listView.frame = listframe;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _fCellHeight)];
    [UIView beginAnimations:@"ainimage" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationRepeatCount:NO];
    self.listView.hidden = YES;
    if (self.bTransfom)
    {
        CGAffineTransform at = CGAffineTransformMakeRotation(0);
        [_dropbtn setTransform:at];
    }
    
	[UIView commitAnimations];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	if(_ayValue == NULL)
        return  3;
//		return 0;
	return [_ayValue count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return _fCellHeight;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *str = @"idetify";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    CGFloat cellWidth = self.frame.size.width;
	if(cell == NULL)
	{
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str]autorelease];
		UILabel *label = nil;
        cell.backgroundColor = [UIColor clearColor];
        
		if (self.droplistdel)
		{
			label = [[[UILabel alloc]initWithFrame:CGRectMake(45, 0, cellWidth-80, _fCellHeight)]autorelease];
		}
		else
		{
			label = [[[UILabel alloc]initWithFrame:CGRectMake(45, 0, cellWidth-50, _fCellHeight)]autorelease];
		}
        
		label.backgroundColor = [UIColor clearColor];
		label.adjustsFontSizeToFitWidth = YES;
        label.tag = 999;
        
//        if (self.textColor) {
//            label.textColor = self.textColor;
//        }
//        else
        {
            label.textColor = [UIColor blackColor];
        }
        
		[cell.contentView addSubview:label];		
	}
    
	if(self.ayValue && [self.ayValue count] > indexPath.row)
    {
        UILabel *nowlabel = (UILabel*)[cell viewWithTag:999];
        nowlabel.font = tztUIBaseViewTextFont(0);
        NSString* labelText = [self.ayValue objectAtIndex:indexPath.row];
        if(self.droplistViewType & tztDroplistSecure)
        {
            nowlabel.text = [self securetext:labelText];
        }
        else
        {
            nowlabel.text = labelText;
        }
        nowlabel.textAlignment = NSTextAlignmentLeft;
//        nowlabel.textAlignment = NSTextAlignmentCenter;
        
        NSString* nsText = @"";
        if (self.ayData && [self.ayData count] > indexPath.row)
        {
            nsText = [self.ayData objectAtIndex:indexPath.row];
        }
        
        if([labelText isEqualToString:self.text] && (self.nsData == NULL || [self.nsData isEqualToString:nsText]))
        {
            cell.imageView.image = [UIImage imageTztNamed:@"TZTChoosed.png"];
        }
        else
        {
            cell.imageView.image = NULL;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if (self.droplistdel)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageTztNamed:@"TZTBaseTextFieldClear.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageTztNamed:@"TZTBaseTextFieldClearBG.png"] forState:UIControlStateHighlighted];
            [btn setFrame:CGRectMake(cellWidth - 32 , 2, 32, 32)];
            [btn addTarget:self action:@selector(doDeleteData:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = indexPath.row;
            cell.accessoryView =  btn;
        }
    }
    return cell;
}

- (void)doDeleteData:(id)Sender
{
	if(self.ayValue == nil || [self.ayValue count] < 1)
		return;
    UIButton *btn = (UIButton*)Sender;
    NSInteger selectRow = btn.tag;
    if(selectRow > [self.ayValue count] - 1)
        selectRow = self.ayValue.count - 1;
    
    _deleteindex = selectRow;
	NSString* deletedata = [self.ayValue objectAtIndex:_deleteindex];
    NSString *str  = [NSString stringWithFormat:@"确定要删除 %@: %@的信息记录么？",self.title,deletedata];
	
	CGRect appRect = [[UIScreen mainScreen] bounds];
	TZTUIMessageBox *pMessage = [[[TZTUIMessageBox alloc] initWithFrame:appRect nBoxType_:TZTBoxTypeButtonBoth delegate_:self] autorelease];;
	//需要组织字符串
	pMessage.m_nsContent = [NSString stringWithString:str];
	pMessage.m_nsTitle = [NSString stringWithFormat:@"删除%@",self.title];
	[pMessage showForView:self animated:YES];
	return;
}

- (void)TZTUIMessageBox:(TZTUIMessageBox *)pMessageBox clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        [self doHideList];
        if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistView:didDeleteIndex:)])
            [_tztdelegate tztDroplistView:self didDeleteIndex:_deleteindex];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        [self doHideList];
        if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistView:didDeleteIndex:)])
            [_tztdelegate tztDroplistView:self didDeleteIndex:_deleteindex];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    TZTNSLog(@"assssssssssfa");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_enabled == FALSE)
        return;
    [self doShowList:0];
	_selectindex = indexPath.row;
	if(self.ayValue == nil || [self.ayValue count] < _selectindex)
		return;
    self.text = [self.ayValue objectAtIndex:_selectindex];
    if (self.ayData && [self.ayData count] > _selectindex)
        self.nsData = [self.ayData objectAtIndex:_selectindex];
    else
        self.nsData = nil;
//    [_listView reloadData];
	if(_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztDroplistView: didSelectIndex:)])
		[_tztdelegate tztDroplistView:self didSelectIndex:_selectindex];
}

- (void)setSelectindex:(NSInteger)selectindex
{
    _selectindex = selectindex;
    if(_selectindex >= 0 && _selectindex < [_ayValue count])
    {
        self.text = [_ayValue objectAtIndex:_selectindex];
        if (self.ayData && [self.ayData count] > _selectindex)
            self.nsData = [self.ayData objectAtIndex:_selectindex];
        
    }
}

- (NSString*)securetext:(NSString*)str
{
    if(!str)
		return @"";
    if([str length] < 5)
		return str;
	NSUInteger length = [str length];
	NSString *Fstr;
	NSString *Bstr;
    NSString *Mstr = @"*";
//zxl 20130730 区分了国泰和自营的账号加密方式不同
#ifdef  GTJA_AcoountSecure
	Fstr = [str substringToIndex:2];
	Bstr = [str substringFromIndex:length-2];
#else
    int nStar = 2;
    if (length <= (g_pSystermConfig.nSecLength + 1) || g_pSystermConfig.nSecLength <= 0)
    {
        Fstr = [str substringToIndex:length-3];
        Bstr = [str substringFromIndex:length-1];
    }
    else
    {
        nStar = g_pSystermConfig.nSecLength;
        NSUInteger nLeft = (length - g_pSystermConfig.nSecLength) / 2;
        Fstr = [str substringToIndex:nLeft];
        Bstr = [str substringFromIndex:length - nLeft];
    }
#endif
    for(int i = 1;i < nStar; i++)
    {
        Mstr = [NSString stringWithFormat:@"*%@",Mstr];
    }
	NSString* ns = [NSString stringWithFormat:@"%@%@%@",Fstr,Mstr,Bstr];
    return ns;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
}
#endif

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
