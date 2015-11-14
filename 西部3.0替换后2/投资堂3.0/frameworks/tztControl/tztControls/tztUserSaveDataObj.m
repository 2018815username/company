//
//  tztUserDataObj.m
//  tztMobileApp_ZSSC
//
//  Created by King on 15-3-11.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import "tztUserSaveDataObj.h"

@implementation tztUserSaveDataObj

+(tztUserSaveDataObj*)getShareInstance
{
    static dispatch_once_t once;
    static tztUserSaveDataObj *sharedView;
    dispatch_once(&once, ^{ sharedView = [[tztUserSaveDataObj alloc] init];
    });
    return sharedView;
}


-(void)setUserDataValue:(NSString *)nsValue ForKey:(NSString *)nsKey
{
    if (nsValue == nil || nsKey == nil)
        return;
    [[NSUserDefaults standardUserDefaults] setObject:nsValue forKey:nsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(NSString*)getUserDataValueForKey:(NSString *)nsKey
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:nsKey];
}
@end
