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


@interface CalendarCollectionView ()
{
    CalendarCollectionCell *selectDayCell;
    BOOL isCurrenCalendar;
    
    NSNumber* todayYear ;
    NSNumber* todayMonth;
    NSNumber* todayDay;

    
    NSNumber * curYear;
    NSNumber * curMonth;
    NSNumber * curDay;
    NSNumber * daysTotalInMonth;
    NSNumber * weekTotalInMonth;
    NSNumber * weekOfMonthFirstDay;
    CGFloat cellLineSpacing;
    CGFloat cellInteritemSpacing;

    
    

}

@end

@implementation CalendarCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isCurrenCalendar=NO;
    [self initDateDictionary];
    [self initCollectionViewCell];
    
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



-(void)initDateDictionary
{
    
    //今天的日期
    NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    todayYear = [NSNumber numberWithInteger:[todayDate year]];
    todayMonth =[NSNumber numberWithInteger:[todayDate month]];
    todayDay =[NSNumber numberWithInteger:[todayDate day]];

    //當前選擇的Calendar
    curYear=[self.dateDictionary objectForKey:@"curYear"];
    curMonth=[self.dateDictionary objectForKey:@"curMonth"];
    curDay=[self.dateDictionary objectForKey:@"curDay"];
    daysTotalInMonth=[self.dateDictionary objectForKey:@"daysTotalInMonth"];
    weekTotalInMonth=[self.dateDictionary objectForKey:@"weekTotalInMonth"];
    weekOfMonthFirstDay=[self.dateDictionary objectForKey:@"weekOfMonthFirstDay"];
    
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
        NSInteger dateInt = [dateString intValue];

        dayCell.calendarDayLabel.text=dayString;
        [dayCell setTag:dateInt];
        if (isCurrenCalendar&&dayInt ==curDay)
        {
            dayCell.calendarDayLabel.textColor=[UIColor colorWithRed:242.0f/255.0f green:89.0f/255.0f blue:75.0f/255.0f alpha:1.0f];

        }

    }
    else
    {
        

        
        
        dayCell.calendarDayLabel.text=@"";
    
    }
    
    
    
    return dayCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *todayString=[[NSString alloc]initWithFormat:@"%@%@%@",todayYear,todayMonth,todayDay];
    NSInteger todayInt = [todayString intValue];

    if (todayInt==selectDayCell.tag)
    {
        selectDayCell.backgroundColor=[UIColor whiteColor];
        selectDayCell.calendarDayLabel.textColor=[UIColor colorWithRed:242.0f/255.0f green:89.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    }
    else
    {
        selectDayCell.backgroundColor=[UIColor whiteColor];
        selectDayCell.calendarDayLabel.textColor=[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
    }
    
    UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
    selectDayCell=(CalendarCollectionCell*)cell;
    if (todayInt==selectDayCell.tag)
    {
        selectDayCell.backgroundColor=[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        selectDayCell.calendarDayLabel.textColor=[UIColor colorWithRed:242.0f/255.0f green:89.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    }
    else
    {
        selectDayCell.backgroundColor=[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        selectDayCell.calendarDayLabel.textColor=[UIColor whiteColor];

    }


}
@end
