//
//  BIDViewController.h
//  ble
//
//  Created by Zhangzhen on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>

@interface BIDViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


@property (strong, nonatomic) IBOutlet UIButton *buttonStartScan;
//@property (strong, nonatomic) IBOutlet UIButton *buttonContactCansec;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorScan;
@property (strong, nonatomic) IBOutlet UILabel *labelConnectedBLE;
@property (strong, nonatomic) IBOutlet UILabel *labelRSSI;
@property (strong, nonatomic) IBOutlet UIProgressView *progressRSSI;
@property (strong, nonatomic) IBOutlet UITableView *tableViewBLEs;

//@property (strong, nonatomic) IBOutlet UILabel *labelCharacteristicValue;

@property (strong, nonatomic) IBOutlet UILabel *labelKeyState;
@property (strong, nonatomic) IBOutlet UIStepper *stepper;


- (IBAction)switchLED1_ValueChanged:(id)sender;
- (IBAction)switchLED2_ValueChanged:(id)sender;
- (IBAction)switchLED3_ValueChanged:(id)sender;
- (IBAction)switchLED4_ValueChanged:(id)sender;
- (IBAction)switchLED5_ValueChanged:(id)sender;

- (IBAction)switchRSSI_ValueChanged:(id)sender;
- (IBAction)switchKey_ValueChanged:(id)sender;



@property (strong, nonatomic) IBOutlet UISwitch *switchRSSI;
@property (strong, nonatomic) IBOutlet UISwitch *switchLED4;
@property (strong, nonatomic) IBOutlet UISwitch *switchLED2;
@property (strong, nonatomic) IBOutlet UISwitch *switchLED1;
@property (strong, nonatomic) IBOutlet UISwitch *switchKEY;
@property (strong, nonatomic) IBOutlet UISwitch *switchLED3;
@property (strong, nonatomic) IBOutlet UISwitch *switchLED5;


- (IBAction)buttonStartScanFn:(UIButton *)sender;


@property (strong, nonatomic) CBCentralManager *myCentralManager;
@property (strong, nonatomic) CBPeripheral *myPeripheral;
@property (strong, nonatomic) CBCharacteristic *myCharacteristic;
@property (strong, nonatomic) CBCharacteristic *myCharacteristicFFF0;
@property (strong, nonatomic) CBCharacteristic *myCharacteristicFFF1;
@property (strong, nonatomic) CBCharacteristic *myCharacteristicFFF2;
@property (strong, nonatomic) CBCharacteristic *myCharacteristicFFF3;
@property (strong, nonatomic) CBCharacteristic *myCharacteristicFFF4;
@property (strong, nonatomic) CBCharacteristic *myCharacteristicFFF5;
@property (strong, nonatomic) CBCharacteristic *myCharacteristicFFE1;
@property (strong, nonatomic) CBCharacteristic *myCharacteristicFFE2;

@property (strong, nonatomic) CBService *myService;

@property (strong, nonatomic) NSMutableArray *myMArrayPeripheral;

@property (strong, nonatomic) NSMutableArray *myPeripheralTable;

@property (strong, nonatomic) NSTimer *myTimer;
@property (strong, nonatomic) NSTimer *myTimerCansec;
@property (strong, nonatomic) IBOutlet UIButton *button_Cansec;


- (IBAction)stepper_ValueChanged:(id)sender;
- (IBAction)buttonBuzzer_TouchUp:(id)sender;


@property (strong,nonatomic) NSArray *myListData;



@end

