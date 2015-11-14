//
//  XMLParser.h
//  broadcast
//
//  Created by he lin on 09-6-1.
//  Copyright 2009 zzvcom. All rights reserved.
//

#import <Foundation/Foundation.h>
//所有解析的顶级父类
@interface XMLParser : NSObject <NSXMLParserDelegate>{
	
}
- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;
- (void)parseXMLFileWithData:(NSData *)data parseError:(NSError **)error;
@end
 