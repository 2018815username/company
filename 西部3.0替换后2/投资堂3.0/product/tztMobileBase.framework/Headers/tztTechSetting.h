/*******************************************************************************
 * Copyright (c)2012, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称：tztTechSetting.h
 * 文件标识：
 * 摘    要：设置信息
 *
 * 当前版本：
 * 作    者：yangdl
 * 完成日期：2012.12.12
 *
 * 备    注：
 *
 * 修改记录：
 * 
 *******************************************************************************/
#if TARGET_OS_IPHONE
//K线参数
@interface tzttechParamSet:NSObject
{
    int  _valueNums; //数据个数
    NSString* _kindName;//名称
    NSMutableArray* _ayNames; //标题
    NSMutableArray* _ayParams;//参数值
}

@property (nonatomic, retain) NSString* kindName;
@property (nonatomic, retain) NSMutableArray* ayNames;
@property (nonatomic, retain) NSMutableArray* ayParams;
@property int valueNums;
- (NSDictionary*)GetJsonData;
- (void)setJsonData:(NSDictionary *)jsondata;
@end

@interface tztTechSetting : NSObject 
{    
    NSMutableArray*  _ayParamColors; //参数色列
    NSMutableDictionary* _techParamSetting; //K线指标设置
    UIColor*  _upColor;       //上涨色 #ff0000
    UIColor*  _downColor;     //下跌色 #00ff00
    UIColor*  _balanceColor;  //相等   #ffffff
    
    UIColor*  _kLineUpColor; //K线上涨色 #ff3c3c
    UIColor*  _kLineDownColor;//K线下跌色 #00e4ff

    UIColor*  _sumColor; //总金额颜色  #11ffff

    UIColor*  _BackgroundColor;//背景色 #111111
    UIColor*  _GridColor;   //表格色 #990000
    
    UIColor*  _CursorColor;//十字光标线颜色 #ffffff
    
    UIColor*  _hideGridColor;   //隐藏视图表格色 #606060
    
    UIColor*  _fixTxtColor; //固定字颜色 #cccccc
    UIColor*  _axisTxtColor;   //坐标字颜色 #ffff00
    
    UIColor*  _tipBackColor;   //信息框底色 #000000
    
    CGFloat   _reportTxtSize; //排名数据字体大小
    CGFloat   _drawTxtSize;  //绘制字体大小
    UIFont*   _drawTxtFont;  //绘制字体
    
    int _nRequestTimer; //请求间隔时间（S）

    NSUInteger _nTechCustomDay; //自定义日线
    NSUInteger _nTechCustomMin; //自定义分钟线
    
    NSUInteger _nKLineChuQuan;  //K线复权
    
    CGSize _chinaTxtSize;
    CGSize _englishTxtSize;
    CGSize _numberTxtSize;
    
    //启动时自动测速
    int        _nAutoTestServer;
    //自动使用最优站点连接
    int        _nAutoUseFastServer;
    //历史数据请求日期间隔
    int        _nDateMargin;
    //0-普通快速买卖菜单 1-融资融券快速买卖菜单
    int        _nMenuType;
    
}
@property (nonatomic, retain) NSMutableArray*  ayParamColors; //参数色列
@property (nonatomic, retain) NSMutableDictionary* techParamSetting;//K线指标设置
@property (nonatomic, retain) UIColor*  upColor;       //上涨色 #ff0000
@property (nonatomic, retain) UIColor*  downColor;     //下跌色 #00ff00
@property (nonatomic, retain) UIColor*  balanceColor;  //相等   #ffffff

@property (nonatomic, retain) UIColor*  kLineUpColor; //K线上涨色 #ff3c3c
@property (nonatomic, retain) UIColor*  kLineDownColor;//K线下跌色 #00e4ff


@property (nonatomic, retain) UIColor*  sumColor; //总金额颜色  #11ffff

@property (nonatomic, retain) UIColor*  hideGridColor;   //隐藏视图表格色 #606060
@property (nonatomic, retain) UIColor*  backgroundColor;//背景色 #111111
@property (nonatomic, retain) UIColor*  gridColor;   //表格色 #990000


@property (nonatomic, retain) UIColor*  cursorColor;//十字光标线颜色 #ffffff

@property (nonatomic, retain) UIColor*  fixTxtColor; //固定字颜色 #cccccc
@property (nonatomic, retain) UIColor*  axisTxtColor;   //坐标字颜色 #ffff00

@property (nonatomic, retain) UIColor*  tipBackColor;   //信息框底色 #000000

@property (nonatomic) CGFloat reportTxtSize; //排名字体大小
@property (nonatomic, readonly) CGFloat drawTxtSize; //绘制字体大小
@property (nonatomic, retain) UIFont*   drawTxtFont;   //绘制字体

@property int nRequestTimer;

@property NSUInteger nTechCustomDay; //自定义日线
@property NSUInteger nTechCustomMin; //自定义分钟线

@property NSUInteger nKLineChuQuan;  //K线复权

@property (nonatomic, readonly) CGSize chinaTxtSize; //绘制字体大小
@property (nonatomic, readonly) CGSize englishTxtSize; //绘制字体大小
@property (nonatomic, readonly) CGSize numberTxtSize; //绘制字体大小

@property int        nAutoTestServer;
@property int        nAutoUseFastServer;
@property int        nDateMargin;
@property int        nMenuType;

+ (tztTechSetting *)getInstance;
- (UIColor*)getparamcolor:(int)iIndex;
//设置字体大小
- (void)setDrawTxtSize:(CGFloat)txtsize;

- (int)getTechParamSettingMAnum;
- (void)setTechParamSettingMAnum:(int)num;

-(void)SaveData;
-(void)ReadData;
@end

#endif
