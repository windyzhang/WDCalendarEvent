//
//  WDAlertView.h
//  WDCalendarEvent
//
//  Created by WindyZhang on 2018/2/5.
//  Copyright © 2018年 feeyo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VZTIntegerBlock)(NSInteger iVal);

@interface WDAlertView : NSObject

+ (void)showAlertView:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel otherButtons:(NSArray *)titles inViewController:(UIViewController *)viewController selectAt:(VZTIntegerBlock)block;

+ (void)alertViewInViewController:(UIViewController *)viewController message:(NSString *)message;

@end
