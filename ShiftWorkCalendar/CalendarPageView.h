//
//  CalendarPageView.h
//  TestCalendar
//
//  Created by Josh on 2017/3/11.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarPageView : UIView<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end
