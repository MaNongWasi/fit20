//
//  ScanViewController.h
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "EncoderViewController.h"
#import "BLECentral.h"

@interface ScanViewController : UIViewController<BLEConnectStatusDelegate>




@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *bleDevice;
@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong)UIRefreshControl *refreshControl;

@end
