//
//  ShiftWorkInformationView.h
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/4/1.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiftWorkInformationView : UIView
+(ShiftWorkInformationView*)initShiftWorkInformationViewInSubview:(UIView*)view;
@property (strong, nonatomic) IBOutlet UIView *shiftWorkInformationView;

-(void)updateShiftWorkInformation:(NSMutableDictionary *)info;

@end
