//
//  WDCalendarEventManager.m
//  WDCalendarEvent
//
//  Created by WindyZhang on 2018/2/2.
//  Copyright © 2018年 WindyZhang. All rights reserved.
//

#import "WDCalendarEventManager.h"
#import <EventKit/EventKit.h>

NSString *const kCalendarTag = @"kCalendarTag";

@interface WDCalendarEventManager ()


@end

@implementation WDCalendarEventManager

+ (instancetype)shareCalendarEvent {
    
    static WDCalendarEventManager *manage = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manage = [[WDCalendarEventManager alloc] init];
    });
    return manage;
}
- (void)showCalendarPermissionTip:(WDBlock)successBlock failingBlock:(WDBlock)failureBlock {
    
    EKEventStoreRequestAccessCompletionHandler completion = ^(BOOL granted, NSError *error) {
        if (granted) {
            if (successBlock) {
                successBlock();
            }
        } else {
            if (failureBlock) {
                failureBlock();
            }
        }
    };
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case EKAuthorizationStatusNotDetermined: {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:completion];
        }
            break;
        case EKAuthorizationStatusAuthorized:
            completion(YES, NULL);
            [self setCalendarTag:@"1"];
            break;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
            completion(NO, NULL);
            [self setCalendarTag:@"0"];
            break;
    }
   
}
- (void)writeCalendarEventWithDataDic:(NSDictionary *)dataDic {
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *startDate = [formatter dateFromString:dataDic[@"startDate"]];
    NSDate *endDate = [formatter dateFromString:dataDic[@"endDate"]];
    event.title = dataDic[@"title"];
    event.notes = dataDic[@"notes"];
    event.startDate = startDate;
    event.endDate = endDate;
    event.allDay = NO;
    
    NSTimeInterval alarmTime = -2 * 60;
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[NSDate dateWithTimeInterval:alarmTime sinceDate:endDate]];
    [event addAlarm:alarm];
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    [eventStore saveEvent:event span:EKSpanThisEvent error:NULL];
    [self.eventDelegate getEventIdenfiterFromAddSuccess:event.eventIdentifier];
}
- (void)deleteCalendarEventWithID:(NSString *)eventID {
    
    if ([eventID isEqualToString:@""]) {
        return;
    }
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *anEvent = [eventStore eventWithIdentifier:eventID];
    if (anEvent) {
        [eventStore removeEvent:anEvent span:EKSpanThisEvent error:nil];
    }
}
- (NSArray *)getCalendarEventData {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *startComponents = [[NSDateComponents alloc] init];
    startComponents.day = -100;
    NSDate *startDate = [calendar dateByAddingComponents:startComponents toDate:[NSDate date] options:0];
    
    NSDateComponents *arrivalComponents = [[NSDateComponents alloc] init];
    arrivalComponents.day = 100;
    NSDate *arrivalDate = [calendar dateByAddingComponents:arrivalComponents toDate:[NSDate date] options:0];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate endDate:arrivalDate calendars:nil];
    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
    events = [events sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    return events;
}

- (BOOL)getCalendarPermission {
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case EKAuthorizationStatusAuthorized:
            return YES;
            break;
        case EKAuthorizationStatusDenied:
            return NO;
            break;
        case EKAuthorizationStatusNotDetermined:
            return NO;
            break;
        case EKAuthorizationStatusRestricted:
            return NO;
            break;
        default:
            break;
    }
}
- (void)setCalendarTag:(NSString *)tag {
    
    if (![self getCalendarPermission]) {
        tag = @"0";
    }
    [[NSUserDefaults standardUserDefaults] setObject:tag forKey:kCalendarTag];
}

- (NSString *)getCalendarTag {
    
    if (![self getCalendarPermission]) {
        return @"0";
    }
    NSString *tag = [[NSUserDefaults standardUserDefaults] objectForKey:kCalendarTag];
    return tag;
}

@end
