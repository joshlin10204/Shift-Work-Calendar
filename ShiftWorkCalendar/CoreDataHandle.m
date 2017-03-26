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
- (ShiftWorkTypeCoreData*)addShiftWorkType:(NSMutableDictionary*)typeInfo
{
    NSError *error;
    NSLog(@"0------%@", [typeInfo objectForKey:CoreData_ShiftTypeInfo_TitleName]);
    
    NSManagedObjectContext *managedContext = [self delegate].persistentContainer.viewContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftWorkTypeCoreData" inManagedObjectContext:managedContext];
    ShiftWorkTypeCoreData *shiftWorkType = (ShiftWorkTypeCoreData *)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
    shiftWorkType.typeID = [typeInfo objectForKey:CoreData_ShiftTypeInfo_TypeID];
    shiftWorkType.titleName = [typeInfo objectForKey:CoreData_ShiftTypeInfo_TitleName];
    shiftWorkType.shortName = [typeInfo objectForKey:CoreData_ShiftTypeInfo_ShortName];
//    shiftWorkType.color = [typeInfo objectForKey:@"color"];
//    shiftWorkType.time = [typeInfo objectForKey:@"time"];
//    shiftWorkType.image = [typeInfo objectForKey:@"image"];
    shiftWorkType.color = [NSKeyedArchiver archivedDataWithRootObject:[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color]];
    shiftWorkType.time = [NSKeyedArchiver archivedDataWithRootObject:[typeInfo objectForKey:CoreData_ShiftTypeInfo_Time]];
    shiftWorkType.image = [NSKeyedArchiver archivedDataWithRootObject:[typeInfo objectForKey:CoreData_ShiftTypeInfo_Image]];

    
    BOOL result = [[self delegate].persistentContainer.viewContext save:&error];
    if (result) {
        return shiftWorkType;
    }
    return nil;
}


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
- (BOOL)deleteShiftWorkTypeWithTypeID:(NSString *)typeID
{
    NSPredicate *perdicate = [NSPredicate predicateWithFormat:@"typeID = %@",typeID];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShiftWorkTypeCoreData" inManagedObjectContext:[self delegate].persistentContainer.viewContext];
    
    [request setEntity:entity];
    
    [request setPredicate:perdicate];
    
    [request setFetchLimit:1];
    
    NSError *error = nil;
    
    NSArray *infos = [[[self delegate].persistentContainer.viewContext executeFetchRequest:request error:&error] mutableCopy];
    if (infos == nil) {
        return NO;
    }
    
    for (ShiftWorkTypeCoreData *shiftWorkType in infos) {
        [[self delegate].persistentContainer.viewContext deleteObject:shiftWorkType];
        [[self delegate].persistentContainer.viewContext save:&error];
        return YES;
    }
    
    return NO;



}


@end
