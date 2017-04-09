//
//  ShiftWorkInformationView.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/4/1.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftWorkInformationView.h"
#import "ViewController.h"
#import "CoreDataHandle.h"


static ShiftWorkInformationView *instance=nil;

@interface ShiftWorkInformationView ()
{
//    UIView * informationViewBasicView;
    CAShapeLayer *viewMaskLayer ;
    CGRect originaViewlFrame;
    UILabel *shiftWorkNameLabel;
    UILabel *shiftWorkBeginLabel;
    UILabel *shiftWorkEndLabel;
    UIImageView *shiftWorkBeginImage;
    UIImageView *shiftWorkEndImage;
}

@end

@implementation ShiftWorkInformationView

+(ShiftWorkInformationView*)initShiftWorkInformationViewInSubview:(UIView*)view
{
    
    @synchronized(self)
    {
        if (instance == nil)
        {
            CGSize viewSize;
            CGPoint viewPoint;
            viewSize.height=view.frame.size.height;
            viewSize.width=view.frame.size.width*50/100;
            viewPoint.x=view.frame.size.width*50/100;
            viewPoint.y=0;
            
            instance=[[ShiftWorkInformationView alloc]initWithFrame:CGRectMake(viewPoint.x,viewPoint.y,viewSize.width,viewSize.height)];
            [view addSubview:instance];
            
        }
        else
        {
            CGSize viewSize;
            CGPoint viewPoint;
            viewSize.height=view.frame.size.height;
            viewSize.width=view.frame.size.width*50/100;
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
        
        
        [[NSBundle mainBundle]loadNibNamed:@"ShiftWorkInformationView"
                                     owner:self options:nil];
        self.shiftWorkInformationView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.shiftWorkInformationView.opaque=NO;

        
        [self addSubview:self.shiftWorkInformationView];
        [self initNotification];
        [self initShiftWorkInformationMaskView];
        [self initShiftWorkNameLabel];
        [self initShiftWorkBeginTimeLabel];
        [self initShiftWorkEndTimeLabel];
        [self initShiftWorkBeginTimeImage];
        [self initShiftWorkEndTimeImage];
        
        
        
    }
    
    return self;
}
#pragma mark -Update Shift Work Information
-(void)updateShiftWorkInformation:(NSMutableDictionary *)info
{

    NSLog(@"update :%@",info);
    shiftWorkNameLabel.text=[info objectForKey:CoreData_ShiftTypeInfo_ShortName];
    NSMutableDictionary *timeInfo=[info objectForKey:CoreData_ShiftTypeInfo_Time];
    NSMutableDictionary *beginTimeInfo=[timeInfo objectForKey:ShiftTypeInfo_BeginTimeInfo];
    NSMutableDictionary *endTimeInfo=[timeInfo objectForKey:ShiftTypeInfo_EndTimeInfo];

    NSString * beginHour=[beginTimeInfo objectForKey:ShiftTypeInfo_Time_Hour];
    NSString * beginMinute=[beginTimeInfo objectForKey:ShiftTypeInfo_Time_Minute];
    NSString * beginTime=[[NSString alloc]initWithFormat:@"%@:%@",beginHour,beginMinute];
    NSString * endHour=[endTimeInfo objectForKey:ShiftTypeInfo_Time_Hour];
    NSString * endMinute=[endTimeInfo objectForKey:ShiftTypeInfo_Time_Minute];
    NSString * endTime=[[NSString alloc]initWithFormat:@"%@:%@",endHour,endMinute];

    
    shiftWorkBeginLabel.text=beginTime;
    shiftWorkEndLabel.text=endTime;
    
    

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

#pragma mark -MaskView

-(void)initShiftWorkInformationMaskView
{
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath=[self getViewMaskBezierPath:self.frame] ;
    
    viewMaskLayer = [CAShapeLayer layer];
    viewMaskLayer.frame = bounds;
    viewMaskLayer.path = maskPath.CGPath;
    [self.layer addSublayer:viewMaskLayer];
    self.layer.mask=viewMaskLayer;
    
}
-(UIBezierPath*)getViewMaskBezierPath:(CGRect)frame
{
    
    CGSize shapeFrame;
    shapeFrame.height=frame.size.height;
    shapeFrame.width=frame.size.width;
    CGSize layerFrame;
    layerFrame.width=shapeFrame.width*80/100;
    
    
    UIBezierPath *maskPath=[[UIBezierPath alloc]init] ;
    [maskPath moveToPoint:CGPointMake(shapeFrame.width-layerFrame.width, 0)];
    [maskPath addLineToPoint:CGPointMake(shapeFrame.width, 0)];
    [maskPath addLineToPoint:CGPointMake(shapeFrame.width, shapeFrame.height)];
    [maskPath addLineToPoint:CGPointMake(shapeFrame.width-layerFrame.width, shapeFrame.height)];
    [maskPath addQuadCurveToPoint:CGPointMake(shapeFrame.width-layerFrame.width, 0)
                     controlPoint:CGPointMake(-shapeFrame.width*20/100,
                                              shapeFrame.height/2)];
    
    return maskPath;
}


#pragma mark -Shift Work Information

-(void)initShiftWorkNameLabel
{
    CGPoint labelPoint;
    CGSize labelSize;
    labelSize.width=self.frame.size.width*60/100;
    labelSize.height=self.frame.size.height*15/100;
    labelPoint.x=self.frame.size.width*30/100;
    labelPoint.y=self.frame.size.height*20/100;
    shiftWorkNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
    
    shiftWorkNameLabel.font=[UIFont fontWithName:@"Futura-Bold" size:200];
    shiftWorkNameLabel.textAlignment=NSTextAlignmentCenter;
    shiftWorkNameLabel.textColor=[UIColor whiteColor];
    shiftWorkNameLabel.adjustsFontSizeToFitWidth=YES;
    shiftWorkNameLabel.numberOfLines=0;
    shiftWorkNameLabel.text=@"早班";
    [self addSubview:shiftWorkNameLabel];

}

-(void)initShiftWorkBeginTimeLabel
{
    CGPoint labelPoint;
    CGSize labelSize;
    labelSize.width=self.frame.size.width*40/100;
    labelSize.height=self.frame.size.height*15/100;
    labelPoint.x=self.frame.size.width*50/100;
    labelPoint.y=self.frame.size.height/2-labelSize.height/2;
    shiftWorkBeginLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
    
    shiftWorkBeginLabel.font=[UIFont fontWithName:@"Futura-Bold" size:200];
    shiftWorkBeginLabel.textAlignment=NSTextAlignmentCenter;
    shiftWorkBeginLabel.textColor=[UIColor whiteColor];
    shiftWorkBeginLabel.adjustsFontSizeToFitWidth=YES;
    shiftWorkBeginLabel.numberOfLines=0;
    shiftWorkBeginLabel.text=@"09:00";
    [self addSubview:shiftWorkBeginLabel];
}
-(void)initShiftWorkBeginTimeImage
{
    CGPoint imagePoint;
    CGSize imageSize;
    imageSize.width=self.frame.size.width*12/100;
    imageSize.height=imageSize.width;
    imagePoint.x=self.frame.size.width*30/100;;
    imagePoint.y=self.frame.size.height/2-imageSize.height/2;
    
    shiftWorkBeginImage = [[UIImageView alloc] initWithFrame: CGRectMake(imagePoint.x,imagePoint.y,imageSize.width,imageSize.height)];
    shiftWorkBeginImage.image = [UIImage imageNamed:@"TestType01"];
    [self addSubview:shiftWorkBeginImage];
}

-(void)initShiftWorkEndTimeLabel
{
    CGPoint labelPoint;
    CGSize labelSize;
    labelSize.width=self.frame.size.width*40/100;
    labelSize.height=self.frame.size.height*15/100;
    labelPoint.x=self.frame.size.width*50/100;
    labelPoint.y=self.frame.size.height*65/100;
    shiftWorkEndLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelPoint.x, labelPoint.y, labelSize.width, labelSize.height)];
    
    shiftWorkEndLabel.font=[UIFont fontWithName:@"Futura-Bold" size:200];
    shiftWorkEndLabel.textAlignment=NSTextAlignmentCenter;
    shiftWorkEndLabel.textColor=[UIColor whiteColor];
    shiftWorkEndLabel.adjustsFontSizeToFitWidth=YES;
    shiftWorkEndLabel.numberOfLines=0;
    shiftWorkEndLabel.text=@"18:00";
    [self addSubview:shiftWorkEndLabel];
}
-(void)initShiftWorkEndTimeImage
{
    CGPoint imagePoint;
    CGSize imageSize;
    imageSize.width=self.frame.size.width*12/100;
    imageSize.height=imageSize.width;
    imagePoint.x=self.frame.size.width*30/100;;
    imagePoint.y=self.frame.size.height*65/100;
    shiftWorkEndImage = [[UIImageView alloc] initWithFrame: CGRectMake(imagePoint.x,imagePoint.y,imageSize.width,imageSize.height)];
    shiftWorkEndImage.image =[UIImage imageNamed:@"TestType03"];
    [self addSubview:shiftWorkEndImage];
    
    
}
#pragma mark -Zoom Animation

-(void)enlargeInformationView
{
    [self transformViewMaskAnimation:originaViewlFrame withNowFrame:self.frame];
    [self transformViewFrameAnimation:originaViewlFrame];

    [self transformAllInfoSizeAnimation:YES];

}
-(void)reducedInformationView
{
    originaViewlFrame=self.frame;
    CGRect viewFrame=self.frame;
    viewFrame.size.height=self.frame.size.height*80/100;
    
    
    
    [self transformViewMaskAnimation:viewFrame withNowFrame:self.frame];
    [self transformViewFrameAnimation:viewFrame];
    [self transformAllInfoSizeAnimation:NO];

    
}
-(void)transformViewFrameAnimation:(CGRect)frame
{
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame=frame;
    
    
    CGRect nameLabelFrame=shiftWorkNameLabel.frame;
    nameLabelFrame.origin.y=frame.size.height*20/100;
    shiftWorkNameLabel.frame=nameLabelFrame;
    
    CGRect beginLabelFrame=shiftWorkBeginLabel.frame;
    beginLabelFrame.origin.y=frame.size.height/2-beginLabelFrame.size.height/2;
    shiftWorkBeginLabel.frame=beginLabelFrame;

    CGRect endLabelFrame=shiftWorkEndLabel.frame;
    endLabelFrame.origin.y=frame.size.height*65/100;
    shiftWorkEndLabel.frame=endLabelFrame;

    CGRect beginImageFrame=shiftWorkBeginImage.frame;
    beginImageFrame.origin.y=frame.size.height/2-beginLabelFrame.size.height/2;
    shiftWorkBeginImage.frame=beginImageFrame;

    CGRect endImageFrame=shiftWorkEndImage.frame;
    endImageFrame.origin.y=frame.size.height*65/100;
    shiftWorkEndImage.frame=endImageFrame;



    
    [UIView commitAnimations];

}
-(void)transformViewMaskAnimation:(CGRect)frame withNowFrame:(CGRect)nowFrame
{
    UIBezierPath *maskPath=[self getViewMaskBezierPath:frame] ;
    UIBezierPath *nowPath=[self getViewMaskBezierPath:nowFrame] ;

    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
    pathAnim.duration = 0.5;
    pathAnim.repeatCount = 0;
    pathAnim.autoreverses = NO;
    pathAnim.fromValue = (id)nowPath.CGPath;
    pathAnim.toValue = (id)maskPath.CGPath;
    
    //防止動畫結束後返回初始layer大小
    pathAnim.removedOnCompletion = NO;
    pathAnim.fillMode = kCAFillModeForwards;
    [viewMaskLayer addAnimation:pathAnim forKey:@"scale-layer"];
    
}

-(void)transformAllInfoSizeAnimation:(BOOL)isRecovery
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = 0.5;
    animation.repeatCount = 0;
    animation.autoreverses = NO;
    if (isRecovery){
        animation.fromValue = [NSNumber numberWithFloat:0.9];
        animation.toValue = [NSNumber numberWithFloat:1.0];
    }else{
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:0.9];
    }
    //防止動畫結束後返回初始layer大小
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;

    [shiftWorkNameLabel.layer addAnimation:animation forKey:@"scale-layer"];
    [shiftWorkBeginLabel.layer addAnimation:animation forKey:@"scale-layer"];
    [shiftWorkEndLabel.layer addAnimation:animation forKey:@"scale-layer"];
    [shiftWorkBeginImage.layer addAnimation:animation forKey:@"scale-layer"];
    [shiftWorkEndImage.layer addAnimation:animation forKey:@"scale-layer"];
    



}

@end
