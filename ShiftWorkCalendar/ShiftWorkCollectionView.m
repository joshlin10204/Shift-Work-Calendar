//
//  ShiftWorkCollectionView.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/15.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftWorkCollectionView.h"
#import "ShiftWorkCell.h"
#import "CoreDataHandle.h"


static ShiftWorkCollectionView *instance=nil;

@interface ShiftWorkCollectionView ()
{
    CGFloat cellLineSpacing;
    CGFloat cellInteritemSpacing;
    NSMutableArray *shiftWorkTypeInfosArray;
    ShiftWorkCell * selectShiftCell;
}

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
        [self reloadShiftWorkTypeData];

        [self initShiftWorkCell];
        [self initShiftWorkCollectionView];


        
        
    }
    
    return self;
}
#pragma mark - Shift Work Type Data
//- (NSMutableArray *)shiftWorkTypeInfosArray
//{
//    if (!shiftWorkTypeInfosArray) {
//        
//        shiftWorkTypeInfosArray = [NSMutableArray array];
//    }
//    
//    return shiftWorkTypeInfosArray;
//}
//
-(void)reloadShiftWorkTypeData
{
    shiftWorkTypeInfosArray = [[CoreDataHandle shareCoreDatabase] loadAllShiftWorkType];

    [self.shiftWorkCollectionView reloadData];

}


#pragma mark - Show Shift Work View

-(void) showShiftWorkCollectionView:(AddShiftWorkStatus)status;
{
    
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];


    CGRect frame=self.frame;
    
    if (status==AddShiftWorkStatusOn)
    {
        self.addShiftWorkStatus=AddShiftWorkStatusOn;
        frame.origin.y =frame.size.height*4;
        [self selectFirstCell];
    }
    else
    {
        self.addShiftWorkStatus=AddShiftWorkStatusOff;
        frame.origin.y =frame.size.height*5;
        
    }
    self.frame=frame;
    
    [UIView commitAnimations];
}
-(void)selectFirstCell
{
    if (shiftWorkTypeInfosArray.count!=0)
    {
        [self collectionView:self.shiftWorkCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }

}

#pragma mark - Shift Work Collection View
-(void)initShiftWorkCollectionView
{
    self.shiftWorkCollectionView.delegate=self;
    self.shiftWorkCollectionView.dataSource=self;
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressCell:)];
    longPressGr.minimumPressDuration = 0.5;
    [self.shiftWorkCollectionView addGestureRecognizer:longPressGr];


}

-(void)initShiftWorkCell
{
    [self.shiftWorkCollectionView registerNib:[UINib nibWithNibName:@"ShiftWorkCell" bundle:nil] forCellWithReuseIdentifier:@"ShiftWorkCell"];
    
    cellLineSpacing=self.frame.size.width/150;
    cellInteritemSpacing=self.frame.size.height/200;


}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return cellInteritemSpacing;
}
//列 間距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return cellLineSpacing;
    
}
//
//設置Cell的寬高
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSInteger cellTotal=[weekTotalInMonth integerValue];
    
    
    CGFloat collectionViewWigh=(self.frame.size.width-(cellLineSpacing*5))/4;
    
    CGFloat collectionViewHight=self.frame.size.height-(cellInteritemSpacing*2);
    return CGSizeMake(collectionViewWigh, collectionViewHight);
}


//設置Cell的間距 (上,左,下,右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(cellInteritemSpacing,cellLineSpacing,cellInteritemSpacing,cellLineSpacing);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (shiftWorkTypeInfosArray.count==0)
    {
        return 1;

    }
    else
    {
        NSInteger rowCount=shiftWorkTypeInfosArray.count+1;
        
        return rowCount;
    }
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellID = @"ShiftWorkCell";
    ShiftWorkCell * shiftCell=[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    

    
    if (shiftWorkTypeInfosArray.count==0||indexPath.row==shiftWorkTypeInfosArray.count)
    {
        [shiftCell setTag:0];
        UIColor *newTextColor=[UIColor colorWithRed:(100/255.0f) green:(100/255.0f) blue:(100/255.0f) alpha:1];
        UIColor *newBgColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:0];
        [self setShiftCellWithLabel:shiftCell.titleNameLabel withTextString:@"New Shift" withTextColor:newTextColor withBgColor:newBgColor];
        [self setShiftCellWithLabel:shiftCell.shortNameLabel withTextString:@"＋" withTextColor:newTextColor withBgColor:newBgColor];
        
    }
    else
    {
 
        NSMutableDictionary* typeInfo=shiftWorkTypeInfosArray[indexPath.row];
        UIColor *shiftColor=[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color];
        UIColor *clenerColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:0];
        NSString*titleString=[typeInfo objectForKey:CoreData_ShiftTypeInfo_TitleName];
        NSString*shortString=[typeInfo objectForKey:CoreData_ShiftTypeInfo_ShortName];
        NSInteger typeID=[[typeInfo objectForKey:CoreData_ShiftTypeInfo_TypeID]integerValue];
        
        [shiftCell setTag:typeID];


        [self setShiftCellWithLabel:shiftCell.shortNameLabel
                     withTextString:shortString
                      withTextColor:[UIColor whiteColor]
                        withBgColor:[shiftColor colorWithAlphaComponent:0.3]];
        [self setShiftCellWithLabel:shiftCell.titleNameLabel
                     withTextString:titleString
                      withTextColor:[shiftColor colorWithAlphaComponent:0.3]
                        withBgColor:clenerColor];
        if (indexPath.row==0)
        {
            selectShiftCell=shiftCell;
            [self onSelectCellAnimation:selectShiftCell];
        }

    
    }
    
    
    return shiftCell;
}

-(void)setShiftCellWithLabel:(UILabel*)label
              withTextString:(NSString*)textString
               withTextColor:(UIColor*)textColor
                 withBgColor:(UIColor*)bgColor
{
    label.text=textString;
    label.textColor=textColor;
    label.layer.backgroundColor=[bgColor CGColor];

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self onCancelSelectCellAnimation:selectShiftCell];
    
    selectShiftCell =(ShiftWorkCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableDictionary *info=[NSMutableDictionary new];
    
    // Tag=0 New Shift Work Cell
    if (selectShiftCell.tag==0)
    {
        [self.delegate selectShiftWorkCellWithCellType:ShiftWorkCellTypeAddShiftType withShiftTypeInfo:info];
        
    }
    else
    {
        info=shiftWorkTypeInfosArray[indexPath.row];
        [self onSelectCellAnimation:selectShiftCell];
        [self.delegate selectShiftWorkCellWithCellType:ShiftWorkCellTypeSelShiftType withShiftTypeInfo:info];

    }
}
-(void)handleLongPressCell:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:self.shiftWorkCollectionView];
        
        NSIndexPath *indexPath = [self.shiftWorkCollectionView indexPathForItemAtPoint:point];
        UICollectionViewCell *cell =[self.shiftWorkCollectionView cellForItemAtIndexPath:indexPath];
        NSMutableDictionary *info=[NSMutableDictionary new];
        
        if (cell.tag!=0)
        {
            info=shiftWorkTypeInfosArray[indexPath.row];
            [self.delegate selectShiftWorkCellWithCellType:ShiftWorkCellTypeEditShiftType withShiftTypeInfo:info];
        }
    }
    else
    {
        return;
    
    }

}
-(void)onSelectCellAnimation:(ShiftWorkCell*)cell
{
    cell.shortNameLabel.layer.backgroundColor=[[cell.titleNameLabel.textColor colorWithAlphaComponent:1]CGColor];
    cell.titleNameLabel.textColor=[cell.titleNameLabel.textColor colorWithAlphaComponent:1];

    CABasicAnimation* openAnim = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    openAnim.fromValue = [NSNumber numberWithFloat:1];
    openAnim.toValue = [NSNumber numberWithFloat:1.1];
    openAnim.duration = 0.3;
    openAnim.repeatCount = 0;
    openAnim.autoreverses = NO;
    openAnim.removedOnCompletion = NO;
    openAnim.fillMode = kCAFillModeForwards;
    [cell.shortNameLabel.layer addAnimation:openAnim forKey:@"scale-layer"];
}
-(void)onCancelSelectCellAnimation:(ShiftWorkCell*)cell
{
    cell.shortNameLabel.layer.backgroundColor=[[cell.titleNameLabel.textColor colorWithAlphaComponent:0.3]CGColor];
    cell.titleNameLabel.textColor=[cell.titleNameLabel.textColor colorWithAlphaComponent:0.3];


    CABasicAnimation* openAnim = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    openAnim.fromValue = [NSNumber numberWithFloat:1.1];
    openAnim.toValue = [NSNumber numberWithFloat:1.0];
    openAnim.duration = 0.3;
    openAnim.repeatCount = 0;
    openAnim.autoreverses = NO;
    openAnim.removedOnCompletion = NO;
    openAnim.fillMode = kCAFillModeForwards;
    [cell.shortNameLabel.layer addAnimation:openAnim forKey:@"scale-layer"];
}

-(void)sendNotification
{


}
@end
