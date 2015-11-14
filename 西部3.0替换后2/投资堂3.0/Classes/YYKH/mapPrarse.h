//
//  mapPrarse.h
//  xmlPrase
//
//  Created by dai shouwei on 10-10-9.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMLParser.h"
@interface mapPrarse : XMLParser {
    int count;
    NSMutableArray *InfoArr;
}
@property int count;
@property (nonatomic,retain) NSMutableArray *InfoArr;
- (void)GetAllBranch:(NSString *)StrURL _BranchMSG:(NSMutableArray *)ayBranch;
@end
