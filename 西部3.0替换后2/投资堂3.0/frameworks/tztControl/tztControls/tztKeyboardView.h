//
//  NumberKeyboard.h
//  medcalc
//
//  Created by Pascal Pfiffner on 03.09.08.
//	Copyright 2009 MedCalc. All rights reserved.
//  This sourcecode is released under the Apache License, Version 2.0
//  http://www.apache.org/licenses/LICENSE-2.0.html
//  
//  A custom keyboard that allows to input numerical values and change units
// 

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
/**
 *  键盘类型
 */
typedef NS_ENUM(NSInteger, tztKeyboardViewType){
    /**
     *  默认
     */
    tztKeyboardViewTypeNon = 0,
    /**
     *  数字键盘
     */
    tztKeyboardViewIsNumber = 1,
    /**
     *  不允许字母输入
     */
    tztKeyboardViewNOABC = 1 << 1,
    /**
     *  不允许(.)输入
     */
    tztKeyboardViewNODot = 1 << 2,
    /**
     *  不允许切换到自定义键盘
     */
    tztKeyBoardViewIsSys = 1 << 3,
};

@protocol tztKeyboardViewDelegate;
/**
 *  自定义键盘view
 */
@interface tztKeyboardView : UIView<UIInputViewAudioFeedback>
{
	id<UITextInput> _textView;
    UIButton* _customButton;
    tztKeyboardViewType _keyboardViewType;
    NSInteger         _tztdotvalue;
}
@property (strong) id<UITextInput> textView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *characterKeys;
@property (nonatomic)tztKeyboardViewType keyboardViewType;
@property NSInteger tztdotvalue;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(IBAction)onButtonPressed:(id)sender;
- (void)addCustomButton:(NSString *)name title:(NSString *)title;
- (void)removeCustomButton;
+(tztKeyboardView *)shareKeyboardView;
@end