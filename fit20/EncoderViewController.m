//
//  EncoderViewController.m
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import "EncoderViewController.h"
#import "ShowViewController.h"
#import "UserEntity.h"


// the number of cycles, for example, if it is 5, it means (10sec forward + 10sec backforward)*5
int NUMBER_OF_CYCLES = 5;

// The max valid degree, that means the valid degree range for the system now is 0 - 300°. When the axis of exercise equipment turns to 90°(the max degree of all the equipment),the encoder is at 300°position.  (64mm/49.7mm)*(29mm/11mm)=3.395   64mm is the diameter of axis, 49.7mm is diameter of two big part pulleys, 29mm is diameter of middle small axis between tow big parts pulleys, 11mm is diameter of aluminum pulley concentric with the encoder.
float MAX_DEGREE = 305.54;  //

// the standard deviation of good performance
float VELOCITY_CONST = 0.2;

// the "standard deviation" of good performance
float PROGRESS_CONST = 0.2;

// the inverse proportional coefficent in formula for integrating qs1 and qs2
int INVERSE_PRO_COEFF = 300;

//

@interface EncoderViewController ()

@end

@implementation EncoderViewController

//@synthesize Progress = _Progress;

- (IBAction)Start:(id)sender{
    
    self.n = 0;
    
    if (self.n < NUMBER_OF_CYCLES + 1){
        self.m = 0;
        self.Progress00.progress = 0.0;
        self.rootsum = 0;
        self.sum = 0;
        self.sdsq = 0;
        self.a = 0;
        self.j = 0;
        
        self.Calibration.hidden = YES;
        self.OK.hidden = YES;
        if ([timer isValid]) {
            [timer invalidate];
            timer=nil;
        }

        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];

        
    }
    
}

- (IBAction)Calibrate:(id)sender{
    self.i = 2;
}

- (IBAction)Ok:(id)sender{
    self.i = 1;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bluetoothCentral = [BLECentral shared];
    self.bluetoothCentral.datasetDelegate = self;
    
    [self.time setText:[NSString stringWithFormat:@"%i", 0]];
    [self.pro11 setText:[NSString stringWithFormat:@"%i", 0]];
//    [self.encoderLabel setText:[NSString stringWithFormat:@"%i", 0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)dataReady:(float)degree{
    self.degree_l1.text = [NSString stringWithFormat:@"%.2f", degree];
    NSLog(@"%f", degree);
    
    if (degree <= 330){
        
        //set the limit of exercise person/ calibration
        if (self.i == 2){
            self.limit = degree;
            
            self.pro22.text = [NSString stringWithFormat:@"%.0f%%",degree/self.limit*100];
            
            self.Progress22.progress = degree/self.limit;
            self.Progress33.progress = degree/self.limit;
            self.Progress44.progress = degree/self.limit;
            self.Progress55.progress = degree/self.limit;
            self.Progress66.progress = degree/self.limit;
        }
        
        
        //if the OK button is pressed, calibration is confirmed
        if (self.i == 1){
            
            self.pro22.text = [NSString stringWithFormat:@"%.0f%%",degree/self.limit*100];
            
            self.Progress22.progress = degree/self.limit;
            self.Progress33.progress = degree/self.limit;
            self.Progress44.progress = degree/self.limit;
            self.Progress55.progress = degree/self.limit;
            self.Progress66.progress = degree/self.limit;
        }
        //if the OK button is not pressed, the calibration is invalid
        else{
            self.pro22.text = [NSString stringWithFormat:@"%.0f%%",degree/MAX_DEGREE*100];
            self.Progress22.progress = degree/MAX_DEGREE;
            self.Progress33.progress = degree/MAX_DEGREE;
            self.Progress44.progress = degree/MAX_DEGREE;
            self.Progress55.progress = degree/MAX_DEGREE;
            self.Progress66.progress = degree/MAX_DEGREE;
            
        }
        
    }
    else{
        self.Progress22.progress = 0.0;
        self.Progress33.progress = 0.0;
        self.Progress44.progress = 0.0;
        self.Progress55.progress = 0.0;
        self.Progress66.progress = 0.0;
        
    }
    
    
}

-(void)scan{
    NSLog(@"scan");
}



-(void)periphralIsFound:(CBPeripheral *)perName{
    NSLog(@"i found %@", perName.name);
    
}

-(void)periphralIsConnected{
    NSLog(@"connect");
}

-(void)serviceIsFound{
    NSLog(@"found service");
}

-(void)dataIsSent{
    NSLog(@"data is sent");
}

-(void)update
{
    
    float floatString1 = [self.pro11.text floatValue];
    float floatString2 = [self.pro22.text floatValue];   //transfer the string type into int value
    
    //Go process
    if (self.m <= 100){
        
        self.Progress00.progress = self.Progress00.progress + 0.01;        //the step of standard progress is 0.01(1%)
        self.Progress11.progress = 0.0;
        self.pro11.text = [NSString stringWithFormat:@"%.0f%%",self.Progress00.progress * 100];
        self.time.text = [NSString stringWithFormat:@"%.0f",self.Progress00.progress * 10];
        self.m ++;
        
        if ((floatString2 - floatString1)>= 15){
            //when 1.5+ sec faster, bright red, and red rabbit appears
            
            self.redRabbit.hidden = NO;
            self.lightRedRabbit.hidden = YES;
            self.smile.hidden = YES;
            self.lightBlueTurtle.hidden = YES;
            self.darkBlueTurtle.hidden = YES;
            
            self.Progress22.hidden = NO;
            self.Progress33.hidden = YES;
            self.Progress44.hidden = YES;
            self.Progress55.hidden = YES;
            self.Progress66.hidden = YES;
        }
        
        else if ((floatString2 - floatString1)< 15 && (floatString2 - floatString1)>= 5){
            
            //when 0.5+ sec faster light red, and light red rabbit appears
            
            self.redRabbit.hidden = YES;
            self.lightRedRabbit.hidden = NO;
            self.smile.hidden = YES;
            self.lightBlueTurtle.hidden = YES;
            self.darkBlueTurtle.hidden = YES;
            
            self.Progress22.hidden = YES;
            self.Progress33.hidden = NO;
            self.Progress44.hidden = YES;
            self.Progress55.hidden = YES;
            self.Progress66.hidden = YES;
            
            
        }
        
        else if (((floatString2 - floatString1)< 5 && (floatString2 - floatString1)> 0 ) || ((floatString1 - floatString2)< 5 && (floatString1 - floatString2)> 0 )){
            //not more than 0.5 sec faster or slower, green, and smile icon appears
            
            self.redRabbit.hidden = YES;
            self.lightRedRabbit.hidden = YES;
            self.smile.hidden = NO;
            self.lightBlueTurtle.hidden = YES;
            self.darkBlueTurtle.hidden = YES;
            
            self.Progress22.hidden = YES;
            self.Progress33.hidden = YES;
            self.Progress44.hidden = NO;
            self.Progress55.hidden = YES;
            self.Progress66.hidden = YES;
            
        }
        
        else if ((floatString1 - floatString2)< 15 && (floatString1 - floatString2)>= 5){
            //when 0.5+ sec slower light blue, and light blue turtle appears
            
            self.redRabbit.hidden = YES;
            self.lightRedRabbit.hidden = YES;
            self.smile.hidden = YES;
            self.lightBlueTurtle.hidden = NO;
            self.darkBlueTurtle.hidden = YES;
            
            self.Progress22.hidden = YES;
            self.Progress33.hidden = YES;
            self.Progress44.hidden = YES;
            self.Progress55.hidden = NO;
            self.Progress66.hidden = YES;
            
            
        }
        
        else if ((floatString1 - floatString2)>= 15){
            // 1.5+ sec slower dark blue, and blue trutle appears
            
            self.redRabbit.hidden = YES;
            self.lightRedRabbit.hidden = YES;
            self.smile.hidden = YES;
            self.lightBlueTurtle.hidden = YES;
            self.darkBlueTurtle.hidden = NO;
            
            self.Progress22.hidden = YES;
            self.Progress33.hidden = YES;
            self.Progress44.hidden = YES;
            self.Progress55.hidden = YES;
            self.Progress66.hidden = NO;
        }
        
    }
    
    //Back process
    if (self.m >= 101){
        
        //Five back processes
        if (self.n < NUMBER_OF_CYCLES){
            
            self.Progress00.progress = self.Progress00.progress - 0.01;
            
            self.pro11.text = [NSString stringWithFormat:@"%.0f%%",self.Progress00.progress * 100];
            self.time.text = [NSString stringWithFormat:@"%.0f",self.Progress00.progress * 10];
            self.m ++;
            
            if (self.Progress00.progress == 0){
                self.m = 0;
            }
            
            if ((floatString1 - floatString2)>= 15){
                //when 1.5+ sec faster, bright red
                
                self.lightRedRabbit.hidden = YES;
                self.lightBlueTurtle.hidden = YES;
                self.darkBlueTurtle.hidden = YES;
                self.smile.hidden = YES;
                self.redRabbit.hidden = NO;
                
                self.Progress22.hidden = NO;
                self.Progress33.hidden = YES;
                self.Progress44.hidden = YES;
                self.Progress55.hidden = YES;
                self.Progress66.hidden = YES;
                
                
            }
            
            else if ((floatString1 - floatString2)< 15 && (floatString1 - floatString2)>= 5){
                //when 0.5+ sec faster light red
                
                self.redRabbit.hidden = YES;
                self.lightBlueTurtle.hidden = YES;
                self.darkBlueTurtle.hidden = YES;
                self.smile.hidden = YES;
                self.lightRedRabbit.hidden = NO;
                
                self.Progress22.hidden = YES;
                self.Progress33.hidden = NO;
                self.Progress44.hidden = YES;
                self.Progress55.hidden = YES;
                self.Progress66.hidden = YES;
                
            }
            
            else if (((floatString1 - floatString2)< 5 && (floatString1 - floatString2)> 0 ) || ((floatString2 - floatString1)< 5 && (floatString2 - floatString1)> 0 )){
                //not more than 0.5 sec faster or slower, green
                
                self.redRabbit.hidden = YES;
                self.lightRedRabbit.hidden = YES;
                self.lightBlueTurtle.hidden = YES;
                self.darkBlueTurtle.hidden = YES;
                self.smile.hidden = NO;
                
                self.Progress22.hidden = YES;
                self.Progress33.hidden = YES;
                self.Progress44.hidden = NO;
                self.Progress55.hidden = YES;
                self.Progress66.hidden = YES;
                
                
            }
            
            else if ((floatString2 - floatString1)< 15 && (floatString2 - floatString1)>= 5){
                //when 0.5+ sec slower light blue
                
                self.redRabbit.hidden = YES;
                self.lightRedRabbit.hidden = YES;
                self.darkBlueTurtle.hidden = YES;
                self.smile.hidden = YES;
                self.lightBlueTurtle.hidden = NO;
                
                self.Progress22.hidden = YES;
                self.Progress33.hidden = YES;
                self.Progress44.hidden = YES;
                self.Progress55.hidden = NO;
                self.Progress66.hidden = YES;
                
                
            }
            
            else if ((floatString2 - floatString1)>= 15){
                // 1.5+ sec slower dark blue
                
                self.redRabbit.hidden = YES;
                self.lightRedRabbit.hidden = YES;
                self.lightBlueTurtle.hidden = YES;
                self.smile.hidden = YES;
                self.darkBlueTurtle.hidden = NO;
                
                self.Progress22.hidden = YES;
                self.Progress33.hidden = YES;
                self.Progress44.hidden = YES;
                self.Progress55.hidden = YES;
                self.Progress66.hidden = NO;
                
            }
            
        }
        
        
        
        //the fifth time back, standard progress is always 100%, but the timer is still counting down
        if (self.n == NUMBER_OF_CYCLES){
            self.Progress00.progress = self.Progress00.progress - 0.01;
            self.Progress11.progress = 1.0;
            
            self.pro11.text = [NSString stringWithFormat:@"100%%"];
            self.time.text = [NSString stringWithFormat:@"%.0f",self.Progress00.progress * 10];
            
            self.redRabbit.hidden = YES;
            self.lightRedRabbit.hidden = YES;
            self.lightBlueTurtle.hidden = YES;
            self.darkBlueTurtle.hidden = YES;
            self.smile.hidden = NO;
            
            self.m ++;
            
            if (self.Progress00.progress == 0){
                self.m = 0;
            }
            
        }
    }
    
    
    if (self.m == 201){
        self.n ++;
    }
    
    if(self.m % 5 == 0){
        self.root = (floatString2 - floatString1)*(floatString2 - floatString1);
        self.rootsum = self.rootsum + self.root;
        self.a++;
        self.falsesd = sqrtf(self.rootsum/self.a);
        self.qs1 = self.falsesd/PROGRESS_CONST;
    }
    
    if ((self.m % 5 == 0 )&& (self.m % 10 != 0)){
        self.x = floatString2;
    }
    if (self.m % 10 == 0 && self.m != 0){
        self.y = floatString2;
        
    }
    self.velocity = fabsf(self.x - self.y);
    
    self.sum = self.sum + self.velocity;
    self.j++;
    self.ave = self.sum / self.j;
    self.sdsq = self.sdsq + (self.velocity - self.ave)*(self.velocity - self.ave);
    self.sd = sqrtf(self.sdsq/self.j);
    self.qs2 = self.sd/VELOCITY_CONST;
    
    self.qs3 = INVERSE_PRO_COEFF/(self.qs1 + self. qs2);
    
    if (self.qs3 <= 1){
        self.qs = 0.0;
    }
    else if (self.qs3 >= 10){
        self.qs = 10.0;
    }
    else{
        self.qs = 9.6 * log10(self.qs3);
    }
    
//    NSLog(@"以下是qs1");
//    NSLog(@"%.2f", self.qs1);
//    NSLog(@"以下是qs2");
//    NSLog(@"%.2f", self.qs2);
//    NSLog(@"以下是qs3");
//    NSLog(@"%.2f", self.qs3);
//    NSLog(@"以下是qs");
//    NSLog(@"%.2f", self.qs);
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        UserEntity *userEntity = [[UserEntity alloc]init];
        userEntity.qs = self.qs;
        
        ShowViewController *showcontroller =[self.storyboard instantiateViewControllerWithIdentifier:@"show"];
        showcontroller.userEntity = userEntity;
        [self.navigationController pushViewController:showcontroller animated:YES];
        
        
    }
    
}

- (IBAction)Over:(id)sender{
    [timer invalidate];
    [timer invalidate];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Well done!"
                          message:@"Show my score"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles: @"Yes",nil];
    [alert show];
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



