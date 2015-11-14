/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：NSObject+TZTSub.h
 * 文件标识：
 * 摘    要：按钮
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.02.29
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/

#import "tztUISwitch.h"
@interface tztUISwitch ()

- (void)initdata;
@end

@implementation tztUISwitch
@synthesize switched = _switched;
@synthesize checked = _checked;
@synthesize yestitle = _yestitle;
@synthesize notitle = _notitle;
@synthesize noImage = _noImage;
@synthesize yesImage = _yesImage;
@synthesize tztcheckdate = _tztcheckdate;
@synthesize tzttagcode = _tzttagcode;
@synthesize tztdelegate = _tztdelegate;
@synthesize fontSize = _fontSize;
@synthesize tzttarget = _tzttarget;
@synthesize tztaction = _tztaction;
@synthesize bUnderLine = _bUnderLine;
@synthesize pNormalColor = _pNormalColor;
@synthesize nsUnderLineColor = _nsUnderLinseColor;
@synthesize pUnCheckedColor = _pUnCheckedColor;
//;tag|区域|控件类型|title|value|textAlignment|font|enabled|检测数据|YesImage|NoImage|YesText|NoText|
- (void)initdata
{
    NilObject(self.tztdelegate);
    self.switched = YES;
    self.bUnderLine=FALSE; //设置 标题下划线
    self.yestitle = @"";
    self.notitle = @"";
    NilObject(self.tzttagcode);
//    self.yesImage = [UIImage imageTztNamed:@"TZTTabSelectBtnImg.png"];
    self.noImage = nil;
    _checked = FALSE;
    self.tztcheckdate = FALSE;
    _fontSize = 14.0f;
    self.nsUnderLineColor = @"";
//    xinlan
    self.pNormalColor = [UIColor whiteColor];
    if ([g_pSystermConfig.strMainTitle isEqual:@"一创财富通"])
    {
         self.pNormalColor = [UIColor blueColor];
    }
    self.pUnCheckedColor = [UIColor whiteColor];


//    self.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [self initdata];
        self.tzttarget = self;
        self.tztaction = @selector(checkboxButton:);
        [self addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initdata];
        self.tzttarget = self;
        self.tztaction = @selector(checkboxButton:);
        [self addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initdata];
        self.tzttarget = self;
        self.tztaction = @selector(checkboxButton:);
        [self addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithProperty:(NSString*)strProperty
{
    self = [super init];
    if(self)
    {
        [self initdata];
        self.tzttarget = self;
        self.tztaction = @selector(checkboxButton:);
        [self addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
        [self setProperty:strProperty];
    }
    return self;
}

- (void)setProperty:(NSString*)strProperty
{
    NSString* strRect = @",,,";
    self.titleLabel.font = tztUIBaseViewTextFont(0);
    if(strProperty && [strProperty length] > 0)
    {
        
        NSMutableDictionary* Property = NewObjectAutoD(NSMutableDictionary);
        [Property settztProperty:strProperty];
        //tag
        NSString* strValue = [Property objectForKey:@"tag"];
        if(strValue && [strValue length] > 0)
            self.tzttagcode = strValue;
        
        //区域
        strValue = [Property objectForKey:@"rect"];
        if(strValue && [strValue length] > 0)
            strRect = strValue;
    
        //控件类型
        strValue = [Property objectForKey:@"type"];
        if(strValue == nil || [strValue length] <= 0)
            strValue = @"switch";
        
        if(strValue && [strValue length] > 0) //设置区域
        {
            self.switched = ([strValue compare:@"switch"] == NSOrderedSame);
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
        strValue = [Property objectForKey:@"text"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            _checked = ([strValue intValue] != 0);
        }
        
        //textAlignment 
        strValue = [Property objectForKey:@"textalignment"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            if([strValue compare:@"right"] == NSOrderedSame)
            {
                self.titleLabel.textAlignment = NSTextAlignmentRight;
            }
            else if([strValue compare:@"center"] == NSOrderedSame)
            {
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
            else 
            {
                self.titleLabel.textAlignment = NSTextAlignmentLeft;
            }
        }
        
        self.titleLabel.textColor = [UIColor redColor];
        //font
        strValue = [Property objectForKey:@"font"];
        if(strValue && [strValue length] > 0)//设置字体大小
        {
            CGFloat _fSize = [strValue floatValue];
            _fontSize = _fSize;
            self.titleLabel.font = tztUIBaseViewTextFont(_fontSize);
        }
        
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
        
        //YesImage
        strValue = [Property objectForKey:@"yesimage"];
        if(strValue)
            self.yesImage = [UIImage imageTztNamed:strValue];
        else
            self.yesImage = nil;
        
        //NoImage
        strValue = [Property objectForKey:@"noimage"];
        if(strValue)
            self.noImage = [UIImage imageTztNamed:strValue];
        else
            self.noImage = nil;    
    }
    

    if(strRect && [strRect length] > 0)
    {
        CGRect frame = CGRectMaketztNSString(strRect,tztUIBaseViewBeginBlank,tztUIBaseViewOrgY,tztUIBaseViewMaxWidth,tztUIBaseViewHeight,tztUIBaseViewMaxWidth,tztUIBaseViewTableCellHeight);
        [self setFrame:frame];
    }
    [self setChecked:_checked];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_checked && self.bUnderLine)
    {
        UILabel *label = self.titleLabel;
        NSString *title = [self titleForState:self.state];
//        UIColor *titleColor=[UIColor blueColor];
        UIColor *titleColor = [self titleColorForState:self.state];
        if (self.nsUnderLineColor && self.nsUnderLineColor.length > 0)
        {
            UIImage *image = [UIImage imageTztNamed:self.nsUnderLineColor];
            if (image)
                titleColor = [UIColor colorWithPatternImage:image];
            else
                titleColor = [UIColor colorWithTztRGBStr:self.nsUnderLineColor];
        }
        CGSize size = [title sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
        CGPoint from, to;
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentLeft:
                from.x = 0;
                to.x = size.width;
                break;
            case UIControlContentHorizontalAlignmentCenter:
                from.x = (self.frame.size.width - size.width) / 2;
                to.x = (self.frame.size.width + size.width) / 2;
                break;
            case UIControlContentHorizontalAlignmentRight:
                from.x = self.frame.size.width - size.width;
                to.x = self.frame.size.width;
                break;
            case UIControlContentHorizontalAlignmentFill:
                from.x = 0;
                to.x = self.frame.size.width;
                break;
        }
        switch (self.contentVerticalAlignment) {
            case UIControlContentVerticalAlignmentBottom:
                from.y = self.frame.size.height;
                to.y = from.y;
                break;
            default:
                from.y = (self.frame.size.height + size.height) / 2;
                to.y = from.y;
                break;
        }
        
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [titleColor setStroke];
        CGContextSetLineWidth(context, 2.0);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, from.x, from.y);
        CGContextAddLineToPoint(context, to.x, to.y);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (BOOL)onCheckdata
{
    if(_tztcheckdate && (!self.hidden))
    {
        if(!_checked)
        {
            return FALSE;
        }
    }
    return TRUE;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)dealloc
{
    NilObject(self.tztdelegate);
    NilObject(self.tzttagcode);
    NilObject(self.noImage);
    NilObject(self.yesImage);
    NilObject(self.notitle);
    NilObject(self.yestitle);
    [super dealloc];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.tzttarget = target;
    self.tztaction = action;
	[super addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if(_checked)
    {
        if (self.bUnderLine)
            self.backgroundColor = [UIColor colorWithPatternImage:self.yesImage];
        else
            [self setTztBackgroundImage:self.yesImage];
        if(self.yestitle)
        {
           self.titleLabel.font = tztUIBaseViewTextBoldFont(_fontSize+2);
            [self setTztTitle:self.yestitle];
        }
//        xinlan 将switch选中变颜色
        [self setTitleColor:self.pNormalColor forState:UIControlStateNormal];
//        self.titleLabel.textColor = self.pNormalColor;
    }
    else
    {
        if (self.bUnderLine)
            self.backgroundColor = [UIColor colorWithPatternImage:self.noImage];
        else
            [self setTztBackgroundImage:self.noImage];
        if(self.notitle)
        {
            self.titleLabel.font = tztUIBaseViewTextFont(_fontSize);
            [self setTztTitle:self.notitle];
        }
        [self setTitleColor:self.pUnCheckedColor forState:UIControlStateNormal];
//        self.titleLabel.textColor = self.pUnCheckedColor;
    }
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIBaseView:checked:)])
    {
        [_tztdelegate tztUIBaseView:self checked:_checked];
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    if (self.bUnderLine)
        [self setNeedsDisplay];
}

-(void)checkboxButton:(id)sender
{
    if(_switched)
    {
        _checked = !_checked;
    }
    else
    {
        _checked = YES;
    }
    [self setChecked:_checked];
}

-(void)setTztTitleColor:(UIColor *)color
{
    self.pNormalColor = color;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
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
    return (_checked ? @"1":@"0");
}

- (void)settztUIBaseViewValue:(NSString*)strValue
{
    BOOL bCheck = (strValue && [strValue compare:@"1"] == NSOrderedSame);
    [self setChecked:bCheck];
}
@end
