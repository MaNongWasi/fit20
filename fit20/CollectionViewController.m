//
//  CollectionViewController.m
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import "CollectionViewController.h"
#import "EncoderViewController.h"

@interface CollectionViewController ()

@end


@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButton:(id)sender{
    EncoderViewController *encoderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eView"];
    [self.navigationController pushViewController:encoderViewController animated:YES];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
