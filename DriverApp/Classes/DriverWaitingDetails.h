//
//  DriverWaitingDetails.h
//  driverApp
//
//  Created by Nagraj on 07/11/12.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AllocatedJourney.h"

@interface DriverWaitingDetails : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField *baseLabel;
    IBOutlet UITableView *driverTableView;
    IBOutlet UIPickerView *basePicker;
     MBProgressHUD *HUD;
    NSArray *baseArray;
     NSArray *driverArray;
    UIBarButtonItem* customBarItem;
    NSArray *travelarray;
    UIAlertView *newJnyAlert;
    UIAlertView *dropRejectedAlert;
    AllocatedJourney *jny;
    //NSString *actionType;
    NSTimer *updatetimer;
    BOOL timerCalled;
    BOOL updatingJnys;
}

 @property (nonatomic, assign) BOOL updatingJnys;
 @property (nonatomic, assign) BOOL timerCalled;
@property(nonatomic, retain)  UIBarButtonItem* customBarItem;
@property(nonatomic, retain)  IBOutlet UIPickerView *basePicker;
@property(nonatomic,retain)IBOutlet UITextField *baseLabel;
@property(nonatomic,retain)IBOutlet UITableView *driverTableView;
@property(nonatomic,retain)  NSArray *baseArray;
 @property(nonatomic,retain) NSArray *driverArray;
@property (nonatomic, retain) NSArray *travelarray;

@property(nonatomic, retain) UIAlertView *dropRejectedAlert;
@property (nonatomic, retain) UIAlertView *newJnyAlert;

@property (nonatomic, retain) AllocatedJourney *journey;
//@property (nonatomic, retain) NSString *actionType;

@property (nonatomic, retain) NSTimer *updatetimer;


@end
