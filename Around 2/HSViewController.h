//
//  HSViewController.h
//  Around 2
//
//  Created by Тареев Григорий and Михаил Луцкий on 25.10.14.
//  Copyright (c) 2014 AppCoda LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
@interface HSViewController : UIViewController <MBProgressHUDDelegate, CBPeripheralManagerDelegate, CLLocationManagerDelegate, UINavigationBarDelegate, UINavigationControllerDelegate> {
    MBProgressHUD *HUD;
    
    long long expectedLength;
    long long currentLength;
}
- (IBAction)but:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countAr;
@property (weak, nonatomic) IBOutlet UITextField *text;
- (IBAction)backgroundTouchedHideKeyboard:(id)sender;
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) NSDictionary *myBeaconData;
@property (weak, nonatomic) IBOutlet UILabel *minor;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (weak, nonatomic) IBOutlet UILabel *major;
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion2;
@property (weak, nonatomic) IBOutlet UILabel *search;
@property (weak, nonatomic) IBOutlet UILabel *mayak;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
