//
//  ColorChipsData.h
//  ColorChips
//
//  Created by Josh on 2017/3/22.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ColorChipsData : NSObject
+ (id)initColorChipsDatabase;

-(NSMutableArray*)loadColorChipsDatabase;
@end
