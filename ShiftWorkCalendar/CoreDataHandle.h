//
//  CoreDataHandle.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/19.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShiftWorkTypeCoreData+CoreDataProperties.h"
#import "ShiftDateCoreData+CoreDataProperties.h"

#define CoreData_ShiftTypeInfo_TypeID @"CoreData_ShiftTypeInfo_TypeID"
#define CoreData_ShiftTypeInfo_TitleName @"CoreData_ShiftTypeInfo_TitleName"
#define CoreData_ShiftTypeInfo_ShortName @"CoreData_ShiftTypeInfo_ShortName"
#define CoreData_ShiftTypeInfo_Color @"CoreData_ShiftTypeInfo_Color"
#define CoreData_ShiftTypeInfo_Time @"CoreData_ShiftTypeInfo_Time"
#define CoreData_ShiftTypeInfo_Image @"CoreData_ShiftTypeInfo_Image"

#define CoreData_ShiftDateInfo_DateID @"CoreData_ShiftDateInfo_DateID"
#define CoreData_ShiftDateInfo_ShiftTypeID @"CoreData_ShiftDateInfo_ShiftTypeID"
#define CoreData_ShiftDateInfo_CalendarPage @"CoreData_ShiftDateInfo_CalendarPage"
//#define CoreData_ShiftDateInfo_DateInfo @"CoreData_ShiftDateInfo_DateInfo"

#define ShiftTypeInfo_BeginTimeInfo @"ShiftTypeInfo_BeginTimeInfo"
#define ShiftTypeInfo_EndTimeInfo @"ShiftTypeInfo_EndTimeInfo"
#define ShiftTypeInfo_Time_Hour @"ShiftTypeInfo_Time_Hour"
#define ShiftTypeInfo_Time_Minute @"ShiftTypeInfo_Time_Minute"

@interface CoreDataHandle : NSObject
+ (id)shareCoreDatabase;

// ShiftWorkType
- (NSMutableArray*)loadAllShiftWorkType;
- (ShiftWorkTypeCoreData*)addShiftWorkType:(NSMutableDictionary*)typeInfo;
- (void)updateShiftWorkTypeWithTypeID:(NSString *)typeID withShiftWorkType:(NSMutableDictionary*)typeInfo;
- (NSMutableDictionary*)searchShiftWorkTypeOfTypeID:(NSString*)typeID;

- (BOOL)deleteShiftWorkTypeWithTypeID:(NSString *)typeID;

//ShiftDateCoreData
- (NSMutableArray*)loadAllShiftDate;
- (NSMutableDictionary*)searchShiftDateInfoOfCalendarPage:(NSString*)calendarPage;
- (void)addShiftDate:(NSMutableDictionary*)info;
- (void)updateShiftDateOfDateID:(NSString *)dateID withShiftCalendar:(NSMutableDictionary*)info;
- (void)deleteShiftDateOfDateID:(NSString *)dateID;






@end
