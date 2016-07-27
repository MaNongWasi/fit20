//
//  ShowViewController.h
//  fit20
//
//  Created by MuBingjie on 16/5/20.
//  Copyright © 2016年 MuBingjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EncoderViewController.h"
#import "UserEntity.h"

@interface ShowViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *qsLabel;
@property (retain,nonatomic) UserEntity *userEntity;
@property (nonatomic) float qs;

@end
