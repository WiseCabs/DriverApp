//
//  driverAppAppDelegate.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 14/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "driverAppAppDelegate.h"
#import "Reachability.h"
#import "json.h"
#import "HomePage.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>
#import "Common.h"
#import "WebServiceHelper.h"
#import "ScheduleJourneydetail.h"
#import "LoginPage.h"

@implementation driverAppAppDelegate



@synthesize window;
@synthesize maintabBarController,result;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	[self homePageLoad];
    self.maintabBarController.tabBar.translucent = NO;

	[self.window makeKeyAndVisible];
    return YES;
	
	
}

-(void)homePageLoad{
	
	if ([Common isNetworkExist]<1)
	{
		//[self loadTabBarController];
		[Common showNetwokAlert];
		
	}
	
	  //[Common setWebServiceURL:@"http://www.wisecabs.com/auth/"];
		//[Common setWebServiceURL:@"http://192.168.0.8:8081/WiseCabs/auth/"];
		[Common setWebServiceURL:@"http://test.wisecabs.com/auth/"];
		//[Common setWebServiceURL:@"http://192.168.0.11/cabwise/auth/"];
		
		[self loadTabBarController];
		
	
}

-(void)loadTabBarController{

	maintabBarController=[[UITabBarController alloc] init];
	maintabBarController.delegate=self;
	//CitySearch *citySearch=[[[CitySearch alloc] init] autorelease];
	ScheduleJourneydetail *ScheduledJourney= [[[ScheduleJourneydetail alloc] init] autorelease];
	ScheduledJourney.tabName=@"Scheduled Jobs";
	ScheduleJourneydetail *CompletedJourney= [[[ScheduleJourneydetail alloc] init] autorelease];
	CompletedJourney.tabName=@"Completed Jobs";
	LoginPage *loginPage=[[[LoginPage alloc] init] autorelease];
	
	float rd = 4.00/255.00;
	float gr = 152.00/255.00;
	float bl = 229.00/255.00;
	
	
	UINavigationController *ScheduledJourneyNavController=[[[UINavigationController alloc] initWithRootViewController:loginPage] autorelease];
	UINavigationController *CompletedJourneyNavController=[[[UINavigationController alloc] initWithRootViewController:CompletedJourney] autorelease];
	
	ScheduledJourneyNavController.navigationBar.barTintColor =[UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
	CompletedJourneyNavController.navigationBar.barTintColor =[UIColor colorWithRed:rd green:gr blue:bl alpha:1.0];
    [ScheduledJourneyNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [CompletedJourneyNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    ScheduledJourneyNavController.navigationBar.tintColor = [UIColor whiteColor];
    CompletedJourneyNavController.navigationBar.tintColor = [UIColor whiteColor];

    maintabBarController.tabBar.barTintColor = [UIColor blackColor];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:(38.0/255.0) green:(38.0/255.0) blue:(38.0/255.0) alpha:1.0]];

	if([[UIApplication sharedApplication] isStatusBarHidden])
	[maintabBarController view].frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
	else 
		[maintabBarController view].frame = CGRectMake(0, 20, 320, ([[UIScreen mainScreen] bounds].size.height-20.0));
	
	ScheduledJourneyNavController.tabBarItem.title=@"Scheduled Jobs";
	CompletedJourneyNavController.tabBarItem.title=@"Completed Jobs";
	
	
	ScheduledJourneyNavController.tabBarItem.image = [UIImage imageNamed:@"complete2-01.png"];
	CompletedJourneyNavController.tabBarItem.image = [UIImage imageNamed:@"folder.png"];
	
	NSArray *tabbarArray=[NSArray arrayWithObjects:ScheduledJourneyNavController,CompletedJourneyNavController,nil];
	maintabBarController.viewControllers=tabbarArray;
	
	[window addSubview:maintabBarController.view];
	
	
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
    
    if (buttonIndex == 1)
    {
		 [self homePageLoad];
	

	}
	
	
}*/


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopUpdating" object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	
	
	}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[NSNotificationCenter defaultCenter]
	 postNotificationName:@"checkIfDateChanged"
	 object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

//read
- (void)dealloc {
	[result release];
    [window release];
	[maintabBarController release];
    [super dealloc];
}
/*
@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
	UIColor *color = [UIColor blackColor];
	UIImage *img  = [UIImage imageNamed: @"NavigationBarImage.png"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.tintColor = color;

}
 */ 

@end
