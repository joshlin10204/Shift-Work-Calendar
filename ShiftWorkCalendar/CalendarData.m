//
//  CalendarData.m
//  TestCalendar
//
//  Created by Josh on 2017/3/12.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "CalendarData.h"

@implementation CalendarData


+(NSMutableDictionary*)getCurrentDateInfo
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:[NSDate date]];
    
    NSNumber * curYear=[NSNumber numberWithInteger:dateComponents.year];
    NSNumber * curMonth=[NSNumber numberWithInteger:dateComponents.month];
    NSNumber * curDay=[NSNumber numberWithInteger:dateComponents.day];
    NSNumber * curWeek=[NSNumber numberWithInteger:dateComponents.weekday];
    NSNumber * curWeekOfMonth=[NSNumber numberWithInteger:dateComponents.weekOfMonth];
    NSNumber * weekOfMonthFirstDay=[self getWeekOfMonthFirstDay:curMonth inputYear:curYear];
    NSNumber* daysTotalInMonth=[self getNumberOfDaysInMonth:curMonth inputYear:curYear];
    NSNumber* weekTotalInMonth=[self getWeekTotalInMonth:curMonth inputYear:curYear];
    
    NSLog(@"~~~~:%@",curWeek);
    NSMutableDictionary *currentDateInfo=[[NSMutableDictionary alloc]init];
    [currentDateInfo setObject:curYear  forKey:CalendarData_Year];
    [currentDateInfo setObject:curMonth  forKey:CalendarData_Month];
    [currentDateInfo setObject:curDay  forKey:CalendarData_Day];
    [currentDateInfo setObject:curWeek  forKey:CalendarData_Week];
    [currentDateInfo setObject:curWeekOfMonth  forKey:CalendarData_WeekInMonth];
    [currentDateInfo setObject:weekOfMonthFirstDay  forKey:CalendarData_FirstDayWeekInMonth];
    [currentDateInfo setObject:daysTotalInMonth  forKey:CalendarData_DaysTotalInMonth];
    [currentDateInfo setObject:weekTotalInMonth  forKey:CalendarData_WeekTotalInMonth];



    return currentDateInfo;
}

+(NSMutableDictionary*)getNextDateInfo:(NSMutableDictionary*)curDateInfo
{
    NSNumber * nextYear=[curDateInfo objectForKey:CalendarData_Year];
    NSNumber * nextMonth=[curDateInfo objectForKey:CalendarData_Month];
    NSNumber * nextDay=[curDateInfo objectForKey:CalendarData_Day];

    
    NSInteger newYear = [nextYear integerValue];
    NSInteger newMonth = [nextMonth integerValue];
    
    if (newMonth==12)
    {
        newMonth=1;
        newYear++;
    }
    else
    {
        newMonth++;
        
    }
    nextYear=[NSNumber numberWithInteger:newYear];
    nextMonth=[NSNumber numberWithInteger:newMonth];
    NSNumber * weekOfMonthFirstDay=[self getWeekOfMonthFirstDay:nextMonth inputYear:nextYear];
    NSNumber* daysTotalInMonth=[self getNumberOfDaysInMonth:nextMonth inputYear:nextYear];
    NSNumber* weekTotalInMonth=[self getWeekTotalInMonth:nextMonth inputYear:nextYear];

    
    NSMutableDictionary *nextDateInfo=[[NSMutableDictionary alloc]init];
    [nextDateInfo setObject:nextYear  forKey:CalendarData_Year];
    [nextDateInfo setObject:nextMonth  forKey:CalendarData_Month];
    [nextDateInfo setObject:nextDay  forKey:CalendarData_Day];
    [nextDateInfo setObject:weekOfMonthFirstDay  forKey:CalendarData_FirstDayWeekInMonth];
    [nextDateInfo setObject:daysTotalInMonth  forKey:CalendarData_DaysTotalInMonth];
    [nextDateInfo setObject:weekTotalInMonth  forKey:CalendarData_WeekTotalInMonth];

    return nextDateInfo;
}
+(NSMutableDictionary*)getPrevDateInfo:(NSMutableDictionary*)curDateInfo
{

    NSNumber * prevYear=[curDateInfo objectForKey:CalendarData_Year];
    NSNumber * prevMonth=[curDateInfo objectForKey:CalendarData_Month];
    NSNumber * prevDay=[curDateInfo objectForKey:CalendarData_Day];


    
    NSInteger newYear = [prevYear integerValue];
    NSInteger newMonth = [prevMonth integerValue];
    
    if (newMonth==1)
    {
        newMonth=12;
        newYear--;
    }
    else
    {
        newMonth--;
    
    }
    
    prevYear=[NSNumber numberWithInteger:newYear];
    prevMonth=[NSNumber numberWithInteger:newMonth];
    NSNumber * weekOfMonthFirstDay=[self getWeekOfMonthFirstDay:prevMonth inputYear:prevYear];
    NSNumber* daysTotalInMonth=[self getNumberOfDaysInMonth:prevMonth inputYear:prevYear];
    NSNumber* weekTotalInMonth=[self getWeekTotalInMonth:prevMonth inputYear:prevYear];

    NSMutableDictionary *prevDateInfo=[[NSMutableDictionary alloc]init];
    [prevDateInfo setObject:prevYear  forKey:CalendarData_Year];
    [prevDateInfo setObject:prevMonth  forKey:CalendarData_Month];
    [prevDateInfo setObject:prevDay  forKey:CalendarData_Day];
    [prevDateInfo setObject:weekOfMonthFirstDay  forKey:CalendarData_FirstDayWeekInMonth];
    [prevDateInfo setObject:daysTotalInMonth  forKey:CalendarData_DaysTotalInMonth];
    [prevDateInfo setObject:weekTotalInMonth  forKey:CalendarData_WeekTotalInMonth];


    return prevDateInfo;
}




//取得每個月的第一天是禮拜幾
+(NSNumber*)getWeekOfMonthFirstDay:(NSNumber*)month inputYear:(NSNumber*)year
{
    NSInteger monthInt = [month integerValue];
    NSInteger yearInt = [year integerValue];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
    [greCalendar setTimeZone: timeZone];

    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setMonth:monthInt];
    [dateComponentsForDate setYear:yearInt];
    [dateComponentsForDate setDay:1];
    NSDate *date = [greCalendar dateFromComponents:dateComponentsForDate];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [greCalendar components:calendarUnit fromDate:date];
    
    NSNumber * curWeekOfMonthFirstDay=[NSNumber numberWithInteger:theComponents.weekday];
    return curWeekOfMonthFirstDay;
    
}
+(NSNumber*)getWeekTotalInMonth:(NSNumber*)month inputYear:(NSNumber*)year
{
    NSInteger daysTotalInMonth=[[self getNumberOfDaysInMonth:month inputYear:year]integerValue];
    NSInteger monthInt = [month integerValue];
    NSInteger yearInt = [year integerValue];
    
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
    [greCalendar setTimeZone: timeZone];
    
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setMonth:monthInt];
    [dateComponentsForDate setYear:yearInt];
    [dateComponentsForDate setDay:daysTotalInMonth];
    NSDate *date = [greCalendar dateFromComponents:dateComponentsForDate];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekOfMonth;
    NSDateComponents *theComponents = [greCalendar components:calendarUnit fromDate:date];
    
    NSNumber * weekTotleInMonth=[NSNumber numberWithInteger:theComponents.weekOfMonth];
    
    return weekTotleInMonth;



}



//取得月份有幾天
+(NSNumber*)getNumberOfDaysInMonth:(NSNumber*)month inputYear:(NSNumber*)year

{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger monthInt = [month integerValue];
    NSInteger yearInt = [year integerValue];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
    [greCalendar setTimeZone: timeZone];
    
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setMonth:monthInt];
    [dateComponentsForDate setYear:yearInt];
    
    NSDate *date = [greCalendar dateFromComponents:dateComponentsForDate];

    
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    NSNumber *daysCount = [NSNumber numberWithInteger:range.length];

    return daysCount;
}


@end
