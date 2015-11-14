//
//  CJSONSerialization.h
//  TouchJSON
//
//  Created by Jonathan Wight on 03/04/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    tztkCJSONReadingMutableContainers = 0x1,
    tztkCJSONReadingMutableLeaves = 0x2,
    tztkCJSONReadingAllowFragments = 0x04,
};
typedef NSUInteger tztEJSONReadingOptions;

enum {
    tztkCJJSONWritingPrettyPrinted = 0x1
};
typedef NSUInteger tztEJSONWritingOptions;


@interface tztCJSONSerialization : NSObject {
    
}

+ (BOOL)isValidJSONObject:(id)obj;
+ (NSData *)dataWithJSONObject:(id)obj options:(tztEJSONWritingOptions)opt error:(NSError **)error;
+ (id)JSONObjectWithData:(NSData *)data options:(tztEJSONReadingOptions)opt error:(NSError **)error;
+ (NSInteger)writeJSONObject:(id)obj toStream:(NSOutputStream *)stream options:(tztEJSONWritingOptions)opt error:(NSError **)error;
+ (id)JSONObjectWithStream:(NSInputStream *)stream options:(tztEJSONReadingOptions)opt error:(NSError **)error;

@end
