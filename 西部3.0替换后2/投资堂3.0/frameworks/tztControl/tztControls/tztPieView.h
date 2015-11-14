/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztPieView
 * 文件标识：    饼图绘制
 * 摘    要：
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：    20130826
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

@class tztPieView;
@protocol tztPieViewDataSource <NSObject>
@required
-(NSInteger)numberOfSlicesInPieView:(tztPieView*)pieView;
-(CGFloat)tztPieView:(tztPieView*)pieView valueForSliceAtIndex:(NSUInteger)nIndex;

@optional
-(UIColor*)tztPieView:(tztPieView*)pieView colorForSliceAtIndex:(NSUInteger)nIndex;
- (NSString *)tztPieChart:(tztPieView *)pieChart textForSliceAtIndex:(NSUInteger)index;
@end

@protocol tztPieViewDelegate <NSObject>
@optional
-(void)tztPieView:(tztPieView*)pieView willSelectSlictAtIndex:(NSUInteger)nIndex;
-(void)tztPieView:(tztPieView*)pieView didSelectSliceAtIndex:(NSUInteger)nIndex;
-(void)tztPieView:(tztPieView*)pieView willDeselectSliceAtIndex:(NSUInteger)nIndex;
-(void)tztPieView:(tztPieView*)pieView didDeselectSliceAtIndex:(NSUInteger)nIndex;
@end

@interface tztPieView : UIView
{
    id<tztPieViewDataSource> _tztDataSource;
    id<tztPieViewDelegate>   _tztDelegate;
    
    CGFloat                 _fStartPieAngle;
    CGFloat                 _fAnimationSpeed;
    CGPoint                 _fPieCenter;
    CGFloat                 _fPieRadius;
    BOOL                    _bShowLabel;
    UIFont                  *_labelFont;
    UIColor                 *_labelColor;
    UIColor                 *_labelShadowColor;
    CGFloat                 _fLabelRadius;
    CGFloat                 _fSelectedSliceStroke;
    CGFloat                 _fSelectedSliceOffsetRadius;
    BOOL                    _bShowPercentage;
    BOOL                    _bShowInfo;
}

@property(nonatomic, assign)id<tztPieViewDataSource>tztDataSource;
@property(nonatomic, assign)id<tztPieViewDelegate>tztDelegate;
@property(nonatomic) CGFloat fStartPieAngle;
@property(nonatomic) CGFloat fAnimationSpeed;
@property(nonatomic) CGPoint fPieCener;
@property(nonatomic) CGFloat fPieRadius;
@property(nonatomic) BOOL    bShowLabel;
@property(nonatomic, retain) UIFont    *labelFont;
@property(nonatomic, retain) UIColor   *labelShadowColor;
@property(nonatomic, retain) UIColor   *labelColor;
@property(nonatomic) CGFloat fLabelRadius;
@property(nonatomic) CGFloat fSelectedSliceStroke;
@property(nonatomic) CGFloat fSelectedSliceOffsetRadius;
@property(nonatomic) BOOL    bShowPercentage;
@property(nonatomic) BOOL    bShowInfo;

-(id)initWithFrame:(CGRect)frame Center:(CGPoint)center Rafius:(CGFloat)radius;
-(void)reloadData;
-(void)setPieBackgroudColor:(UIColor*)color;
-(void)addUserSubView:(UIView *)view;
@end

#endif