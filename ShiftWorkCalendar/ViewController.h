//
//  ViewController.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/12.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Calendar_Date_Notification @"Calendar_Date_Notification"
#define ShiftWorkType_OnAdd_Notification @"ShiftWorkType_OnAdd_Notification"
#define ShiftWorkType_OffAdd_Notification @"ShiftWorkType_OffAdd_Notification"


@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *calendarNavigationItem;

@end

