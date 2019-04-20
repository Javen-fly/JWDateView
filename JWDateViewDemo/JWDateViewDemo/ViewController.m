//
//  ViewController.m
//  JWDateViewDemo
//
//  Created by 吴建文 on 2019/4/20.
//  Copyright © 2019 Javen. All rights reserved.
//

#import "ViewController.h"
#import "JWDatePickerView.h"
#import "JWDateAlertView.h"

@interface ViewController ()
@property (nonatomic, strong) JWDatePickerView *pickerView;
@property (nonatomic, strong) JWDateAlertView *alertView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pickerView = [[JWDatePickerView alloc]init];
    _pickerView.frame = CGRectMake(0, 200, 375, 120.f);
    [self.view addSubview:_pickerView];
    _alertView = [[JWDateAlertView alloc]init];
    _alertView.type = JWDateViewTypeLunar;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"%@,%@,%@",_pickerView.lunarDate.yearStr,_pickerView.lunarDate.monthStr,_pickerView.lunarDate.dayStr);
    //    NSLog(@"%04zd,%02zd,%02zd",_pickerView.solarDate.year,_pickerView.solarDate.month,_pickerView.solarDate.day);
    //    NSLog(@"%@",_pickerView.date);
    [_alertView show];
}


@end
