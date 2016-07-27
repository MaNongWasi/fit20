//
//  BLECenteral.m
//  fit20
//
//  Created by MuBingjie on 16/5/31.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//
#import "BLECentral.h"

@interface BLECentral()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *p;
@property double record_time;
@property NSString *recordtime;


@end

@implementation BLECentral

+ (BLECentral *)shared
{
    static dispatch_once_t onceToken;
    static BLECentral *class;
    dispatch_once(&onceToken, ^{
        class = [[BLECentral alloc] init];
    });
    NSLog(@"%@", @"ble shared");
    return class;
}


- (void)start {
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)stopScan{
    [self.manager stopScan];
}

- (void)connect:(CBPeripheral *)peripheral{
    self.manager.delegate = self;
    
    [self.manager connectPeripheral:peripheral options:nil];
    self.p = peripheral;
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    
    if (central.state != CBCentralManagerStatePoweredOn) {
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"BLE not supported !" message:[NSString stringWithFormat: @"CoreBluetooth return state: %d", central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alertView show];
    }else{
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}




//call back function when the peripheral is discovered
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Found a BLE Device :%@", peripheral);
    
    [self.connectStatusDelegate periphralIsFound:peripheral];
    if (self.p != peripheral) {
        self.p = peripheral;
        
        
    }
    
}



//call back funtion when the peripheral is discovered
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"%@", @"THE PERIPHERAL HAS BEEN CONNECTED");
    //NSLog(@"%@", [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"]);
    [self.connectStatusDelegate periphralIsConnected];
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"disvocerService");
    BOOL found = false;
    for (CBService *s in peripheral.services){
        if ([s.UUID isEqual:[CBUUID UUIDWithString:ENCODER_SERVICE_UUID]]) {
            found = true;
        }
        [peripheral discoverCharacteristics:nil forService:s];
    }
    if (!found) {
        [self.datasetDelegate wrongDevice];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"Error discovering characteristic: %@", [error localizedDescription]);
        //  [self cleanup];
        return;
    }
    
    if ([service.UUID isEqual:[CBUUID UUIDWithString:ENCODER_SERVICE_UUID]]) {
        for (CBCharacteristic *aChar in service.characteristics) {
            //Request heart rate notifications
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:ENCODER_CHARACTERISTIC_UUID]]) {
                [self.p setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found encoder characteristic");
            }
        }
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    //Get the Heart Rate Monitor BPM
    NSData *data = [characteristic value];
    const uint8_t *reportData = [data bytes];
 //   NSLog(@"%d %d", reportData[0], reportData[1]);
    int degree = ((reportData[0] & 0x3f) * 256 + reportData[1]);
    degree = degree >> 1;
    [self.datasetDelegate dataReady: (degree * 360 / 1023)];
    //NSLog(@"degree %f", (float)(degree * 360 / 1023));
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic.UUID,error);
}


- (void)cleanup {
    
    self.manager.delegate = nil;
    self.manager = nil;
    self.p = nil;
    
}



@end

