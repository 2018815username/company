//
//  mapPrarse.m
//  xmlPrase
//
//  Created by dai shouwei on 10-10-9.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "mapPrarse.h"


@implementation mapPrarse


@synthesize count;
@synthesize InfoArr;

-(id)init
{
 if(self = [super init])
 {
     count = 0;
     InfoArr = [[NSMutableArray alloc]init];
     
 }
    return self;
}

- (void)dealloc {
	if(InfoArr)
	{
		[InfoArr removeAllObjects];
		[InfoArr release];
		InfoArr = NULL;
	}
    [super dealloc];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
     }
    
    if ([elementName isEqualToString:@"marker"]) {
               
        count++;
        // 输出属性值
        NSArray *lineInfoArr=[NSArray arrayWithObjects:[attributeDict objectForKey:@"id"],[attributeDict objectForKey:@"province"],[attributeDict objectForKey:@"name"],[attributeDict objectForKey:@"address"],[attributeDict objectForKey:@"lat"],[attributeDict objectForKey:@"lng"],(void*)0]; 
        
        [InfoArr addObject:lineInfoArr];
        }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // 元素终了句柄
    if (qName) {
        elementName = qName;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // 取得元素的text
}

- (void)GetAllBranch:(NSString *)StrURL _BranchMSG:(NSMutableArray *)ayBranch
{
    if (ayBranch == NULL)
        ayBranch = NewObject(NSMutableArray);
    
    NSError *parseError = nil;
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取document路径,括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    
    //定义记录文件全名以及路径的字符串filePath
    
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"GTJA.xml"];
    
	NSData * data = [NSData dataWithContentsOfFile:filePath];
    
    [self parseXMLFileWithData:data parseError:&parseError];
    [ayBranch setArray:self.InfoArr];
}

@end
