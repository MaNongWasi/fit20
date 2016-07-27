//
//  BLECentral.h
//  fit20
//
//  Created by MuBingjie on 16/5/31.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BLEConnectStatusDelegate <NSObject>

@required

- (void)periphralIsFound:(CBPeripheral *) perName;
- (void)periphralIsConnected;
- (void)serviceIsFound;

@end

@protocol BLEDatasetDelegate <NSObject>

@required
- (void)dataReady:(float)encode;

@optional
- (void)wrongDevice;

@end

@interface BLECentral : NSObject

#define ENCODER_SERVICE_UUID @"FFF0"
#define ENCODER_CHARACTERISTIC_UUID @"FFF4"


@property (weak, nonatomic)id<BLEConnectStatusDelegate> connectStatusDelegate;
@property (weak, nonatomic)id<BLEDatasetDelegate> datasetDelegate;


+ (BLECentral *)shared;
- (void)start;
- (void)stopScan;
- (void)cleanup;
- (void)connect:(CBPeripheral *)peripheral;

@end
