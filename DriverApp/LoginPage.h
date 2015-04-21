//
//  LoginPage.h
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 22/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginPage : UIViewController {
	IBOutlet UIButton *LogIn;
	IBOutlet UIButton *Forgotpassword;
	IBOutlet UITextField *PhoneNo;
	IBOutlet UITextField *Password;
	IBOutlet UISwitch *RememberMe;
	//IBOutlet UIActivityIndicatorView *activityIndicator;
	NSString *PhoneNoPlist;
	NSString *PasswordPlist;
	NSString *UserIdPlist;
	MBProgressHUD *HUD;
	
}
@property(nonatomic,retain) IBOutlet UIButton *LogIn;
@property(nonatomic,retain) IBOutlet UIButton *Forgotpassword;
@property(nonatomic,retain) IBOutlet UITextField *PhoneNo;
@property(nonatomic,retain) IBOutlet UITextField *Password;
@property(nonatomic,retain) IBOutlet UISwitch *RememberMe;
//@property(nonatomic,retain) IBOutlet IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain)	NSString *PhoneNoPlist;
@property (nonatomic, retain)	NSString *PasswordPlist;
@property (nonatomic, retain)	NSString *UserIdPlist;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction) cancelEdit:(id)sender;
- (IBAction)loginIn:(id)sender;
@end




