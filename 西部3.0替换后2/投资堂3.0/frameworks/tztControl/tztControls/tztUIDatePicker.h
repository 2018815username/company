//
//  tztUIDatePicker.h
//  TestDatePicker
//
//  Created by gudugd on 12-9-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
@class tztUIDatePicker;

@protocol tztUIDatePickerDelegate <NSObject>
@optional
- (void)tztUIDatePicker:(tztUIDatePicker *)datePickerView selectDate:(NSDate *)selectDate;
@end


@interface tztUIDatePicker : UIView
{
	UIDatePicker	*_tztDatePicker;
	UIButton		*_surebutton;
	UIButton		*_cancelbutton;
	id<tztUIDatePickerDelegate>              _tztdelegate;
	BOOL            _bShowBtn;//是否显示button
}

@property BOOL    bShowBtn;
@property (retain,nonatomic)id              tztdelegate;
@property (retain,nonatomic)UIDatePicker	*tztDatePicker;
-(void)setShowBtn:(BOOL)bShow;
-(void)setCurDate:(NSDate *)curDate;
@end

