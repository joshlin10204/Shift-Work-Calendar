//
//  ShiftWorkTypeSetViewController.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/19.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShiftWorkTypeSetViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *shiftTypeTitleField;
@property (weak, nonatomic) IBOutlet UITextField *shiftTypeShortNameField;
@property (weak, nonatomic) IBOutlet UILabel *shiftBeginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shiftEndTimeLabel;
@property (nonatomic, strong) NSMutableDictionary * shiftWorkTypeInfo;
@property (nonatomic, assign) BOOL isAddNewShiftWorkType;

@end
