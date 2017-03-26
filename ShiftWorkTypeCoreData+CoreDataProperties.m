//
//  ShiftWorkTypeCoreData+CoreDataProperties.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/24.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftWorkTypeCoreData+CoreDataProperties.h"

@implementation ShiftWorkTypeCoreData (CoreDataProperties)

+ (NSFetchRequest<ShiftWorkTypeCoreData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ShiftWorkTypeCoreData"];
}

@dynamic typeID;
@dynamic titleName;
@dynamic shortName;
@dynamic color;
@dynamic time;
@dynamic image;

@end
