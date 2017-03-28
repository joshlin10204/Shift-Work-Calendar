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
    CGFloat cellLineSpacing;
    CGFloat cellInteritemSpacing;

    
    BOOL isAddShiftWork;
    NSMutableDictionary*shiftTypeInfo;
    NSMutableArray*shiftDateInfosArray;
    NSMutableDictionary*shiftDateTempInfo;


    
    

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self sendCalendarDateNotification];

//    [self.collectionView reloadData];

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
    if (todayYear ==curYear &&todayMonth==curMonth)
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
    NSString *titleMonth = [curMonth stringValue];
    NSString *calendarDateString=[[NSString alloc ]initWithFormat:@"%@ / %@ 月",titleYear,titleMonth];
    [[NSNotificationCenter defaultCenter]postNotificationName:Calendar_Date_Notification object:calendarDateString];

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
        NSString *dateString=[[NSString alloc]initWithFormat:@"%@%@%@",curYear,curMonth,dayString];
        NSInteger cellID = [dateString intValue];

        dayCell.calendarDayLabel.text=dayString;
        [dayCell setTag:cellID];
        if (isCurrenCalendar&&dayInt ==todayDay)
        {
            dayCell.calendarDayLabel.textColor=[UIColor colorWithRed:242.0f/255.0f green:89.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
            dayCell.calendarDayLabel.backgroundColor=[UIColor colorWithRed:242.0f/255.0f green:89.0f/255.0f blue:75.0f/255.0f alpha:0.3f];

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
    CalendarCollectionCell *curSelectDayCell=selectDayCell;
    selectDayCell=(CalendarCollectionCell*)cell;
    if (isAddShiftWork)
    {
        // Tag=0 代表 上/下個月 Cell
        if (cell.tag !=0)
        {
            [self setAddShiftWorkInSelectCell:selectDayCell withShiftTypeInfo:shiftTypeInfo];
        }
    }
    else
    {
        // Tag=0 代表 上/下個月 Cell
        if (cell.tag !=0)
        {
            [self updateDayCell:curSelectDayCell isSelection:NO];
            [self updateDayCell:selectDayCell isSelection:YES];
        }
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
                                                name:ShiftWorkType_OnAdd_Notification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(offAddShiftWorkNotification)
                                                name:ShiftWorkType_OffAdd_Notification
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
    [self saveShiftDateData];

}

#pragma mark -- Add Shift Work in Cell
-(void)setAddShiftWorkInSelectCell:(CalendarCollectionCell*)cell
                 withShiftTypeInfo:(NSMutableDictionary*)typeInfo
{
    NSString *shiftShortName=[typeInfo objectForKey:CoreData_ShiftTypeInfo_ShortName];
    UIColor *shiftColor=[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color];
    NSString *shiftTypeID=[typeInfo objectForKey:CoreData_ShiftTypeInfo_TypeID];
    
    cell.shiftShortNameLabel.text=shiftShortName;
    cell.shiftShortNameLabel.layer.backgroundColor=[shiftColor CGColor];
    
//    NSString*shiftCalendarID=[[NSString alloc]initWithFormat:@"%ld",(long)cell.tag];
//    [shiftCalendarTempInfo setObject:shiftCalendarID forKey:CoreData_ShiftCalendarInfo_ShiftCalendarID];
//    [shiftCalendarTempInfo setObject:shiftTypeID forKey:CoreData_ShiftCalendarInfo_ShiftTypeID];
//    [shiftCalendarTempInfo setObject:shiftCalendarID forKey:CoreData_ShiftCalendarInfo_ShiftCalendarID];
    
    
    
}
-(void)setCancelShiftWorkInSelectCell:(CalendarCollectionCell*)cell
                    withShiftTypeInfo:(NSMutableDictionary*)typeInfo
{
    cell.shiftShortNameLabel.text=@"";
    cell.shiftShortNameLabel.layer.backgroundColor=[[UIColor clearColor] CGColor];

}

#pragma mark - Shift Date Data
#pragma mark -- Temporary Data
-(void)initShiftDateTempData
{
    shiftDateTempInfo=[[NSMutableDictionary alloc]init];
}
-(void)deleteShiftDateTempData
{
    shiftDateTempInfo=nil;
}

#pragma mark -- Core Data
-(void)loadShiftDateData
{
//    shiftCalendarInfosArray = [[CoreDataHandle shareCoreDatabase] loadAllShiftCalendar];
//    
//    [self.collectionView reloadData];

}
-(void)saveShiftDateData
{

    [self deleteShiftDateTempData];

}

@end
