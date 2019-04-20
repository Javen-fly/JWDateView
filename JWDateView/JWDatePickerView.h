//
//  JWDatePickerView.h
//  JWDateViewDemo
//
//  Created by 吴建文 on 2019/4/20.
//  Copyright © 2019 Javen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JWLunarCalendarDB/JWLunarDate.h>
#import <JWLunarCalendarDB/JWSolarDate.h>
typedef NS_ENUM(NSInteger, JWDateViewType) {
    JWDateViewTypeDefault = 0,    //默认格式 公历年月日 2018-02-24
    JWDateViewTypeTime,           //选时分秒 13:39:20
    JWDateViewTypeLunar          //农历日期 戊戌年正月初九
    //    JWDatePickerViewTypeCustom          //自定义格式
};

NS_ASSUME_NONNULL_BEGIN

@interface JWDatePickerView : UIView

/** 显示内容样式 */
@property (nonatomic, assign) JWDateViewType type;
/** 农历 */
@property (nonatomic, strong) JWLunarDate *lunarDate;
/** 公历 */
@property (nonatomic, strong) JWSolarDate *solarDate;
/** 时间 */
@property (nonatomic, strong) NSDate *date;
@end

NS_ASSUME_NONNULL_END
