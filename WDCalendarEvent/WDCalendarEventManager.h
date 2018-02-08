//
//  WDCalendarEventManager.h
//  WDCalendarEvent
//
//  Created by WindyZhang on 2018/2/2.
//  Copyright © 2018年 WindyZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WDBlock)(void);

@protocol WDCalendarEventDelegate <NSObject>

@optional

- (void)getEventIdenfiterFromAddSuccess:(NSString *)idenfiter;

@end

@interface WDCalendarEventManager : NSObject

@property (nonatomic, weak) id<WDCalendarEventDelegate> eventDelegate;

+ (instancetype)shareCalendarEvent;

- (void)showCalendarPermissionTip:(WDBlock)successBlock failingBlock:(WDBlock)failureBlock;
//写日历事件
- (void)writeCalendarEventWithDataDic:(NSDictionary *)dataDic;
//删除日历事件
- (void)deleteCalendarEventWithID:(NSString *)eventID;
//获取日历事件
- (NSArray *)getCalendarEventData;
//获取日历权限
- (BOOL)getCalendarPermission;

- (void)setCalendarTag:(NSString *)tag;
- (NSString *)getCalendarTag;

@end
