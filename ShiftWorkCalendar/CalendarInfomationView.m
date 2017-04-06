//
//  CalendarInfomationView.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/31.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "CalendarInfomationView.h"
#import "ShiftWorkInformationView.h"
#import "ViewController.h"

static CalendarInfomationView *instance=nil;

@interface CalendarInfomationView ()
{
    ShiftWorkInformationView *shiftWorkInformationView;
    CGRect originaViewlFrame;
    CGAffineTransform originalDayLabelAffineTransform;
    CGAffineTransform originalWeekLabelAffineTransform;

    UILabel *dayLabel;
    UILabel *weekLabel;

}
@property (weak, nonatomic) IBOutlet UIView *labelBasciView;

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
        [self initNotification];
        [self initDaylabel];
        [self initWeeklabel];
        
        
    }
    
    return self;
}

-(void)updateInformation:(NSMutableDictionary*)info
{
    


}

#pragma mark -Notification

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(enlargeInformationView)
                                                name:ShiftWorkType_CloseAddView_Notification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reducedInformationView)
                                                name:ShiftWorkType_ShowAddView_Notification
                                              object:nil];    
    
}

-(void)enlargeInformationView
{

    [UIView animateWithDuration:0.5 animations:^{
        dayLabel.transform = originalDayLabelAffineTransform;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        weekLabel.transform = originalWeekLabelAffineTransform;
    }];

    
    CGRect frame=originaViewlFrame;

    [self zoomViewAnimation:frame];


}
-(void)reducedInformationView
{

    originalDayLabelAffineTransform=dayLabel.transform;
    [UIView animateWithDuration:0.5 animations:^{
        dayLabel.transform = CGAffineTransformScale(dayLabel.transform,0.8,0.8);
    }];
    
    originalWeekLabelAffineTransform=CGAffineTransformScale(weekLabel.transform, 1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        weekLabel.transform = CGAffineTransformScale(weekLabel.transform,0.8,0.8);
    }];

    originaViewlFrame=self.frame;
    CGRect viewFrame=self.frame;
    viewFrame.size.height=self.frame.size.height*80/100;
    [self zoomViewAnimation:viewFrame];

    
    
}

-(void)zoomViewAnimation:(CGRect)frame
{
    
    
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame=frame;
    CGRect dayLabelFrame=dayLabel.frame;
    dayLabelFrame.origin.y=frame.size.height*10/100;
    dayLabel.frame=dayLabelFrame;
    CGRect weelLabelFrame=weekLabel.frame;
    weelLabelFrame.origin.y=frame.size.height*70/100;
    weekLabel.frame=weelLabelFrame;

    [UIView commitAnimations];

}

#pragma mark -Label

-(void)initDaylabel
{
    CGPoint labelPoint;
    CGSize labelSize;
    labelSize.height=self.frame.size.height*70/100;
    labelSize.width=self.frame.size.width*50/100;
    labelPoint.x=0;
    labelPoint.y=self.frame.size.height*10/100;
    dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
    
    dayLabel.font=[UIFont fontWithName:@"Futura-Bold" size:200];
    dayLabel.textAlignment=NSTextAlignmentCenter;
    dayLabel.text=@"3";
    dayLabel.textColor=[UIColor whiteColor];
    dayLabel.adjustsFontSizeToFitWidth=YES;
    dayLabel.numberOfLines=0;
    [self addSubview:dayLabel];

}


-(void)initWeeklabel
{
    CGPoint labelPoint;
    CGSize labelSize;
    labelSize.height=self.frame.size.height*25/100;
    labelSize.width=self.frame.size.width*50/100;
    labelPoint.x=0;
    labelPoint.y=self.frame.size.height*70/100;
    weekLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
    
    weekLabel.font=[UIFont fontWithName:@"Futura-Bold" size:200];
    weekLabel.textAlignment=NSTextAlignmentCenter;
    weekLabel.text=@"Friday";
    weekLabel.textColor=[UIColor whiteColor];
    weekLabel.adjustsFontSizeToFitWidth=YES;
    weekLabel.numberOfLines=0;
    [self addSubview:weekLabel];
    
}




#pragma mark -Shift Work Information
-(void)initShiftWorkInformationView:(UIView*)view
{
    shiftWorkInformationView=[ShiftWorkInformationView initShiftWorkInformationViewInSubview:view];
}

@end
