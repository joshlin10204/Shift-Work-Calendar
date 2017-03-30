//
//  ColorChipsData.m
//  ColorChips
//
//  Created by Josh on 2017/3/22.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ColorChipsData.h"


@implementation ColorChipsData
static ColorChipsData *database;

+ (id)initColorChipsDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        database = [[ColorChipsData alloc] init];
    });
    if (!onceToken)
    {
        
    }
    return database;
}

-(NSMutableArray*)loadColorChipsDatabase;
{
    NSMutableArray *colorChipsData=[[NSMutableArray alloc]init];

    
    
    UIColor *color1=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(26/255.0f) alpha:1];
    UIColor *color2=[UIColor colorWithRed:(255/255.0f) green:(120/255.0f) blue:(20/255.0f) alpha:1];
    UIColor *color3=[UIColor colorWithRed:(255/255.0f) green:(60/255.0f) blue:(25/255.0f) alpha:1];
    
    UIColor *color4=[UIColor colorWithRed:(250/255.0f) green:(20/255.0f) blue:(50/255.0f) alpha:1];
    UIColor *color5=[UIColor colorWithRed:(255/255.0f) green:(45/255.0f) blue:(100/255.0f) alpha:1];
    UIColor *color6=[UIColor colorWithRed:(255/255.0f) green:(10/255.0f) blue:(15/255.0f) alpha:1];
    
    UIColor *color7=[UIColor colorWithRed:(255/255.0f) green:(100/255.0f) blue:(255/255.0f) alpha:1];
    UIColor *color8=[UIColor colorWithRed:(197/255.0f) green:(60/255.0f) blue:(255/255.0f) alpha:1];
    UIColor *color9=[UIColor colorWithRed:(100/255.0f) green:(70/255.0f) blue:(255/255.0f) alpha:1];
    
    
    UIColor *color10=[UIColor colorWithRed:(20/255.0f) green:(70/255.0f) blue:(255/255.0f) alpha:1];
    UIColor *color11=[UIColor colorWithRed:(0/255.0f) green:(180/255.0f) blue:(255/255.0f) alpha:1];
    UIColor *color12=[UIColor colorWithRed:(40/255.0f) green:(220/255.0f) blue:(220/255.0f) alpha:1];
    
    UIColor *color13=[UIColor colorWithRed:(80/255.0f) green:(240/255.0f) blue:(180/255.0f) alpha:1];
    UIColor *color14=[UIColor colorWithRed:(0/255.0f) green:(200/255.0f) blue:(130/255.0f) alpha:1];

    UIColor *color15=[UIColor colorWithRed:(0/255.0f) green:(215/255.0f) blue:(60/255.0f) alpha:1];
    
    
    UIColor *color16=[UIColor colorWithRed:(0/255.0f) green:(174/255.0f) blue:(10/255.0f) alpha:1];
    UIColor *color17=[UIColor colorWithRed:(120/255.0f) green:(220/255.0f) blue:(0/255.0f) alpha:1];
    UIColor *color18=[UIColor colorWithRed:(200/255.0f) green:(240/255.0f) blue:(0/255.0f) alpha:1];
    UIColor *color19=[UIColor colorWithRed:(68/255.0f) green:(68/255.0f) blue:(68/255.0f) alpha:1];
    
    
    [colorChipsData addObject:color1];
    [colorChipsData addObject:color2];
    [colorChipsData addObject:color3];
    [colorChipsData addObject:color4];
    [colorChipsData addObject:color5];
    [colorChipsData addObject:color6];
    [colorChipsData addObject:color7];
    [colorChipsData addObject:color8];
    [colorChipsData addObject:color9];
    [colorChipsData addObject:color10];
    [colorChipsData addObject:color11];
    [colorChipsData addObject:color12];
    [colorChipsData addObject:color13];
    [colorChipsData addObject:color14];
    [colorChipsData addObject:color15];
    [colorChipsData addObject:color16];
    [colorChipsData addObject:color17];
    [colorChipsData addObject:color18];
    [colorChipsData addObject:color19];
    
    return colorChipsData;
}


@end
