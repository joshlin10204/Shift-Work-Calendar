//
//  ShiftWorkTypeSetViewController.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/3/19.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftWorkTypeSetViewController.h"
#import "ColorChipsView.h"
#import "TimePickerView.h"
#import "CoreDataHandle.h"
#define ShiftTypeInfo_BeginTimeInfo @"ShiftTypeInfo_BeginTimeInfo"
#define ShiftTypeInfo_EndTimeInfo @"ShiftTypeInfo_EndTimeInfo"




@interface ShiftWorkTypeSetViewController ()<TimePickerViewDelegate>
{
    ColorChipsView *colorChipsView;
    TimePickerView *timePickerView;
    NSMutableDictionary *shiftBeginTimeInfo;
    NSMutableDictionary *shiftEndTimeInfo;
    UILabel*selectTimeLabel;
    
    NSString *typeID;
    NSString *titleName;
    NSString *shortName;
    UIColor *shiftTypeColor;
    NSMutableDictionary *shiftTimeInfo;


    
}
@property (weak, nonatomic) IBOutlet UIView *colorBasicView;
@end

@implementation ShiftWorkTypeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.backBarButtonItem.title=@"";
    [self loadShiftWorkTypeData];
    [self initShiftTypeNameText];
    [self initColorChipsView];
    [self initShiftTimeLabel];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initTimePickerView];


 
}

#pragma mark - Load & Save Data
-(void)loadShiftWorkTypeData
{
    if (_isAddNewShiftWorkType)
    {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMddkkmmss"];
        typeID=[formatter stringFromDate:date];
        shiftTypeColor=[UIColor colorWithRed:(243/255.0f) green:(152/255.0f) blue:(1/255.0f) alpha:1];
        self.shiftWorkTypeInfo=[[NSMutableDictionary alloc]init];
        shiftTimeInfo=[[NSMutableDictionary alloc]init];
        shiftBeginTimeInfo=[[NSMutableDictionary alloc]init];
        [shiftBeginTimeInfo setObject:@"09" forKey:ShiftTypeInfo_Time_Hour];
        [shiftBeginTimeInfo setObject:@"30" forKey:ShiftTypeInfo_Time_Minute];
        shiftEndTimeInfo=[[NSMutableDictionary alloc]init];
        [shiftEndTimeInfo setObject:@"18" forKey:ShiftTypeInfo_Time_Hour];
        [shiftEndTimeInfo setObject:@"30" forKey:ShiftTypeInfo_Time_Minute];

    }
    else
    {


        typeID=[self.shiftWorkTypeInfo objectForKey:CoreData_ShiftTypeInfo_TypeID];
        titleName=[self.shiftWorkTypeInfo objectForKey:CoreData_ShiftTypeInfo_TitleName];
        shortName=[self.shiftWorkTypeInfo objectForKey:CoreData_ShiftTypeInfo_ShortName];
        shiftTypeColor=[self.shiftWorkTypeInfo objectForKey:CoreData_ShiftTypeInfo_Color];
        shiftTimeInfo=[self.shiftWorkTypeInfo objectForKey:CoreData_ShiftTypeInfo_Time];
        shiftBeginTimeInfo=[shiftTimeInfo objectForKey:ShiftTypeInfo_BeginTimeInfo];
        shiftEndTimeInfo=[shiftTimeInfo objectForKey:ShiftTypeInfo_EndTimeInfo];
    
    }
    
}

-(void)saveShiftWorkTypeData
{

    titleName=self.shiftTypeTitleField.text;
    shortName=self.shiftTypeShortNameField.text;
    shiftTypeColor=colorChipsView.curColor;
    [shiftTimeInfo setObject:shiftBeginTimeInfo forKey:ShiftTypeInfo_BeginTimeInfo];
    [shiftTimeInfo setObject:shiftEndTimeInfo forKey:ShiftTypeInfo_EndTimeInfo];
    [self.shiftWorkTypeInfo setObject:typeID forKey:CoreData_ShiftTypeInfo_TypeID];
    [self.shiftWorkTypeInfo setObject:titleName forKey:CoreData_ShiftTypeInfo_TitleName];
    [self.shiftWorkTypeInfo setObject:shortName forKey:CoreData_ShiftTypeInfo_ShortName];
    [self.shiftWorkTypeInfo setObject:shiftTypeColor forKey:CoreData_ShiftTypeInfo_Color];
    [self.shiftWorkTypeInfo setObject:shiftTimeInfo forKey:CoreData_ShiftTypeInfo_Time];

    if (_isAddNewShiftWorkType)
    {
        ShiftWorkTypeCoreData* shiftCoreData=[[CoreDataHandle shareCoreDatabase]addShiftWorkType:self.shiftWorkTypeInfo];

    }
    else
    {
        [[CoreDataHandle shareCoreDatabase]updateShiftWorkTypeWithTypeID:typeID withShiftWorkType:self.shiftWorkTypeInfo];
        
    
    }

}
- (IBAction)onClickSaveBtn:(id)sender
{
    [self saveShiftWorkTypeData];
    
    
}
#pragma mark - Shift Work Text Field
-(void)initShiftTypeNameText
{
    self.shiftTypeTitleField.text=titleName;
    self.shiftTypeShortNameField.text=shortName;
    self.shiftTypeTitleField.textColor=[UIColor colorWithRed:74.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
    self.shiftTypeShortNameField.textColor=[UIColor colorWithRed:74.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0f];


    
}

#pragma mark - Color Chips
-(void)initColorChipsView
{

    colorChipsView=[ColorChipsView initColorChipsViewWithSubview:self.colorBasicView OrientationTypes:OrientationTypesHorizontal];
    [colorChipsView setCurColor:shiftTypeColor];
    colorChipsView.selectBorderColor=[UIColor colorWithRed:74.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
    
}


#pragma mark - Shift Work Time
#pragma mark -- Shift Work Time Label

-(void)initShiftTimeLabel
{
    [self updateShiftTimeLabelText:self.shiftBeginTimeLabel withTimeInfo:shiftBeginTimeInfo];
    [self updateShiftTimeLabelText:self.shiftEndTimeLabel withTimeInfo:shiftEndTimeInfo];

    [self updateShiftTimeLabelColor:self.shiftBeginTimeLabel withIsSelect:NO];
    [self updateShiftTimeLabelColor:self.shiftEndTimeLabel withIsSelect:NO];
    
    self.shiftBeginTimeLabel.userInteractionEnabled = YES;
    self.shiftEndTimeLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *beginTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(onClickShiftBeginTimeLabel)];
    
    UITapGestureRecognizer *endTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(onClickShiftEndTimeLabel)];
    
    [self.shiftBeginTimeLabel addGestureRecognizer:beginTapGesture];
    [self.shiftEndTimeLabel addGestureRecognizer:endTapGesture];

}
-(void)updateShiftTimeLabelColor:(UILabel*)label withIsSelect:(BOOL)isSelect
{
    if (isSelect)
    {
        label.textColor=[UIColor colorWithRed:74.0f/255.0f
                                        green:217.0f/255.0f
                                         blue:217.0f/255.0f
                                        alpha:1.0f];
    }
    else
    {
        label.textColor=[UIColor colorWithRed:100.0f/255.0f
                                        green:100.0f/255.0f
                                         blue:100.0f/255.0f
                                        alpha:1.0f];
    }

}
-(void)updateShiftTimeLabelText:(UILabel*)label withTimeInfo:(NSMutableDictionary*)timeInfo
{

    NSInteger hour=[[timeInfo objectForKey:ShiftTypeInfo_Time_Hour]integerValue];
    NSInteger minute=[[timeInfo objectForKey:ShiftTypeInfo_Time_Minute]integerValue];
    if (hour>12)
    {
        hour=hour-12;
        NSString *timeString=[[NSString alloc]initWithFormat:@"下午 %ld : %ld",(long)hour,(long)minute];
        label.text=timeString;
    }
    else if (hour==12)
    {
        NSString *timeString=[[NSString alloc]initWithFormat:@"下午 %ld : %ld",(long)hour,(long)minute];
        label.text=timeString;
    }

    else if (hour==0)
    {
        hour=12;
        NSString *timeString=[[NSString alloc]initWithFormat:@"上午 %ld : %ld",(long)hour,(long)minute];
        label.text=timeString;
    }

    else
    {
        NSString *timeString=[[NSString alloc]initWithFormat:@"上午 %ld : %ld",(long)hour,(long)minute];
        label.text=timeString;

    }
}
-(void)onClickShiftBeginTimeLabel
{
    selectTimeLabel=self.shiftBeginTimeLabel;
    
    [self updateShiftTimeLabelColor:self.shiftBeginTimeLabel withIsSelect:YES];
    [self updateShiftTimeLabelColor:self.shiftEndTimeLabel withIsSelect:NO];
    
    
    [timePickerView showTimePickerView:shiftBeginTimeInfo withSetStatus:TimePickerViewSetStatusOn];
    
    
}
-(void)onClickShiftEndTimeLabel
{
    selectTimeLabel=self.shiftEndTimeLabel;
    [self updateShiftTimeLabelColor:self.shiftBeginTimeLabel withIsSelect:NO];
    [self updateShiftTimeLabelColor:self.shiftEndTimeLabel withIsSelect:YES];
    
    
    [timePickerView showTimePickerView:shiftEndTimeInfo withSetStatus:TimePickerViewSetStatusOn];
    
}

#pragma mark -- Shift Work Time Picker View

-(void)initTimePickerView
{
    timePickerView=[TimePickerView initPickerViewWithSubview:self.view];
    timePickerView.delegate=self;

}
- (void) closeTimePickerView
{
    selectTimeLabel=nil;
    [self updateShiftTimeLabelColor:self.shiftBeginTimeLabel withIsSelect:NO];
    [self updateShiftTimeLabelColor:self.shiftEndTimeLabel withIsSelect:NO];    
}

- (void) selectTimePickerViewTime:(NSMutableDictionary*)timeInfo
{
    if (selectTimeLabel ==self.shiftBeginTimeLabel)
    {
        NSLog(@"BeginTimeLabel");
        shiftBeginTimeInfo=timeInfo;
        [self updateShiftTimeLabelText:selectTimeLabel withTimeInfo:shiftBeginTimeInfo];

    }
    else
    {
        NSLog(@"EndTimeLabel");

        shiftEndTimeInfo=timeInfo;
        [self updateShiftTimeLabelText:selectTimeLabel withTimeInfo:shiftEndTimeInfo];
    }
    
}
@end
