//
//  driverAppAppDelegate.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 14/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TravelDetails;
@interface driverAppAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate,UITabBarDelegate,UITabBarControllerDelegate> {
    UIWindow *window;
	UITabBarController *maintabBarController;
	NSArray *result;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *maintabBarController;
@property (nonatomic, retain) NSArray *result;
//- (NSDictionary *)readPlist:(NSString *)fileName; 
-(void)homePageLoad;
-(void)loadTabBarController;

@end

