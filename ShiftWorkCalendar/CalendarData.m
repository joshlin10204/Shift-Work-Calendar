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
    
    NSMutableDictionary *currentDateInfo=[[NSMutableDictionary alloc]init];
    [currentDateInfo setObject:curYear  forKey:@"curYear"];
    [currentDateInfo setObject:curMonth  forKey:@"curMonth"];
    [currentDateInfo setObject:curDay  forKey:@"curDay"];
    [currentDateInfo setObject:curWeek  forKey:@"curWeek"];
    [currentDateInfo setObject:curWeekOfMonth  forKey:@"curWeekOfMonth"];
    [currentDateInfo setObject:weekOfMonthFirstDay  forKey:@"weekOfMonthFirstDay"];
    [currentDateInfo setObject:daysTotalInMonth  forKey:@"daysTotalInMonth"];
    [currentDateInfo setObject:weekTotalInMonth  forKey:@"weekTotalInMonth"];



    return currentDateInfo;
}

+(NSMutableDictionary*)getNextDateInfo:(NSMutableDictionary*)curDateInfo
{
    NSNumber * nextYear=[curDateInfo objectForKey:@"curYear"];
    NSNumber * nextMonth=[curDateInfo objectForKey:@"curMonth"];
    NSNumber * nextDay=[curDateInfo objectForKey:@"curDay"];

    
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
    [nextDateInfo setObject:nextYear  forKey:@"curYear"];
    [nextDateInfo setObject:nextMonth  forKey:@"curMonth"];
    [nextDateInfo setObject:nextDay  forKey:@"curDay"];
    [nextDateInfo setObject:weekOfMonthFirstDay  forKey:@"weekOfMonthFirstDay"];
    [nextDateInfo setObject:daysTotalInMonth  forKey:@"daysTotalInMonth"];
    [nextDateInfo setObject:weekTotalInMonth  forKey:@"weekTotalInMonth"];

    return nextDateInfo;
}
+(NSMutableDictionary*)getPrevDateInfo:(NSMutableDictionary*)curDateInfo
{

    NSNumber * prevYear=[curDateInfo objectForKey:@"curYear"];
    NSNumber * prevMonth=[curDateInfo objectForKey:@"curMonth"];
    NSNumber * prevDay=[curDateInfo objectForKey:@"curDay"];


    
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
    [prevDateInfo setObject:prevYear  forKey:@"curYear"];
    [prevDateInfo setObject:prevMonth  forKey:@"curMonth"];
    [prevDateInfo setObject:prevDay  forKey:@"curDay"];
    [prevDateInfo setObject:weekOfMonthFirstDay  forKey:@"weekOfMonthFirstDay"];
    [prevDateInfo setObject:daysTotalInMonth  forKey:@"daysTotalInMonth"];
    [prevDateInfo setObject:weekTotalInMonth  forKey:@"weekTotalInMonth"];


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
    
    NSLog(@"####!!!!:%ld",(long)daysTotalInMonth);
    
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
    
    NSLog(@"##### :%@",weekTotleInMonth);
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
