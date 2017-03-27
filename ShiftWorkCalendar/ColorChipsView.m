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

    NSMutableArray *colorChipsArray;
    
    NSInteger curSelectCellRow;
    NSIndexPath *selectIndexPath;


}

@end

@implementation ColorChipsView
@synthesize curColor=_curColor;
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
//            [instance specifySelectColorCellAnimation];


        }
        else
        {
            CGSize colorChipsViewSize;
            CGPoint colorChipsViewPoint;
            colorChipsViewSize.height=view.frame.size.height;
            colorChipsViewSize.width=view.frame.size.width;
            colorChipsViewPoint.x=0;
            colorChipsViewPoint.y=0;
            
            instance.frame=CGRectMake(colorChipsViewPoint.x,colorChipsViewPoint.y,colorChipsViewSize.width,colorChipsViewSize.height);
            [view addSubview:instance];

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

        
        if (self.curColor==0)
        {
            self.curColor=[UIColor colorWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1];
        }
        
        [[NSBundle mainBundle]loadNibNamed:@"ColorChipsView" owner:self options:nil];
        self.colorChipsBasicView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.colorChipsBasicView.opaque=NO;
        self.colorChipsBasicView.backgroundColor=[UIColor colorWithRed:(255/255) green:(255/255) blue:(255/255) alpha:1];
        
        [self addSubview:self.colorChipsBasicView];

        

        
    }
    
    return self;
}





#pragma mark -  Color Chips Data
-(void)initPaletteColorsData
{
    colorChipsArray=[[ColorChipsData initColorChipsDatabase]loadColorChipsDatabase];
}
-(void)setCurColor:(UIColor *)color
{
    _curColor=color;
    [self didSelectToCurColorCell];
    [self.colorChipsTableView reloadData];
    
}
-(void)didSelectToCurColorCell
{
    for (int i=0; i<colorChipsArray.count; i++)
    {
        if ([self.curColor isEqual:colorChipsArray[i]])
        {
            NSIndexPath *ip=[NSIndexPath indexPathForRow:i inSection:0];
            [self.colorChipsTableView selectRowAtIndexPath:ip
                                                  animated:NO
                                            scrollPosition:UITableViewScrollPositionMiddle];
            
        }
        
    }
    
    [self.colorChipsTableView reloadData];
    
}
#pragma mark - Color Chips TableView
-(void)initColorChipsTableView:(OrientationTypes)type
{
    self.colorChipsTableView=[[UITableView alloc]init];
    self.colorChipsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.colorChipsTableView.backgroundColor=[UIColor colorWithRed:(255/255) green:(255/255) blue:(255/255) alpha:0];
    
    
    if (type==OrientationTypesHorizontal)
    {
        self.colorChipsTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.colorChipsTableView.opaque=NO;
        self.colorChipsTableView.showsVerticalScrollIndicator=NO;
    }

    self.colorChipsTableView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    [self addSubview:self.colorChipsTableView];
    [self.colorChipsTableView  setDelegate:self];
    [self.colorChipsTableView setDataSource:self];
    [self.colorChipsTableView registerNib:[UINib nibWithNibName:@"ColorChipsCell"
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
    NSLog(@" In Cell");
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
    self.curColor=colorChipsArray[indexPath.row];
    curSelectCellRow=indexPath.row;
    [self.colorChipsTableView reloadData];
    
}


@end
