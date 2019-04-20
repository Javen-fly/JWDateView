//
//  JWDateAlertView.m
//  JWDateViewDemo
//
//  Created by 吴建文 on 2019/4/20.
//  Copyright © 2019 Javen. All rights reserved.
//

#import "JWDateAlertView.h"

@interface JWDateAlertView()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) JWDatePickerView *dateView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic,   copy) void (^selectedDate)(JWSolarDate *, JWLunarDate *, NSDate *);

@end

@implementation JWDateAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBase];
        [self initUI];
    }
    return self;
}


+ (instancetype)alertView
{
    return [[self alloc]init];
}

+ (instancetype)alertViewWithSelectedAction:(void (^)(JWSolarDate *, JWLunarDate *, NSDate *))selectedDate
{
    JWDateAlertView *alertView = [[JWDateAlertView alloc]init];
    alertView.selectedDate = [selectedDate copy];
    return alertView;
}

#pragma mark ------- base -------

- (void)initBase
{
    _type = JWDateViewTypeDefault;
}

#pragma mark ------- UI -------

- (void)initUI
{
    _maskView = [[UIView alloc]init];
    _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _maskView.alpha = 0.f;
    
    self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.f];
    [_maskView addSubview:self];
    
    _cancelBtn  = [self buttonWithTitle:@"取消" action:@selector(cancelShow)];
    _confirmBtn = [self buttonWithTitle:@"确定" action:@selector(confirmSelect)];
    _dateView   = [[JWDatePickerView alloc]init];
    _dateView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_cancelBtn];
    [self addSubview:_confirmBtn];
//    [self addSubview:_lineView];
    [self addSubview:_dateView];
}

#pragma mark ------- action -------

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:_maskView];
    
    _maskView.frame = keyWindow.bounds;
    CGFloat width   = keyWindow.bounds.size.width;
    CGFloat height  = keyWindow.bounds.size.height;
    CGFloat dateViewHeight      = 300.f;
    CGFloat headerViewHeight    = 50.f;
    CGFloat contentHeight       = dateViewHeight + headerViewHeight;
    self.frame = CGRectMake(0, height, width, contentHeight);
    
    CGFloat btnWidth    = 50.f;
    CGFloat btnToMargin = 5.f;
    CGFloat btnHeight   = headerViewHeight - btnToMargin * 2;
    
    _cancelBtn.frame    = CGRectMake(btnToMargin, btnToMargin, btnWidth, btnHeight);
    _confirmBtn.frame   = CGRectMake(width - btnWidth - btnToMargin, btnToMargin, btnWidth, btnHeight);
    _dateView.frame     = CGRectMake(0, headerViewHeight, width, dateViewHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame      = CGRectMake(0, height - contentHeight, width, contentHeight);
        self.maskView.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame      = CGRectMake(0, self.maskView.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        self.maskView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}

- (void)cancelShow
{
    [self dismiss];
}

- (void)confirmSelect
{
    if (_delegate && [_delegate respondsToSelector:@selector(dateAlertViewDidSelectedSolar:lunarDate:date:)]) {
        [_delegate dateAlertViewDidSelectedSolar:_dateView.solarDate lunarDate:_dateView.lunarDate date:_dateView.date];
    }
    else if (_selectedDate)
    {
        _selectedDate(_dateView.solarDate, _dateView.lunarDate, _dateView.date);
    }
    [self dismiss];
}

- (void)setType:(JWDateViewType)type
{
    _dateView.type = type;
}

- (void)setLunarDate:(JWLunarDate *)lunarDate
{
    _dateView.lunarDate = lunarDate;
}

- (void)setSolarDate:(JWSolarDate *)solarDate
{
    _dateView.solarDate = solarDate;
}

- (void)setDate:(NSDate *)date
{
    _dateView.date = date;
}

- (JWLunarDate *)lunarDate
{
    return _dateView.lunarDate;
}

- (JWSolarDate *)solarDate
{
    return _dateView.solarDate;
}

- (NSDate *)date
{
    return _dateView.date;
}
#pragma mark ------- lazy -------

- (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action
{
    UIButton *button        = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font  = [UIFont systemFontOfSize:15.f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
