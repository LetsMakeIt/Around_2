//
//  HSViewController.m
//  Around 2
//
//  Created by Тареев Григорий and Михаил Луцкий on 25.10.14.
//  Copyright (c) 2014 AppCoda LLC. All rights reserved.
//

#import "HSViewController.h"
#import <Parse/Parse.h>
#import "SearchResultViewController.h"
#import "ViewController.h"
@interface HSViewController ()

@end

@implementation HSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firststart"]){
        ViewController *vc = (ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"first"];
        [self presentModalViewController:vc animated:YES];

    }
    _text.delegate = self;
    [_text resignFirstResponder];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"79CC4118-B56B-40EA-BFA1-1A56D45CACD6"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.myBeaconRegion2 = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                             identifier:@"ru.appcoda.arround"];
    
    // Initialize the Beacon Region
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:1
                                                                  minor:1
                                                             identifier:@"ru.appcoda.arround"];
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion2];
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]; [alert show]; return;
    }
    self.myBeaconData = [self.myBeaconRegion peripheralDataWithMeasuredPower:nil];
    
    // Start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
    // Do any additional setup after loading the view.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // do whatever you have to do
    
    [_text resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backgroundTouchedHideKeyboard:(id)sender
{
    [_text resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)but:(id)sender {
    if (![_text.text isEqualToString:@""]){
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        
        // Set custom view mode
        HUD.mode = MBProgressHUDModeCustomView;
        
        HUD.delegate = self;
        HUD.labelText = @"Добавлено";
        
        [HUD show:YES];
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:@"Enable"];
        [push setMessage:[NSString stringWithFormat:@"#%@",_text.text]];
        [push sendPushInBackground];
        PFObject *gameScore = [PFObject objectWithClassName:@"messages"];
        gameScore[@"text"] = [NSString stringWithFormat:@"#%@",_text.text];
        [gameScore saveInBackground];
        [HUD hide:YES afterDelay:2];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Напишите текст сообщения!" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil] show];
    }
    //
}
- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    // We entered a region, now start looking for our target beacons!
    self.search.text = @"Finding beacons.";
    [self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion2];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
    // Exited the region
    self.search.text = @"None found.";
    _countAr.text = @"0 Around";
    [self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion2];
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    self.search.text = @"Beacon found!";
    
    CLBeacon *foundBeacon = [beacons firstObject];
    _countAr.text = [NSString stringWithFormat:@"%lu Around",(unsigned long)[_locationManager monitoredRegions].count];
    // You can retrieve the beacon data from its properties
    //NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    _major.text = [NSString stringWithFormat:@"%@", foundBeacon.major];
    _minor.text = [NSString stringWithFormat:@"%@", foundBeacon.minor];
}
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Bluetooth is on
        
        // Update our status label
        self.mayak.text = @"Broadcasting...";
        
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.myBeaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        self.mayak.text = @"Stopped";
        
        // Bluetooth isn't on. Stop broadcasting
        [self.peripheralManager stopAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStateUnsupported)
    {
        self.mayak.text = @"Unsupported";
    }
}
@end
