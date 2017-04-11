//
//  ViewController.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/12.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ViewController.h"
#import "CalendarPageView.h"
//#import "ShiftWorkCollectionView.h"
#import "ShiftWorkTypeSetViewController.h"
#import "CalendarInfomationView.h"
#import "ShiftWorkAllTypeView.h"
#import "CalendarData.h"



@interface ViewController ()<ShiftWorkAllTypesViewDelegate>
{
    UIView *calendarBasicView;
    UIView  *calendarTitleView;
    UILabel *calendarTitleLabel;
    UIView *weekTitleView;
    NSMutableDictionary *pageTitleInfo;

}
@property (strong, nonatomic) CalendarPageView *calendarPageView;
@property (strong, nonatomic) ShiftWorkAllTypeView *shiftWorkAllTypeView;
@property (strong, nonatomic) CalendarInfomationView *calendarInfomationView;

@property (weak, nonatomic) IBOutlet UIView *weekTitleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self initNotification];
    [self initCalendarAllView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self initShiftWorkAllTypeView];
    [self reloadCalendarPageView];

    [self.navigationController setNavigationBarHidden:YES animated:animated];

    

}
#pragma mark - Notification

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(switchingCalendarNotification:)
                                                name:Calendar_Date_Notification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(moveDownCalendarBasicView)
                                                name:ShiftWorkType_CloseAddView_Notification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(moveUpCalendarBasicView)
                                                name:ShiftWorkType_ShowAddView_Notification
                                              object:nil];
    
    
    
}



#pragma mark -Calendar  Basic View

-(void)initCalendarAllView
{
    
    [self initCalendarBasicView];
    [self initCalendarTitleView];
    [self initCalendarTitleLabel];
    [self initWeekTitleView];
    [self initWeeksTitleLabel];
    
    
    [self initCalendarPageView];
    [self initCalendarInfomationView];
    
    
}

-(void)initCalendarBasicView
{
    CGSize viewSize;
    CGPoint viewPoint;
    viewSize.height=self.view.frame.size.height*62/100;
    viewSize.width=self.view.frame.size.width;
    viewPoint.x=0;
    viewPoint.y=self.view.frame.size.height*30/100;

    
    calendarBasicView=[[UIView alloc]initWithFrame:CGRectMake(viewPoint.x,
                                                             viewPoint.y,
                                                             viewSize.width,
                                                              viewSize.height)];
    [self.view addSubview:calendarBasicView];


}

#pragma mark -- Calendar Title View

-(void)initCalendarTitleView
{
    CGSize viewSize;
    CGPoint viewPoint;
    viewSize.height=calendarBasicView.frame.size.height*10/100;
    viewSize.width=calendarBasicView.frame.size.width;
    viewPoint.x=0;
    viewPoint.y=0;

    calendarTitleView=[[UIView alloc]initWithFrame:CGRectMake(viewPoint.x,
                                                             viewPoint.y,
                                                             viewSize.width,
                                                              viewSize.height)];
    

    [calendarBasicView addSubview:calendarTitleView];

}
-(void)initCalendarTitleLabel
{
    CGPoint labelPoint;
    CGSize labelSize;
    labelSize.height=calendarTitleView.frame.size.height*80/100;
    labelSize.width=calendarTitleView.frame.size.width*50/100;
    labelPoint.x=calendarTitleView.frame.size.width*25/100;
    labelPoint.y=calendarTitleView.frame.size.height*10/100;
    calendarTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
    
    calendarTitleLabel.font=[UIFont fontWithName:@"Futura" size:200];
    calendarTitleLabel.textAlignment=NSTextAlignmentCenter;
    calendarTitleLabel.textColor=[UIColor colorWithRed:75/255.0f green:75/255.0f blue:75/255.0f alpha:1.0];
    calendarTitleLabel.adjustsFontSizeToFitWidth=YES;
    calendarTitleLabel.numberOfLines=0;
    [calendarTitleView addSubview:calendarTitleLabel];



}
-(void)switchingCalendarNotification:(NSNotification *)notification
{
    
    pageTitleInfo=[notification object];
    
    NSNumber *titleYear = [pageTitleInfo objectForKey:CalendarData_Year];
    NSString *titleMonth = [self calendarDateMonth:[pageTitleInfo objectForKey:CalendarData_Month] ];
    
    NSString *calendarDateString=[[NSString alloc ]initWithFormat:@"%@ %@ ",titleYear,titleMonth];
    
    calendarTitleLabel.text=calendarDateString;

    
}

-(NSString*)calendarDateMonth:(NSNumber*)month
{
    NSArray *monthArray=[NSArray arrayWithObjects: [NSNull null], @"January", @"February", @"March", @"April", @"May", @"June", @"July",@"August",@"September",@"October",@"November",@"December", nil];
    NSInteger i=[month integerValue];
    return [monthArray objectAtIndex:i];
    
}

#pragma mark -- Week Title View
-(void)initWeekTitleView
{
    CGSize viewSize;
    CGPoint viewPoint;
    viewSize.height=calendarBasicView.frame.size.height*10/100;
    viewSize.width=calendarBasicView.frame.size.width;
    viewPoint.x=0;
    viewPoint.y=calendarBasicView.frame.size.height*10/100;
    
    weekTitleView=[[UIView alloc]initWithFrame:CGRectMake(viewPoint.x,
                                                              viewPoint.y,
                                                              viewSize.width,
                                                              viewSize.height)];
    
    [calendarBasicView addSubview:weekTitleView];
    


}

-(void)initWeeksTitleLabel
{

    NSArray *weekArray=[NSArray arrayWithObjects: @"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI",@"SAT", nil];
    for (int i=0; i<7; i++)
    {
        CGPoint labelPoint;
        CGSize labelSize;
        labelSize.height=weekTitleView.frame.size.height*80/100;
        labelSize.width=weekTitleView.frame.size.width/7;
        labelPoint.x=labelSize.width*i;
        labelPoint.y=weekTitleView.frame.size.height*10/100;
        UILabel *weekLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
        
        weekLabel.font=[UIFont fontWithName:@"Futura" size:15];
        weekLabel.textAlignment=NSTextAlignmentCenter;
        weekLabel.text=weekArray[i];
        weekLabel.textColor=[UIColor colorWithRed:75/255.0f green:75/255.0f blue:75/255.0f alpha:1.0];
        weekLabel.adjustsFontSizeToFitWidth=YES;
        weekLabel.numberOfLines=0;
        [weekTitleView addSubview:weekLabel];
    }

}

#pragma mark - Calendar PageView


-(void)initCalendarPageView
{

    CGSize calendarPageSize;
    calendarPageSize.height=calendarBasicView.frame.size.height*80/100;
    calendarPageSize.width=calendarBasicView.frame.size.width;
    
    CGPoint calendarPagePoint;
    calendarPagePoint.x=0;
    calendarPagePoint.y=calendarBasicView.frame.size.height*20/100;
    self.calendarPageView=[[CalendarPageView alloc]init];
    self.calendarPageView.frame=CGRectMake(calendarPagePoint.x,
                                           calendarPagePoint.y,
                                          calendarPageSize.width,
                                           calendarPageSize.height);

    [calendarBasicView addSubview:self.calendarPageView];



}
-(void)moveUpCalendarBasicView
{
    CGRect frame=calendarBasicView.frame;
    frame.origin.y=self.view.frame.size.height*24/100;
    [self moveCalendarBasicViewAnimation:frame];
}
-(void)moveDownCalendarBasicView
{
    CGRect frame=calendarBasicView.frame;
    frame.origin.y=self.view.frame.size.height*30/100;
    [self moveCalendarBasicViewAnimation:frame];
    
}

-(void)moveCalendarBasicViewAnimation:(CGRect)frame
{
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    calendarBasicView.frame=frame;
    
    
    [UIView commitAnimations];
    
}
-(void)reloadCalendarPageView
{

    [[NSNotificationCenter defaultCenter]postNotificationName:CalendarPageView_Reload_Notification object:pageTitleInfo];
}
#pragma mark -  Shift Work
-(void)initShiftWorkAllTypeView
{

    self.shiftWorkAllTypeView=[ShiftWorkAllTypeView initShiftWorkAllTypeView:self.view];
    self.shiftWorkAllTypeView.delegate=self;
    [self.shiftWorkAllTypeView reloadShiftWorkTypeData];
    
    

}
#pragma mark -- Add Shift Work

-(void)selectShiftWorkTypeTableViewWithCellType:(ShiftWorkCellType)type withShiftTypeInfo:(NSMutableDictionary *)info
{

    if (type==ShiftWorkCellTypeAddShiftType)
    {

        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        ShiftWorkTypeSetViewController* addShiftWorkTypeView = [storyboard instantiateViewControllerWithIdentifier:@"ShiftWorkTypeSetViewController"];
        addShiftWorkTypeView.isAddNewShiftWorkType=YES;
        
        [self.navigationController pushViewController:addShiftWorkTypeView animated:YES];
    
    }
    else if (type==ShiftWorkCellTypeEditShiftType)
    {
        

        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ShiftWorkTypeSetViewController* addShiftWorkTypeView = [storyboard instantiateViewControllerWithIdentifier:@"ShiftWorkTypeSetViewController"];
        addShiftWorkTypeView.isAddNewShiftWorkType=NO;
        addShiftWorkTypeView.shiftWorkTypeInfo=info;
        
        [self.navigationController pushViewController:addShiftWorkTypeView animated:YES];
    }
    else
    {
    
        [[NSNotificationCenter defaultCenter]postNotificationName:ShiftWorkType_AddShiftType_Notification object:info];
    }
    


}


#pragma mark - Schedule TableView

-(void)initCalendarInfomationView
{
    self.calendarInfomationView=[CalendarInfomationView initCalendarInfomationViewInSubview:self.view];
    
}

#pragma mark - NavigationBar
-(void)initCalendarNavigationItem
{
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:74.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    
    
    
}

@end
