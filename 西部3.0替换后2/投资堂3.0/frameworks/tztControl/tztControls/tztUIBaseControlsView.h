//
//  tztUIBaseControlsView.h
//  tztMobileApp
//
//  Created by yangdl on 13-2-23.
//  Copyright (c) 2013年 投资堂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tztUIControlsInfo.h"

extern int g_nJYBackBlackColor;
@interface tztUIBaseControlsCell : UIView
{
    NSString* _cellname;//Cell名称
    BOOL _bgridline;
    NSString* _nsgridcolor;
    UIView* _lineview;
    CGFloat _minHeight;//最低高度
    CGFloat _maxHeight;//最大高度
    id _tztdelegate;
    BOOL _bDetailShow;
}
@property (nonatomic,assign) id<tztSysKeyboardDelegate> tztdelegate;
@property (nonatomic) BOOL bgridline;
@property CGFloat minHeight;
@property CGFloat maxHeight;
@property (nonatomic,retain) NSString* cellname;
@property (nonatomic,retain) NSString* nsgridcolor;
@property BOOL bDetailShow;
@end

/**
 *    @author yinjp
 *
 *    @brief  基础控件view，用于VCBaseView创建对应得界面控件并进行布局
 */
@interface tztUIBaseControlsView : UIView
                                    <
                                    tztUIBaseViewTagDelegate,
                                    tztSysKeyboardDelegate,
                                    tztUIBaseViewTextDelegate,
                                    tztUIBaseViewCheckDelegate,
                                    tztUIDroplistViewDelegate,
                                    tztUIButtonDelegate
                                    >
{
    int _nRadius; //圆角半径
    BOOL _bGridLine;  //分隔线
    NSString*  _nsgridcolor;///
    BOOL _bAutoCalcul; //自动计算
    NSDictionary* _tableinfo;
    NSMutableArray* _tablecells;
    NSMutableDictionary* _tableControls;
    CGFloat _viewMaxheight;
    CGFloat _cellheight;
    id _tztdelegate;
    UIColor*   _clBackground;//背景色
    BOOL       _bDetailShow;
}
@property (nonatomic,assign) id<tztSysKeyboardDelegate> tztdelegate;
@property CGFloat cellheight;
@property CGFloat viewMaxheight; //最大高度
@property (nonatomic) int nRadius;
@property BOOL bAutoCalcul;
@property BOOL bGridLine;
@property (nonatomic,retain) NSDictionary* tableinfo;
@property (nonatomic,retain) UIColor*  clBackground;
@property (nonatomic,retain) NSString* nsgridcolor;
@property BOOL bDetailShow;
- (void)setListViewData:(NSArray*)aylist withdata:(NSArray *)aydata;
- (void)setListViewData:(NSArray *)aydata;
-(void)doHiddenDroplist:(UIView*)droplistview;
-(void)doHiddenDroplistEx:(UIView*)droplistview;
-(NSArray*)getAyCells;
//设置某行隐藏或者显示
-(void)setCellHidenFlag:(int)nLineNo bHidden_:(BOOL)bHidden;
- (void)OnRefreshView;
@end
