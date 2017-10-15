//
//  AppDelegate.h
//  Lab2
//
//  Created by Ernest on 10/13/17.
//  Copyright © 2017 Ernest. All rights reserved.
//

#import <UIKit/UIKit.h>
#define theAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *strResponse;
@property (strong, nonatomic) NSDate *tempDate;
@property (nonatomic) NSInteger weekday;
@property (nonatomic) BOOL isPair;
@property (strong, nonatomic) NSString *noteDate;
@end

