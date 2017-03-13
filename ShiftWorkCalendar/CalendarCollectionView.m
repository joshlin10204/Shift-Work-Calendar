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
    BOOL isCurrenCalendar;
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
    curYear=[self.dateDictionary objectForKey:@"curYear"];
    curMonth=[self.dateDictionary objectForKey:@"curMonth"];
    curDay=[self.dateDictionary objectForKey:@"curDay"];
    daysTotalInMonth=[self.dateDictionary objectForKey:@"daysTotalInMonth"];
    weekTotalInMonth=[self.dateDictionary objectForKey:@"weekTotalInMonth"];
    weekOfMonthFirstDay=[self.dateDictionary objectForKey:@"weekOfMonthFirstDay"];
    
    NSDateComponents *todayDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSNumber* todayYear = [NSNumber numberWithInteger:[todayDate year]];
    NSNumber* todayMonth =[NSNumber numberWithInteger:[todayDate month]];
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
    CalendarCollectionCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];


    NSInteger mothTotalDay=[daysTotalInMonth integerValue];
    NSInteger monthFirstDayOnWeek=[weekOfMonthFirstDay integerValue];
    
    NSInteger cellRow=indexPath.row+1;
    if (cellRow>=monthFirstDayOnWeek &&
        cellRow<mothTotalDay+monthFirstDayOnWeek)
    {
        NSNumber * dateInt= [NSNumber numberWithInteger:cellRow-monthFirstDayOnWeek+1];
        NSString *dateString=[[NSString alloc]initWithFormat:@"%@",dateInt];
        cell.calendarDayLabel.text=dateString;
        
        if (isCurrenCalendar&&dateInt ==curDay)
        {
            cell.calendarDayLabel.textColor=[UIColor redColor];

        }

    }
    else
    {
        
        
        
        cell.calendarDayLabel.text=@"";
    
    }
    
    
    return cell;
}


@end
