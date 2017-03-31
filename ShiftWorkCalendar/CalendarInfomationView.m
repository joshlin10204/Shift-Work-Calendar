//
//  CalendarInfomationView.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/31.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "CalendarInfomationView.h"
#import "ShiftWorkInformationView.h"

static CalendarInfomationView *instance=nil;

@interface CalendarInfomationView ()
{
    ShiftWorkInformationView *shiftWorkInformationView;


}
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@end

@implementation CalendarInfomationView

+(CalendarInfomationView*)initCalendarInfomationViewInSubview:(UIView*)view
{

    @synchronized(self)
    {
        if (instance == nil)
        {
            CGSize viewSize;
            CGPoint viewPoint;
            viewSize.height=view.frame.size.height*30/100;
            viewSize.width=view.frame.size.width;
            viewPoint.x=0;
            viewPoint.y=0;
            
            instance=[[CalendarInfomationView alloc]initWithFrame:CGRectMake(viewPoint.x,viewPoint.y,viewSize.width,viewSize.height)];
            [view addSubview:instance];
            [instance initShiftWorkInformationView:instance];
//            [instance initDayLabel];

            
        }
        else
        {
            CGSize viewSize;
            CGPoint viewPoint;
            viewSize.height=view.frame.size.height*40/100;
            viewSize.width=view.frame.size.width;
            viewPoint.x=0;
            viewPoint.y=0;

            instance.frame=CGRectMake(viewPoint.x,viewPoint.y,viewSize.width,viewSize.height);
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
        
        
        [[NSBundle mainBundle]loadNibNamed:@"CalendarInfomationView" owner:self options:nil];
        self.calendarInformationView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.calendarInformationView.opaque=NO;
        [self addSubview:self.calendarInformationView];
        
        
    }
    
    return self;
}

-(void)updateInformation:(NSMutableDictionary*)info
{
    


}


#pragma mark -Shift Work Information
-(void)initShiftWorkInformationView:(UIView*)view
{
    shiftWorkInformationView=[ShiftWorkInformationView initShiftWorkInformationViewInSubview:view];
}

@end
