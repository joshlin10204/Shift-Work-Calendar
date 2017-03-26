//
//  TimePickerView.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/24.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ShiftTypeInfo_Time_Hour @"ShiftTypeInfo_Time_Hour"
#define ShiftTypeInfo_Time_Minute @"ShiftTypeInfo_Time_Minute"

typedef enum TimePickerViewSetStatus
{
    TimePickerViewSetStatusOff = 0,
    TimePickerViewSetStatusOn,
} TimePickerViewSetStatus;

@protocol TimePickerViewDelegate <NSObject>
@required
- (void) selectTimePickerViewTime:(NSMutableDictionary*)timeInfo ;
- (void) closeTimePickerView;

@end

@interface TimePickerView : UIView
@property (strong,nonatomic) id<TimePickerViewDelegate> delegate;
@property (nonatomic, assign) TimePickerViewSetStatus timePickerViewSetStatus;

+(TimePickerView*)initPickerViewWithSubview:(UIView*)view;

-(void)showTimePickerView:(NSMutableDictionary*)timeInfo withSetStatus:(TimePickerViewSetStatus)status;
@end
