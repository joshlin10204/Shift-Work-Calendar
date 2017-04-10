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

typedef enum InformationDisplayType
{
    InformationDisplayTypeShowDate  = 0,
    InformationDisplayTypeShowShiftTitle,
} InformationDisplayType;


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
    CGRect dayLabelOriginalFrame;
    CGRect weekLabelOriginalFrame;
    CGRect todayLabelOriginalFrame;

}
@property (weak, nonatomic) IBOutlet UIView *labelBasciView;
@property (nonatomic, assign) InformationDisplayType informationDisplayType;

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
            viewSize.height=view.frame.size.height*30/100;
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


#pragma mark -Notification

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateCalendarInformation:)
                                                name:Calendar_SelectDay_Notification
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateCalendarInformation:)
                                                name:ShiftWorkType_AddShiftType_Notification
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

#pragma mark -Update Calendar Information


-(void)updateCalendarInformation:(NSNotification *)notification
{
    NSMutableDictionary *newInfo=[notification object];
    
    
    if (self.informationDisplayType==InformationDisplayTypeShowDate)
    {
        NSMutableDictionary*dayInfo=[newInfo objectForKey:@"dayInfo"];
        NSMutableDictionary *typeInfo=[newInfo objectForKey:@"typeInfo"];
        BOOL isToday = [[newInfo objectForKey:@"isToday"]boolValue];
        BOOL isHaveTypeInfo=typeInfo;
        NSString *day=[dayInfo objectForKey:CalendarData_AllDayInfo_Day];
        NSString *week=[dayInfo objectForKey:CalendarData_AllDayInfo_Week];
        UIColor *color=[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color];

        [self updateLabelInfo:dayLabel withString:day withIsHidden:NO];
        [self updateLabelInfo:weekLabel withString:week withIsHidden:NO];
        [self updateLabelInfo:todayLabel withString:@"Today" withIsHidden:!isToday];
        [self moveDayLabel:isHaveTypeInfo];
        [self moveWeekLabel:isHaveTypeInfo];
        [self moveTodayLabel:isHaveTypeInfo];
        [self moveShiftInfoViewPoint:isHaveTypeInfo];
        [self updateCalendarInformationBackgroundColor:color];
        [shiftWorkInformationView updateShiftWorkInformation:typeInfo];
    }
    else
    {
        NSString *shiftTitle=[newInfo objectForKey:CoreData_ShiftTypeInfo_TitleName];
        UIColor *color=[newInfo objectForKey:CoreData_ShiftTypeInfo_Color];
        [self updateLabelInfo:dayLabel withString:shiftTitle withIsHidden:NO];
        [self updateLabelInfo:weekLabel withString:@"" withIsHidden:YES];
        [self updateLabelInfo:todayLabel withString:@"On Add" withIsHidden:YES];
        [self updateCalendarInformationBackgroundColor:color];
        [self moveShiftInfoViewPoint:YES];
        [self moveDayLabel:YES];
        [self moveWeekLabel:YES];
        [self moveTodayLabel:YES];


        [shiftWorkInformationView updateShiftWorkInformation:newInfo];

    }

}
-(void)updateLabelInfo:(UILabel*)label withString:(NSString*)string withIsHidden:(BOOL)isHedden
{
    label.hidden=isHedden;
    label.text=string;

}

-(void)updateCalendarInformationBackgroundColor:(UIColor*)color
{
    UIColor* newColor=color;
    if (color==nil) {
        newColor=[UIColor colorWithRed:(216/255.0f) green:(216/255.0f) blue:(216/255.0f) alpha:1];
    }
    self.calendarInformationView.backgroundColor=newColor;
}
#pragma mark -Calendar Animation

-(void)moveDayLabel:(BOOL)isShowShift
{
    CGPoint newPoint;
    CGRect labelframe=dayLabel.frame;
    
    if (self.informationDisplayType==InformationDisplayTypeShowShiftTitle)
    {
        newPoint.y=self.frame.size.height/2-labelframe.size.height/2;
        newPoint.x =self.frame.size.width/4-labelframe.size.width/2;

    }
    else
    {
        newPoint.y=labelframe.origin.y;
        if (isShowShift)
        {
            newPoint.x =dayLabelOriginalFrame.origin.x;
        }
        else
        {
            newPoint.x =self.frame.size.width/2-labelframe.size.width/2;
        }

    }

    
    
    [self moveViewAnimation:dayLabel withPoint:newPoint];
    
}
-(void)moveWeekLabel:(BOOL)isShowShift
{
    CGPoint newPoint;
    CGRect labelframe=weekLabel.frame;
    
    newPoint.y=weekLabelOriginalFrame.origin.y;
    if (isShowShift)
    {
        newPoint.x =weekLabelOriginalFrame.origin.x;
    }
    else
    {
        newPoint.x =self.frame.size.width/2-labelframe.size.width/2;
    }
    
    
    [self moveViewAnimation:weekLabel withPoint:newPoint];
    
    
}
-(void)moveTodayLabel:(BOOL)isShowShift
{
    CGPoint newPoint;
    CGRect labelframe=todayLabel.frame;
    
    newPoint.y=todayLabelOriginalFrame.origin.y;
    if (isShowShift)
    {
        newPoint.x =todayLabelOriginalFrame.origin.x;
    }
    else
    {
        newPoint.x =self.frame.size.width*95/100-labelframe.size.width;
    }
    
    
    [self moveViewAnimation:todayLabel withPoint:newPoint];
    
    
    
}
#pragma mark -Zoom View Animation

-(void)enlargeInformationView
{

    self.informationDisplayType=InformationDisplayTypeShowDate;
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
    self.informationDisplayType=InformationDisplayTypeShowShiftTitle;


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
    dayLabelOriginalFrame=CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height);
    dayLabel=[[UILabel alloc]initWithFrame:dayLabelOriginalFrame];
    
    dayLabel.font=[UIFont fontWithName:@"Futura-Bold" size:200];
    dayLabel.textAlignment=NSTextAlignmentCenter;
    dayLabel.text=@"3";
    dayLabel.textColor=[UIColor whiteColor];
    dayLabel.adjustsFontSizeToFitWidth=YES;
    dayLabel.baselineAdjustment= UIBaselineAdjustmentNone;
//    dayLabel.minimumScaleFactor=0.01;
    dayLabel.numberOfLines=10;

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
    weekLabelOriginalFrame=CGRectMake(labelPoint.x,labelPoint.y,labelSize.width,labelSize.height);
    weekLabel=[[UILabel alloc]initWithFrame:weekLabelOriginalFrame];
    weekLabel.font=[UIFont fontWithName:@"Futura" size:200];
    weekLabel.textAlignment=NSTextAlignmentCenter;
    weekLabel.text=@"Friday";
    weekLabel.textColor=[UIColor whiteColor];
    weekLabel.adjustsFontSizeToFitWidth=YES;
    weekLabel.numberOfLines=2;
    weekLabel.baselineAdjustment= UIBaselineAdjustmentAlignBaselines;

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
    todayLabelOriginalFrame=CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height);
    todayLabel=[[UILabel alloc]initWithFrame:todayLabelOriginalFrame];
    
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
-(void)moveShiftInfoViewPoint:(BOOL)isShow
{

    CGPoint newPoint;
    newPoint.y=shiftWorkInformationView.frame.origin.y;
    if (isShow)
    {
        newPoint.x =self.frame.size.width*50/100;
    }
    else
    {
        newPoint.x =self.frame.size.width;
    }

    [self moveViewAnimation:shiftWorkInformationView withPoint:newPoint];
    
}
#pragma mark - Animation

-(void)moveViewAnimation:(UIView*)view withPoint:(CGPoint)point
{
    
    
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGRect viewFrame=view.frame;
    viewFrame.origin=point;
    view.frame=viewFrame;
    [UIView commitAnimations];
    
    
}


@end
