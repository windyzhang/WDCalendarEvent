//
//  WDMainViewController.m
//  WDCalendarEvent
//
//  Created by WindyZhang on 2018/2/2.
//  Copyright © 2018年 feeyo. All rights reserved.
//

#import "WDMainViewController.h"
#import "WDAddCalendarEventController.h"
#import "WDCalendarEventDetailController.h"
#import "WDAlertView.h"

@interface WDMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *switchButton;

@end

@implementation WDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日历事件";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addCalendarEvent)];
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
- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 10, 60, 30)];
        [_switchButton addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    if ([[WDCalendarEventManager shareCalendarEvent] getCalendarPermission] && [[[WDCalendarEventManager shareCalendarEvent] getCalendarTag] integerValue] == 1) {
        _switchButton.on = YES;
    } else {
        _switchButton.on = NO;
    }
    return _switchButton;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        cell.textLabel.text = @"日历权限";
        [cell.contentView addSubview:self.switchButton];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"开始时间";
        } else {
            cell.textLabel.text = @"结束时间";
        }
    } else {
        cell.textLabel.text = @"获取事件";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [self getCalenderEvent];
    }
}
- (void)switchChanged:(UISwitch *)sender {
    
    if (sender.isOn) {
        [[WDCalendarEventManager shareCalendarEvent] showCalendarPermissionTip:^{
            [[WDCalendarEventManager shareCalendarEvent] setCalendarTag:@"1"];
        } failingBlock:^{
            sender.on = NO;
            [WDAlertView showAlertView:@"没有权限"
                               message:@"您的日历权限没有打开，请在“设置-隐私-日历”打开!"
                          cancelButton:@"取消"
                                   otherButtons:@[ @"确定" ]
                               inViewController:self
                                       selectAt:^(NSInteger iVal) {
                if (iVal == 1) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
        }];
    } else {
        [[WDCalendarEventManager shareCalendarEvent] setCalendarTag:@"0"];
    }
}


- (void)addCalendarEvent {
    WDAddCalendarEventController *addEvent = [[WDAddCalendarEventController alloc] init];
    [self.navigationController pushViewController:addEvent animated:YES];
}
- (void)getCalenderEvent {
    if ([[[WDCalendarEventManager shareCalendarEvent] getCalendarTag] integerValue] == 0) {
        [WDAlertView alertViewInViewController:self message:@"请打开日历权限"];
        return;
    }
    NSArray *events = [[WDCalendarEventManager shareCalendarEvent] getCalendarEventData];
    WDCalendarEventDetailController *eventDetail = [[WDCalendarEventDetailController alloc] init];
    eventDetail.eventArray = events;
    [self.navigationController pushViewController:eventDetail animated:YES];
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
