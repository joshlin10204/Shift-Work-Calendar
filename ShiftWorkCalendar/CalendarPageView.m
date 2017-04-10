//
//  CalendarPageView.m
//  TestCalendar
//
//  Created by Josh on 2017/3/11.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "CalendarPageView.h"
#import "CalendarCollectionView.h"
#import "CalendarData.h"

#import "ViewController.h"

@interface CalendarPageView ()
{
    NSArray *viewControllers;
    NSString *currentPageDateTitle;


}

//@property (strong, nonatomic) CalendarData *calendarData;

@property (strong, nonatomic) NSArray *pageData;
@property (strong, nonatomic) NSMutableDictionary *currentDateInfo;


@end

@implementation CalendarPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        [self initNotification];
        [self initDateData];
        [self initMonthCollectionView];
        [self initPageControllerView];
        



    }
    return self;
}

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reloadPageView:)
                                                name:CalendarPageView_Reload_Notification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(setCurrentPageDateTitle:)
                                                name:Calendar_Date_Notification
                                              object:nil];

}
-(void)initDateData
{
    self.currentDateInfo=[CalendarData getCurrentDayCalendarInfo];
}

-(void)initMonthCollectionView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle mainBundle]];
    
    CalendarCollectionView *calendarCollectionView=[self currentCalendarViewDateInfo:self.currentDateInfo
                                                                    storyboard:storyboard];
    viewControllers = @[calendarCollectionView];
    
    
}
- (CalendarCollectionView *)currentCalendarViewDateInfo:(NSMutableDictionary*)curDateDic storyboard:(UIStoryboard *)storyboard
{
    CalendarCollectionView * calendarCollectionView=[storyboard instantiateViewControllerWithIdentifier:@"CalendarCollectionView"];
    calendarCollectionView.dateDictionary=curDateDic;
    return calendarCollectionView;

}


-(void)initPageControllerView
{
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addSubview:self.pageViewController.view];
    
    self.pageViewController.view.frame = CGRectMake(0,
                                                    0,
                                                    self.frame.size.width,
                                                    self.frame.size.height*35/100);;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    CalendarCollectionView * calendarCollectionView=(CalendarCollectionView *)viewController;
    
    self.currentDateInfo=[CalendarData getNextCalendarInfo:calendarCollectionView.dateDictionary];
    
    return [self currentCalendarViewDateInfo:self.currentDateInfo storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    CalendarCollectionView * calendarCollectionView=(CalendarCollectionView *)viewController;

    self.currentDateInfo=[CalendarData getPrevCalendarInfo:calendarCollectionView.dateDictionary];


    return [self currentCalendarViewDateInfo:self.currentDateInfo storyboard:viewController.storyboard];
}



-(void)setCurrentPageDateTitle:(NSNotification *)notification
{
    NSMutableDictionary*curPageInfo=[notification object];
    
    NSNumber *titleYear = [curPageInfo objectForKey:CalendarData_Year];
    NSNumber *titleMonth =[curPageInfo objectForKey:CalendarData_Month];
    currentPageDateTitle=[[NSString alloc]initWithFormat:@"%@%@",titleYear,titleMonth];

}

-(void)reloadPageView:(NSNotification *)notification
{
    NSMutableDictionary *updateInfo=[notification object];
    
    
    NSNumber * year=[updateInfo objectForKey:CalendarData_Year];
    NSNumber * month=[updateInfo objectForKey:CalendarData_Month];
    NSString *reloadDate=[[NSString alloc]initWithFormat:@"%@%@",year,month];

    //判斷目前顯示的Page，更新畫面
    if ([currentPageDateTitle isEqualToString:reloadDate])
    {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:[NSBundle mainBundle]];
        CalendarCollectionView *calendarCollectionView=[self currentCalendarViewDateInfo:updateInfo
                                                                              storyboard:storyboard];
        
        
        viewControllers = @[calendarCollectionView];
        [self.pageViewController setViewControllers: viewControllers
                                          direction: UIPageViewControllerNavigationDirectionForward
                                           animated: NO
                                         completion: nil];
        
        
    }
    
}

@end
