//
//  CoreDataHandle.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/19.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShiftWorkTypeCoreData+CoreDataProperties.h"

#define CoreData_ShiftTypeInfo_TypeID @"CoreData_ShiftTypeInfo_TypeID"
#define CoreData_ShiftTypeInfo_TitleName @"CoreData_ShiftTypeInfo_TitleName"
#define CoreData_ShiftTypeInfo_ShortName @"CoreData_ShiftTypeInfo_ShortName"
#define CoreData_ShiftTypeInfo_Color @"CoreData_ShiftTypeInfo_Color"
#define CoreData_ShiftTypeInfo_Time @"CoreData_ShiftTypeInfo_Time"
#define CoreData_ShiftTypeInfo_Image @"CoreData_ShiftTypeInfo_Image"


@interface CoreDataHandle : NSObject
+ (id)shareCoreDatabase;

// ShiftWorkType
- (ShiftWorkTypeCoreData*)addShiftWorkType:(NSMutableDictionary*)typeInfo;
- (NSMutableArray*)loadAllShiftWorkType;
- (void)updateShiftWorkTypeWithTypeID:(NSString *)typeID withShiftWorkType:(NSMutableDictionary*)typeInfo;
- (BOOL)deleteShiftWorkTypeWithTypeID:(NSString *)typeID;






@end
