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

#import "tztKLineSetView.h"

@implementation tztKLineSetView
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
    [self onSetTableConfig:@"tztUIHQKLineSetting"];
}

- (void)onReadWriteSettingValue:(BOOL)bRead
{
    int nTime = [tztTechSetting getInstance].nRequestTimer;
    if(bRead)
    {
        BOOL bCQ = ([tztTechSetting getInstance].nKLineChuQuan > 0 ? TRUE : FALSE);
        NSUInteger nTechCustomDay = [tztTechSetting getInstance].nTechCustomDay;
        NSUInteger nTechCustomMin = [tztTechSetting getInstance].nTechCustomMin;
        NSUInteger nTechMAnum = [[tztTechSetting getInstance] getTechParamSettingMAnum];
        NSUInteger nDateMargin = [tztTechSetting getInstance].nDateMargin;
        
        [_tztTableView setCheckBoxValue:bCQ withTag_:7000];
        [_tztTableView setEditorText:[NSString stringWithFormat:@"%ld", (long)nTechCustomDay] nsPlaceholder_:NULL withTag_:2000];
        [_tztTableView setEditorText:[NSString stringWithFormat:@"%ld", (long)nTechCustomMin] nsPlaceholder_:NULL withTag_:2001];
        [_tztTableView setEditorText:[NSString stringWithFormat:@"%ld", (long)nTechMAnum] nsPlaceholder_:NULL withTag_:2002];
        [_tztTableView setEditorText:[NSString stringWithFormat:@"%ld", (long)nDateMargin] nsPlaceholder_:NULL withTag_:2005];
        
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
        //zxl 20131017 修改了ipad行情K线设置的用按钮
        if (!IS_TZTIPAD)
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
                [[tztTechSetting getInstance] setValue:strNowTime forKeyPath:@"_nRequestTimer"];
            }
            
            BOOL bCQ = [_tztTableView getCheckBoxValue:7000];
            NSString* nTechDay = [_tztTableView GetEidtorText:2000];
            NSString* nTechMin = [_tztTableView GetEidtorText:2001];
            NSString* nTechMAnum = [_tztTableView GetEidtorText:2002];
            NSString* nDateMargin = [_tztTableView GetEidtorText:2005];
            
            [tztTechSetting getInstance].nKLineChuQuan = (bCQ ? 1 : 0);
            [tztTechSetting getInstance].nTechCustomDay = [nTechDay intValue];
            [tztTechSetting getInstance].nTechCustomMin = [nTechMin intValue];
            [[tztTechSetting getInstance] setTechParamSettingMAnum:[nTechMAnum intValue]];
            [tztTechSetting getInstance].nDateMargin = [nDateMargin intValue];
            [[tztTechSetting getInstance] SaveData];
        }
    }
}
//zxl 20131017 修改了ipad行情K线设置的用按钮
-(void)OnButtonClick:(id)sender
{
    tztUIButton *button = (tztUIButton *)sender;
    if ([button.tzttagcode intValue] == 5000)
    {
        int nTime = [tztTechSetting getInstance].nRequestTimer;
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
            [[tztTechSetting getInstance] setValue:strNowTime forKeyPath:@"_nRequestTimer"];
        }
        
        BOOL bCQ = [_tztTableView getCheckBoxValue:7000];
        NSString* nTechDay = [_tztTableView GetEidtorText:2000];
        NSString* nTechMin = [_tztTableView GetEidtorText:2001];
        NSString* nTechMAnum = [_tztTableView GetEidtorText:2002];
        NSString* nDateMargin = [_tztTableView GetEidtorText:2005];
        [tztTechSetting getInstance].nKLineChuQuan = (bCQ ? 1 : 0);
        [tztTechSetting getInstance].nTechCustomDay = [nTechDay intValue];
        [tztTechSetting getInstance].nTechCustomMin = [nTechMin intValue];
        [tztTechSetting getInstance].nDateMargin = [nDateMargin intValue];
        [[tztTechSetting getInstance] setTechParamSettingMAnum:[nTechMAnum intValue]];
        [[tztTechSetting getInstance] SaveData];
        //zxl 20131022 添加设置成功提示信息
        [self showMessageBox:@"行情设置成功！" nType_:TZTBoxTypeNoButton nTag_:0];
    }
}

-(void)dealloc
{
    [super dealloc];
}

@end
