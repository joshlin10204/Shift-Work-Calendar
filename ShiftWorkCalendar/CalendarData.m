//
//  CalendarData.m
//  TestCalendar
//
//  Created by Josh on 2017/3/12.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "CalendarData.h"

@implementation CalendarData


+(NSMutableDictionary*)getCurrentDayCalendarInfo
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:[NSDate date]];
    
    NSNumber * curYear=[NSNumber numberWithInteger:dateComponents.year];
    NSNumber * curMonth=[NSNumber numberWithInteger:dateComponents.month];
    NSNumber * weekOfMonthFirstDay=[self getWeekOfMonthFirstDay:curMonth inputYear:curYear];
    NSNumber* daysTotalInMonth=[self getNumberOfDaysInMonth:curMonth inputYear:curYear];
    NSNumber* weekTotalInMonth=[self getWeekTotalInMonth:curMonth inputYear:curYear];
    NSMutableDictionary*allDayInfo=[self getAllDayInfoInCurYear:curYear withMonth:curMonth withDaysTotalInMonth:daysTotalInMonth];
    
    NSMutableDictionary *currentDateInfo=[[NSMutableDictionary alloc]init];
    [currentDateInfo setObject:curYear  forKey:CalendarData_Year];
    [currentDateInfo setObject:curMonth  forKey:CalendarData_Month];
    [currentDateInfo setObject:weekOfMonthFirstDay  forKey:CalendarData_FirstDayWeekInMonth];
    [currentDateInfo setObject:daysTotalInMonth  forKey:CalendarData_DaysTotalInMonth];
    [currentDateInfo setObject:weekTotalInMonth  forKey:CalendarData_WeekTotalInMonth];
    [currentDateInfo setObject:allDayInfo  forKey:CalendarData_AllDayInfo];

    

    return currentDateInfo;
}

+(NSMutableDictionary*)getNextCalendarInfo:(NSMutableDictionary*)curDateInfo
{
    NSNumber * nextYear=[curDateInfo objectForKey:CalendarData_Year];
    NSNumber * nextMonth=[curDateInfo objectForKey:CalendarData_Month];

    
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
    [nextDateInfo setObject:weekOfMonthFirstDay  forKey:CalendarData_FirstDayWeekInMonth];
    [nextDateInfo setObject:daysTotalInMonth  forKey:CalendarData_DaysTotalInMonth];
    [nextDateInfo setObject:weekTotalInMonth  forKey:CalendarData_WeekTotalInMonth];

    return nextDateInfo;
}
+(NSMutableDictionary*)getPrevCalendarInfo:(NSMutableDictionary*)curDateInfo
{

    NSNumber * prevYear=[curDateInfo objectForKey:CalendarData_Year];
    NSNumber * prevMonth=[curDateInfo objectForKey:CalendarData_Month];

    
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

+(NSMutableDictionary*)getAllDayInfoInCurYear:(NSNumber*)year
                                    withMonth:(NSNumber*)month
                         withDaysTotalInMonth:(NSNumber*)total

{
    NSMutableDictionary *allDayInfo=[[NSMutableDictionary alloc]init];

    NSInteger yearInt=[year integerValue];
    NSInteger monthInt=[month integerValue];
    NSInteger dayTotal=[total integerValue];
    for (int i=1; i<=dayTotal; i++)
    {
        NSMutableDictionary *dayInfo=[[NSMutableDictionary alloc]init];
        NSString*day=[[NSString alloc]initWithFormat:@"%d",i];
        NSString*key=[[NSString alloc]initWithFormat:@"%@%@%@",year,month,day];
        NSString*weekString=[self weekdayStringFromYear:yearInt withMonth:monthInt withDay:i];
        [dayInfo setObject:day forKey:CalendarData_AllDayInfo_Day];
        [dayInfo setObject:weekString forKey:CalendarData_AllDayInfo_Week];
        [allDayInfo setObject:dayInfo forKey:key];
    }
    
    
    
    return allDayInfo;
}
+(NSString*)weekdayStringFromYear:(NSInteger)year
                        withMonth:(NSInteger)month
                          withDay:(NSInteger)day
{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSDateComponents *dateComponents=[[NSDateComponents alloc]init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:day];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Taipei"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    

    NSDate *date = [calendar dateFromComponents:dateComponents];
    NSDateComponents *weekComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:weekComponents.weekday];
    
}


@end
