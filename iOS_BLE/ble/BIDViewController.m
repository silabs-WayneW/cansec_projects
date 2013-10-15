//
//  BIDViewController.m
//  ble
//
//  Created by Zhangzhen on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BIDViewController.h"

@interface BIDViewController()

@end

@implementation BIDViewController

@synthesize audioPlayer;

@synthesize switchRSSI;
@synthesize switchLED4;
@synthesize switchLED2;
@synthesize switchLED1;
@synthesize switchKEY;
@synthesize switchLED3;
@synthesize switchLED5;


@synthesize buttonStartScan;
//@synthesize buttonContactCansec;
@synthesize indicatorScan;
@synthesize labelConnectedBLE;
@synthesize labelRSSI;
@synthesize progressRSSI;
@synthesize tableViewBLEs;
//@synthesize labelCharacteristicValue;
@synthesize labelKeyState;
@synthesize stepper;

@synthesize myPeripheral;
@synthesize myCentralManager;
@synthesize myCharacteristic;
@synthesize myCharacteristicFFF0;
@synthesize myCharacteristicFFF1;
@synthesize myCharacteristicFFF2;
@synthesize myCharacteristicFFF3;
@synthesize myCharacteristicFFF4;
@synthesize myCharacteristicFFF5;
@synthesize myCharacteristicFFE1;
@synthesize myCharacteristicFFE2;
@synthesize myService;

@synthesize myMArrayPeripheral;
@synthesize myPeripheralTable;

@synthesize myTimer;
@synthesize myTimerCansec;
@synthesize myListData;

@synthesize button_Cansec;



#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [indicatorScan setHidden:YES];
    [stepper setHidden:YES];
    [button_Cansec setHidden:YES];
    
    myMArrayPeripheral = [[NSMutableArray alloc] init];
    myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    
}

- (void)viewDidUnload
{

    [self setMyService:nil];
    [self setMyMArrayPeripheral:nil];
    [self setMyCentralManager:nil];
    [self setMyCharacteristic:nil];
    [self setMyPeripheral:nil];

    
  //  [self setButtonContactCansec:nil];
    [self setButtonStartScan:nil];
    [self setIndicatorScan:nil];
    [self setLabelConnectedBLE:nil];
    [self setLabelRSSI:nil];
    [self setProgressRSSI:nil];
    
   
   // [self setLabelCharacteristicValue:nil];
    [self setLabelKeyState:nil];
    [self setTableViewBLEs:nil];
    [self setSwitchRSSI:nil];
    [self setStepper:nil];
    [self setSwitchLED4:nil];
    [self setSwitchLED2:nil];
    [self setSwitchLED1:nil];
    [self setSwitchKEY:nil];
    [self setSwitchLED3:nil];
    [self setSwitchLED5:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}




///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (IBAction)buttonStartScanFn:(UIButton *)sender 
{
    // NSLog(@"\n\n*** Enter:-> buttonStartScanFn()!");
     
    if([[buttonStartScan titleLabel].text isEqualToString:@"Scan BLE"])
    {
        if(myPeripheral&&myPeripheral.isConnected)
        //if((myPeripheral)&&(myPeripheral.state == CBPeripheralStateConnected))
            [myCentralManager cancelPeripheralConnection:myPeripheral];
        
        [indicatorScan startAnimating];
        [indicatorScan setHidden:NO];
        
        [buttonStartScan setTitle:@"Stop Scan" forState:UIControlStateNormal];
        [labelConnectedBLE setText:@""];
        
        
        [myMArrayPeripheral removeAllObjects];  //clear peripheral array.
        [tableViewBLEs reloadData];
        
       
        
        //start scan BLE peripheral.
        NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:@"FFF0"], nil];
        NSDictionary *optionsDictioinary = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
        [myCentralManager scanForPeripheralsWithServices:uuidArray options:optionsDictioinary];
        
        myTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(scanBLETimer:) userInfo:nil repeats:NO];
        
    }
    else if([[buttonStartScan titleLabel].text isEqualToString:@"Stop Scan"])
    {
        [myCentralManager stopScan];
        
        [indicatorScan stopAnimating];
        [indicatorScan setHidden:YES];
        
        [buttonStartScan setTitle:@"Scan BLE" forState:UIControlStateNormal];
        [myTimer invalidate];
        
        
        
    }
    else if([[buttonStartScan titleLabel].text isEqualToString:@"Disconnect"])
    {
        [buttonStartScan setTitle:@"Scan BLE" forState:UIControlStateNormal];

        if(myPeripheral && (myPeripheral.isConnected))
        //if((myPeripheral) && (myPeripheral.state == CBPeripheralStateConnected))
            [myCentralManager cancelPeripheralConnection:myPeripheral];
    }
    
}

- (void) scanBLETimer:(NSTimer*)scanTimer
{
    
    // NSLog(@"****->scanBLETimer()");
    
    
    [indicatorScan stopAnimating];
    [indicatorScan setHidden:YES];
    
    [buttonStartScan setTitle:@"Scan BLE" forState:UIControlStateNormal];
    
    [myCentralManager stopScan];
    [myTimer invalidate];
    //[labelConnectedBLE setText:@"Scan BLE Timeout"];
}


- (IBAction)switchLED1_ValueChanged:(id)sender 
{
   // UISwitch *switchLED1 = (UISwitch*)sender;
        
    if(switchLED1.on)
    {
        // NSLog(@"LED1-On");
        uint8_t val = 11;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
                
    }
    else 
    {
        // NSLog(@"LED1-Off");
        uint8_t val = 10;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse]; 
        
    }
  
}

- (IBAction)switchLED2_ValueChanged:(id)sender {
    //UISwitch *switchLED1 = (UISwitch*)sender;
    
    if(switchLED2.on)
    {
        // NSLog(@"LED2-On");
        uint8_t val = 21;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        
    }
    else 
    {
        // NSLog(@"LED2-Off");
        uint8_t val = 20;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse]; 
        
    }

}

- (IBAction)switchLED3_ValueChanged:(id)sender {
    //UISwitch *switchLED1 = (UISwitch*)sender;
    
    if(switchLED3.on)
    {
        // NSLog(@"LED3-On");
        uint8_t val = 31;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        
    }
    else 
    {
        // NSLog(@"LED3-Off");
        uint8_t val = 30;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        
    }

}

- (IBAction)switchLED4_ValueChanged:(id)sender {
   // UISwitch *switchLED1 = (UISwitch*)sender;
    
    if(switchLED4.on)
    {
        // NSLog(@"LED4-On");
        uint8_t val = 41;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        
    }
    else 
    {
        // NSLog(@"LED4-Off");
        uint8_t val = 40;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse]; 
        
    }

}

BOOL led5value = false;

- (IBAction)switchLED5_ValueChanged:(id)sender {
    
    led5value = switchLED5.on;
    if(switchLED5.on)
    {
        // NSLog(@"LED5-On");
        uint8_t val = 51;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        [stepper setHidden:NO];
        [stepper setEnabled:true];
        
    }
    else 
    {
        // NSLog(@"LED5-Off");
        uint8_t val = 50;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse]; 
        [stepper setHidden:YES];
        [stepper setEnabled:false];
    }

    
}

BOOL aaa = YES;
-(void)oneSecond:(NSTimer* ) timer
{
    
        if(aaa==YES)
        {
            aaa = NO;
            [button_Cansec setHidden:NO];
        }
        else
        {
            aaa = YES;
              [button_Cansec setHidden:YES];
        }
    
}

- (IBAction)switchRSSI_ValueChanged:(id)sender {
    
    //UISwitch *switchRSSI1 = (UISwitch*)sender;
   // BOOL value = switchRSSI1.isOn;
    //if(switchLED5.on)
    if(switchRSSI.on)
    {
        // NSLog(@"Enter:RSSI-On");
        [myPeripheral setNotifyValue:YES forCharacteristic:myCharacteristicFFF4];
        

        
    }
    else 
    {
        // NSLog(@"Enter:RSSI-Off");
        [myPeripheral setNotifyValue:NO forCharacteristic:myCharacteristicFFF4];
       
        [myTimerCansec invalidate];
        [self stopSound];
        [progressRSSI setProgress:0.0];
        [labelRSSI setText:@""];
        
       
    }

}

- (IBAction)switchKey_ValueChanged:(id)sender {
    //UISwitch *switchKey1 = (UISwitch*)sender;
    //BOOL value = switchKey1.isOn;
    if(switchKEY.on)
    {
        // NSLog(@"Key-On");
        [myPeripheral setNotifyValue:YES forCharacteristic:myCharacteristicFFE1]; 
    }
    else 
    {
        // NSLog(@"Key-Off");
        [myPeripheral setNotifyValue:NO forCharacteristic:myCharacteristicFFE1]; 
        
    }

}
/*
- (void) switch_ValueChanged:(id)sender{
    UISwitch *switchRed = (UISwitch*)sender;
    BOOL value = switchRed.isOn;
    if(value)
        NSLog(@"11111");
    else {
        
        NSLog(@"00000");
    }
    if(myPeripheral&&myPeripheral.isConnected)
        [myPeripheral readValueForCharacteristic:myCharacteristicFFF1];
}
 */
/*
- (void)butead_Characteristic:(id)sender 
{
    if(myPeripheral&&myPeripheral.isConnected)
        [myPeripheral readValueForCharacteristic:myCharacteristicFFF1];
}
*/
/*
- (void)buttonContactCansecFn:(id)sender 
{
    NSLog(@"\n\n*** Enter:-> buttonContactCansecFn()!");
    
    NSString *msg = @"mail:wangjinchao126@126.com";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Cansec" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    
}
*/
uint8_t led5stepper = 0;    //save the stepper value.

- (IBAction)stepper_ValueChanged:(id)sender 
{
    // NSLog(@"Stepper-On");
    UIStepper *stepper1 = (UIStepper*)sender;
    
    NSNumber *value = [NSNumber numberWithDouble:stepper1.value];
    // NSLog(@"stepper int value = %d",value.intValue);
    led5stepper = value.intValue;
    if (led5value) {
        uint8_t val = value.intValue;
        NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
        [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
    }
    // NSLog(@"Stepper-Off");
    
    
}

- (IBAction)buttonBuzzer_TouchUp:(id)sender
{
    // NSLog(@"Buzzer-On");
    uint8_t val = 60;
    NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
    [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
    // NSLog(@"Buzzer-Off");
}




///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    // NSLog(@"\n\n*** Enter:-> centralManagerDidUpdateState()!");
    NSString *str;
    NSString *msg;
    
    //static CBCentralManagerState previousState = -1;
    static CBCentralManagerState previousState = CBCentralManagerStatePoweredOff;
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            str = @"CBCentralManagerStatePoweredOn";
            break;
        case CBCentralManagerStatePoweredOff:
            str = @"CBCentralManagerStatePoweredOff";
            msg = @"You must turn on Bluetooth in Settings in order to use LE";
            [myMArrayPeripheral removeAllObjects]; //clear all ble device.
            [tableViewBLEs reloadData]; //refresh table view.
            //if(previousState != -1)
            if(previousState != CBCentralManagerStatePoweredOff)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bluetooth Power" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        case CBCentralManagerStateResetting:
            str = @"CBCentralManagerStateResetting";
            break;
        case CBCentralManagerStateUnauthorized:
            str = @"CBCentralManagerStateUnauthorized";
            break;
        case CBCentralManagerStateUnsupported:
            str = @"CBCentralManagerStateUnsupported";
            break;
        case CBCentralManagerStateUnknown:
            str = @"CBCentralManagerStateUnknown";
            break;            
            
        default:
            break;
    }
    // NSLog(@"Manager BLE State is %@",str);
    
   
    
}


- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // NSLog(@"\n\n*** Enter:-> didDiscoverPeripheral()!");
   
    
    if((peripheral.name != Nil) && ![myMArrayPeripheral containsObject:peripheral])
    {
        [myMArrayPeripheral addObject:peripheral];
        // NSLog(@"peritpheral = %@",peripheral.name);
        [tableViewBLEs reloadData];
    }
    
    // NSLog(@"myMArrayPeripheral count = %d",[myMArrayPeripheral count]);
   // NSLog(@"find peripheral: %@",peripheral.name);
   // NSLog(@"CBAdvertisementDataLocalNameKey  = %@",[advertisementData objectForKey:CBAdvertisementDataLocalNameKey]);
    //NSLog(@"CBAdvertisementDataManufacturerDataKey  = %@",[advertisementData objectForKey:CBAdvertisementDataManufacturerDataKey]);
    //NSLog(@"CBAdvertisementDataServiceDataKey  = %@",[advertisementData objectForKey:CBAdvertisementDataServiceDataKey]);
    //NSLog(@"CBAdvertisementDataServiceUUIDsKey  = %@",(NSString*)([advertisementData objectForKey:CBAdvertisementDataServiceUUIDsKey]));
    //NSLog(@"CBAdvertisementDataTxPowerLevelKey  = %@",[advertisementData objectForKey:CBAdvertisementDataTxPowerLevelKey]);
    //NSLog(@"RSSI=%@dB",RSSI);
    
    
    
   /* [labelRSSI setText:[NSString stringWithFormat:@"%@dB",RSSI]];
    NSLog(@"-=================%f",RSSI.floatValue);
    [progressRSSI setProgress:0.0 animated:YES];
    float rssi = (float)((RSSI.intValue+80)/90);   //(-80dB  ----  +10dB)
    [progressRSSI setProgress:rssi animated:YES];
    */
    
    //auto connect
    //[myCentralManager stopScan];
    //[myCentralManager retrievePeripherals:[NSArray arrayWithObject:(id)peripheral.UUID]];
}



- (void) centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
    // NSLog(@"\n\n***->Enter didRetrievePeripherals()");
    
   // NSLog(@"Peripheral Count= %u --------- Peripheral Name= %@",[peripherals count],[peripherals objectAtIndex:0]);
    // NSLog(@"Peripheral Count= %u",peripherals.count);
    for(CBPeripheral *peri in peripherals)
    {
        // NSLog(@"peripheral name = %@",peri.name);
    }
    
    
    //if([peripherals count] >=1)
   // {
        //[myCentralManager stopScan];
        //[tableViewBLEs reloadData];
        
        //myPeripheral = [peripherals objectAtIndex:0];
        //[central connectPeripheral:myPeripheral options:nil];
       
   // }
}


- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    // NSLog(@"\n\n***->Enter didConnectPeripheral()");
    // NSLog(@"Connect to peripheral: %@",peripheral.name);
     
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    
     myPeripheral = peripheral;
    
    [buttonStartScan setTitle:@"Scan BLE" forState:UIControlStateNormal];
    [indicatorScan stopAnimating];
    [indicatorScan setHidden:YES];
    [labelConnectedBLE setText:peripheral.name];
    
    
    [tableViewBLEs reloadData];
    
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    // NSLog(@"\n\n***->Enter didDisconnectPeripheral()");
    // NSLog(@"Disconnect from peripheral: %@",peripheral.name);
    
    [labelConnectedBLE setText:@""];
    [tableViewBLEs reloadData];
    
}

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    // NSLog(@"\n\n***->Enter didFailToConnectPeripheral()");
    
    // NSLog(@"Fail to connect to peripheral: %@ with error = %@",peripheral,[error localizedDescription]);
    // NSLog(@"Fail Peripheral Name = %@",peripheral.name);
    [buttonStartScan setTitle:@"Scan BLE" forState:UIControlStateNormal];
    [indicatorScan stopAnimating];
    [indicatorScan setHidden:YES];
    [labelConnectedBLE setText:@"No BLE Device"];
    
    /*
    if(myPeripheral&&myCentralManager)
        [myCentralManager cancelPeripheralConnection:myPeripheral];

    if(myPeripheral)
    {
        [myPeripheral setDelegate:nil];
        myPeripheral = nil;
    }
     */
}


//                  Peripheral Degelete
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
//#pragma mark -


- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
     // NSLog(@"\n\n***-> Enter didDiscoverServices()");
    
    for(CBService *aService in peripheral.services)
    {
        // NSLog(@"Serivice found with UUID: %@",aService.UUID);
        
        //if ([aService.UUID isEqual:[CBUUID UUIDWithString: CBUUIDGenericAccessProfileString]])
        if ([aService.UUID isEqual:[CBUUID UUIDWithString: CBUUIDCharacteristicUserDescriptionString]])
        {
            [peripheral discoverCharacteristics:nil forService:aService];
            //[labelConnectedBLE setText:@"Find Serives:GenericAccessProfile"];
            [labelConnectedBLE setText:@"Find Serives:CBUUIDCharacteristicUserDescriptionString"];

        }
        
        //if ([aService.UUID isEqual:[CBUUID UUIDWithString: CBUUIDGenericAttributeProfileString]])
        if ([aService.UUID isEqual:[CBUUID UUIDWithString: CBUUIDCharacteristicUserDescriptionString]])
        {
            [peripheral discoverCharacteristics:nil forService:aService];
            //[labelConnectedBLE setText:@"Find Serives:GenericAttributeProfile"];
            [labelConnectedBLE setText:@"Find Serives:CBUUIDCharacteristicUserDescriptionString"];
        }
 
        if([aService.UUID isEqual:[CBUUID UUIDWithString:@"180A"]])
        {
            [peripheral discoverCharacteristics:nil forService:aService];
            [labelConnectedBLE setText:@"Find Serives:180A"];
        }
        
        if([aService.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]])
        {
            [peripheral discoverCharacteristics:nil forService:aService];
            [labelConnectedBLE setText:@"Find Serives:FFF0"];
        }
        
        if([aService.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]])
        {
            [peripheral discoverCharacteristics:nil forService:aService];
            [labelConnectedBLE setText:@"Find Serives:FFE0"];
        }
        
        
            
               
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    // NSLog(@"\n\n***-> Enter didDiscoverCharacteristicsForService()");
    
    /*
    if([service.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]])
    {
        NSLog(@"---- Service CBUUIDGenericAccessProfileString ----");
        for(CBCharacteristic *aChar in service.characteristics)
        {
            NSLog(@"Found a CBUUIDGenericAccessProfileString Charateristic=%@", aChar.value);
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]])
            {
                [peripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a Device Name Charateristic = %@",aChar.value);
            }
        }
    }
    */
    /*
    if([service.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAttributeProfileString]])
    {
        NSLog(@"---- Service CBUUIDGenericAttributeProfileString ----");
        for(CBCharacteristic *aChar in service.characteristics)
        {
            NSLog(@"Found a CBUUIDGenericAttributeProfileString Charateristic=%@",aChar.value);
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAttributeProfileString]])
            {
                NSLog(@"Found a CBUUIDGenericAttributeProfileString");
            }
        }
    }
     */
   
    if([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]])
    {
        // NSLog(@"---- Service 180A ----");
        for(CBCharacteristic *aChar in service.characteristics)
        {
            
            // NSLog(@"Found a 180A Charateristic=%@",aChar);
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A23"]])
            {
                [peripheral readValueForCharacteristic:aChar];
                // NSLog(@"Found a 2A23 Characteristic");
            }
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]])
            {
                //[peripheral readValueForCharacteristic:aChar];
                // NSLog(@"Found a 2A24 Characteristic");
            }
            
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]])
            {
                //[peripheral readValueForCharacteristic:aChar];
                // NSLog(@"Found a 2A25 Characteristic");
            }
            
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]])
            {
                //[peripheral readValueForCharacteristic:aChar];
                // NSLog(@"Found a 2A26 Characteristic");
            }
            
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]])
            {
                //[peripheral readValueForCharacteristic:aChar];
                // NSLog(@"Found a 2A27 Characteristic");
            }
            
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]])
            {
                //[peripheral readValueForCharacteristic:aChar];
                // NSLog(@"Found a 2A28 Characteristic");
            }
            
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]])
            {
                [peripheral readValueForCharacteristic:aChar];
                // NSLog(@"Found a 2A29 Characteristic");
            }
            
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A2A"]])
            {
                //[peripheral readValueForCharacteristic:aChar];
                // NSLog(@"Found a 2A2A Characteristic");
            }
            
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"2A50"]])
            {
                //[peripheral readValueForCharacteristic:aChar];
                // NSLog(@"Found a 2A50 Characteristic");
            }
            
            
        }
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]]) 
    {
         // NSLog(@"---- Service FFF0 ----");
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // NSLog(@"Found a FFF0 Charateristic=%@",aChar.value);
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) 
            {
                // NSLog(@"Found FFF1 Characteristic!");
                myCharacteristicFFF1 = aChar;
                [labelConnectedBLE setText:@"Find Characteristic:FFF1"];
            
            }
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]])
            {
                // NSLog(@"Found FFF2 Characteristic!");
                myCharacteristicFFF2 = aChar;
                //[peripheral readValueForCharacteristic:aChar];
                [labelConnectedBLE setText:@"Find Characteristic:FFF2"];
                
            }
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FFF3"]])
            {
                // NSLog(@"Found FFF3 Characteristic!");
                myCharacteristicFFF3 = aChar;
                [labelConnectedBLE setText:@"Find Characteristic:FFF3"];
                //uint8_t val = 1;
                //NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
                //[peripheral writeValue:valData forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
                           
            }
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FFF4"]]) 
            {
                // NSLog(@"Found FFF4 Characteristic!");
                //NSLog(@"FFF4 Set a Notify!!!!");
                myCharacteristicFFF4 = aChar;
                [labelConnectedBLE setText:@"Find Characteristic:FFF4"];
                //[peripheral setNotifyValue:YES forCharacteristic:aChar];
                
            }
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FFF5"]]) 
            {
                // NSLog(@"Found FFF5 Characteristic!");
                myCharacteristicFFF5 = aChar;
                [labelConnectedBLE setText:@"Find Characteristic:FFF5"];
                
            }
            
        }
            
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]]) 
    {
        // NSLog(@"---- Service FFE0 ----");
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // NSLog(@"Found a FFE0 Charateristic=%@",aChar.value);
            
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) 
            {
                // NSLog(@"Found FFE1 Characteristic!");
                myCharacteristicFFE1 = aChar;
                [labelConnectedBLE setText:@"Find Characteristic:FFE1"];
                
                               
            }
            if([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FFE2"]])
            {
                // NSLog(@"Found FFF2 Characteristic!");
                myCharacteristicFFE2 = aChar;
                //[peripheral readValueForCharacteristic:aChar];
                
            }
                                    
        }
        
    }
    
    
}




- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    // NSLog(@"\n\n***-> Enter didUpdateValueForCharacteristic()");
    
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]])
    {
        // NSLog(@"characteristic.UUID = FFF1");
       
       // NSData *updateValue = characteristic.value;
       // uint8_t *dataPointer = (uint8_t*)[updateValue bytes];
       // NSLog(@"FFF1 Value byte = %d",dataPointer[0]);
        //[labelCharacteristicValue setText:[NSString stringWithFormat:@"%d",dataPointer[0]]];
        
    }
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]])
    {
        // NSLog(@"characteristic.UUID = FFF2");
        if((characteristic.value) || !error)
        {
            // NSLog(@"HHHHHHHHHH:%@",characteristic.value);
            //[self.scanInfo setText:[NSString stringWithFormat:@"\nHeart Rate Data: %d",characteristic.value]];
            
        }
    }
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF3"]])
    {
        // NSLog(@"characteristic.UUID = FFF3");
        if((characteristic.value) || !error)
        {
            // NSLog(@"HHHHHHHHHH:%@",characteristic.value);
            //[self.scanInfo setText:[NSString stringWithFormat:@"\nHeart Rate Data: %d",characteristic.value]];
            
        }
    }
    //Key Sate FFF4
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF4"]])
    {
        // NSLog(@"characteristic.UUID = FFF4");
        if((characteristic.value) || !error)
        {

            [myPeripheral readRSSI];
        }
    }
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF5"]])
    {
        // NSLog(@"characteristic.UUID = FFF5");
        if((characteristic.value) || !error)
        {
            // NSLog(@"HHHHHHHHHH:%@",characteristic.value);
            //[self.scanInfo setText:[NSString stringWithFormat:@"\nHeart Rate Data: %d",characteristic.value]];
            
        }
    }

    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]])
    {
        // NSLog(@"characteristic.UUID = FFE1");
        if((characteristic.value) || !error)
        {
            // NSLog(@"HHHHHHHHHH:%@",characteristic.value);
            
            NSData *updateValue = characteristic.value;
            uint8_t *dataPointer = (uint8_t*)[updateValue bytes];     
            // NSLog(@"FFE1 Key State =%d",dataPointer[0]);
            
            switch (dataPointer[0]) 
            {
                case 0:
                    [labelKeyState setText:@""];
                    break;
                case 1:
                    [labelKeyState setText:@"S1"];
                    break;
                case 2:
                    [labelKeyState setText:@"S2"];
                    break;
                case 4:
                    [labelKeyState setText:@"S3"];
                    break;
                case 3:
                    [labelKeyState setText:@"S1+S2"];
                    break;
                case 5:
                    [labelKeyState setText:@"S1+S3"];
                    break;
                case 6:
                    [labelKeyState setText:@"S2+S3"];
                    break;
                case 7:
                    [labelKeyState setText:@"S1+S2+S3"];
                    break;
                
                default:
                    [labelKeyState setText:@""];
                    break;
            }

            
            //[self.scanInfo setText:[NSString stringWithFormat:@"\nHeart Rate Data: %d",characteristic.value]];
            
        }
    }

    /*
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDDeviceNameString]])
    {
        NSLog(@"characteristic.UUID = CBUUIDDeviceNameString");
        NSString *deviceName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        NSLog(@"Device name = %@",deviceName);
    }
     */
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]])
    {
        // NSLog(@"characteristic.UUID = 2A29");
        //NSString *manufacturer = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        // NSLog(@"Manufacturer Name = %@",manufacturer);
    }
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A23"]])
    {
        // NSLog(@"characteristic.UUID = 2A23");
        NSData *updateValue = characteristic.value;
        uint8_t *dataPointer= (uint8_t*)[updateValue bytes];
        
        //[characteristic.value getBytes:dataPointer length:8];
        NSString *str = [NSString stringWithFormat:@"%X:%X:%X:%X:%X:%X",dataPointer[7],dataPointer[6],dataPointer[5],dataPointer[2],dataPointer[1],dataPointer[0]];
        
        // NSLog(@"MAC = %@",str);
        [labelConnectedBLE setText:str];
        
        
        //Update current contorl state and setting.
        if(switchLED1.on)
        {
            uint8_t val = 11;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }
        else {
            
            uint8_t val = 10;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }
        
        if(switchLED2.on)
        {
            uint8_t val = 21;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }
        else {
            
            uint8_t val = 20;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }

        if(switchLED3.on)
        {
            uint8_t val = 31;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }
        else {
            
            uint8_t val = 30;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }

        if(switchLED4.on)
        {
            uint8_t val = 41;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }
        else {
            
            uint8_t val = 40;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }

        if(switchLED5.on)
        {
            uint8_t val = 51;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }
        else {
            
            uint8_t val = 50;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }

        if(switchRSSI.on)
        {
            // NSLog(@"\n\n*** Enter:Start RSSI Report");
            [myPeripheral setNotifyValue:YES forCharacteristic:myCharacteristicFFF4]; 
        }
        else 
        {
            // NSLog(@"\n\n*** Enter:Stop RSSI Report");
            [myPeripheral setNotifyValue:NO forCharacteristic:myCharacteristicFFF4]; 
            
        }
        
        if(switchKEY.on)
        {
            // NSLog(@"\n\n*** Enter:Start FFE1 Key");
            [myPeripheral setNotifyValue:YES forCharacteristic:myCharacteristicFFE1]; 
        }
        else 
        {
            // NSLog(@"\n\n*** Enter:Stop FFE1 Key");
            [myPeripheral setNotifyValue:NO forCharacteristic:myCharacteristicFFE1]; 
            
        }
        /*
        if (switchLED5.on) {
            uint8_t val = led5stepper;
            NSData *valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [myPeripheral writeValue:valData forCharacteristic:myCharacteristicFFF1 type:CBCharacteristicWriteWithResponse];
        }
         */

        
    }

}

-(void) playSound:(NSString*)soundFileName
{
    NSString *aFilePath = [[NSBundle mainBundle] pathForResource:soundFileName ofType:@"mp3"];
    if(nil != audioPlayer)
    {
        [audioPlayer stop];
        
    }
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:aFilePath] error:NULL];
    [audioPlayer play];
}

-(void) stopSound
{
    if(nil != audioPlayer)
    {
        [audioPlayer stop];
    }
}
- (void) peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(error==nil)
    {
        // NSLog(@"xxxxxxxxx= %d",peripheral.RSSI.intValue);
        
        //[progressRSSI setProgress:(float)(1.0)];
        [progressRSSI setProgress:(90+peripheral.RSSI.floatValue)/100];

        [labelRSSI setText:[NSString stringWithFormat:@"%ddB",peripheral.RSSI.intValue]];
        
        
        //if((rssi >= -80) && (rssi <= 10))
        //{
            
            //(-80dB  ----  +10dB)
            //[progressRSSI setProgress:(80+peripheral.RSSI.intValue)/90];
        //}

        
        
        if(peripheral.RSSI.intValue > -60)
        {
            if(myTimerCansec == nil)
            {
                myTimerCansec =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(oneSecond:) userInfo:nil repeats:YES];
                [self playSound:@"alarm"];
            }
        }
        else
        {
            [myTimerCansec invalidate];
            [button_Cansec setHidden:YES];
            myTimerCansec = nil;
            [self stopSound];
            
        }
    }
}
///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table View Data Source Methods


//- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//{
//    NSLog(@"\n\n****->numberOfSectionsInTableView()");
//    return 1;   //only a setction.
//}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // NSLog(@"\n\n****->numberOfRowsInSection()");
    // NSLog(@"myMArrayPeripheral count = %d",[myMArrayPeripheral count]);      
    return [self.myMArrayPeripheral count];  //cell number.
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"\n\n****->cellForRowAtIndexPath()*****");

   
    static NSString *simpleTableIdentifier = @"simpleTableIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:simpleTableIdentifier];
    }
    
    myPeripheral = [myMArrayPeripheral objectAtIndex:indexPath.row];
    
    cell.textLabel.text = myPeripheral.name;
    //if(myPeripheral.state == CBPeripheralStateConnected)
    if(myPeripheral.isConnected)
    {
        cell.detailTextLabel.text = @"Connected";
        //[tableViewBLEs selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else 
    {
        cell.detailTextLabel.text = @"Not Connected";
        //[tableViewBLEs deselectRowAtIndexPath:indexPath animated:YES];
    }
   
    
    // NSLog(@"cell row = %d", indexPath.row);
    // NSLog(@"cell text = %@",cell.textLabel.text);
    // NSLog(@"cell subtext = %@",cell.detailTextLabel.text);

    
    return cell;
 
    
}


#pragma mark -
#pragma mark Table Delegate Methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"\n\n****->didSelectRowAtIndexPath()");
   
    static NSInteger preRow = 0;
    
       
    [indicatorScan stopAnimating];
    [indicatorScan setHidden:YES];
    
    myPeripheral = [myMArrayPeripheral objectAtIndex:indexPath.row];
    
    if(preRow != indexPath.row)
    {
        //if(myPeripheral.state == CBPeripheralStateConnected)
        if(myPeripheral.isConnected)
        {
            [myCentralManager cancelPeripheralConnection:myPeripheral];
            //myPeripheral1 = [myMArrayPeripheral objectAtIndex:indexPath.row];
            [myCentralManager connectPeripheral:myPeripheral options:nil];
        }
        else
        {
            
            [myCentralManager stopScan];
            //myPeripheral = [myMArrayPeripheral objectAtIndex:indexPath.row];
            [myCentralManager connectPeripheral:myPeripheral options:nil];
            
        }

    }
    else 
    {
        //if(myPeripheral.state == CBPeripheralStateConnected)
        if(myPeripheral.isConnected)
        {
            [myCentralManager cancelPeripheralConnection:myPeripheral];
            // NSLog(@"peripheral name=%@",myPeripheral.name);
            
        }
        else
        {
            [myCentralManager stopScan];
            [myCentralManager connectPeripheral:myPeripheral options:nil];
            // NSLog(@"peripheral name=%@",myPeripheral.name);
            
        }
    }
 
    preRow = indexPath.row;
    
}



///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

@end