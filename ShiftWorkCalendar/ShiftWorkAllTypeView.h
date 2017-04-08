//
//  ShiftWorkAllTypeView.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/4/8.
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

@protocol ShiftWorkAllTypesViewDelegate <NSObject>
@required
- (void) selectShiftWorkTypeTableViewWithCellType:(ShiftWorkCellType)type withShiftTypeInfo:(NSMutableDictionary*)info;
@end


@interface ShiftWorkAllTypeView : UIView
@property (strong,nonatomic) id<ShiftWorkAllTypesViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *shiftWorkTypesBasicView;
@property (nonatomic, assign) AddShiftWorkStatus addShiftWorkStatus;
@property(strong,nonatomic)UITableView *shiftWorkTypeTableView;



+(ShiftWorkAllTypeView*)initShiftWorkAllTypeView:(UIView*)view;
+(NSMutableDictionary*)getSelectionShiftWorkType;
-(void) showShiftWorkCollectionViewAnimation:(AddShiftWorkStatus)status;
-(void) reloadShiftWorkTypeData;


@end
