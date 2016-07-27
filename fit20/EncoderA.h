//
//  EncoderA.h
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol ECConnectStatusDelegate <NSObject>

@required

- (void)periphralIsFound:(CBPeripheral *) perName;
- (void)periphralIsConnected;
- (void)serviceIsFound;
- (void)dataIsSent;

@optional
- (void)wrongDevice;

@end

@interface EncoderA : NSObject

@property (weak, nonatomic)id<ECConnectStatusDelegate> connectStatusDelegate;

#define ENCODER_SERVICE_UUID @"FFF0"
#define ENCODER_CHARACTERISTIC_UUID @"FFF3"

+ (EncoderA *)shared;
- (void)start;
- (void)stopScan;
- (void)cleanup;
- (void)connect:(CBPeripheral *)peripheral;
- (void)setData:(char)data_w;

@end
