//
//  tztUIBaseViewDelegate.h
//  tztMobileApp
//
//  Created by yangdl on 13-2-25.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tztUIControlsProperty.h"

#define tztUIBaseViewTableBlank 5  //表格空余间隔
#define tztUIBaseViewTableCellHeight (IS_TZTIPAD ? 35 : 44) //cell 默认高度
#define tztUIBaseViewTableRadius 10 //表格转角半径

#define tztUIBaseViewBeginBlank 10 //控件起始间隔
#define tztUIBaseViewMidBlank 5 //控件之间间隔
#define tztUIBaseViewEndBlank 10 //控件最后剩余间隔
#define tztUIBaseViewHeight 30 //控件默认高度
#define tztUIBaseViewOrgY (IS_TZTIPAD ? 2 : 7) //(tztUIBaseViewTableCellHeight - tztUIBaseViewHeight)/2 = 7
//控件最大长度
#define tztUIBaseViewMaxWidth (TZTScreenWidth - tztUIBaseViewTableBlank * 2 - tztUIBaseViewBeginBlank - tztUIBaseViewEndBlank)

CG_INLINE CGRect
CGRectMaketztNSString(NSString* strRect,CGFloat x, CGFloat y, CGFloat width, CGFloat height,CGFloat MaxW,CGFloat MaxH)
{
    NSArray* ayRect = [strRect componentsSeparatedByString:@","];
    for (int i = 0; i < [ayRect count]; i++)
    {
        NSString* strValue = [ayRect objectAtIndex:i];
        if(strValue && [strValue length] > 0)
        {
            switch (i) {
                case 0:
                    if ([strValue hasSuffix:@"%"])
                    {
                        x = [strValue floatValue] * MaxW / 100.f;
                    }
                    else
                    {
                        x = [strValue floatValue];
                    }
                    break;
                case 1:
                    if ([strValue hasSuffix:@"%"])
                    {
                        y = [strValue floatValue] * MaxH / 100.f;
                    }
                    else
                    {
                        y = [strValue floatValue];
                    }
                    break;
                case 2:
                    if ([strValue hasSuffix:@"%"])
                    {
                        width = [strValue floatValue] * MaxW / 100.f;
                    }
                    else
                    {
                        width = [strValue floatValue];
                    }
                    break;
                case 3:
                    if ([strValue hasSuffix:@"%"])
                    {
                        height = [strValue floatValue] * MaxH / 100.f;
                    }
                    else
                    {
                        height = [strValue floatValue];
                    }
                    break;
                default:
                    break;
            }
        }
    }
    return CGRectMake(x,y,width,height);
}

CG_INLINE CGRect
CGRectMakeNSString(NSString* strRect)
{
    float fX = 0.0f;
    float fY = 0.0f;
    float fW = 0.0f;
    float fH = 0.0f;
    if (strRect && [strRect length] > 1)
    {
        NSArray *pAy = [strRect componentsSeparatedByString:@","];
        NSUInteger nCount = [pAy count];
        if (nCount > 0)
            fX = [[pAy objectAtIndex:0] floatValue];
        if (nCount > 1)
            fY = [[pAy objectAtIndex:1] floatValue];
        if (nCount > 2)
            fW = [[pAy objectAtIndex:2] floatValue];
        if (nCount > 3)
            fH = [[pAy objectAtIndex:3] floatValue];
    }
    return CGRectMake(fX, fY, fW, fH);
}


@protocol tztUIBaseViewDelegate <NSObject>
@required
@property (nonatomic,retain) NSString* tzttagcode;
- (NSString*)gettztUIBaseViewValue;
- (void)settztUIBaseViewValue:(NSString*)strValue;
@end

@protocol tztUIBaseViewTagDelegate <NSObject>
@optional
- (void)settztUIBaseView:(NSString*)tzttagcode withTag:(NSInteger)tag;
- (void)removetztUIBaseView:(NSString*)tzttagcode;
- (void)settztUIBaseViewControl:(NSString*)tzttagcode withControl:(UIView *)view;
- (UIView *)gettztUIBaseViewWithTag:(NSString*)tzttagcode;
@end

//选择框事件协议
@protocol tztUIBaseViewCheckDelegate
@optional
- (void)tztUIBaseView:(UIView *)tztUIBaseView checked:(BOOL)checked;
@end


@protocol tztUIBaseViewTextDelegate <UITextFieldDelegate,UITextViewDelegate>
@optional
- (void)tztUIBaseView:(UIView *)tztUIBaseView willChangeHeight:(CGFloat)height;
- (void)tztUIBaseView:(UIView *)tztUIBaseView textchange:(NSString *)text;
- (void)tztUIBaseView:(UIView *)tztUIBaseView textmaxlen:(NSString *)text;
- (void)tztUIBaseView:(UIView *)tztUIBaseView focuseChanged:(NSString *)text;
- (void)tztUIBaseView:(UIView *)tztUIBaseView beginEditText:(NSString *)text;
@end