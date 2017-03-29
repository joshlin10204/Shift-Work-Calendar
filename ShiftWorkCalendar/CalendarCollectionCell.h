//
//  CalendarCollectionCell.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/13.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum CalendarCellStatus
{
    CalendarCellStatusNone =0,
    CalendarCellStatusHaveShiftDate,
    CalendarCellStatusAddShiftDate,
    CalendarCellStatusUpdateShiftDate,
    CalendarCellStatusDeleteShiftDate,
} CalendarCellStatus;

@interface CalendarCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *calendarDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *shiftShortNameLabel;
@property (nonatomic, assign) CalendarCellStatus calendarCellStatus;

@end
