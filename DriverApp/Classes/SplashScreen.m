//
//  SplashScreen.m
//  driverApp
//
//  Created by Nagraj Gopalakrishnan on 24/11/11.
//  Copyright 2011 Apppli. All rights reserved.
//

#import "SplashScreen.h"


@implementation SplashScreen

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	UIViewController *modalViewController = [[UIViewController alloc] init];
    modalViewController.view = SplashView;
    [self presentModalViewController:modalViewController animated:NO];
    [self performSelector:@selector(hideSplash) withObject:nil afterDelay:2.0];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)showSplash
{
    UIViewController *modalViewController = [[UIViewController alloc] init];
    modalViewController.view = SplashView;
    [self presentModalViewController:modalViewController animated:NO];
    [self performSelector:@selector(hideSplash) withObject:nil afterDelay:2.0];
}

//hide splash screen
- (void)hideSplash{
    [[self modalViewController] dismissModalViewControllerAnimated:YES];
}
- (void)dealloc {
    [super dealloc];
}


@end
