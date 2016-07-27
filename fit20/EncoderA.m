//
//  EncoderA.m
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import "EncoderA.h"

@interface EncoderA()<CBCentralManagerDelegate, CBPeripheralDelegate>


@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *p;
@end

@implementation EncoderA

char data;

+ (EncoderA *)shared
{
    static dispatch_once_t onceToken;
    static EncoderA *class;
    dispatch_once(&onceToken, ^{
        class = [[EncoderA alloc] init];
    });
    NSLog(@"%@", @"ble shared");
    return class;
}


- (void)start {
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    data = 0x01;
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
        [self.connectStatusDelegate wrongDevice];
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
                [self.p writeValue: [NSData dataWithBytes:&data length:1] forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
                NSLog(@"Found encoder characteristic");
            }
        }
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic.UUID,error);
    [self cleanup];
    [self.connectStatusDelegate dataIsSent];
}


- (void)cleanup {
    self.manager.delegate = nil;
    self.manager = nil;
    self.p = nil;
    
}

- (void)setData:(char)data_w{
    data = data_w;
}

@end
