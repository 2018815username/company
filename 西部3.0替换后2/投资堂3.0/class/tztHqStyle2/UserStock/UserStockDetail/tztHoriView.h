
@protocol tztTimeTechTitleViewDelegate <NSObject>

@optional
-(void)tztTimeTechTitleView:(id)view OnCloser:(id)sender;

@end

@interface TZTTimeTechTitleView : tztHqBaseView <tztHqBaseViewDelegate, tztTimeTechTitleViewDelegate>
{
}

@property (nonatomic, retain)TZTSegSectionView *segmentView;

- (void)updateContent;
- (UIButton*)GetCurrentSelBtn;
@end

@protocol tztHoriViewDelegate <NSObject>

@required
 /**
 *	@brief	关闭事件
 *
 *	@return	NULL
 */
-(void)tztHoriViewClosedAtIndex:(NSInteger)nIndex;


@end

 /**
 *	@brief	横屏显示界面
 */
@interface tztHoriView : tztHqBaseView<tztHqBaseViewDelegate>


@property(nonatomic,assign)NSInteger nCurrentIndex;
@end
