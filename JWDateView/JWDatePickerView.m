//
//  JWDatePickerView.m
//  JWDateViewDemo
//
//  Created by 吴建文 on 2019/4/20.
//  Copyright © 2019 Javen. All rights reserved.
//

#import "JWDatePickerView.h"
#import <JWPickerView/JWPickerView.h>
#import <JWLunarCalendarDB/JWLunarCalendarDB.h>
#import <JWLunarCalendarDB/JWDateUtil.h>
@interface JWDatePickerView()<JWPickerViewDelegate, JWPickerViewDataSource>

@property (nonatomic, strong) JWPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation JWDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBase];
        [self initUI];
    }
    return self;
}

#pragma mark ------- base -------

- (void)initBase
{
    _type           = JWDateViewTypeDefault;
    _dataSourceArr  = [NSMutableArray array];
    self.date       = [NSDate date];
}

#pragma mark ------- UI -------

- (void)initUI
{
    _pickerView = [[JWPickerView alloc]initWithFrame:self.bounds];
    _pickerView.delegate    = self;
    _pickerView.dateSource  = self;
    _pickerView.textFont            = [UIFont systemFontOfSize:13.f];
    _pickerView.selectedTextFont    = [UIFont systemFontOfSize:20.f];
    
    [self addSubview:_pickerView];
}

#pragma mark ------- set -------

- (void)analysisDateFormatter
{
    [_dataSourceArr removeAllObjects];
    
    switch (_type) {
        case JWDateViewTypeDefault:
        {
            NSArray *yArr = [JWDateUtil gregorianCalendarYearArr];
            NSArray *mArr = [JWDateUtil gregorianCalendarMonthArr];
            NSArray *dArr = [JWDateUtil gregorianCalendarDayArrWithYear:_solarDate.year month:_solarDate.month];
            [_dataSourceArr addObject:yArr];
            [_dataSourceArr addObject:mArr];
            [_dataSourceArr addObject:dArr];
        }
            break;
        case JWDateViewTypeTime:
        {
            NSArray *hArr = [JWDateUtil hourArrInDay];
            NSArray *mArr = [JWDateUtil minuteArrInHour];
            NSArray *sArr = [JWDateUtil secondArrInMinute];
            [_dataSourceArr addObject:hArr];
            [_dataSourceArr addObject:mArr];
            [_dataSourceArr addObject:sArr];
        }
            break;
        case JWDateViewTypeLunar:
        {
            NSArray *yArr = [JWDateUtil lunarCalendarYearArr];
            NSArray *mArr = [JWDateUtil lunarCalendarMonthArrWithYear:_lunarDate.year];
            NSArray *dArr = [JWDateUtil lunarCalendarDayArrWithYear:_lunarDate.year month:_lunarDate.month];
            [_dataSourceArr addObject:yArr];
            [_dataSourceArr addObject:mArr];
            [_dataSourceArr addObject:dArr];
        }
            break;
            
        default:
            break;
    }
}

- (void)setSolarDate:(JWSolarDate *)solarDate
{
    _solarDate = solarDate;
    _lunarDate = [JWLunarCalendarDB solarToLunar:solarDate];
    _date      = [JWLunarCalendarDB solarToDate:solarDate];
    [self analysisDateFormatter];
}

- (void)setLunarDate:(JWLunarDate *)lunarDate
{
    _lunarDate = lunarDate;
    _solarDate = [JWLunarCalendarDB lunarToSolar:lunarDate];
    _date      = [JWLunarCalendarDB solarToDate:_solarDate];
    [self analysisDateFormatter];
}

- (void)setDate:(NSDate *)date
{
    _date       = date;
    _solarDate  = [JWSolarDate dateWithDate:date];
    _lunarDate  = [JWLunarCalendarDB solarToLunar:_solarDate];
    [self analysisDateFormatter];
}

- (void)setType:(JWDateViewType)type
{
    _type = type;
    [self analysisDateFormatter];
}
#pragma mark ------- JWPickerViewDataSource -------

- (NSInteger)jw_numberOfItemInPickerView:(JWPickerView *)pickerView
{
    [self analysisDateFormatter];
    return _dataSourceArr.count;
}

- (NSInteger)jw_pickerView:(JWPickerView *)pickerView numberOfRowInItem:(NSInteger)item
{
    NSArray *array = _dataSourceArr[item];
    return array.count;
}

- (NSString *)jw_pickerView:(JWPickerView *)pickerView textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = _dataSourceArr[indexPath.section];
    return array[indexPath.row];
}

#pragma mark ------- JWPickerViewDelegate -------

- (CGFloat)jw_pickerView:(JWPickerView *)pickerView widthForRowInItem:(NSInteger)item
{
    switch (_type) {
        case JWDateViewTypeLunar:   return item ? 80.f : 180.f;
            
        default:                    return 100.f;
    }
}

- (void)jw_pickerView:(JWPickerView *)pickerView didSelectedRow:(NSInteger)row inItem:(NSInteger)item
{
    if (!pickerView.selectedDic.count) {
        return;
    }
    switch (_type) {
        case JWDateViewTypeDefault:
        {
            [self datePickerViewInDefaultDidSelectedRow:row inItem:item];
        }
            break;
        case JWDateViewTypeTime:
        {
            [self datePickerViewInTimeDidSelectedRow:row inItem:item];
        }
            break;
        case JWDateViewTypeLunar:
        {
            [self datePickerViewInLunarDidSelectedRow:row inItem:item];
        }
            break;
        default:
            break;
    }
}

#pragma mark ------- dateViewDataSource -------

- (void)datePickerViewInDefaultDidSelectedRow:(NSInteger)row inItem:(NSInteger)item
{
    switch (item) {
        case 0:case 1:
        {
            NSInteger ySelected     = [_pickerView.selectedDic[@0] integerValue];
            NSInteger mSelected     = [_pickerView.selectedDic[@1] integerValue];
            NSArray *yArr           = [_dataSourceArr firstObject];
            _solarDate.year         = [yArr[ySelected] integerValue];
            _solarDate.month        = mSelected + 1;
            NSArray *dArr           = [JWDateUtil gregorianCalendarDayArrWithYear:_solarDate.year month:_solarDate.month];
            [_dataSourceArr replaceObjectAtIndex:2 withObject:dArr];
            [_pickerView reloadDataWithItem:2];
            
        }
            break;
        case 2:
        {
            NSInteger dSelected = [_pickerView.selectedDic[@2] integerValue];
            NSArray *dArr       = _dataSourceArr[2];
            _solarDate.day      = [dArr[dSelected] integerValue];
            _lunarDate = [JWLunarCalendarDB solarToLunar:_solarDate];
            _date = [JWLunarCalendarDB solarToDate:_solarDate];
        }
            break;
            
        default:
            break;
    }
}

- (void)datePickerViewInTimeDidSelectedRow:(NSInteger)row inItem:(NSInteger)item
{
    switch (item) {
        case 0:
            _solarDate.hour    = row;
            break;
        case 1:
            _solarDate.minute  = row;
            break;
        case 2:
            _solarDate.second  = row;
            break;
        default:
            break;
    }
}

- (void)datePickerViewInLunarDidSelectedRow:(NSInteger)row inItem:(NSInteger)item
{
    switch (item) {
        case 0:
        {
            NSInteger ySelected = [_pickerView.selectedDic[@(0)] integerValue];
            NSArray *yArr       = [JWDateUtil gregorianCalendarYearArr];
            NSArray *lyArr      = _dataSourceArr[0];
            NSArray *mArr       = [JWDateUtil lunarCalendarMonthArrWithYear:[yArr[ySelected]integerValue]];
            _lunarDate.year     = [yArr[ySelected] integerValue];
            _lunarDate.yearStr  = lyArr[ySelected];
            [_dataSourceArr replaceObjectAtIndex:1 withObject:mArr];
            [_pickerView reloadDataWithItem:1];
        }
            break;
        case 1:
        {
            NSInteger ySelected = [_pickerView.selectedDic[@(0)] integerValue];
            NSInteger mSelected = [_pickerView.selectedDic[@(1)] integerValue];
            NSArray *yArr       = [JWDateUtil gregorianCalendarYearArr];
            NSArray *mArr       = _dataSourceArr[1];
            NSArray *dArr       = [JWDateUtil lunarCalendarDayArrWithYear:[yArr[ySelected] integerValue] month:mSelected];
            _lunarDate.monthStr    = mArr[mSelected];
            _lunarDate.month       = mSelected+1;
            NSInteger indexOfLeap  = [JWLunarCalendarDB indexOfLeapMonthInYear:_lunarDate.year];
            if (indexOfLeap) {
                if (indexOfLeap == _lunarDate.month -1) {
                    _lunarDate.isLeap = YES;
                }
                if (indexOfLeap < _lunarDate.month) {
                    _lunarDate.month--;
                }
            }
            [_dataSourceArr replaceObjectAtIndex:2 withObject:dArr];
            [_pickerView reloadDataWithItem:2];
        }
        case 2:
        {
            NSInteger dSlected  = [_pickerView.selectedDic[@(2)] integerValue];
            NSArray *dArr       = _dataSourceArr[2];
            if (dSlected >= dArr.count) {
                dSlected = dArr.count - 1;
            }
            _lunarDate.day     = dSlected+1;
            _lunarDate.dayStr  = dArr[dSlected];
            _solarDate  = [JWLunarCalendarDB lunarToSolar:_lunarDate];
            _date       = [JWLunarCalendarDB solarToDate:_solarDate];
        }
            
        default:
            break;
    }
}



#pragma mark ------- lazy -------


- (void)layoutSubviews
{
    [super layoutSubviews];
    _pickerView.frame = self.bounds;
    [_pickerView reloadData];
    switch (_type) {
        case JWDateViewTypeDefault:
        {
            [_pickerView selectIndexPaths:@[[NSIndexPath indexPathForRow:_solarDate.year - 1900 - 1 inSection:0],
                                            [NSIndexPath indexPathForRow:_solarDate.month - 1 inSection:1],
                                            [NSIndexPath indexPathForRow:_solarDate.day - 1 inSection:2]]];
            
            
        }
            break;
        case JWDateViewTypeTime:
        {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:_date];
            
            NSInteger hour      = [components hour];
            NSInteger minute    = [components minute];
            NSInteger second    = [components second];
            
            [_pickerView selectIndexPaths:@[[NSIndexPath indexPathForRow:hour inSection:0],
                                            [NSIndexPath indexPathForRow:minute inSection:1],
                                            [NSIndexPath indexPathForRow:second inSection:2]]];
        }
            break;
        case JWDateViewTypeLunar:
        {
            NSInteger indexOfLeap = [JWLunarCalendarDB indexOfLeapMonthInYear:_lunarDate.year];
            NSInteger month = _lunarDate.month + _lunarDate.isLeap - 1 + (indexOfLeap < _lunarDate.month && indexOfLeap);
            [_pickerView selectIndexPaths:@[[NSIndexPath indexPathForRow:_lunarDate.year - kMinYear  inSection:0],
                                            [NSIndexPath indexPathForRow:month inSection:1],
                                            [NSIndexPath indexPathForRow:_lunarDate.day - 1 inSection:2]]];
        }
            break;
            
        default:
            break;
    }
}

@end
