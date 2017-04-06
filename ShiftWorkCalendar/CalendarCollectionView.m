//
//  CalendarCollectionView.m
//  TestCalendar
//
//  Created by Josh on 2017/3/11.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "CalendarCollectionView.h"
#import "ViewController.h"
#import "CalendarCollectionCell.h"
#import "CalendarData.h"
#import "CoreDataHandle.h"

#define ShiftDateTempInfo_AddInfo @"ShiftDateTempInfo_AddInfo"
#define ShiftDateTempInfo_DeleteInfo @"ShiftDateTempInfo_DeleteInfo"
#define ShiftDateTempInfo_UpdateInfo @"ShiftDateTempInfo_AddInfo"


@interface CalendarCollectionView ()
{
    CalendarCollectionCell *selectDayCell;
    NSMutableDictionary *nextDateInfo;
    NSMutableDictionary *prevDateInfo;
    BOOL isCurrenCalendar;
    
    NSNumber* todayYear ;
    NSNumber* todayMonth;
    NSNumber* todayDay;

    
    NSNumber * curYear;
    NSNumber * curMonth;
    NSNumber * daysTotalInMonth;
    NSNumber * weekTotalInMonth;
    NSNumber * weekOfMonthFirstDay;
    NSMutableDictionary*allDayInfo;
    CGFloat cellLineSpacing;
    CGFloat cellInteritemSpacing;

    
    BOOL isAddShiftWork;
    NSString*calendarPage;
    NSMutableDictionary*shiftTypeInfo;
//    NSMutableDictionary*shiftDateInfo;
    NSMutableDictionary* allShiftDateTypeInfo;
    NSMutableDictionary* allShiftDateInfo;
    
    NSMutableDictionary* addShiftDateTempInfo;
    NSMutableDictionary* deleteShiftDateTempInfo;
    NSMutableDictionary* updateShiftDateTempInfo;

    



    
    

}

@end

@implementation CalendarCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isCurrenCalendar=NO;
    isAddShiftWork=NO;
    [self initDateDictionary];
    [self initCollectionViewCell];
    [self initNotification];
    [self loadShiftDateData];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self sendCalendarDateNotification];


}


#pragma mark - Date Data

-(void)initDateDictionary
{
    //取得下一個與前一個月的資料
    nextDateInfo=[CalendarData getNextCalendarInfo:self.dateDictionary];
    prevDateInfo=[CalendarData getPrevCalendarInfo:self.dateDictionary];

    //今天的日期
    NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    todayYear = [NSNumber numberWithInteger:[todayDate year]];
    todayMonth =[NSNumber numberWithInteger:[todayDate month]];
    todayDay =[NSNumber numberWithInteger:[todayDate day]];

    //當前選擇的Calendar
    curYear=[self.dateDictionary objectForKey:CalendarData_Year];
    curMonth=[self.dateDictionary objectForKey:CalendarData_Month];
    daysTotalInMonth=[self.dateDictionary objectForKey:CalendarData_DaysTotalInMonth];
    weekTotalInMonth=[self.dateDictionary objectForKey:CalendarData_WeekTotalInMonth];
    weekOfMonthFirstDay=[self.dateDictionary objectForKey:CalendarData_FirstDayWeekInMonth];
    allDayInfo=[self.dateDictionary objectForKey:CalendarData_AllDayInfo];
    calendarPage=[[NSString alloc]initWithFormat:@"%@%@",curYear,curMonth];
    if (todayYear ==curYear&&todayMonth==curMonth)
    {
        isCurrenCalendar=YES;
    }
    else
    {
        isCurrenCalendar=NO;
    
    }

}

-(void)sendCalendarDateNotification
{
    NSString *titleYear = [curYear stringValue];
    NSString *titleMonth = [self calendarDateMonth:curMonth ];
    NSString *calendarDateString=[[NSString alloc ]initWithFormat:@"%@ %@ ",titleYear,titleMonth];
    [[NSNotificationCenter defaultCenter]postNotificationName:Calendar_Date_Notification object:calendarDateString];

}

-(NSString*)calendarDateMonth:(NSNumber*)month
{
    NSArray *monthArray=[NSArray arrayWithObjects: [NSNull null], @"January", @"February", @"March", @"April", @"May", @"June", @"July",@"August",@"September",@"October",@"November",@"December", nil];
    NSInteger i=[month integerValue];
    return [monthArray objectAtIndex:i];

}

#pragma mark - Collection View

-(void)initCollectionViewCell
{
    cellLineSpacing=self.view.frame.size.width/150;
    cellInteritemSpacing=self.view.frame.size.height/200;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CalendarCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CalendarCollectionCell"];


}

//行 間距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    return cellInteritemSpacing;
}
//列 間距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

    return cellLineSpacing;

}

//設置Cell的寬高
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger cellTotal=[weekTotalInMonth integerValue];

    
    CGFloat collectionViewWigh=(self.view.frame.size.width-(cellLineSpacing*8))/7;

    CGFloat collectionViewHight=(self.view.frame.size.height-(cellInteritemSpacing*(cellTotal+1)))/cellTotal;
    
    return CGSizeMake(collectionViewWigh, collectionViewHight);
}


//設置Cell的間距 (上,左,下,右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(cellInteritemSpacing,cellLineSpacing,cellInteritemSpacing,cellLineSpacing);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSInteger rowTotel=[weekTotalInMonth integerValue]*7;
    
    return rowTotel;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *cellID = @"CalendarCollectionCell";
    CalendarCollectionCell * dayCell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];


    NSInteger mothTotalDay=[daysTotalInMonth integerValue];
    NSInteger monthFirstDayOnWeek=[weekOfMonthFirstDay integerValue];
    
    NSInteger cellRow=indexPath.row+1;
    if (cellRow>=monthFirstDayOnWeek &&
        cellRow<mothTotalDay+monthFirstDayOnWeek)
    {
        NSNumber * dayInt= [NSNumber numberWithInteger:cellRow-monthFirstDayOnWeek+1];
        NSString *dayString=[[NSString alloc]initWithFormat:@"%@",dayInt];
        NSString *idString=[[NSString alloc]initWithFormat:@"%@%@%@",curYear,curMonth,dayString];
        NSInteger cellID = [idString intValue];
        dayCell.calendarDayLabel.text=dayString;
        [dayCell setTag:cellID];
        if (isCurrenCalendar&&dayInt ==todayDay)
        {
            dayCell.calendarDayLabel.textColor=[UIColor colorWithRed:242.0f/255.0f green:89.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
            dayCell.calendarDayLabel.backgroundColor=[UIColor colorWithRed:242.0f/255.0f green:89.0f/255.0f blue:75.0f/255.0f alpha:0.3f];

        }

        NSMutableDictionary *shiftDateInfo=[allShiftDateInfo objectForKey:idString];
        if (shiftDateInfo!=nil)
        {
            dayCell.calendarCellStatus=CalendarCellStatusHaveShiftDate;
            NSString *typeID=[shiftDateInfo objectForKey:CoreData_ShiftDateInfo_ShiftTypeID];
            NSMutableDictionary *typeInfo=[allShiftDateTypeInfo objectForKey:typeID];
            [self addShiftWorkInSelectCell:dayCell withShiftTypeInfo:typeInfo];
        }

        
        
        
    }
    else if (cellRow<monthFirstDayOnWeek)
    {
        // Tag=0 代表 上/下個月 Cell
        [dayCell setTag:0];

        NSInteger prevDaysTotalInMonth=[[prevDateInfo objectForKey:CalendarData_DaysTotalInMonth]integerValue];
        
        NSInteger prevDay=prevDaysTotalInMonth-(monthFirstDayOnWeek-cellRow-1);
        NSString *dayString=[[NSString alloc]initWithFormat:@"%ld",(long)prevDay];
        dayCell.calendarDayLabel.text=dayString;
        dayCell.calendarDayLabel.textColor=[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];

    }
    
    else
    {
        // Tag=0 代表 上/下個月 Cell
        [dayCell setTag:0];

        NSInteger nextDaysTotalInMonth=cellRow-(mothTotalDay+monthFirstDayOnWeek)+1;
        NSString *dayString=[[NSString alloc]initWithFormat:@"%ld",(long)nextDaysTotalInMonth];
        dayCell.calendarDayLabel.text=dayString;
        dayCell.calendarDayLabel.textColor=[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
        
    }
    return dayCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
    // Tag=0 代表 上/下個月 Cell
    if (cell.tag ==0)
    {
        return;
    }

    //----點選 Cell Day Info
    NSString*dayInfoKey=[[NSString alloc]initWithFormat:@"%ld",(long)cell.tag];
    NSMutableDictionary*dayInfo=[allDayInfo objectForKey:dayInfoKey];
    NSString *day=[dayInfo objectForKey:CalendarData_AllDayInfo_Day];
    NSString *week=[dayInfo objectForKey:CalendarData_AllDayInfo_Week];
    //----

    CalendarCollectionCell *curSelectDayCell=selectDayCell;
    selectDayCell=(CalendarCollectionCell*)cell;

    if (isAddShiftWork)
    {
        NSInteger typeID=[[shiftTypeInfo objectForKey:CoreData_ShiftTypeInfo_TypeID]integerValue];
        BOOL isRepeatSet=[self checkSetRepeatShiftTypeInCell:selectDayCell withShiftTypeID:typeID];
        if (isRepeatSet)
        {
            [self cancelShiftWorkInSelectCell:selectDayCell];
            [self addShiftDateTempInfoItemOfCell:selectDayCell
                               withShiftTypeInfo:shiftTypeInfo
                             withIsRepeatSetCell:YES];
        }
        else
        {
            [self addShiftWorkInSelectCell:selectDayCell withShiftTypeInfo:shiftTypeInfo];
            [self addShiftDateTempInfoItemOfCell:selectDayCell
                               withShiftTypeInfo:shiftTypeInfo
                             withIsRepeatSetCell:NO];
            
        }


    }
    else
    {
        [self updateDayCell:curSelectDayCell isSelection:NO];
        [self updateDayCell:selectDayCell isSelection:YES];
    }





}

-(void)updateDayCell:(CalendarCollectionCell*)dayCell isSelection:(BOOL)isSelection
{
    NSString *todayString=[[NSString alloc]initWithFormat:@"%@%@%@",todayYear,todayMonth,todayDay];
    NSInteger todayInt = [todayString intValue];
    if (isSelection)
    {
        if (todayInt==dayCell.tag)
        {
            dayCell.backgroundColor=[UIColor colorWithRed:242.0f/255.0f green:89.0f/255.0f blue:75.0f/255.0f alpha:0.1f];
        }
        else
        {
            dayCell.backgroundColor=[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        }
        
    }
    else
    {


        dayCell.backgroundColor=[UIColor whiteColor];
        
    }
}
#pragma mark - Add Shift Work
#pragma mark -- Shift Work Notification

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(onAddShiftWorkNotification:)
                                                name:ShiftWorkType_AddShiftType_Notification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(offAddShiftWorkNotification)
                                                name:ShiftWorkType_CloseAddView_Notification
                                              object:nil];

    
}

-(void)onAddShiftWorkNotification:(NSNotification *)notification
{
    isAddShiftWork=YES;
    shiftTypeInfo=[notification object];
    [self initShiftDateTempData];

}
-(void)offAddShiftWorkNotification
{
    isAddShiftWork=NO;
    [self saveShiftDateCoreData];
    [self loadShiftDateData];



}

#pragma mark -- Add Shift Work in Cell
-(void)addShiftWorkInSelectCell:(CalendarCollectionCell*)cell
                 withShiftTypeInfo:(NSMutableDictionary*)typeInfo
{
    NSString *shiftShortName=[typeInfo objectForKey:CoreData_ShiftTypeInfo_ShortName];
    UIColor *shiftColor=[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color];
    NSInteger typeID=[[typeInfo objectForKey:CoreData_ShiftTypeInfo_TypeID]integerValue];
    
    cell.shiftShortNameLabel.tag=typeID;
    cell.shiftShortNameLabel.text=shiftShortName;
    cell.shiftShortNameLabel.layer.backgroundColor=[shiftColor CGColor];
    
}
-(void)cancelShiftWorkInSelectCell:(CalendarCollectionCell*)cell
{
    cell.shiftShortNameLabel.tag=0;
    cell.shiftShortNameLabel.text=@"";
    cell.shiftShortNameLabel.layer.backgroundColor=[[UIColor clearColor] CGColor];
    
}


-(BOOL)checkSetRepeatShiftTypeInCell:(CalendarCollectionCell*)cell
                withShiftTypeID:(NSInteger)typeID
{
    if (cell.shiftShortNameLabel.tag ==typeID)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Shift Type Data



#pragma mark - Shift Date Data
#pragma mark -- Temporary Data
-(void)initShiftDateTempData
{
    addShiftDateTempInfo=[[NSMutableDictionary alloc]init];
    deleteShiftDateTempInfo=[[NSMutableDictionary alloc]init];
    updateShiftDateTempInfo=[[NSMutableDictionary alloc]init];

}
-(void)deleteShiftDateTempData
{
    addShiftDateTempInfo=nil;
    deleteShiftDateTempInfo=nil;
    updateShiftDateTempInfo=nil;
}

-(void)addShiftDateTempInfoItemOfCell:(CalendarCollectionCell*)cell
                 withShiftTypeInfo:(NSMutableDictionary*)typeInfo
               withIsRepeatSetCell:(BOOL)isRepeatSet
{
    
    NSString*dateID=[[NSString alloc]initWithFormat:@"%ld",(long)cell.tag];
    NSString *shiftTypeID=[typeInfo objectForKey:CoreData_ShiftTypeInfo_TypeID];
    NSMutableDictionary*dateInfo=[[NSMutableDictionary alloc]init];
    [dateInfo setObject:dateID forKey:CoreData_ShiftDateInfo_DateID];
    [dateInfo setObject:calendarPage forKey:CoreData_ShiftDateInfo_CalendarPage];
    [dateInfo setObject:shiftTypeID forKey:CoreData_ShiftDateInfo_ShiftTypeID];
    
    switch(cell.calendarCellStatus)
    {
        case CalendarCellStatusNone:
            [self saveShiftDateInfo:dateInfo intoTempInfo:addShiftDateTempInfo];
            cell.calendarCellStatus=CalendarCellStatusAddShiftDate;
            break;
        case CalendarCellStatusHaveShiftDate:
            if (isRepeatSet)
            {
                cell.calendarCellStatus=CalendarCellStatusDeleteShiftDate;
                [self saveShiftDateInfo:dateInfo intoTempInfo:deleteShiftDateTempInfo];


            }
            else
            {
                cell.calendarCellStatus=CalendarCellStatusUpdateShiftDate;
                [self saveShiftDateInfo:dateInfo intoTempInfo:updateShiftDateTempInfo];
            
            }
            
            break;
        case CalendarCellStatusAddShiftDate:
            
            if (isRepeatSet)
            {
                cell.calendarCellStatus=CalendarCellStatusNone;
                [self removeShiftDateInfo:dateInfo fromTempInfo:addShiftDateTempInfo];
                
                
            }
            else
            {
                cell.calendarCellStatus=CalendarCellStatusAddShiftDate;
                [self saveShiftDateInfo:dateInfo intoTempInfo:addShiftDateTempInfo];
                
            }

            break;
            
        case CalendarCellStatusUpdateShiftDate:
            if (isRepeatSet)
            {
                cell.calendarCellStatus=CalendarCellStatusDeleteShiftDate;
                [self removeShiftDateInfo:dateInfo fromTempInfo:updateShiftDateTempInfo];
                [self saveShiftDateInfo:dateInfo intoTempInfo:deleteShiftDateTempInfo];
                
                
            }
            else
            {
                cell.calendarCellStatus=CalendarCellStatusUpdateShiftDate;
                [self saveShiftDateInfo:dateInfo intoTempInfo:updateShiftDateTempInfo];
                
            }
            break;
            
        case CalendarCellStatusDeleteShiftDate:
            cell.calendarCellStatus=CalendarCellStatusUpdateShiftDate;
            [self removeShiftDateInfo:dateInfo fromTempInfo:deleteShiftDateTempInfo];
            [self saveShiftDateInfo:dateInfo intoTempInfo:updateShiftDateTempInfo];
            break;
            
        default:
            break;
    }
    
    
    
    
}


-(void)saveShiftDateInfo:(NSMutableDictionary*)dateinfo
            intoTempInfo:(NSMutableDictionary*)tempInfo
{
    
    NSString*key=[dateinfo objectForKey:CoreData_ShiftDateInfo_DateID];
    [tempInfo setObject:dateinfo forKey:key];
    
}

-(void)removeShiftDateInfo:(NSMutableDictionary*)dateinfo
              fromTempInfo:(NSMutableDictionary*)tempInfo
{
    
    NSString*key=[dateinfo objectForKey:CoreData_ShiftDateInfo_DateID];
    [tempInfo removeObjectForKey:key];
    
}



#pragma mark -- Core Data
-(void)loadShiftDateData
{
    
    allShiftDateInfo = [[CoreDataHandle shareCoreDatabase] searchShiftDateInfoOfCalendarPage:calendarPage];
    
    NSArray *allDateID = [allShiftDateInfo allKeys];
    allShiftDateTypeInfo=[[NSMutableDictionary alloc]init];
    for (int i=0; i<allDateID.count; i++)
    {
        NSMutableDictionary *shiftDateInfo=[allShiftDateInfo objectForKey:allDateID[i]];
        NSString*shiftTypeID=[shiftDateInfo objectForKey:CoreData_ShiftDateInfo_ShiftTypeID];
        NSMutableDictionary* typeInfo= [[CoreDataHandle shareCoreDatabase] searchShiftWorkTypeOfTypeID:shiftTypeID];
        [allShiftDateTypeInfo setObject:typeInfo forKey:shiftTypeID];
    }
}

-(void)saveShiftDateCoreData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        
        NSArray *addArray=[addShiftDateTempInfo allValues];
        NSArray *updateArray=[updateShiftDateTempInfo allValues];
        NSArray *deleteArray=[deleteShiftDateTempInfo allValues];
        
        
        //新增
        for (int i=0; i<addArray.count; i++)
        {
            NSMutableDictionary*info=addArray[i];
            [[CoreDataHandle shareCoreDatabase]addShiftDate:info];
        }
        
        
        //修改
        for (int i=0; i<updateArray.count; i++)
        {
            NSMutableDictionary*info=updateArray[i];
            NSString*dateID=[info objectForKey:CoreData_ShiftDateInfo_DateID];
            [[CoreDataHandle shareCoreDatabase]updateShiftDateOfDateID:dateID withShiftCalendar:info];
        }
        //刪除
        for (int i=0; i<deleteArray.count; i++)
        {
            NSMutableDictionary*info=deleteArray[i];
            NSString*dateID=[info objectForKey:CoreData_ShiftDateInfo_DateID];
            [[CoreDataHandle shareCoreDatabase]deleteShiftDateOfDateID:dateID];
        }
        
        [self deleteShiftDateTempData];

    });

}

@end
