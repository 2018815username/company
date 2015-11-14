//
//  tztBlockIndexInfo.h
//  tztMobileApp_HTSC
//
//  Created by King on 14-2-27.
//
//

#import "tztPriceView.h"


////显示类型
//typedef NS_ENUM(NSInteger,tztBlockIndexInfoType)
//{
//    tztBlockIndexInfoType_Normal = 0,
//    tztBlockIndexInfoType_Ex = 1,
//    tztBlockIndexInfoType_FundFlows = 2,
//    
//};

@interface tztBlockIndexInfo : tztPriceView

@property(nonatomic)tztReportType tztBlockType;


//传入的是结构TZTGridData TZTGridataTitle
-(void)tztBlockIndexInfo:(id)view updateInfo_:(NSMutableArray*)pArray;
@end
