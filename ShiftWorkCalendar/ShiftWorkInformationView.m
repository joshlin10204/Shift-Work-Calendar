//
//  ShiftWorkInformationView.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/4/1.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftWorkInformationView.h"
static ShiftWorkInformationView *instance=nil;

@interface ShiftWorkInformationView ()

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
        [self initShiftWorkInformationMaskView];
        
        
        
    }
    
    return self;
}

-(void)initShiftWorkInformationMaskView
{
    CGRect bounds = self.bounds;
    CGSize shapeFrame;
    shapeFrame.height=self.frame.size.height;
    shapeFrame.width=self.frame.size.width;
    
    CGSize layerFrame;
    layerFrame.width=shapeFrame.width*75/100;
    
    
    UIBezierPath *maskPath=[[UIBezierPath alloc]init] ;
    [maskPath moveToPoint:CGPointMake(shapeFrame.width-layerFrame.width, 0)];
    [maskPath addLineToPoint:CGPointMake(shapeFrame.width, 0)];
    [maskPath addLineToPoint:CGPointMake(shapeFrame.width, shapeFrame.height)];
    [maskPath addLineToPoint:CGPointMake(shapeFrame.width-layerFrame.width, shapeFrame.height)];
    [maskPath addQuadCurveToPoint:CGPointMake(shapeFrame.width-layerFrame.width, 0)
                     controlPoint:CGPointMake(-shapeFrame.width*25/100,
                                              shapeFrame.height/2)];
    
    
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer addSublayer:maskLayer];
    self.layer.mask=maskLayer;
    
}


@end
