//
//  ShiftWorkCollectionView.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/15.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftWorkCollectionView.h"
#import "ShiftWorkCell.h"

static ShiftWorkCollectionView *instance=nil;

@interface ShiftWorkCollectionView ()

@end

@implementation ShiftWorkCollectionView
+(ShiftWorkCollectionView*)initShiftWorkCollectionView:(UIView*)view
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            CGSize basicViewSize;
            basicViewSize.height=view.frame.size.height*20/100;
            basicViewSize.width=view.frame.size.width;
            CGPoint basicViewPoint;
            basicViewPoint.x=0;
            basicViewPoint.y=view.frame.size.height;

            instance=[[ShiftWorkCollectionView alloc]initWithFrame:CGRectMake(0,
                                                                           basicViewPoint.y,
                                                                           basicViewSize.width,
                                                                           basicViewSize.height)];
            
            
            
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
        [[NSBundle mainBundle]loadNibNamed:@"ShiftWorkCollectionView" owner:self options:nil];
        self.shiftWorkCollectionBasicView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.shiftWorkCollectionBasicView];
        
        self.shiftWorkCollectionView.delegate=self;
        self.shiftWorkCollectionView.dataSource=self;

        [self.shiftWorkCollectionView registerNib:[UINib nibWithNibName:@"ShiftWorkCell" bundle:nil] forCellWithReuseIdentifier:@"ShiftWorkCell"];
        
        
    }
    
    return self;
}

-(void) showShiftWorkCollectionView:(AddShiftWorkStatus)status;
{
    
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    CGRect frame=self.frame;
    
    if (status==AddShiftWorkStatusOn)
    {
        self.addShiftWorkStatus=AddShiftWorkStatusOn;
        
        
//        self.menuViewBackground.hidden=NO;
        frame.origin.y =frame.size.height*4;
        
        NSLog(@"%f %f",self.frame.size.height,frame.size.height*5);
    }
    else
    {
        self.addShiftWorkStatus=AddShiftWorkStatusOff;
        
        frame.origin.y =frame.size.height*5;
        
        
        
    }
    self.frame=frame;
    
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return 60;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellID = @"ShiftWorkCell";
    ShiftWorkCell * shiftCell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    return shiftCell;
}


@end
