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

typedef void (^VZTIntegerBlock)(NSInteger iVal);

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
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
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
            [self showWithTitle:@"没有权限"
                        message:@"您的日历权限没有打开，请在“设置-隐私-日历”打开!"
              cancelButtonTitle:@"取消"
              otherButtonTitles:@[ @"确定" ]
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
- (void)showWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancel otherButtonTitles:(NSArray *)titles inViewController:(UIViewController *)viewController selectAt:(VZTIntegerBlock)block {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancel) {
        [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (block) {
                block(0);
            }
        }]];
    }
    
    for (NSInteger i = 0; i < [titles count]; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (block) {
                block(i + 1);
            }
        }]];
    }
    [viewController presentViewController:alert animated:YES completion:NULL];
}

- (void)addCalendarEvent {
    WDAddCalendarEventController *addEvent = [[WDAddCalendarEventController alloc] init];
    [self.navigationController pushViewController:addEvent animated:YES];
}
- (void)getCalenderEvent {
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
