//
//  WDAddCalendarEventController.m
//  WDCalendarEvent
//
//  Created by WindyZhang on 2018/2/2.
//  Copyright © 2018年 feeyo. All rights reserved.
//

#import "WDAddCalendarEventController.h"

typedef NS_ENUM(NSInteger,WDPickerStatus) {
    WDPickerStatusNone,
    WDPickerStatusStartDate,
    WDPickerStatusEndDate
};

@interface WDAddCalendarEventController ()<UITableViewDelegate,UITableViewDataSource,WDCalendarEventDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, assign) WDPickerStatus pickerStatus;
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UILabel *endLabel;

@end

@implementation WDAddCalendarEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加事件";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [_datePicker addTarget:self action:@selector(didSelectDate:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}
- (UITextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 40)];
        _titleTextField.placeholder = @"标题";
    }
    return _titleTextField;
}
- (UILabel *)startLabel {
    if (!_startLabel) {
        _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 215, 0, 200, 50)];
        _startLabel.text = @"2018-02-05 15:31";
        _startLabel.textAlignment = NSTextAlignmentRight;
        _startLabel.textColor = [UIColor grayColor];
    }
    return _startLabel;
}
- (UILabel *)endLabel {
    if (!_endLabel) {
        _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 215, 0, 200, 50)];
        _endLabel.text = @"2018-02-05 17:20";
        _endLabel.textAlignment = NSTextAlignmentRight;
        _endLabel.textColor = [UIColor grayColor];
    }
    return _endLabel;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 200;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellID"];
    }
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.titleTextField];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"开始时间";
            [cell.contentView addSubview:self.startLabel];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"结束时间";
            [cell.contentView addSubview:self.endLabel];
        } else {
            [cell.contentView addSubview:self.datePicker];
        }
    } else {
        cell.textLabel.text = @"写入事件";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
       
    }
    if (indexPath.section == 2) {
        [self writeCalendarEvent];
    }
}
- (void)didSelectDate:(UIDatePicker *)picker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (self.pickerStatus == WDPickerStatusStartDate) {
        self.startLabel.text = [formatter stringFromDate:self.datePicker.date];
    }
    if (self.pickerStatus == WDPickerStatusEndDate) {
        self.endLabel.text = [formatter stringFromDate:self.datePicker.date];
    }
}
- (void)writeCalendarEvent {
    if ([self.titleTextField.text isEqualToString:@""]) {
        [WDAlertView alertViewInViewController:self message:@"请输入标题"];
        return;
    }
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:self.startLabel.text,@"startDate",self.endLabel.text,@"endDate",self.titleTextField.text,@"title", nil];
    [WDCalendarEventManager shareCalendarEvent].eventDelegate = self;
    [[WDCalendarEventManager shareCalendarEvent] writeCalendarEventWithDataDic:paramDic];
}
- (void)getEventIdenfiter:(NSString *)idenfiter {
    [WDAlertView alertViewInViewController:self message:@"写入日历事件成功"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
