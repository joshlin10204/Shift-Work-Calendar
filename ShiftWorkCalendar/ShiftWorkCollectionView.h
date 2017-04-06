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

typedef enum ShiftWorkCellType
{
    ShiftWorkCellTypeAddShiftType  = 0,
    ShiftWorkCellTypeEditShiftType,
    ShiftWorkCellTypeSelShiftType,
} ShiftWorkCellType;

@protocol ShiftWorkCollectionViewDelegate <NSObject>
@required
- (void) selectShiftWorkCellWithCellType:(ShiftWorkCellType)type withShiftTypeInfo:(NSMutableDictionary*)info;
@end

@interface ShiftWorkCollectionView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) id<ShiftWorkCollectionViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *shiftWorkCollectionBasicView;
@property (weak, nonatomic) IBOutlet UICollectionView *shiftWorkCollectionView;
@property (nonatomic, assign) AddShiftWorkStatus addShiftWorkStatus;

+(ShiftWorkCollectionView*)initShiftWorkCollectionView:(UIView*)view;
+(NSMutableDictionary*)getSelectionShiftWorkType;
-(void) showShiftWorkCollectionViewAnimation:(AddShiftWorkStatus)status;
-(void)reloadShiftWorkTypeData;


@end
