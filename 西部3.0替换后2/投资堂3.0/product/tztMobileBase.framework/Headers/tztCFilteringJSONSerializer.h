//
//  CFilteringJSONSerializer.h
//  TouchJSON
//
//  Created by Jonathan Wight on 06/20/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "tztCJSONSerializer.h"

typedef NSString *(^tztJSONConversionTest)(id inObject);
typedef id (^tztJSONConversionConverter)(id inObject); // TODO replace with value transformers.

@interface tztCFilteringJSONSerializer : tztCJSONSerializer {
	NSSet *tests;
	NSDictionary *convertersByName;
}

@property (readwrite, nonatomic, retain) NSSet *tests;
@property (readwrite, nonatomic, retain) NSDictionary *convertersByName;

- (void)addTest:(tztJSONConversionTest)inTest;
- (void)addConverter:(tztJSONConversionConverter)inConverter forName:(NSString *)inName;

@end
