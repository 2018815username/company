//
//  tztUIDatePicker.m
//  TestDatePicker
//
//  Created by gudugd on 12-9-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "tztUIDatePicker.h"

#define MinHeight 140 //datePicker最小高度110 + 30 button高度
#define Minwidth  250 //datePicker最小宽度

#define ButtonWidth 80 //button的宽度
#define Buttonheight 30 //button的高度
@interface tztUIDatePicker (tztPrivate)
-(void)addSubControl;
@end

@implementation tztUIDatePicker
@synthesize bShowBtn = _bShowBtn;
@synthesize tztdelegate = _tztdelegate;
@synthesize tztDatePicker = _tztDatePicker;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.tztdelegate = nil;
        self.backgroundColor = [UIColor colorWithHue:1 saturation:1 brightness:0 alpha:0.3];
        self.bShowBtn = NO;
        [self setShowBtn:_bShowBtn];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) 
    {
        self.bShowBtn = NO;
        if(self.tztDatePicker == nil)
        {
            self.tztDatePicker = [[[UIDatePicker alloc] init] autorelease];
            [self addSubview:self.tztDatePicker];
            self.tztDatePicker.datePickerMode = UIDatePickerModeDate;
            self.tztDatePicker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"] autorelease];
            self.tztDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//            [self setCurDate:nil];
            self.tztDatePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
            //选择得最大日期为当天
            self.tztDatePicker.maximumDate = [NSDate date];
            self.tztDatePicker.alpha =1;
            
            [self.tztDatePicker addTarget:self action:@selector(shouldDatePickerChanged) forControlEvents:UIControlEventValueChanged];
        }
        if(_surebutton == nil)
        {
            _surebutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_surebutton setTztBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBackSmall.png"]];
            [_surebutton setTztTitle:@"确 定"];
            [_surebutton setTztTitleColor:[UIColor blackColor]];
            [_surebutton addTarget:self action:@selector(shouldDatePickerChanged) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_surebutton];
        }
        
        if(_cancelbutton == nil)
        {
            _cancelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelbutton setTztBackgroundImage:[UIImage imageTztNamed:@"TZTButtonBackSmall.png"]];
            [_cancelbutton setTztTitle:@"返 回"];
            [_cancelbutton setTztTitleColor:[UIColor blackColor]];
            [_cancelbutton addTarget:self action:@selector(shouldCancel) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cancelbutton];
        }
    }
    return self;
}

- (void)dealloc {
    NilObject(self.tztDatePicker);
    NilObject(self.tztdelegate);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self addSubControl];
}

-(void)addSubControl
{
	//UIDatePicker控件自身有个最小和最大高度值大约在150--250
	[self.tztDatePicker setFrame:CGRectMake(0, 0, TZTScreenWidth,self.frame.size.height)] ;
    [self setShowBtn:_bShowBtn];
}

-(void)setCurDate:(NSDate *)curDate
{
    //设置初始选中时间,默认为当天
    if(_tztDatePicker){
        if (curDate)
        {
            [_tztDatePicker setDate:curDate animated:NO];
        }
        else
        {
            [_tztDatePicker setDate:[NSDate date] animated:NO];
        }
    }
}

-(BOOL)getBNeedBt
{
    return _bShowBtn;
}

-(void)setShowBtn:(BOOL)bShow
{
    _bShowBtn = bShow;
	_surebutton.hidden = !bShow;
	_cancelbutton.hidden = !bShow;
	int Buttonx = _tztDatePicker.frame.origin.x  + (_tztDatePicker.frame.size.width - ButtonWidth * 2)/3;
	if (bShow) 
    {
        CGRect dateframe = self.bounds;
        dateframe.size.height -= Buttonheight+10;
        _tztDatePicker.frame = dateframe;
        
		_surebutton.frame = CGRectMake(Buttonx, _tztDatePicker.frame.size.height + _tztDatePicker.frame.origin.y + 5, ButtonWidth, Buttonheight);
        
		Buttonx +=_surebutton.frame.size.width + (_tztDatePicker.frame.size.width - ButtonWidth * 2)/3;
		_cancelbutton.frame = CGRectMake(Buttonx, _tztDatePicker.frame.size.height + _tztDatePicker.frame.origin.y + 5, ButtonWidth, Buttonheight);

	}
}

-(void)shouldCancel
{
    self.hidden = YES;
}

-(void)shouldDatePickerChanged
{	
	if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tztUIDatePicker:selectDate:)]) 
	{
		[_tztdelegate tztUIDatePicker:self selectDate:_tztDatePicker.date];
	}
}
@end
