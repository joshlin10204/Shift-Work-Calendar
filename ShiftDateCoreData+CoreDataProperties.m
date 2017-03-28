//
//  ShiftDateCoreData+CoreDataProperties.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/29.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftDateCoreData+CoreDataProperties.h"

@implementation ShiftDateCoreData (CoreDataProperties)

+ (NSFetchRequest<ShiftDateCoreData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ShiftDateCoreData"];
}

@dynamic shiftTypeID;
@dynamic dateID;
@dynamic calendarPage;

@end
