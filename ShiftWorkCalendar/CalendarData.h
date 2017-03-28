//
//  CalendarData.h
//  TestCalendar
//
//  Created by Josh on 2017/3/12.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarData : NSObject
#define CalendarData_Year @"CalendarData_Year"
#define CalendarData_Month @"CalendarData_Month"
#define CalendarData_Day @"CalendarData_Day"
#define CalendarData_Week @"CalendarData_Week"
#define CalendarData_WeekInMonth @"CalendarData_WeekInMonth"
#define CalendarData_FirstDayWeekInMonth @"CalendarData_FirstDayWeekInMonth"
#define CalendarData_DaysTotalInMonth @"CalendarData_DaysTotalInMonth"
#define CalendarData_WeekTotalInMonth @"CalendarData_WeekTotalInMonth"



+(NSMutableDictionary*)getCurrentDateInfo;
+(NSMutableDictionary*)getNextDateInfo:(NSMutableDictionary*)curDateInfo;
+(NSMutableDictionary*)getPrevDateInfo:(NSMutableDictionary*)curDateInfo;
+(NSNumber*)getWeekOfMonthFirstDay:(NSNumber*)month inputYear:(NSNumber*)year;
+(NSNumber*)getWeekTotalInMonth:(NSNumber*)month inputYear:(NSNumber*)year;
+(NSNumber*)getNumberOfDaysInMonth:(NSNumber*)month inputYear:(NSNumber*)year;

@end
