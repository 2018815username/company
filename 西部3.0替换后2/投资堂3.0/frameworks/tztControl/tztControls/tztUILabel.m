//
//  tztUILable.m
//  tztMobileApp
//
//  Created by yangdl on 13-2-22.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import "tztUILabel.h"

@interface tztUILabel()
@property(nonatomic,retain)NSString* strTextColor;
@property(nonatomic,retain)NSString* strBackgroundColor;
@end
@implementation tztUILabel
@synthesize tzttagcode = _tzttagcode;
@synthesize fCellHeight = _fCellHeight;
@synthesize strTextColor = _strTextColor;
@synthesize strBackgroundColor = _strBackgroundColor;

- (id)init
{
    self = [super init];
    if(self)
    {
        [self setProperty:@""];
    }
    return self;
}

- (id)initWithProperty:(NSString*)strProperty withCellWidth_:(float)fWidth CellHeight_:(float)fHeight
{
    _fCellWidth = fWidth;
    _fCellHeight = fHeight;
    if (_fCellHeight <= 0)
        _fCellHeight = tztUIBaseViewHeight;
    _fCellHeight -= (fHeight * 0.25);
    return [self initWithProperty:strProperty];
}

- (id)initWithProperty:(NSString*)strProperty
{
    self = [super init];
    if(self)
    {
        [self setProperty:strProperty];
    }
    return self;
}

//;tag|区域|contentMode|numberOfLines|text|textAlignment|font|enabled|
- (void)setProperty:(NSString*)strProperty
{
    NSString* strRect = @",,,";
    NilObject(self.tzttagcode);
    _insets = UIEdgeInsetsMake(0,0,0,0);
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor tztThemeTextColorLabel];
    self.font = tztUIBaseViewTextFont(0);
    self.contentMode = UIViewContentModeCenter;
//    int nHeight = 0;
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
        
        //行数
        strValue = [Property objectForKey:@"lines"];
        if(strValue && [strValue length] > 0)
        {
            self.numberOfLines = [strValue intValue];
        }
        
        strValue = [Property objectForKey:@"backgroundcolor"];
        if (strValue && [strValue length] > 0)
        {
            self.strBackgroundColor = [NSString stringWithFormat:@"%@", strValue];
            self.backgroundColor = [UIColor colorWithTztRGBStr:strValue];
        }
        
        //text
        self.text = [Property objectForKey:@"text"];
        
        //textcolor
        strValue = [Property objectForKey:@"textcolor"];
        if(strValue && [strValue length] > 0)
        {
            self.strTextColor = [NSString stringWithFormat:@"%@", strValue];
            self.textColor = [UIColor colorWithTztRGBStr:strValue];
        }
        else
        {
            self.textColor = [UIColor tztThemeTextColorLabel];
        }
        //textAlignment
        strValue = [Property objectForKey:@"textalignment"];
        if(strValue && [strValue length] > 0)
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
            self.font = tztUIBaseViewTextFont(fontsize);
        }

        //enabled
        strValue = [Property objectForKey:@"enabled"];
        if(strValue && [strValue length] > 0)
        {
            self.enabled = ([strValue intValue] != 0);
        }

        //adjustsFontSizeToFitWidth
        strValue = [Property objectForKey:@"adjustsfontsizetofitwidth"];
        if(strValue && [strValue length] > 0) //设置区域
        {
            self.adjustsFontSizeToFitWidth = ([strValue intValue] != 0);
            if(self.adjustsFontSizeToFitWidth)
                self.numberOfLines = 1;
        }
        
        strValue = [Property objectForKey:@"height"];
        if (strValue && [strValue length] > 0)
        {
            _fCellHeight = [strValue floatValue];
        }
        DelObject(Property);
    }
    
    if(strRect && [strRect length] > 0)
    {
        CGRect frame = CGRectMaketztNSString(strRect,tztUIBaseViewBeginBlank,tztUIBaseViewOrgY,90.f,_fCellHeight,_fCellWidth,tztUIBaseViewTableCellHeight);
        [self setFrame:frame];
    }

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.strBackgroundColor.length > 0 ){
        NSRange range = [self.strBackgroundColor  rangeOfString:@".png"];
        if (range.length >0) {
            self.backgroundColor =[UIColor colorWithPatternImage: [UIImage imageNamed:self.strBackgroundColor]];
            NSLog(@"xxxxx");
        }else{
        self.backgroundColor = [UIColor colorWithTztRGBStr:self.strBackgroundColor];
        }

    }
    else {
        self.backgroundColor = [UIColor clearColor];
    }

    
    
    if (self.strTextColor.length > 0)
        self.textColor = [UIColor colorWithTztRGBStr:self.strTextColor];
    else
        self.textColor = [UIColor tztThemeTextColorLabel];
}

- (void)setLabelBackgroundColor:(NSString*)strColor andMyBackGroundImage:(NSString*)imageName
{
    if (strColor.length <= 0)
        self.strBackgroundColor = @"";
    else
        self.strBackgroundColor = [NSString stringWithFormat:@"%@", strColor];


}

- (void)dealloc
{
    NilObject(self.tzttagcode);
    [super dealloc];
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

- (void)setUIEdgeInsets:(UIEdgeInsets)insets
{
    _insets = insets;
}

- (void)drawTextInRect:(CGRect)rect
{
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _insets)];
}
@end
