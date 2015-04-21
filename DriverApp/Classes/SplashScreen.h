//
//  SplashScreen.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 24/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplashScreen : UIViewController {
	IBOutlet UIView *SplashView;
}
- (void)showSplash;
- (void)hideSplash;

@end
