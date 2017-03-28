//
//  ShiftDateCoreData+CoreDataProperties.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/29.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftDateCoreData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShiftDateCoreData (CoreDataProperties)

+ (NSFetchRequest<ShiftDateCoreData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *shiftTypeID;
@property (nullable, nonatomic, copy) NSString *dateID;
@property (nullable, nonatomic, retain) NSData *dateInfo;
@property (nullable, nonatomic, copy) NSString *calendarPage;

@end

NS_ASSUME_NONNULL_END
