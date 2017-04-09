//
//  CalendarCollectionView.h
//  TestCalendar
//
//  Created by Josh on 2017/3/11.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCollectionView : UIViewController<UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableDictionary *dateDictionary;

@property(strong,nonatomic)UICollectionView *calendarCollectionView;


@end
