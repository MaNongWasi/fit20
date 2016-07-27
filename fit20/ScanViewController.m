//
//  ScanViewController.m
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import "ScanViewController.h"
#import "CollectionViewController.h"

@interface ScanViewController ()
@property (strong, nonatomic)BLECentral *bluetoothCenteral;
@end

@implementation ScanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Do any additional setup after loading the view.
    
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    self.refreshControl.backgroundColor = [UIColor blueColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl = refreshControl;
    
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    
    
    
    self.bleDevice = [[NSMutableArray alloc]init];
    self.title = @"Choose your Encoder";
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.bluetoothCenteral = [BLECentral shared];
    self.bluetoothCenteral.connectStatusDelegate = self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated{
    
    [self.bluetoothCenteral cleanup];
    [self.bluetoothCenteral start];
    [self.bleDevice removeAllObjects];
}

- (void)refresh{
    
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bleDevice.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"%ld_Cell", (long)indexPath.row]];
    CBPeripheral *device = [self.bleDevice objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", device.name];
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", CFUUIDCreateString(nil, device.UUID)];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", device.description];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    if (section == 0)
        [footerView setBackgroundColor:[UIColor clearColor]];
    
    return footerView;
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        if (self.bleDevice.count > 1) return [NSString stringWithFormat:@"%ld BLE Device Found", (long)self.bleDevice.count];
        
        else return [NSString stringWithFormat:@"%ld SensorTag Found", (long)self.bleDevice.count];
        
    }
    
    return @"";
}


- (double) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0f;
}



- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.bluetoothCenteral stopScan];
    CBPeripheral *p = [self.bleDevice objectAtIndex:indexPath.row];
    [self.bluetoothCenteral connect: p];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //self.navigationController.navigationBar.translucent= YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
  
    CollectionViewController *evc = [self.storyboard instantiateViewControllerWithIdentifier:@"sports"];
    [self.navigationController pushViewController:evc animated:YES];
    

    
}


-(void)periphralIsFound:(CBPeripheral *)perName{
    NSLog(@"i found %@", perName.name);
    BOOL replace = NO;
    
    for (int ii = 0; ii < self.bleDevice.count; ii++) {
        CBPeripheral *dd = [self.bleDevice objectAtIndex:ii];
        NSLog(@"check device %d", ii);
        if ([dd isEqual:perName]) {
            [self.bleDevice replaceObjectAtIndex:ii withObject:perName];
            replace = YES;
            //            NSLog(@"replace");
        }
    }
    
    if (!replace) {
        [self.bleDevice addObject:perName];
        [self.tableView reloadData];
    }else{
        NSLog(@"replace");
    }
}

-(void)periphralIsConnected{
    NSLog(@"connect");
}

-(void)serviceIsFound{
    NSLog(@"found service");
}

@end

