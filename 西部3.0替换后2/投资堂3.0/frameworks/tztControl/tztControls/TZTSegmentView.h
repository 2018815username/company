//
//  TZTSegmentView.h
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 5/9/14.
//
//

#import <UIKit/UIKit.h>

//typedef void(^selectionBlock)(NSUInteger segmentIndex);
@class TZTSegmentView;

@protocol tztSegmentViewDelegate <NSObject>

@optional
-(void)tztSegmentView:(id)segView didSelectAtIndex:(NSInteger)nIndex;

@end

@interface TZTSegmentView : UIView

@property (nonatomic) NSUInteger currentSelected;
@property (nonatomic,strong) UIColor *selectedColor;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *selTextolor;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) id<tztSegmentViewDelegate> tztDelegate;
@property (nonatomic,assign) BOOL bSepLine;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray;

-(UIButton*)GetCurrentSelBtn;

-(void)reducedTitle;

-(void)SetSegmentViewItems:(NSArray*)ayItems;
@end
