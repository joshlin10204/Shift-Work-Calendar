//
//  ColorChipsView.m
//  ColorChips
//
//  Created by Josh on 2017/3/22.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ColorChipsView.h"
#import "ColorChipsCell.h"
#import "ColorChipsData.h"

#define LastSetColor       @"LastPenColor"


static ColorChipsView *instance=nil;

@interface ColorChipsView ()
{
    UITableView *colorChipsTableView;

    NSMutableArray *colorChipsArray;
    
    NSInteger curSelectCellRow;


}

@end

@implementation ColorChipsView
+(ColorChipsView*)initColorChipsViewWithSubview:(UIView*)view OrientationTypes:(OrientationTypes)type
{

    @synchronized(self)
    {
        if (instance == nil)
        {
            CGSize colorChipsViewSize;
            CGPoint colorChipsViewPoint;
            colorChipsViewSize.height=view.frame.size.height;
            colorChipsViewSize.width=view.frame.size.width;
            colorChipsViewPoint.x=0;
            colorChipsViewPoint.y=0;
            
            instance=[[ColorChipsView alloc]initWithFrame:CGRectMake(colorChipsViewPoint.x,colorChipsViewPoint.y,colorChipsViewSize.width,colorChipsViewSize.height)];
            [view addSubview:instance];
            [instance initColorChipsTableView:type];


        }
    }
    return instance;
    


}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        [self initPaletteColorsData];
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:LastSetColor];
        ;
        
        if (colorData==0)
        {
            self.curColor=[UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1];
        }
        else
            
        {
            
            self.curColor=[NSKeyedUnarchiver unarchiveObjectWithData:colorData];;
            
            
        }

        
        [[NSBundle mainBundle]loadNibNamed:@"ColorChipsView" owner:self options:nil];
        self.colorChipsBasicView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.colorChipsBasicView.opaque=NO;
        self.colorChipsBasicView.backgroundColor=[UIColor colorWithRed:(255/255) green:(255/255) blue:(255/255) alpha:0];
        
        [self addSubview:self.colorChipsBasicView];
        
        
        
        
        
        
    }
    
    return self;
}




#pragma mark -  Color Chips Data
-(void)initPaletteColorsData
{
    colorChipsArray=[[ColorChipsData initColorChipsDatabase]loadColorChipsDatabase];
}

#pragma mark - Color Chips TableView
-(void)initColorChipsTableView:(OrientationTypes)type
{
    colorChipsTableView=[[UITableView alloc]init];
    colorChipsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    colorChipsTableView.backgroundColor=[UIColor colorWithRed:(255/255) green:(255/255) blue:(255/255) alpha:0];
    
    
    if (type==OrientationTypesHorizontal)
    {
        colorChipsTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        colorChipsTableView.opaque=NO;
        colorChipsTableView.showsVerticalScrollIndicator=NO;
    }

    colorChipsTableView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    [self addSubview:colorChipsTableView];
    [colorChipsTableView  setDelegate:self];
    [colorChipsTableView setDataSource:self];
    [colorChipsTableView registerNib:[UINib nibWithNibName:@"ColorChipsCell"
                                                          bundle:nil]
                    forCellReuseIdentifier:@"ColorChipsCell"];



}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return colorChipsArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ColorChipsCell";
    
    
    ColorChipsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    
    
    cell.backgroundColor=colorChipsArray[indexPath.row];
    
    if ([self.curColor isEqual:cell.backgroundColor])
    {
        cell.layer.borderWidth = 5;
        cell.layer.borderColor = self.selectBorderColor.CGColor;
        
    }
    else
    {
        cell.layer.borderWidth = 0;
        
    }
    
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"已選擇的cell編號:%ld",indexPath.row);
    self.curColor=colorChipsArray[indexPath.row];
    curSelectCellRow=indexPath.row;
    [colorChipsTableView reloadData];
    
    NSData *lastSetPenColor=[NSKeyedArchiver archivedDataWithRootObject:self.curColor];;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lastSetPenColor forKey:LastSetColor];
    
    NSLog(@"已選擇顏色:%@",self.curColor);

}


@end
