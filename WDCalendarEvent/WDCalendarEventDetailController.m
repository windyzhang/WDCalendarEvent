//
//  WDCalendarEventDetailController.m
//  WDCalendarEvent
//
//  Created by WindyZhang on 2018/2/2.
//  Copyright © 2018年 WindyZhang. All rights reserved.
//

#import "WDCalendarEventDetailController.h"
#import <EventKit/EventKit.h>

NSString *const kDetailTableViewCellID = @"kDetailTableViewCellID";
NSInteger const kBottomViewHeight = 50;

@interface WDCalendarEventDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation WDCalendarEventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事件详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editCalendarEvent:)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.bottomView addSubview:lineView];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 0, 80, kBottomViewHeight)];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [deleteButton addTarget:self action:@selector(deleteCalendarEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:deleteButton];

    UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, kBottomViewHeight)];
    [selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectButton addTarget:self action:@selector(selectAllEventData:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:selectButton];
}
- (NSMutableArray *)mArray {
    if (!_mArray) {
        _mArray = [NSMutableArray arrayWithArray:self.eventArray];
    }
    return _mArray;
}
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kBottomViewHeight)];
    }
    return _bottomView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailTableViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDetailTableViewCellID];
    }
    EKEvent *event = self.mArray[indexPath.row];
    cell.textLabel.text = event.title;
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.selectArray addObject:self.mArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectArray.count > 0) {
        [self.selectArray removeObject:self.mArray[indexPath.row]];
    }
}
- (void)editCalendarEvent:(UIBarButtonItem *)sender {
    
    if ([sender.title isEqualToString:@"编辑"]) {
        if (self.selectArray.count > 0) {
            [self.selectArray removeAllObjects];
        }
        sender.title = @"取消";
        [self.tableView setEditing:YES animated:YES];
        [self showBottomView];
    } else {
        sender.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
        [self hideBottomView];
    }
}
- (void)showBottomView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - kBottomViewHeight, SCREEN_WIDTH, kBottomViewHeight);
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kBottomViewHeight);
    }];
}
- (void)hideBottomView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kBottomViewHeight);
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}
- (void)selectAllEventData:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"全选"]) {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        for (int i = 0; i < self.mArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.selectArray addObject:self.mArray[i]];
        }
    } else {
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        for (int i = 0; i < self.mArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        [self.selectArray removeAllObjects];
    }
    
}
- (void)deleteCalendarEvent {
    
    if (self.selectArray.count == 0) {
        [WDAlertView alertViewInViewController:self message:@"请选择要删除的事件"];
    } else {
        for (EKEvent *event in self.selectArray) {
            NSString *identifier = event.eventIdentifier;
            [[WDCalendarEventManager shareCalendarEvent] deleteCalendarEventWithID:identifier];
            [self.mArray removeObject:event];
        }
        [self.tableView reloadData];
    }
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
