//
//  ViewController.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/12.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ViewController.h"
#import "CalendarPageView.h"


@interface ViewController ()
@property (strong, nonatomic) CalendarPageView *calendarPageView;
@property (weak, nonatomic) IBOutlet UIView *weekTitleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initNotification];
    [self initCalendarNavigationItem];
    [self initWeekTitleView];
    
    [self initCalendarPageView];
    [self initScheduleTableView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

#pragma mark - NavigationBar 
-(void)initCalendarNavigationItem
{



    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:74.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.translucent = NO;
    
    

}


#pragma mark - Week Title View
-(void)initWeekTitleView
{
    self.weekTitleView.backgroundColor=[UIColor colorWithRed:74.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0f];

}


#pragma mark - Notification

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(switchingCalendarNotification:)
                                                name:Calendar_Date_Notification
                                              object:nil];

}
-(void)switchingCalendarNotification:(NSNotification *)notification
{
    NSString *calendarDateString=[notification object];
//    self.calendarNavigationItem.title=calendarDateString;
    [self.navigationItem setTitle:calendarDateString];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
}


#pragma mark - Calendar PageView

-(void)initCalendarPageView
{


    CGSize calendarPageSize;
    calendarPageSize.height=self.view.frame.size.height*1/2;
    calendarPageSize.width=self.view.frame.size.width;
    
    CGPoint calendarPagePoint;
    calendarPagePoint.x=0;
    calendarPagePoint.y=self.weekTitleView.frame.origin.y;
    self.calendarPageView=[[CalendarPageView alloc]init];
    self.calendarPageView.frame=CGRectMake(calendarPagePoint.x,
                                           calendarPagePoint.y,
                                          calendarPageSize.width,
                                           calendarPageSize.height);

    [self.view addSubview:self.calendarPageView];


}

#pragma mark - Schedule TableView

-(void)initScheduleTableView
{
    
    
}

@end
