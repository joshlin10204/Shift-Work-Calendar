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
#import "CalendarData.h"
#import "CoreDataHandle.h"



static CalendarInfomationView *instance=nil;

@interface CalendarInfomationView ()
{
    ShiftWorkInformationView *shiftWorkInformationView;
    CGRect originaViewlFrame;
    CGAffineTransform originalDayLabelAffineTransform;
    CGAffineTransform originalWeekLabelAffineTransform;
    CGAffineTransform originalTodayLabelAffineTransform;


    UILabel *dayLabel;
    UILabel *weekLabel;
    UILabel *todayLabel;


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
        [self initTodaylabel];
        
        
    }
    
    return self;
}
#pragma mark -Update Calendar Information


-(void)updateCalendarInformation:(NSNotification *)notification
{
    NSMutableDictionary *newInfo=[notification object];
    NSMutableDictionary*dayInfo=[newInfo objectForKey:@"dayInfo"];
    NSMutableDictionary *typeInfo=[newInfo objectForKey:@"typeInfo"];
    BOOL isToday = [[newInfo objectForKey:@"isToday"]boolValue];

    NSString *day=[dayInfo objectForKey:CalendarData_AllDayInfo_Day];
    NSString *week=[dayInfo objectForKey:CalendarData_AllDayInfo_Week];

    dayLabel.text=day;
    weekLabel.text=week;
    todayLabel.hidden=!isToday;

    if (typeInfo!=nil)
    {
        self.calendarInformationView.backgroundColor=[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color];
        [self calendarInfoViewAnimation:NO];
        [self shiftInfoViewAnimation:NO];
    
        [shiftWorkInformationView updateShiftWorkInformation:typeInfo];
    }
    else
    {
        [self calendarInfoViewAnimation:YES];

        [self shiftInfoViewAnimation:YES];
        self.calendarInformationView.backgroundColor=[UIColor colorWithRed:(30/255.0f) green:(30/255.0f) blue:(30/255.0f) alpha:1];
    }


    
    
    
}


#pragma mark -Calendar Animation

-(void)calendarInfoViewAnimation:(BOOL)isShiftHide
{
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    
    CGRect dayLabelframe=dayLabel.frame;
    CGRect weekLabelframe=weekLabel.frame;
    CGRect todayLabelframe=todayLabel.frame;


    
    if (isShiftHide)
    {
        dayLabelframe.origin.x =self.frame.size.width/2-dayLabelframe.size.width/2;
        weekLabelframe.origin.x =self.frame.size.width/2-weekLabelframe.size.width/2;
        todayLabelframe.origin.x =self.frame.size.width-todayLabelframe.size.width;

        
    }
    else
    {

        dayLabelframe.origin.x =self.frame.size.width/4-dayLabelframe.size.width/2;
        weekLabelframe.origin.x =self.frame.size.width/4-weekLabelframe.size.width/2;
        todayLabelframe.origin.x =self.frame.size.width/4-todayLabelframe.size.width/2;


        
    }
    dayLabel.frame=dayLabelframe;
    weekLabel.frame=weekLabelframe;
    todayLabel.frame=todayLabelframe;
    
    [UIView commitAnimations];
    
    
    
}

#pragma mark -Notification

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateCalendarInformation:)
                                                name:Calendar_SelectDay_Notification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(enlargeInformationView)
                                                name:ShiftWorkType_CloseAddView_Notification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reducedInformationView)
                                                name:ShiftWorkType_ShowAddView_Notification
                                              object:nil];    
    
}

#pragma mark -Zoom View Animation

-(void)enlargeInformationView
{

    [UIView animateWithDuration:0.5 animations:^{
        dayLabel.transform = originalDayLabelAffineTransform;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        weekLabel.transform = originalWeekLabelAffineTransform;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        todayLabel.transform = originalTodayLabelAffineTransform;
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

    originalTodayLabelAffineTransform=CGAffineTransformScale(todayLabel.transform, 1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        todayLabel.transform = CGAffineTransformScale(todayLabel.transform,0.8,0.8);
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
    dayLabelFrame.origin.y=frame.size.height*15/100;
    dayLabel.frame=dayLabelFrame;
    CGRect weelLabelFrame=weekLabel.frame;
    weelLabelFrame.origin.y=frame.size.height*65/100;
    weekLabel.frame=weelLabelFrame;
    
    CGRect todaylLabelFrame=todayLabel.frame;
    todaylLabelFrame.origin.y=frame.size.height*88/100;
    todayLabel.frame=todaylLabelFrame;

    [UIView commitAnimations];

}

#pragma mark -Label

-(void)initDaylabel
{
    CGPoint labelPoint;
    CGSize labelSize;
    labelSize.height=self.frame.size.height*60/100;
    labelSize.width=self.frame.size.width*40/100;
    labelPoint.x=self.frame.size.width/4-labelSize.width/2;
    labelPoint.y=self.frame.size.height*15/100;
    dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
    
    dayLabel.font=[UIFont fontWithName:@"Futura" size:200];
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
    labelSize.height=self.frame.size.height*20/100;
    labelSize.width=self.frame.size.width*40/100;
    labelPoint.x=self.frame.size.width/4-labelSize.width/2;
    labelPoint.y=self.frame.size.height*65/100;
    weekLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
    
    weekLabel.font=[UIFont fontWithName:@"Futura" size:200];
    weekLabel.textAlignment=NSTextAlignmentCenter;
    weekLabel.text=@"Friday";
    weekLabel.textColor=[UIColor whiteColor];
    weekLabel.adjustsFontSizeToFitWidth=YES;
    weekLabel.numberOfLines=0;
    [self addSubview:weekLabel];
    
}

-(void)initTodaylabel
{
    CGPoint labelPoint;
    CGSize labelSize;
    labelSize.height=self.frame.size.height*10/100;
    labelSize.width=self.frame.size.width*20/100;
    labelPoint.x=self.frame.size.width/4-labelSize.width/2;
    labelPoint.y=self.frame.size.height*88/100;
    todayLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
    
    todayLabel.font=[UIFont fontWithName:@"Futura-Bold" size:200];
    todayLabel.textAlignment=NSTextAlignmentCenter;
    todayLabel.text=@"Today";
    todayLabel.textColor=[UIColor whiteColor];
    todayLabel.adjustsFontSizeToFitWidth=YES;
    todayLabel.numberOfLines=0;
    todayLabel.layer.cornerRadius=8;
    todayLabel.layer.backgroundColor=[[UIColor colorWithRed:(255/255.0f)
                                                      green:(255/255.0f)
                                                       blue:(255/255.0f)
                                                      alpha:0.3]CGColor];
    todayLabel.hidden=YES;

    [self addSubview:todayLabel];
    
}



#pragma mark -Shift Work Information
-(void)initShiftWorkInformationView:(UIView*)view
{
    shiftWorkInformationView=[ShiftWorkInformationView initShiftWorkInformationViewInSubview:view];
}
-(void)shiftInfoViewAnimation:(BOOL)isHide
{
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    
    CGRect windowView=self.window.frame;
    CGRect frame=shiftWorkInformationView.frame;
    
    if (isHide)
    {
        frame.origin.x =self.frame.size.width;
    }
    else
    {
        frame.origin.x =self.frame.size.width*50/100;
        
    }
    shiftWorkInformationView.frame=frame;
    
    [UIView commitAnimations];
    
    
    
}


@end
