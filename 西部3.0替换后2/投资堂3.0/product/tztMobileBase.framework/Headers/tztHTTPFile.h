//
//  tztHTTPFile.h
//  tztbase
//
//  Created by yangares on 13-12-21.
//  Copyright (c) 2013年 yangares. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TZTRSA @".d"

@interface tztHTTPFile : NSObject
{
    NSMutableDictionary* _tztFileCrc;
    NSLock *_lock;
    int _nSessionMaxIndex;
}
@property (nonatomic,retain) NSMutableDictionary* tztFileCrc;
@property (nonatomic,retain) NSLock *lock;
+ (id)sharetztHTTPFile;
+ (void)freeShare;
////获取CRC列表
//- (NSString*)getInitCrclist;
//获取对应Session CRC列表
- (NSString*)getInitCrclist:(int)nSession;
//删除文件列表
- (void)deleteFileList:(NSArray*)filelist;
//删除对应Session 文件列表
- (void)deleteFileList:(NSArray*)filelist session:(int)nSession;
- (void)writeFile:(NSData*)fileData filename:(NSString*)strFile urlpath:(NSString *)strPath crc:(int)fileCrc;
- (void)writeFile:(NSData*)fileData filename:(NSString*)strFile urlpath:(NSString *)strPath crc:(int)fileCrc session:(int)nSession;
-(void)clearAllFiles;
@end