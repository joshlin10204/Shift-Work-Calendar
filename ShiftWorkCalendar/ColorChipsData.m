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

    
    
    UIColor *color1=[UIColor colorWithRed:(248/255.0f) green:(248/255.0f) blue:(1/255.0f) alpha:1];
    UIColor *color2=[UIColor colorWithRed:(248/255.0f) green:(201/255.0f) blue:(0/255.0f) alpha:1];
    UIColor *color3=[UIColor colorWithRed:(243/255.0f) green:(152/255.0f) blue:(1/255.0f) alpha:1];
    UIColor *color4=[UIColor colorWithRed:(235/255.0f) green:(97/255.0f) blue:(0/255.0f) alpha:1];
    UIColor *color5=[UIColor colorWithRed:(230/255.0f) green:(0/255.0f) blue:(18/255.0f) alpha:1];
    UIColor *color6=[UIColor colorWithRed:(208/255.0f) green:(2/255.0f) blue:(95/255.0f) alpha:1];
    UIColor *color7=[UIColor colorWithRed:(146/255.0f) green:(29/255.0f) blue:(84/255.0f) alpha:1];
    UIColor *color8=[UIColor colorWithRed:(97/255.0f) green:(25/255.0f) blue:(133/255.0f) alpha:1];
    UIColor *color9=[UIColor colorWithRed:(29/255.0f) green:(32/255.0f) blue:(137/255.0f) alpha:1];
    UIColor *color10=[UIColor colorWithRed:(1/255.0f) green:(71/255.0f) blue:(158/255.0f) alpha:1];
    UIColor *color11=[UIColor colorWithRed:(26/255.0f) green:(150/255.0f) blue:(212/255.0f) alpha:1];
    UIColor *color12=[UIColor colorWithRed:(66/255.0f) green:(144/255.0f) blue:(56/255.0f) alpha:1];
    UIColor *color13=[UIColor colorWithRed:(142/255.0f) green:(194/255.0f) blue:(31/255.0f) alpha:1];
//    UIColor *color14=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:1];
    UIColor *color15=[UIColor colorWithRed:(221/255.0f) green:(221/255.0f) blue:(221/255.0f) alpha:1];
    UIColor *color16=[UIColor colorWithRed:(160/255.0f) green:(160/255.0f) blue:(160/255.0f) alpha:1];
    UIColor *color17=[UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1];
    
    
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
//    [colorChipsData addObject:color14];
    [colorChipsData addObject:color15];
    [colorChipsData addObject:color16];
    [colorChipsData addObject:color17];
    
    return colorChipsData;
}


@end
