//
//  EncoderViewController.h
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLECentral.h"

@interface EncoderViewController : UIViewController<BLEDatasetDelegate>
{
    
    UIProgressView *Progress;
    NSTimer *timer;
    
}
@property (weak, nonatomic) IBOutlet UILabel *pro11;
@property (weak, nonatomic) IBOutlet UILabel *pro22;

@property (weak, nonatomic) IBOutlet UIButton *Calibration;
@property (weak, nonatomic) IBOutlet UIButton *OK;
@property (weak, nonatomic) IBOutlet UIButton *Start;
@property (weak, nonatomic) IBOutlet UIButton *Over;



@property (weak, nonatomic) IBOutlet UILabel *degree_l1;
@property (strong, nonatomic) CBPeripheral *p;

//for timer
@property (nonatomic) int m;           //used for count per timer cycle
@property (nonatomic) int n;           //used for count 5 timer cycles

//for calibration
@property (nonatomic) int i;           //choose the mode of calibration or OK
@property (nonatomic) float limit;     //used for calibration, the limit for the exercise person

//for method 2 in quality score
@property (nonatomic) int a;
@property (nonatomic) float root;      //square of difference between floatstring1 and floatstring2
@property (nonatomic) float rootsum;   //sum of root
@property (nonatomic) float falsesd;   //the "standard deviation" regarding process(method 2)
@property (nonatomic) float qs1;       //quality score 1 = falsesd/10

//for method 1 in quality score
@property (nonatomic) float x;           //the encode data when m = 5, 15,25...
@property (nonatomic) float y;           //the encode data when m = 10, 20,30...
@property (nonatomic) int j;             //the number of |x-y| (the number of items in the standard deviation formula)
@property (nonatomic) double velocity;  //velocity = |x-y|   (velocity = |x-y|/1sec
@property (nonatomic) double sum;       //sum of velocity for average value
@property (nonatomic) double ave;       //average value of velocity
@property (nonatomic) double sdsq;      //the square value of real standard deviation
@property (nonatomic) double sd;        //the real standard deviation of velocity
@property (nonatomic) float qs2;        //quality score 2 = sd/10

//for calculation of quality score
@property (nonatomic) float qs3;        //qs3 = (qs1 +qs2)/2
@property (nonatomic) float qs;


@property (nonatomic) NSString *userEntity;   //for transfer value from interface 3 to interface 4

//@property (strong, nonatomic) IBOutlet UILabel *time;        //timer count on the top
//@property (strong, nonatomic) IBOutlet UILabel *pro1;        //percentage of the standard progress bar
//@property (strong, nonatomic) IBOutlet UILabel *pro2;        //percentage of the real progress bar
//@property (strong, nonatomic) IBOutlet UILabel *encoderLabel;     //position of encoder


@property (weak, nonatomic) IBOutlet UIImageView *darkBlueTurtle;
@property (weak, nonatomic) IBOutlet UIImageView *lightBlueTurtle;
@property (weak, nonatomic) IBOutlet UIImageView *smile;
@property (weak, nonatomic) IBOutlet UIImageView *lightRedRabbit;
@property (weak, nonatomic) IBOutlet UIImageView *redRabbit;



@property (weak, nonatomic) IBOutlet UIProgressView *Progress00;
@property (weak, nonatomic) IBOutlet UIProgressView *Progress11;
@property (weak, nonatomic) IBOutlet UIProgressView *Progress22;
@property (weak, nonatomic) IBOutlet UIProgressView *Progress33;
@property (weak, nonatomic) IBOutlet UIProgressView *Progress44;
@property (weak, nonatomic) IBOutlet UIProgressView *Progress55;
@property (weak, nonatomic) IBOutlet UIProgressView *Progress66;

@property(nonatomic) BLECentral *bluetoothCentral;




@property (assign, nonatomic) NSTimer *_timer;
@property (weak, nonatomic) IBOutlet UILabel *time;


- (IBAction)Start:(id)sender;
- (IBAction)Over:(id)sender;
- (IBAction)Calibrate:(id)sender;
- (IBAction)Ok:(id)sender;


@end



