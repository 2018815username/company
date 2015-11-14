/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：    tztTradeSegment
 * 文件标识：
 * 摘    要：   交易标题栏栏目切换view
 *
 * 当前版本：
 * 作    者：   yinjp
 * 完成日期：
 *
 * 备    注：
 *
 * 修改记录：    
 *
 *******************************************************************************/
#import <UIKit/UIKit.h>
//zxl 20131011 在添加了按钮的点击前和点击后的配置
#define tztTradeSegmentBtnOnBg @"tztTradeSegmentBtnOnBg"
#define tztTradeSegmentBtnSelBg @"tztTradeSegmentBtnSelBg"
#define tztTradeSegmentName @"tztTradeSegmentName"
#define tztTradeSegmentID   @"tztTradeSegmentID"
#define tztTradeSegmentPro  @"tztTradeSegmentPro"

@class tztTradeSegment;

@protocol tztTradeSegmentDelegate <NSObject>

@optional
-(void)tztTradeSegment:(tztTradeSegment*)tztSeg OnSelectAtIndex:(NSMutableDictionary*)options;
-(BOOL)tztTradeSegment:(tztTradeSegment*)tztSeg ShouldSelectAtIndex:(NSMutableDictionary*)options;
@end

@interface tztTradeSegment : UIView
{
    id<tztTradeSegmentDelegate>_tztdelegate;
}

@property(nonatomic,assign)id<tztTradeSegmentDelegate>tztdelegate;
@property NSInteger nPreIndex;
//zxl 20130927 设置不同的交易类型
-(void)setJyType:(int)nType;
/*
item 同配置文件格式
 */
-(void) setItems:(NSMutableArray*)ayItems;
//获取当前交易类型的按钮信息
-(NSMutableDictionary *)GetCurIndexJYDict;
@end
