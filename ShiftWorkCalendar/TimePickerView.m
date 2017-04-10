//
//  TimePickerView.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/24.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "TimePickerView.h"
#import "CoreDataHandle.h"

static TimePickerView *instance=nil;

@interface TimePickerView ()
@property (strong, nonatomic) IBOutlet UIView *timePickerBasicView;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePickerView;

@end

@implementation TimePickerView

+(TimePickerView*)initPickerViewWithSubview:(UIView*)view
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            CGSize pickerViewSize;
            CGPoint pickerViewPoint;
            pickerViewSize.height=view.frame.size.height*25/100;
            pickerViewSize.width=view.frame.size.width;
            pickerViewPoint.x=0;
            pickerViewPoint.y=view.frame.size.height;
            
            instance=[[TimePickerView alloc]initWithFrame:CGRectMake(pickerViewPoint.x,pickerViewPoint.y,pickerViewSize.width,pickerViewSize.height)];
            [view addSubview:instance];
        
        }
        else
        {
            CGSize pickerViewSize;
            CGPoint pickerViewPoint;
            pickerViewSize.height=view.frame.size.height*25/100;
            pickerViewSize.width=view.frame.size.width;
            pickerViewPoint.x=0;
            pickerViewPoint.y=view.frame.size.height;
            instance.frame=CGRectMake(pickerViewPoint.x,pickerViewPoint.y,pickerViewSize.width,pickerViewSize.height);
            [view addSubview:instance];

        
        }
    }
    return instance;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        
        [[NSBundle mainBundle]loadNibNamed:@"TimePickerView" owner:self options:nil];
        self.timePickerBasicView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.timePickerBasicView.opaque=NO;
        self.timePickerBasicView.backgroundColor=[UIColor colorWithRed:(255/255) green:(255/255) blue:(255/255) alpha:0];
        
        [self addSubview:self.timePickerBasicView];
        
        

        
    }
    
    return self;
}
-(void)setTimePickerViewTime:(NSMutableDictionary*)timeInfo
{
    NSInteger hour=[[timeInfo objectForKey:ShiftTypeInfo_Time_Hour]integerValue];
    NSInteger minute=[[timeInfo objectForKey:ShiftTypeInfo_Time_Minute]integerValue];
    
    
    NSDate * now = [[NSDate alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents * comps = [cal components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
    [comps setHour:hour];
    [comps setMinute:minute];
    
    NSDate * date = [cal dateFromComponents:comps];
    [self.timePickerView setDate:date animated:TRUE];
    
    
}

-(void)showTimePickerView:(NSMutableDictionary*)timeInfo withSetStatus:(TimePickerViewSetStatus)status
{
    self.timePickerViewSetStatus=status;
    [self setTimePickerViewTime:timeInfo];
    [self timePickerViewAnimation];
    
}
- (void)closeTimePickerView
{
    self.timePickerViewSetStatus=TimePickerViewSetStatusOff;

    [self timePickerViewAnimation];    

}
-(void)timePickerViewAnimation
{
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    
    CGRect frame=self.frame;
    
    if (self.timePickerViewSetStatus==TimePickerViewSetStatusOn)
    {
        frame.origin.y =frame.size.height*3;
        
    }
    else
    {
        frame.origin.y =frame.size.height*4;
        
    }
    self.frame=frame;
    
    [UIView commitAnimations];


}

- (IBAction)timePickerViewChange:(id)sender
{
    NSDate *date =self.timePickerView.date;
    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *minuteFormatter = [[NSDateFormatter alloc]init];
    
    [hourFormatter setDateFormat:@"HH"];
    [minuteFormatter setDateFormat:@"mm"];
    
    NSString  *hourString = [[NSString alloc]init];
    NSString  *minuteString = [[NSString alloc]init];
    
    
    hourString = [hourFormatter stringFromDate:date];
    minuteString = [minuteFormatter stringFromDate:date];
    
    NSMutableDictionary *timeInfo=[[NSMutableDictionary alloc]init];
    [timeInfo setObject:hourString forKey:ShiftTypeInfo_Time_Hour];
    [timeInfo setObject:minuteString forKey:ShiftTypeInfo_Time_Minute];
    [self.delegate selectTimePickerViewTime:timeInfo];


}

@end
