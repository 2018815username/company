/*********
投资堂定义控件类型：

1、TZTLabel
;contentMode: center:UIViewContentModeCenter 其他:lable默认 默认:center
;tag|区域|contentMode|numberOfLines|text|textAlignment|font|enabled|adjustsFontSizeToFitWidth|
tag=0|rect=|contentMode=|numberOfLines=|text=手机号码激活|textAlignment=left|font=18|enabled=|adjustsFontSizeToFitWidth=|

2、TZTTextView
;tag|区域|键盘类型|最小行数,最大行数|text|textAlignment|font|enabled|检测数据|是否加密|MaxLen|输入满触发事件|
1000|||手机号码激活||Left|18|0|||||

4、TZTTextField--系统输入框 OK
;是否加密:  Password: 加密 ;其他: 不加密。 默认不加密
;键盘类型:  Number: UIKeyboardTypeNumbersAndPunctuation;  其他:UIKeyboardTypeDefault 。 默认:其他
;检测数据:1:检测;0:不检测. 默认:1
;输入满触发事件:0:不触发；1:触发; 默认:0
;tag|区域|键盘类型|placeholder|text|textAlignment|font|enabled|检测数据|是否加密|MaxLen|输入满触发事件|
3000||Number|输入手机号码|||11||1||11|0|

5、TZTButton OK
;按钮类型:imagebutton:带图片按钮; UIButtonType:Custom，RoundedRect，DetailDisclosure，InfoLight，InfoDark，ContactAdd 系统按钮类型; 默认:RoundedRect
;进行检测: 1:调用检测数据事件 0:不调用检测数据事件 默认:0
;imageAlignment: left:图片在左侧 right:图片在右侧 默认:left
;tag|区域|按钮类型|valueimage|title|textAlignment|font|enabled|进行检测|textcolor|backimage|image|imageAlignment|
4000||RoundedRect||立即激活||18||1|TZTButtonBack.png||left|

6、TZTCheckBox OK
;控件类型:Left:选中框在左侧 right:选中框在右侧 默认:Left
;tag|区域|控件类型|未选中信息|value|textAlignment|font|enabled|检测数据|选中信息|提示信息|
5000|||签署风险提示协议后才可继续操作|0||18|||我同意，我已经阅读风险提示|提示信息|

7、TZTComBox OK
;控件类型:ListDate:下拉选择日期; ListSecure:加密显示;listEdit:可编辑下拉框; 可&
;是否显示下拉按钮 0:不显示;1:显示。 默认:1
;是否可删除下拉数据 0:不可删除;1:可删除。 默认:0
;初始数据:以","分隔数据
;tag|区域|控件类型|placeholder|text|textAlignment|font|enabled|检测数据|title|是否显示下拉按钮|是否可删除下拉数据|初始数据|
6000|||选择账号类型||left|10.0|||账号|1|0||

8、TZTSwitch OK
;控件类型:switch:点击变更数据 UISwitch控件  checked: check控件,点击选中 默认:switch
;tag|区域|控件类型|title|value|textAlignment|font|enabled|检测数据|YesImage|NoImage|YesText|NoText|
7000||||0||18|||||同意|不同意|

*****************/
#import "tztUILabel.h"
#import "tztUITextView.h"
#import "tztUITextField.h"
#import "tztUIButton.h"
#import "tztUICheckButton.h"
#import "tztUISwitch.h"
#import "tztUIDroplistView.h"
#import "tztUIProgressView.h"
#import "tztUIBaseViewDelegate.h"
