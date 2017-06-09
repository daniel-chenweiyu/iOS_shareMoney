//
//  EventViewController.h
//  ShareMoney
//
//  Created by Daniel on 2017/2/20.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

#define NSNOTIFICATIONCENTER_RELOAD_TABLE_VIEW @"reloadData"


@interface EventViewController : UIViewController
@property (nonatomic,strong) NSString * dateString;
@end
