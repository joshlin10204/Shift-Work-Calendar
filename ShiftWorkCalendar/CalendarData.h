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
#define CalendarData_FirstDayWeekInMonth @"CalendarData_FirstDayWeekInMonth"//此月份一號為禮拜幾
#define CalendarData_DaysTotalInMonth @"CalendarData_DaysTotalInMonth"//此月份有幾天
#define CalendarData_WeekTotalInMonth @"CalendarData_WeekTotalInMonth"//此月份有幾禮拜幾

#define CalendarData_AllDayInfo @"CalendarData_AllDayInfo"
#define CalendarData_AllDayInfo_Day @"CalendarData_AllDayInfo_Day"
#define CalendarData_AllDayInfo_Week @"CalendarData_AllDayInfo_Week"
#define CalendarData_AllDayInfo_WeekInMonth @"CalendarData_AllDayInfo_WeekInMonth"


//#define CalendarData_Day @"CalendarData_Day"//本日日期
//#define CalendarData_Week @"CalendarData_Week"//本日為禮拜幾
//#define CalendarData_WeekInMonth @"CalendarData_WeekInMonth"//本日為當月第幾週




+(NSMutableDictionary*)getCurrentDayCalendarInfo;
+(NSMutableDictionary*)getNextCalendarInfo:(NSMutableDictionary*)curDateInfo;
+(NSMutableDictionary*)getPrevCalendarInfo:(NSMutableDictionary*)curDateInfo;
+(NSNumber*)getWeekOfMonthFirstDay:(NSNumber*)month inputYear:(NSNumber*)year;
+(NSNumber*)getWeekTotalInMonth:(NSNumber*)month inputYear:(NSNumber*)year;
+(NSNumber*)getNumberOfDaysInMonth:(NSNumber*)month inputYear:(NSNumber*)year;

@end
