
 /**
 *	@brief	行情－更多－市场列表
 */
@interface tztMarketMoreView : TZTUIBaseView

@property(nonatomic)BOOL    bShowUseWeb;
@property(nonatomic,assign)id tztdelegate;

-(void)setURL:(NSString*)strURL;
@end
