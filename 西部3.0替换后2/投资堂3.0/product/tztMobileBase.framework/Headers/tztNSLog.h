//
//  tztNSLog.h
//  tztMobileApp
//
//  Created by yangares on 13-5-18.
//
//

#ifndef tztMobileBase_tztNSLog_h
#define tztMobileBase_tztNSLog_h

//#define TZTLOG //记录日志

//日志记录标志
//错误信息
#define TZTLOG_FLAG_ERROR    (1 << 0)  // 0...0001
//警告信息
#define TZTLOG_FLAG_WARN     (1 << 1)  // 0...0010
//提示信息
#define TZTLOG_FLAG_INFO     (1 << 2)  // 0...0100
//全部
#define TZTLOG_FLAG_VERBOSE  (1 << 3)  // 0...1000

#define TZTLOG_FLAG_SOCKET   (1 << 5)  // 0.100000

//日志记录级别
//错误级别打印
#define TZTLOG_LEVEL_ERROR   (TZTLOG_FLAG_ERROR)                                                    // 0...0001
//警告级别打印
#define TZTLOG_LEVEL_WARN    (TZTLOG_FLAG_ERROR | TZTLOG_FLAG_WARN)                                    // 0...0011
//提示信息级别打印
#define TZTLOG_LEVEL_INFO    (TZTLOG_FLAG_ERROR | TZTLOG_FLAG_WARN | TZTLOG_FLAG_INFO)                    // 0...0111
//全部打印
#define TZTLOG_LEVEL_VERBOSE (TZTLOG_FLAG_ERROR | TZTLOG_FLAG_WARN | TZTLOG_FLAG_INFO | TZTLOG_FLAG_VERBOSE) // 0...1111

//日志级别判断
#define TZTLOG_ERROR   ((g_tztLogLevel & TZTLOG_FLAG_ERROR) == TZTLOG_FLAG_ERROR)
#define TZTLOG_WARN    ((g_tztLogLevel & TZTLOG_FLAG_WARN) == TZTLOG_FLAG_WARN)
#define TZTLOG_INFO    ((g_tztLogLevel & TZTLOG_FLAG_INFO) == TZTLOG_FLAG_INFO)
#define TZTLOG_VERBOSE ((g_tztLogLevel & TZTLOG_FLAG_VERBOSE) == TZTLOG_FLAG_VERBOSE)
#define TZTLOG_SOCKET  ((g_tztLogLevel & TZTLOG_FLAG_SOCKET) == TZTLOG_FLAG_SOCKET)

#pragma mark -日志打印宏定义函数
//上传错误信息至服务器
#define TZTLogErrorUp(format, ...) if(1) { NSString* strFile = tztExtractFileNameWithoutExtension(__FILE__,YES);\
                    NSString* strFunction = tztExtractFileNameWithoutExtension(__FUNCTION__,YES);\
                    NSString* strInfo = [NSString stringWithFormat:@"File=%@\r\nFunction=%@\r\nLine=%d\r\n",strFile,strFunction,__LINE__]; \
                    NSString* strLog = [strInfo stringByAppendingFormat:format, ## __VA_ARGS__];\
                    [tztNewMSParse UpLoadLogInfo:strLog]; \
                    tztWriteLog(strLog,TRUE); \
                    [strFunction release];\
                    [strFile release];\
                                    }
#define TZTLogTest(x) {\
    g_tztLogLevel = TZTLOG_LEVEL_ERROR;\
    NSString* strFile = tztExtractFileNameWithoutExtension(__FILE__,YES);\
    NSString* strFunction = tztExtractFileNameWithoutExtension(__FUNCTION__,YES);\
    NSLog(@"File=%@\nFunction=%@\nLine=%d\n %@",strFile,strFunction,__LINE__,x); \
                        }

#define TZTLogError(format, ...) if(TZTLOG_ERROR) { \
                    NSString* strFile = tztExtractFileNameWithoutExtension(__FILE__,YES);\
                    NSString* strFunction = tztExtractFileNameWithoutExtension(__FUNCTION__,YES);\
                    NSString* strInfo = [NSString stringWithFormat:@"File=%@\r\nFunction=%@\r\nLine=%d\r\n",strFile,strFunction,__LINE__]; \
                    NSString* strLog = [strInfo stringByAppendingFormat:format, ## __VA_ARGS__];\
                    tztWriteLog(strLog,TRUE); \
                    [strFunction release];\
                    [strFile release];\
                                    }
#define TZTLogSocket(format, ...) if(TZTLOG_SOCKET) { NSLog(format, ## __VA_ARGS__);}
#define TZTLogWarn(format, ...)  if(TZTLOG_WARN) { NSLog(format, ## __VA_ARGS__); }
#define TZTLogInfo(format, ...)  if(TZTLOG_INFO) { NSLog(format, ## __VA_ARGS__); }
#define TZTLogVerbose(format, ...) if(TZTLOG_VERBOSE) { NSLog(format, ## __VA_ARGS__);}

#define TZTNSLog(format, ...) TZTLogVerbose(format, ## __VA_ARGS__)
#endif
