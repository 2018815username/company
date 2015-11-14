/*************************************************************
 * Copyright (c)2009, 杭州中焯信息技术股份有限公司
 * All rights reserved.
 *
 * 文件名称:     tztPageControl
 * 文件标识:
 * 摘要说明:     自定义PageControl
 *
 * 当前版本:     1.0
 * 作   者:     yinjp
 * 更新日期:     20140116
 * 整理修改:
 *
 ***************************************************************/


#import "tztPageControl.h"


@implementation tztPageControl
{
    NSMutableDictionary *_images;
    NSMutableArray      *_pageViews;
    CGSize             _szImage;
}

@synthesize page = _page;
@synthesize pattern = _pattern;
@synthesize delegate = _delegate;

-(void)removeAllObjects
{
    if (_images)
        [_images removeAllObjects];
    [_pageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         UIView *view = obj;
         [view removeFromSuperview];
     }];
    if (_pageViews)
        [_pageViews removeAllObjects];
    _pattern = @"";
    _page = 0;
}

-(void)tztInit
{
    _page = 0;
    _pattern = @"";
    _images = [[NSMutableDictionary alloc] init];
    _pageViews = [[NSMutableArray alloc] init];
}

-(void)dealloc
{
    DelObject(_images);
    DelObject(_pageViews);
    [super dealloc];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self tztInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self tztInit];
    }
    return self;
}

-(void)setPage:(NSInteger)page
{
    _page = page;
    [self layoutSubviews];//重新布局显示
    
    if (_delegate && [_delegate respondsToSelector:@selector(tztPageControl:didUpdateTpPage:)])
    {
        [_delegate tztPageControl:self didUpdateTpPage:page];
    }
}

-(NSInteger)numberOfPages
{
    return _pattern.length;
}

-(void)tapped:(UITapGestureRecognizer*)recognizer
{
    self.page = [_pageViews indexOfObject:recognizer.view];
}

-(UIImageView *)imageViewForKey:(NSString*)key
{
    NSDictionary *imageData = [_images objectForKey:key];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[imageData objectForKey:@"normal"] highlightedImage:[imageData objectForKey:@"highlighted"]] autorelease];
    imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tgr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
//    [imageView addGestureRecognizer:tgr];
    return imageView;
}

-(void)layoutSubviews
{
    [_pageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    [_pageViews removeAllObjects];
    
    if (_pattern == NULL || _pattern.length < 1)
        return;
    NSInteger pages = self.numberOfPages;
    if (pages < 1)
        pages = 1;
    if (_szImage.width <= 15)
        _szImage.width = 15;
    CGFloat xOffset = (self.frame.size.width - (pages-1)*5 - pages * _szImage.width) / 2;
    CGFloat x = 5;
    CGFloat yOffset = (self.frame.size.height - _szImage.height) / 2;
    for (int i=0; i<pages; i++)
    {
        NSString *key = [_pattern substringWithRange:NSMakeRange(i, 1)];
        UIImageView *imageView = [self imageViewForKey:key];
        
        CGRect frame = imageView.frame;
        frame.origin.x = xOffset;
        frame.origin.y = yOffset;
        imageView.frame = frame;
        imageView.highlighted = (i == self.page);
        
        [self addSubview:imageView];
        [_pageViews addObject:imageView];
        
        xOffset += x + frame.size.width;
    }
}

-(void)setImage:(UIImage *)normalImage highlightedImage_:(UIImage *)highlightedImage forKey:(NSString *)key
{
    NSDictionary *imageData = [NSDictionary dictionaryWithObjectsAndKeys:normalImage, @"normal", highlightedImage, @"highlighted", nil];
    _szImage = normalImage.size;
    [_images setObject:imageData forKey:key];
    [self setNeedsLayout];
}
@end
