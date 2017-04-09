//
//  ViewController.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/12.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Calendar_Date_Notification @"Calendar_Date_Notification"
#define Calendar_SelectDay_Notification @"Calendar_SelectDay_Notification"

#define ShiftWorkType_ShowAddView_Notification @"ShiftWorkType_ShowAdd_Notification"
#define ShiftWorkType_CloseAddView_Notification @"ShiftWorkType_CloseAddView_Notification"
#define ShiftWorkType_AddShiftType_Notification @"ShiftWorkType_AddShiftType_Notification"

#define CalendarPageView_Reload_Notification @"CalendarPageView_Reload_Notification"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *calendarNavigationItem;

@end

