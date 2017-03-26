//
//  ShiftWorkTypeCoreData+CoreDataProperties.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/24.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftWorkTypeCoreData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ShiftWorkTypeCoreData (CoreDataProperties)

+ (NSFetchRequest<ShiftWorkTypeCoreData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *typeID;
@property (nullable, nonatomic, copy) NSString *titleName;
@property (nullable, nonatomic, copy) NSString *shortName;
@property (nullable, nonatomic, retain) NSData *color;
@property (nullable, nonatomic, retain) NSData *time;
@property (nullable, nonatomic, retain) NSData *image;

@end

NS_ASSUME_NONNULL_END
