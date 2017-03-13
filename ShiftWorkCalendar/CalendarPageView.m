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


@interface CalendarPageView ()
{
    NSArray *viewControllers;


}

@property (strong, nonatomic) CalendarData *calendarData;

@property (strong, nonatomic) NSArray *pageData;
@property (strong, nonatomic) NSMutableDictionary *currentDateInfo;


@end

@implementation CalendarPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        [self initDateData];
        [self initMonthCollectionView];
        [self initPageControllerView];
    }
    return self;
}
-(void)initDateData
{
    self.calendarData=[[CalendarData alloc]init];
    self.currentDateInfo=[self.calendarData getCurrentDateInfo];
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
    
    self.currentDateInfo=[self.calendarData getNextDateInfo:calendarCollectionView.dateDictionary];
    NSLog(@"前往 :%@",self.currentDateInfo);

    return [self currentCalendarViewDateInfo:self.currentDateInfo storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    CalendarCollectionView * calendarCollectionView=(CalendarCollectionView *)viewController;

    self.currentDateInfo=[self.calendarData getPrevDateInfo:calendarCollectionView.dateDictionary];
    NSLog(@"返回 :%@",self.currentDateInfo);


    return [self currentCalendarViewDateInfo:self.currentDateInfo storyboard:viewController.storyboard];
}


@end
