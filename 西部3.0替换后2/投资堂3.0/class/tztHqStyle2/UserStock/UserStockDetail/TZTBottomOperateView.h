//
//  TZTBottomOperateView.h
//  tztMobileApp_GJUserStock
//
//  Created by DBQ on 5/5/14.
//
//

#ifndef __BOTTOM_H__
#define __BOTTOM_H__
#import <UIKit/UIKit.h>

//typedef void(^selectBlock)(BOOL selected);

@protocol tztBottomOperateViewDelegate <NSObject>

@required
-(void)OnBottomOperateButtonClick:(id)sender;

@end

@interface TZTBottomOperateView : UIView

 /**
 *	@brief	右侧可固定一个按钮，其余均分显示;若需要固定按钮，则直接设置固定宽度，默认从ayButtonData中取最后一个作为固定显示
 */
@property (nonatomic, assign)float          fFixButtonWidth;

@property (nonatomic, retain)NSMutableArray* ayButtonData;
@property (nonatomic, assign)id<tztBottomOperateViewDelegate> tztDelegate;
@property (nonatomic, retain)tztStockInfo *pStockInfo;
//@property (nonatomic, copy)selectBlock block;

@end
#endif