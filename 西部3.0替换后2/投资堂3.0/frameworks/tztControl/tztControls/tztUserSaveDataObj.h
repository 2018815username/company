//
//  tztUserDataObj.h
//  tztMobileApp_ZSSC
//
//  Created by King on 15-3-11.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tztUserSaveDataObj : NSObject

+(tztUserSaveDataObj*)getShareInstance;

-(NSString*)getUserDataValueForKey:(NSString*)nsKey;
-(void)setUserDataValue:(NSString*)nsValue ForKey:(NSString*)nsKey;
@end
