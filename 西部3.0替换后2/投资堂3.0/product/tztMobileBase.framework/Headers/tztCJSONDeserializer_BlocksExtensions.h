//
//  CJSONDeserializer_BlocksExtensions.h
//  TouchJSON
//
//  Created by Jonathan Wight on 10/15/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "tztCJSONDeserializer.h"

@interface tztCJSONDeserializer (tztCJSONDeserializer_BlocksExtensions)

- (void)deserializeAsDictionary:(NSData *)inData completionBlock:(void (^)(id result, NSError *error))block;
- (void)deserializeAsArray:(NSData *)inData completionBlock:(void (^)(id result, NSError *error))block;

@end
