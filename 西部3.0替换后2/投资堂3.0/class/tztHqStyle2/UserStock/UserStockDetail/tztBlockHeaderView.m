//
//  tztBlockHeaderView.m
//  tztMobileApp_ZSSC
//
//  Created by King on 15-3-17.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#define tztTagBlockTag 0x1432
#import "tztBlockHeaderView.h"


@interface tztBlockHeaderView()

@property(nonatomic,retain)UILabel  *labelNewPrice;
@property(nonatomic,retain)UILabel  *labelRatio;
@property(nonatomic,retain)UILabel  *labelRange;
@property(nonatomic,retain)UILabel  *labelCode;
@property(nonatomic,retain)NSMutableArray   *ayData;
@end

@implementation tztBlockHeaderView


-(void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame) || CGRectIsNull(frame))
        return;
    
    [super setFrame:frame];
    
    if (_ayData == NULL)
    {
        _ayData = NewObject(NSMutableArray);
        [_ayData addObject:@{tztName:@"上涨数:", tztValue:tztUpStocks}];
        [_ayData addObject:@{tztName:@"下跌数:", tztValue:tztDownStocks}];
        [_ayData addObject:@{tztName:@"平盘数:", tztValue:tztFlatStocks}];
    }
    
    CGRect rcFrame = self.bounds;
    CGFloat fXOffset = 15;
    CGFloat fYOffset = 10;
    
    CGFloat fXMargin = 5;
    CGFloat fYMargin = 5;
    
    CGFloat fHeight = (rcFrame.size.height - 2 * fYOffset - fYMargin) / 3;
    CGFloat fWidth = (rcFrame.size.width - 2 * fXOffset - 2 * fXMargin) / 3;
    
    if (_labelCode == nil)
    {
        _labelCode = [[UILabel alloc] init];
        _labelCode.backgroundColor = [UIColor clearColor];
        _labelCode.hidden = YES;
        [self addSubview:_labelCode];
        [_labelCode release];
    }
    
    CGRect rcNewPrice = rcFrame;
    rcNewPrice.origin.x += fXOffset;
    rcNewPrice.size.width = fWidth;
    rcNewPrice.origin.y += fYOffset;
    rcNewPrice.size.height = fHeight * 2;
    if (_labelNewPrice == nil)
    {
        _labelNewPrice = [[UILabel alloc] initWithFrame:rcNewPrice];
        _labelNewPrice.backgroundColor = [UIColor clearColor];
        _labelNewPrice.textAlignment = NSTextAlignmentLeft;
        _labelNewPrice.font = tztUIBaseViewTextBoldFont(20);
        _labelNewPrice.adjustsFontSizeToFitWidth = YES;
        _labelNewPrice.userInteractionEnabled = YES;
        [self addSubview:_labelNewPrice];
        [_labelNewPrice release];
    }
    else
        _labelNewPrice.frame = rcNewPrice;
    
    rcNewPrice.origin.x += rcNewPrice.size.width + fXMargin;
    if (_labelRange == nil)
    {
        _labelRange = [[UILabel alloc] initWithFrame:rcNewPrice];
        _labelRange.backgroundColor = [UIColor clearColor];
        _labelRange.textAlignment = NSTextAlignmentLeft;
        _labelRange.font = tztUIBaseViewTextFont(15);
        _labelRange.adjustsFontSizeToFitWidth = YES;
        _labelRange.userInteractionEnabled = YES;
        [self addSubview:_labelRange];
        [_labelRange release];
    }
    else
        _labelRange.frame = rcNewPrice;
    
    CGRect rcPrice = rcNewPrice;
    rcPrice.origin.x = fXOffset;
    rcPrice.origin.y += rcNewPrice.size.height + fYMargin;
    rcPrice.size.height = fHeight;
    NSString* str = @"上涨数:";
    CGFloat fTitleWidth = [str sizeWithFont:tztUIBaseViewTextFont(13)].width;
    
    for (int i = 0; i < self.ayData.count; i++)
    {
        CGRect rcTitle = rcPrice;
        rcTitle.size.width = fTitleWidth;
        NSDictionary* dict = [self.ayData objectAtIndex:i];
        NSString* strTitle = [dict tztObjectForKey:tztName];
        UILabel *lbTitle = (UILabel*)[self viewWithTag:tztTagBlockTag + i];
        if (lbTitle == NULL)
        {
            lbTitle = [[UILabel alloc] initWithFrame:rcTitle];
            lbTitle.tag = tztTagBlockTag + i;
            lbTitle.font = tztUIBaseViewTextFont(15);
            lbTitle.adjustsFontSizeToFitWidth = YES;
            lbTitle.userInteractionEnabled = YES;
            [self addSubview:lbTitle];
            lbTitle.textColor = [UIColor tztThemeHQFixTextColor];
            [lbTitle release];
        }
        lbTitle.text = strTitle;
        
        CGRect rcValue = rcPrice;
        rcValue.origin.x += fTitleWidth + 8;
        rcValue.size.height = rcTitle.size.height;
        rcValue.size.width = rcPrice.size.width - fTitleWidth;
        UILabel *lbValue = (UILabel*)[self viewWithTag:tztTagBlockTag * 2 + i];
        if (lbValue == NULL)
        {
            lbValue = [[UILabel alloc] initWithFrame:rcValue];
            lbValue.tag = tztTagBlockTag * 2 + i;
            lbValue.font = tztUIBaseViewTextFont(14);
            lbValue.userInteractionEnabled = YES;
            lbValue.adjustsFontSizeToFitWidth = YES;
            [self addSubview:lbValue];
            [lbValue release];
        }
        else
            lbValue.frame = rcValue;
        
        rcPrice.origin.x += rcPrice.size.width + fXMargin;
    }
    
}

- (void)updateContent
{
    NSArray *arr = self.ayData;
    NSDictionary *stockDic = [TZTPriceData stockDic];
    
    NSDictionary *dictNew = [stockDic tztObjectForKey:tztNewPrice];
    self.labelNewPrice.text = [dictNew tztObjectForKey:tztValue];
    self.labelNewPrice.textColor = [dictNew tztObjectForKey:tztColor];
    
    NSDictionary* dictRange = [stockDic tztObjectForKey:tztPriceRange];
    self.labelRange.text = [dictRange tztObjectForKey:tztValue];
    self.labelRange.textColor = [dictRange tztObjectForKey:tztColor];
    
    for (int i = 0; i < arr.count; i ++)
    {
        UILabel *lbTitle = (UILabel*)[self viewWithTag:tztTagBlockTag + i];
        UILabel *lbCont = (UILabel *)[self viewWithTag:tztTagBlockTag * 2 + i];
        
        NSDictionary* dict = [self.ayData objectAtIndex:i];
        NSString* strTitle = [dict tztObjectForKey:tztName];
        NSString* strKey = [dict tztObjectForKey:tztValue];
        
        NSMutableDictionary *pDict = [stockDic objectForKey:strKey];
        
        lbTitle.text = strTitle;
        lbCont.text =  [pDict objectForKey:tztValue];
        lbCont.textColor = [pDict objectForKey:tztColor];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_tztdelegate && [_tztdelegate respondsToSelector:@selector(tzthqView:setStockCode:)])
    {
        tztStockInfo *pStockInfo = NewObject(tztStockInfo);
        pStockInfo.stockCode = [NSString stringWithFormat:@"%@", self.pStockInfo.stockCode];
        pStockInfo.stockName = [NSString stringWithFormat:@"%@", self.pStockInfo.stockName];
        pStockInfo.stockType = self.pStockInfo.stockType;
        [_tztdelegate tzthqView:nil setStockCode:pStockInfo];
        DelObject(pStockInfo);
    }
}

@end
