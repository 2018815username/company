/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        资讯处理基类
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import <Foundation/Foundation.h>

@class tztInfoItem;

@protocol tztInfoDelegate <NSObject>
@optional
-(void)SetInfoData:(NSMutableArray*)ayData;

-(void)SetInfoItem:(id)delegate pItem_:(tztInfoItem*)pItem;

@end

//单条资讯数据类
@interface tztInfoItem : NSObject 
{
    NSString*   _IndexID;
    NSString*   _InfoContent;
    NSString*   _InfoSubCount;
    NSString*   _InfoTime;
    NSString*   _InfoTitle;
    
    int         _nIsIndex;
    int         _nLevel;
}

@property(nonatomic,retain)NSString* IndexID;
@property(nonatomic,retain)NSString* InfoContent;
@property(nonatomic,retain)NSString* InfoSubCount;
@property(nonatomic,retain)NSString* InfoTime;
@property(nonatomic,retain)NSString* InfoTitle;
@property(nonatomic,retain)NSString* InfoSource; //资讯来源
@property int nIsIndex;
@property int nLevel;


@end

@interface tztInfoBase : tztHqBaseView<tztSocketDataDelegate>
{
    NSInteger     _nStartPos; //起始位置
    NSInteger     _nMaxCount; //请求个数
    
    NSInteger     _nHaveCur;  //当前序号
    NSInteger     _nHaveMax;  //总数据数
    NSString    *_hSString; //hsstring 
    NSString    *_menuID;   //栏目ID
    NSString    *_nsOp_Type;//属性
    
    NSMutableArray *_ayInfoData;//资讯数据列
    NSInteger     _nIsMenu; //是栏目
    UInt16  _ntztReqNo;
    id      _pDelegate;
    BOOL    _bRequestList;//是否请求菜单
    
    BOOL    _bShowLocal;
}
@property NSInteger nStartPos;
@property NSInteger nMaxCount;
@property NSInteger nHaveCur;
@property NSInteger nIsMenu;
@property NSInteger nHaveMax;
@property BOOL bRequestList;
//xinlan 增加获取首页咨询标题

@property(nonatomic,retain)NSString* infoContent;
@property(nonatomic,retain)NSString* menuTitle;
@property(nonatomic,retain)NSString* titleDate; //标题日期

////////////
@property(nonatomic,retain)NSString* hSString;
@property(nonatomic,retain)NSString* menuID;
@property(nonatomic,retain)NSString* nsOp_Type;
@property(nonatomic,retain)NSString* menuKind;
@property(nonatomic,retain)NSMutableArray *ayInfoData;
@property(nonatomic,assign)id pDelegate;

-(NSInteger)GetMenu:(NSString*)nsMenuID retStr_:(NSMutableData*)retStr;
//首页资讯
-(NSInteger)GetInfo;

-(void)ClearData;
//是否存在前后页
-(NSInteger)HaveBackPage;
-(NSInteger)HaveNextPage;


-(BOOL)NextPage;
-(BOOL)BackPage;

//是否存在前后条内容
-(NSInteger)HaveBackContent;
-(NSInteger)HaveNextContent;

-(BOOL)NextContent;
-(BOOL)BackContent;

//读取本地数据并刷新
- (void)readParse:(int)nAction;

//xinlan
- (void)setMenu:(NSString *)title infoContetn:(NSString *)text;
-(void)acquireDate:(id)Date; // 获取时间
@end
