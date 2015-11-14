/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:        系统设置view
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       D.B.Q
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztSystemSettingView.h"

@implementation tztSystemSettingView

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
    [self onSetTableConfig:@"tztUISystemSetting"];
}

- (void)onReadWriteSettingValue:(BOOL)bRead
{
    int nTime = [tztTechSetting getInstance].nRequestTimer;
    if(bRead)
    {
        BOOL bCQ = ([tztTechSetting getInstance].nKLineChuQuan > 0 ? TRUE : FALSE);
        NSUInteger nTechCustomDay = [tztTechSetting getInstance].nTechCustomDay;
        NSUInteger nTechCustomMin = [tztTechSetting getInstance].nTechCustomMin;
        int nTechMAnum = [[tztTechSetting getInstance] getTechParamSettingMAnum];
        int nDateMargin = [tztTechSetting getInstance].nDateMargin;
        NSMutableDictionary * dict = GetDictByListName(@"KMKM");
        BOOL bKMKMNormal = [[dict objectForKey:@"KMKMNormal"] boolValue];
        
        [_tztTableView setCheckBoxValue:bCQ withTag_:7000];
        [_tztTableView setEditorText:[NSString stringWithFormat:@"%ld", (long)nTechCustomDay] nsPlaceholder_:NULL withTag_:2000];
        [_tztTableView setEditorText:[NSString stringWithFormat:@"%ld", (long)nTechCustomMin] nsPlaceholder_:NULL withTag_:2001];
        [_tztTableView setEditorText:[NSString stringWithFormat:@"%d", nTechMAnum] nsPlaceholder_:NULL withTag_:2002];
        
        [_tztTableView setEditorText:[NSString stringWithFormat:@"%d", nDateMargin] nsPlaceholder_:NULL withTag_:2005];
        
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
        NSMutableArray* array = [[NSMutableArray alloc] initWithObjects:
                                    @"普通",
                                    @"信用",
                                    nil];
        [_tztTableView setComBoxData:array ayContent_:array AndIndex_:bKMKMNormal withTag_:3001];
        [array release];
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
            [[tztTechSetting getInstance] setValue:strNowTime forKeyPath:@"_nRequestTimer"];
        }
        
        BOOL bCQ = [_tztTableView getCheckBoxValue:7000];
        NSString* nTechDay = [_tztTableView GetEidtorText:2000];
        NSString* nTechMin = [_tztTableView GetEidtorText:2001];
        NSString* nTechMAnum = [_tztTableView GetEidtorText:2002];
        NSString* nDateMargin = [_tztTableView GetEidtorText:2005];
        [tztTechSetting getInstance].nKLineChuQuan = (bCQ ? 1 : 0);
        NSLog(@"%lu",(unsigned long)[tztTechSetting getInstance].nKLineChuQuan);
        [tztTechSetting getInstance].nTechCustomDay = [nTechDay intValue];
        [tztTechSetting getInstance].nTechCustomMin = [nTechMin intValue];
        [tztTechSetting getInstance].nDateMargin = [nDateMargin intValue];
        [[tztTechSetting getInstance] setTechParamSettingMAnum:[nTechMAnum intValue]];
        [[tztTechSetting getInstance] SaveData];
        
        NSMutableDictionary *pDict = NewObject(NSMutableDictionary);
        NSInteger nIndex = [_tztTableView getComBoxSelctedIndex:3001];
        if (nIndex < 0)
            nIndex = 0;
        [pDict setTztObject:[NSString stringWithFormat:@"%ld",(long)nIndex] forKey:@"KMKMNormal"];
        SetDictByListName(pDict, @"KMKM");
        [pDict release];
    }
}

-(void)dealloc
{
    [super dealloc];
}

-(void)OnButtonClick:(id)sender
{
    [self onReadWriteSettingValue:FALSE];
    tztAfxMessageBox(@"保存成功!");
}

@end
