//
//  F10View.m
//  tztMobileApp_GJUserStock
//
//  Created by wry on 15-4-2.
//  Copyright (c) 2015年 ZZTZT. All rights reserved.
//

#import "F10View.h"

@implementation F10View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rc = self.frame;
        rc.size.height -=20;
        
        self.webView = [[tztWebView alloc] initWithFrame:rc];
        
        [self addSubview:self.webView];
        self.webView.hidden = YES;
        
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        self.lable.text =@"暂无资讯内容";
        self.lable.textColor = [UIColor colorWithRed:143.0/255.0 green:143.0/255.0 blue:143.0/255.0 alpha:1.0];
        self.lable.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lable];
        self.lable.hidden = YES;
    }
    return self;
}
-(void)stockInfo:(int)pStockInfo andUrl:(NSString* )url{
    
    if (MakeIndexMarket(pStockInfo)) {
        self.lable.hidden = NO;
    }else{
        
        self.lable.hidden = YES;
        self.webView.hidden = NO;
        [self.webView setWebURL:url];
    }
 
}
@end

