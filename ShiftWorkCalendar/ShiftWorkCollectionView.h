//
//  ShiftWorkCollectionView.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/15.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum AddShiftWorkStatus
{
    AddShiftWorkStatusOff  = 0,
    AddShiftWorkStatusOn,
} AddShiftWorkStatus;

@interface ShiftWorkCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *shiftWorkCollectionBasicView;
@property (weak, nonatomic) IBOutlet UICollectionView *shiftWorkCollectionView;
@property (nonatomic, assign) AddShiftWorkStatus addShiftWorkStatus;

+(ShiftWorkCollectionView*)initShiftWorkCollectionView:(UIView*)view;
-(void) showShiftWorkCollectionView:(AddShiftWorkStatus)status;

@end
