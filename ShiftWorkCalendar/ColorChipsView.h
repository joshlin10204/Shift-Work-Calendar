//
//  ColorChipsView.h
//  ColorChips
//
//  Created by Josh on 2017/3/22.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum OrientationTypes
{
    OrientationTypesVertical  = 0,
    OrientationTypesHorizontal,
} OrientationTypes;

@interface ColorChipsView : UIView


+(ColorChipsView*)initColorChipsViewWithSubview:(UIView*)view OrientationTypes:(OrientationTypes)type;

@property (strong, nonatomic) IBOutlet UIView *colorChipsBasicView;
@property (strong, nonatomic) UITableView *colorChipsTableView;
@property (nonatomic, assign) OrientationTypes orientationTypes;

@property (strong, nonatomic)UIColor *curColor;
@property (strong, nonatomic)UIColor *selectBorderColor;

@end
