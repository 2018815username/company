/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        
 * 文件标识:        
 * 摘要说明:        
 * 
 * 当前版本:        2.0
 * 作    者:       yinjp
 * 更新日期:            
 * 整理修改:	
 *
 ***************************************************************/

#import "tztHQSetView.h"

@implementation tztHQSetView
-(id)init
{
    if (self = [super init]) 
    {
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    [self onSetTableConfig:@"tztUIHQSetting"];
 }


-(void)dealloc
{
    [super dealloc];
}

- (void)onReadWriteSettingValue:(BOOL)bRead
{
    int nTime = [tztTechSetting getInstance].nRequestTimer;
    if(bRead)
    {

        NSString* strTime = @"关闭";
        if (nTime > 0)
            strTime = [NSString stringWithFormat:@"%d",nTime];
        NSMutableArray* _pAyTime = [[NSMutableArray alloc] initWithObjects:
                                    @"关闭",
                                    @"3",
                                    @"5",
                                    @"10",
                                    @"15",
                                    @"20",
                                    @"25",
                                    @"30",
                                    nil];
        NSUInteger nIndex = [_pAyTime indexOfObject:strTime];
        if(nIndex == NSNotFound)
        {
            nIndex = 0;
        }
        [_tztTableView setComBoxData:_pAyTime ayContent_:_pAyTime AndIndex_:nIndex withTag_:3000];
        [_pAyTime release];
    }
    else
    {
        NSString *strNowTime = [_tztTableView getComBoxText:3000];
        int nNowTime;
        if ([strNowTime compare:@"关闭"] == NSOrderedSame)
        {
            nNowTime = 0;
        }
        else
        {
            nNowTime = [strNowTime intValue];
        }
        //存储
        if (nNowTime != nTime)
        {
            g_nTime = [strNowTime intValue];
            [tztTechSetting getInstance].nRequestTimer = [strNowTime intValue];
            [[tztTechSetting getInstance] SaveData];
            [[tztTechSetting getInstance] setValue:strNowTime forKeyPath:@"_nRequestTimer"];
        }
    }
}

-(void)tztDroplistView:(tztUIDroplistView *)droplistview didSelectIndex:(NSInteger)index
{
    if (droplistview.tag == 3000 && IS_TZTIPAD)
    {
        [self onReadWriteSettingValue:FALSE];
    }
}

@end
