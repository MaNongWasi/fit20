//
//  EncoderB.m
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import "EncoderB.h"


@interface EncoderB()<CBCentralManagerDelegate>
@property (nonatomic, strong)CBCentralManager *manager;
@property (nonatomic) float degree;
@property (nonatomic) NSDictionary* scanOptions;

@end

@implementation EncoderB

+ (EncoderB *)shared
{
    static dispatch_once_t onceToken;
    static EncoderB *class;
    dispatch_once(&onceToken, ^{
        class = [[EncoderB alloc] init];
    });
    NSLog(@"%@", @"bt shared");
    return class;
}


- (void)start {
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.degree = 0;
}

-(void)startScan{
    [self.manager scanForPeripheralsWithServices:nil options:self.scanOptions];
    NSLog(@"B startScan");
}

- (void)stopScan {
    [self.manager stopScan];
    NSLog(@"B stopScan");
}

-(void)stop{
    self.manager.delegate = nil;
    self.manager = nil;
    if ([self.starttimer isValid]) {
        [self.starttimer invalidate];
    }
    if ([self.stoptimer isValid]) {
        [self.stoptimer invalidate];
    }
    
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state == CBCentralManagerStatePoweredOn) {
        // [central scanForPeripheralsWithServices:nil options:nil];
        self.scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];                  // Make sure we start scan from scratch
        [self startScan];
        
        self.stoptimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(stopScan) userInfo:nil repeats:YES];
        self.starttimer = [NSTimer scheduledTimerWithTimeInterval:4.01 target:self selector:@selector(startScan) userInfo:nil repeats:YES];
        
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSDictionary *serviceData = [advertisementData objectForKey:@"kCBAdvDataServiceData"];
    NSDictionary *localName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
    // NSString *address = [NSString stringWithFormat:@"%@", [peripheral.identifier UUIDString]];
    NSString *name = [NSString stringWithFormat:@"%@", localName];
    NSData *eData = [serviceData objectForKey:[CBUUID UUIDWithString:@"1808"]];
    
    //NSString *rssiValue = [NSString stringWithFormat:@"RSSI: %@", RSSI];
    if(!serviceData || !localName){
        return;
    }
    
    NSLog(@"local Name%@", localName);
    
    if ([name isEqual:@"EC00"]) {
        NSLog(@"%@", eData);
        float degree = [self calcEValue:eData];
        char scratchVal[eData.length];
        [eData getBytes:&scratchVal length:3];
        
        self.degree = degree;
        [self.datasetDelegate dataReady:self.degree];
        
    }
}

-(float) calcEValue:(NSData *)data {
    int degree =0;
    char scratchVal[data.length];
    [data getBytes:&scratchVal length:2];
    if (scratchVal[0] < 0) {
        degree = ((scratchVal[1] & 0x0f) * 256 + scratchVal[0] + 256);
    }else{
        degree = ((scratchVal[1] & 0x0f) * 256 + scratchVal[0]);
    }
    degree = degree >> 1;
    return degree * 360 / 1023;
}

@end

