//
//  CoreDataHandle.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/19.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "CoreDataHandle.h"
#import "AppDelegate.h"

@implementation CoreDataHandle
static CoreDataHandle *database;

+ (id)shareCoreDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        database = [[CoreDataHandle alloc] init];
    });
    if (!onceToken)
    {
        
    }
    return database;
}
//返回delegate
- (AppDelegate *)delegate
{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - ShiftWorkType Core Data

- (NSMutableArray*)loadAllShiftWorkType
{
    //創建請求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //設置需要查詢的實體對象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftWorkTypeCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    //設置請求實體
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSArray *coreDatainfos = [[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] mutableCopy];
    
    NSMutableArray *info=[[NSMutableArray alloc]init];
    for (int i=0; i<coreDatainfos.count; i++)
    {
        ShiftWorkTypeCoreData* coreData=coreDatainfos[i];
        NSMutableDictionary*timeInfo=[[NSMutableDictionary alloc]init];
        timeInfo=[NSKeyedUnarchiver unarchiveObjectWithData:coreData.time];
        UIColor *color=[NSKeyedUnarchiver unarchiveObjectWithData:coreData.color];
        UIImage *imgae=[NSKeyedUnarchiver unarchiveObjectWithData:coreData.image];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setObject:coreData.typeID forKey:CoreData_ShiftTypeInfo_TypeID];
        [dic setObject:coreData.titleName forKey:CoreData_ShiftTypeInfo_TitleName];
        [dic setObject:coreData.shortName forKey:CoreData_ShiftTypeInfo_ShortName];
        [dic setObject:timeInfo forKey:CoreData_ShiftTypeInfo_Time];
        [dic setObject:color forKey:CoreData_ShiftTypeInfo_Color];
        //        [dic setObject:imgae forKey:CoreData_ShiftTypeInfo_Image];
        [info addObject:dic];
    }
    
    if (!error)
    {
        return info;
    }
    
    return nil;
    
    
}
- (ShiftWorkTypeCoreData*)addShiftWorkType:(NSMutableDictionary*)typeInfo
{
    NSError *error;
    NSManagedObjectContext *managedContext = [self delegate].persistentContainer.viewContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftWorkTypeCoreData" inManagedObjectContext:managedContext];
    ShiftWorkTypeCoreData *coreData = (ShiftWorkTypeCoreData *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
    coreData.typeID = [typeInfo objectForKey:CoreData_ShiftTypeInfo_TypeID];
    coreData.titleName = [typeInfo objectForKey:CoreData_ShiftTypeInfo_TitleName];
    coreData.shortName = [typeInfo objectForKey:CoreData_ShiftTypeInfo_ShortName];
    coreData.color = [NSKeyedArchiver archivedDataWithRootObject:[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color]];
    coreData.time = [NSKeyedArchiver archivedDataWithRootObject:[typeInfo objectForKey:CoreData_ShiftTypeInfo_Time]];
    coreData.image = [NSKeyedArchiver archivedDataWithRootObject:[typeInfo objectForKey:CoreData_ShiftTypeInfo_Image]];

    
    BOOL result = [[self delegate].persistentContainer.viewContext save:&error];
    if (result) {
        return coreData;
    }
    return nil;
}


- (void)updateShiftWorkTypeWithTypeID:(NSString *)typeID withShiftWorkType:(NSMutableDictionary*)typeInfo
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftWorkTypeCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"typeID = %@",typeID];
    [request setPredicate:predicate];
    NSError *error = nil;
    
    NSArray *infos = [[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] mutableCopy];
    ShiftWorkTypeCoreData *coreData = infos[0];
    coreData.titleName = [typeInfo objectForKey:CoreData_ShiftTypeInfo_TitleName];
    coreData.shortName = [typeInfo objectForKey:CoreData_ShiftTypeInfo_ShortName];
    coreData.color = [NSKeyedArchiver archivedDataWithRootObject:[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color]];
    coreData.time = [NSKeyedArchiver archivedDataWithRootObject:[typeInfo objectForKey:CoreData_ShiftTypeInfo_Time]];
    coreData.image = [NSKeyedArchiver archivedDataWithRootObject:[typeInfo objectForKey:CoreData_ShiftTypeInfo_Image]];
    
    [[self delegate].persistentContainer.viewContext save:nil];

    
}
- (NSMutableDictionary*)searchShiftWorkTypeOfTypeID:(NSString*)typeID
{

    NSFetchRequest *request = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftWorkTypeCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    NSError *error = nil;
    
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"typeID = %@",typeID];
    [request setPredicate:predicate];
    
    NSArray *coreDatainfos = [[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] mutableCopy];
    
    ShiftWorkTypeCoreData* coreData=coreDatainfos[0];
    NSMutableDictionary*timeInfo=[[NSMutableDictionary alloc]init];
    timeInfo=[NSKeyedUnarchiver unarchiveObjectWithData:coreData.time];
    UIColor *color=[NSKeyedUnarchiver unarchiveObjectWithData:coreData.color];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:coreData.typeID forKey:CoreData_ShiftTypeInfo_TypeID];
    [dic setObject:coreData.titleName forKey:CoreData_ShiftTypeInfo_TitleName];
    [dic setObject:coreData.shortName forKey:CoreData_ShiftTypeInfo_ShortName];
    [dic setObject:timeInfo forKey:CoreData_ShiftTypeInfo_Time];
    [dic setObject:color forKey:CoreData_ShiftTypeInfo_Color];
    if (!error)
    {
        return dic;
    }
    
    return nil;



}
- (void)deleteShiftWorkTypeOfTypeID:(NSString *)typeID;
{
    NSFetchRequest *request = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftWorkTypeCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"typeID = %@",typeID];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSManagedObject *obj =[[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] lastObject];
    
    if (obj)
    {
        [[self delegate].persistentContainer.viewContext deleteObject:obj];
        [[self delegate].persistentContainer.viewContext save:nil];
    }


}

#pragma mark - Shift Date Core Data
- (NSMutableArray*)loadAllShiftDate
{
    //創建請求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    //設置需要查詢的實體對象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftDateCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    //設置請求實體
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSArray *coreDatainfos = [[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] mutableCopy];
    
    NSMutableArray *info=[[NSMutableArray alloc]init];
    for (int i=0; i<coreDatainfos.count; i++)
    {
        ShiftDateCoreData* coreData=coreDatainfos[i];
        NSMutableDictionary*dateInfo=[[NSMutableDictionary alloc]init];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setObject:coreData.dateID forKey:CoreData_ShiftDateInfo_DateID];
        [dic setObject:coreData.shiftTypeID forKey:CoreData_ShiftDateInfo_ShiftTypeID];
        [dic setObject:coreData.calendarPage forKey:CoreData_ShiftDateInfo_CalendarPage];

        [info addObject:dic];
    }
    
    if (!error)
    {
        return info;
    }
    
    return nil;

}
- (NSMutableDictionary*)searchShiftDateInfoOfCalendarPage:(NSString*)calendarPage;
{
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftDateCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    NSError *error = nil;
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"calendarPage = %@",calendarPage];
    [request setPredicate:predicate];
    
    NSArray *coreDatainfos = [[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] mutableCopy];
    
    NSMutableDictionary *dateInfo=[[NSMutableDictionary alloc]init];
    for (int i=0; i<coreDatainfos.count; i++)
    {
        NSMutableDictionary *info=[[NSMutableDictionary alloc]init];
        ShiftDateCoreData* coreData=coreDatainfos[i];        
        [info setObject:coreData.dateID forKey:CoreData_ShiftDateInfo_DateID];
        [info setObject:coreData.shiftTypeID forKey:CoreData_ShiftDateInfo_ShiftTypeID];
        [dateInfo setObject:info forKey:coreData.dateID];

    }

    if (!error)
    {
        return dateInfo;
    }
    
    return nil;


}
- (void)addShiftDate:(NSMutableDictionary*)info
{
    NSManagedObjectContext *managedContext = [self delegate].persistentContainer.viewContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftDateCoreData" inManagedObjectContext:managedContext];
    NSError *error = nil;

    
    ShiftDateCoreData *coreData = (ShiftDateCoreData *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
    coreData.dateID = [info objectForKey:CoreData_ShiftDateInfo_DateID];
    coreData.shiftTypeID = [info objectForKey:CoreData_ShiftDateInfo_ShiftTypeID];
    coreData.calendarPage = [info objectForKey:CoreData_ShiftDateInfo_CalendarPage];
    
    
    BOOL result = [[self delegate].persistentContainer.viewContext save:&error];
    if (result) {
        NSLog(@"儲存！");
    }
//    return nil;


}
- (void)updateShiftDateOfDateID:(NSString *)dateID withShiftCalendar:(NSMutableDictionary*)info
{
    NSFetchRequest *request = [NSFetchRequest new];

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftDateCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateID = %@",dateID];
    [request setPredicate:predicate];
    NSError *error = nil;
    
    NSArray *infos = [[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] mutableCopy];
    ShiftDateCoreData *coreData = infos[0];
    coreData.dateID = [info objectForKey:CoreData_ShiftDateInfo_DateID];
    coreData.shiftTypeID = [info objectForKey:CoreData_ShiftDateInfo_ShiftTypeID];
    coreData.calendarPage = [info objectForKey:CoreData_ShiftDateInfo_CalendarPage];
    
    [[self delegate].persistentContainer.viewContext save:nil];


}
- (void)deleteShiftDateOfShiftTypeID:(NSString *)typeID
{
    
    NSFetchRequest *request = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftDateCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shiftTypeID = %@",typeID];
    [request setPredicate:predicate];
    NSError *error = nil;

    NSArray *objArray=[[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] mutableCopy];
    
    for (int i=0; i<objArray.count; i++)
    {
        
        NSManagedObject *obj=objArray[i];
        [[self delegate].persistentContainer.viewContext deleteObject:obj];
        [[self delegate].persistentContainer.viewContext save:nil];
        
    }

    
}



- (void)deleteShiftDateOfDateID:(NSString *)dateID
{
    NSFetchRequest *request = [NSFetchRequest new];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftDateCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateID = %@",dateID];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSManagedObject *obj =[[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] lastObject];
    
    if (obj)
    {
        [[self delegate].persistentContainer.viewContext deleteObject:obj];
        [[self delegate].persistentContainer.viewContext save:nil];
    }


}


@end
