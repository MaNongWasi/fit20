//
//  EncoderB.h
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BTDatasetDelegate <NSObject>

@required
- (void)dataReady:(float)degree;
@end

@interface EncoderB: NSObject
@property (weak, nonatomic)id<BTDatasetDelegate> datasetDelegate;
@property (nonatomic)NSTimer *starttimer;
@property (nonatomic)NSTimer *stoptimer;

+ (EncoderB *)shared;
- (void)start;
- (void)stop;
@end
