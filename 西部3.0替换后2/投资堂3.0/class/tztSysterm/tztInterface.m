/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:
 * 文件标识:
 * 摘要说明:
 *
 * 当前版本:        2.0
 * 作    者:       zxl
 * 更新日期:
 * 整理修改:
 *
 ***************************************************************/

#import "tztInterface.h"
#import "tztUISearchStockViewController_iPad.h"
#import "TZTInitReportMarketMenu.h"
tztInterface * g_Interface = NULL;
@implementation tztInterface
@synthesize PopoverVC = _PopoverVC;

+(tztInterface*)getShareInterface
{
    if (g_Interface == NULL)
    {
        g_Interface = NewObject(tztInterface);
    }
    return g_Interface;
}

+(void)freeShareInterface
{
    DelObject(g_Interface);
}

-(void) PopViewController:(UIViewController*)pVC rect:(CGRect)rect
{
	if (pVC == NULL)
		return;
	
	if (_PopoverVC != NULL)
	{
		[_PopoverVC dismissPopoverAnimated:NO];
		[_PopoverVC release];
		_PopoverVC = NULL;
	}
	
	_PopoverVC = [[UIPopoverController alloc] initWithContentViewController:pVC];
	_PopoverVC.delegate = self;
	
	@try {
		[_PopoverVC presentPopoverFromRect:rect
                                    inView:g_CallNavigationController.topViewController.view
                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                  animated:YES];
	}
	@catch (NSException * e)
	{
		[_PopoverVC release];
		_PopoverVC = NULL;
	}
	
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	if (_PopoverVC && _PopoverVC == popoverController)
	{
		[_PopoverVC release];
		_PopoverVC = NULL;
	}
	
	return;
}


/*
用途：券商接口传进来的Params 通过组合成相同的Params 返回(如果中间不需要重组就直接再返回就OK了)
入参：需要重组的Params（数据）
出参：重组后的Params（数据）
 */
-(NSDictionary *)GetChangeParams:(NSDictionary *)Params
{

    return Params;
}

/*个股查询*/
-(void)OnSelectHQStock:(tztStockInfo *)pStock
{
    if (g_pTZTDelegate && g_CallNavigationController && pStock)
    {
        NSString * strStock= [NSString stringWithFormat:@"%@|%@|%d",pStock.stockCode,pStock.stockName,pStock.stockType];
        NSArray* pArrayNewApp = [NSArray arrayWithObjects:[TZTAppObj getShareInstance].window,g_CallNavigationController,strStock,[NSString stringWithFormat:@"%d",HQ_MENU_SearchStock],nil];
        
        NSDictionary * NewParams = [NSDictionary dictionaryWithObjectsAndKeys:pArrayNewApp,@"APP",nil];
        [[TZTAppObj getShareInstance] InitWithApp:NewParams withDelegate:g_pTZTDelegate];
    }
    
}
-(void)ShowStockQueryVC:(UIViewController*)pPopVC  Rect:(CGRect)rect
{
    if (pPopVC)
    {
        tztUISearchStockViewController_iPad *pVC = [[tztUISearchStockViewController_iPad alloc] init];
        [pVC setVcShowKind:tztvckind_Pop];
        pVC.nKeyBordType = TZTUserKeyBord_Number;
        [self PopViewController:pVC rect:rect];
        [pVC release];
    }
}

/*- 模糊查询*/
-(void)tztGetFuzzyStock:(NSString *)strCode
{
    if (g_pReportMarket == NULL)
        g_pReportMarket = NewObject(TZTInitReportMarketMenu);
    [g_pReportMarket tztperformSelector:@"RequestStockFuzzy:" withObject:strCode];
}

/*- 全球股份*/
-(void)tztGetWPIndex
{
    if (g_pReportMarket == NULL)
        g_pReportMarket = NewObject(TZTInitReportMarketMenu);
    [g_pReportMarket tztperformSelector:@"RequestWPIndex"];
}
/*- 查询股票信息*/
-(void)tztSearchStockInfo_iPad:(tztStockInfo*)pStock
{
    if (g_pReportMarket == NULL)
        g_pReportMarket = NewObject(TZTInitReportMarketMenu);
    
    [g_pReportMarket tztperformSelector:@"RequestStockInfo" withObject:pStock];
}
/*处理功能号 各个券商不同功能号的事件*/
-(void)OnDealNib:(int)nMsgType ArryApp:(NSArray *)arryApp
{
    if (arryApp == NULL || [arryApp count] < 1)
    {
        return;
    }
}
/*-返回数据处理（避免代码中出现特殊的功能号）*/
-(NSInteger)callbackDataDeal:(id)caller withParams:(NSDictionary *)params
{
    return 1;
}

@end
