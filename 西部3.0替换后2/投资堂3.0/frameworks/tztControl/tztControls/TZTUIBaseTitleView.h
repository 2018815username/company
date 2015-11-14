//
//  tztUIBaseTitleViewNew.h
//  tztMobileApp_HTSC
//
//  Created by yangares on 13-12-15.
//
//

#import "TZTUIBaseTitleViewOld.h"

@interface TZTUIBaseTitleView : TZTUIBaseTitleViewOld
{
    UIButton* _firstTitleBtn;
    UIButton* _secondTitleBtn;
    UIButton* _preTitleBtn;
    UIButton* _nextTitleBtn;
    UILabel* _titleLab;
    UILabel* _topLab;
    UILabel* _bottomLab;
    UIImageView* _titleImage;
}
@property (nonatomic,retain) UIButton* firstTitleBtn;
@property (nonatomic,retain) UIButton* secondTitleBtn;
@property (nonatomic,retain) UIButton* preTitleBtn;
@property (nonatomic,retain) UIButton* nextTitleBtn;
@property (nonatomic,retain) UILabel* titleLab;
@property (nonatomic,retain) UILabel* topLab;
@property (nonatomic,retain) UILabel* bottomLab;
@property (nonatomic,retain) UIImageView* titleImage;

//设置Image标题
-(void)setTitleWithImage:(UIImage*)image;
@end
