//
//  CalendarInfomationView.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/31.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarInfomationView : UIView

+(CalendarInfomationView*)initCalendarInfomationViewInSubview:(UIView*)view;
@property (strong, nonatomic) IBOutlet UIView *calendarInformationView;
//@property (strong, nonatomic)  UIView *shiftWorkInformationView;

-(void)updateInformation:(NSMutableDictionary*)info;
@end
