//
//  CalendarCollectionCell.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/13.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "CalendarCollectionCell.h"

@implementation CalendarCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.calendarDayLabel.textColor=[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
}

@end
