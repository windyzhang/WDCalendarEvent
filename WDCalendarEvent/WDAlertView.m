//
//  WDAlertView.m
//  WDCalendarEvent
//
//  Created by WindyZhang on 2018/2/5.
//  Copyright © 2018年 feeyo. All rights reserved.
//

#import "WDAlertView.h"

@implementation WDAlertView

+ (void)showAlertView:(NSString *)title message:(NSString *)message cancelButton:(NSString *)cancel otherButtons:(NSArray *)titles inViewController:(UIViewController *)viewController selectAt:(VZTIntegerBlock)block {
    
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

+ (void)alertViewInViewController:(UIViewController *)viewController message:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:NULL]];
    [viewController presentViewController:alert animated:YES completion:NULL];
}

@end
