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
typedef enum RightBarBtnStatus
{
    RightBarBtnStatusDone  = 0,
    RightBarBtnStatusHiddenTimer,
    RightBarBtnStatusHiddenKeyboard,
} RightBarBtnStatus;




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
    
    UIBarButtonItem *rightButton;


    
}
@property (nonatomic, assign) RightBarBtnStatus rightBarBtnStatus;

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
    [self initNavigationbarRightButton];
    [self setNavigationbar];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initTimePickerView];
 
}



#pragma mark - Core Data
-(void)loadShiftWorkTypeData
{
    if (_isAddNewShiftWorkType)
    {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMddkkmmss"];
        typeID=[formatter stringFromDate:date];
        shiftTypeColor=[UIColor colorWithRed:(255/255.0f) green:(225/255.0f) blue:(26/255.0f) alpha:1];
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
#pragma mark - Navigationbar
-(void)setNavigationbar
{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    self.navigationController.navigationBar.barTintColor = shiftTypeColor;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    NSDictionary *attributesInfo=[[NSDictionary alloc]initWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Futura-Bold" size:16.0], NSFontAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributesInfo];
    
    self.navigationController.navigationBar.translucent = NO;

    [[UIBarButtonItem appearance] setTitleTextAttributes:attributesInfo forState:UIControlStateNormal];

}

#pragma mark - RightBarButton
-(void)initNavigationbarRightButton
{
    self.rightBarBtnStatus=RightBarBtnStatusDone;
    UIImage *image=[UIImage imageNamed:@"ShiftCalendar_Button_Done"];
    rightButton = [[UIBarButtonItem alloc] initWithImage:image
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(onClickRightBtn)];
    self.navigationItem.rightBarButtonItem=rightButton;
}

- (void)onClickRightBtn
{
    
    switch(self.rightBarBtnStatus)
    {
        case RightBarBtnStatusDone:
            [self checkSaveShiftWorkType];

            
            break;
            
        case RightBarBtnStatusHiddenTimer:

            [self closeTimePickerView];
            [self updateRightBarButtonBtnImage:RightBarBtnStatusDone];
            [self updateRightBarBtnStatus:RightBarBtnStatusDone];

            break;
        case RightBarBtnStatusHiddenKeyboard:

            [self.shiftTypeTitleField resignFirstResponder];
            [self.shiftTypeShortNameField resignFirstResponder];
            [self updateRightBarButtonBtnImage:RightBarBtnStatusDone];
            [self updateRightBarBtnStatus:RightBarBtnStatusDone];
            break;
            
        default:
            break;
    }

    
    
}

-(void)updateRightBarButtonBtnImage:(RightBarBtnStatus)status
{
    UIImage *image;
    switch(status)
    {
        case RightBarBtnStatusDone:
            image=[UIImage imageNamed:@"ShiftCalendar_Button_Done"];
            break;
            
        case RightBarBtnStatusHiddenTimer:
            image=[UIImage imageNamed:@"ShiftCalendar_Button_HiddenKeyboard"];
            break;
        case RightBarBtnStatusHiddenKeyboard:
            image=[UIImage imageNamed:@"ShiftCalendar_Button_HiddenKeyboard"];
            break;
            
        default:
            break;
    }
    
    rightButton.image=image;
    
}

-(void)updateRightBarBtnStatus:(RightBarBtnStatus)status
{
    switch(self.rightBarBtnStatus)
    {
        case RightBarBtnStatusDone:
            self.rightBarBtnStatus=status;
            break;
            
        case RightBarBtnStatusHiddenTimer:
            if (status !=RightBarBtnStatusHiddenTimer)
            {
                [self closeTimePickerView];
                self.rightBarBtnStatus=status;
            }
            break;
            
        case RightBarBtnStatusHiddenKeyboard:
            if (status !=RightBarBtnStatusHiddenKeyboard)
            {
                [self.shiftTypeTitleField resignFirstResponder];
                [self.shiftTypeShortNameField resignFirstResponder];
                self.rightBarBtnStatus=status;

            }
            break;
            
        default:
            break;
    }



}
-(void)checkSaveShiftWorkType
{
    BOOL isEmptyTitleField=self.shiftTypeTitleField.text.length==0;
    BOOL isEmptyShortField=self.shiftTypeShortNameField.text.length==0;

    
    if (isEmptyTitleField || isEmptyShortField)
    {
        NSString*string=[[NSString alloc]init];
        if (isEmptyTitleField)
        {
            string=@"Shift Work Title Name This Empty";
        }
        else if (isEmptyShortField)
        {
            string=@"Shift Work Short Name This Empty";

        }
        else
        {
            string=@"Field is Empty";
        }
        [self showAlertView:string];

    }
    else
    {
        [self saveShiftWorkTypeData];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }

}

-(void)showAlertView:(NSString*)string
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Note"
                                                                             message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
    
    [alertController addAction:okAction];

    
    [self presentViewController:alertController animated:YES completion:nil];
    

}
#pragma mark - Shift Work Text Field
-(void)initShiftTypeNameText
{
    
    
    self.shiftTypeTitleField.text=titleName;
    self.shiftTypeShortNameField.text=shortName;
    self.shiftTypeTitleField.textColor=[UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
    self.shiftTypeShortNameField.textColor=[UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f];

    self.shiftTypeTitleField.delegate=self;
    self.shiftTypeShortNameField.delegate=self;


    
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    [self updateRightBarButtonBtnImage:RightBarBtnStatusDone];

    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField*)textField
{

    [self updateRightBarButtonBtnImage:RightBarBtnStatusHiddenKeyboard];
    [self updateRightBarBtnStatus:RightBarBtnStatusHiddenKeyboard];

}
//-(void)textFieldDidEndEditing:(UITextField*)textField
//{
//    [self updateRightBarButtonBtnImage:RightBarBtnStatusHiddenKeyboard];
//}

#pragma mark - Color Chips
-(void)initColorChipsView
{

    colorChipsView=[ColorChipsView initColorChipsViewWithSubview:self.colorBasicView OrientationTypes:OrientationTypesHorizontal];
    [colorChipsView setCurColor:shiftTypeColor];
    colorChipsView.delegate=self;
    colorChipsView.selectBorderColor=[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    
}
- (void) selectColorChipsViewColor:(UIColor*)color
{

    shiftTypeColor=color;
    selectTimeLabel.textColor=shiftTypeColor;

    self.navigationController.navigationBar.barTintColor = shiftTypeColor;

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
        label.textColor=shiftTypeColor;
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
    NSString* minute=[timeInfo objectForKey:ShiftTypeInfo_Time_Minute];
    if (hour>12)
    {
        hour=hour-12;
        NSString *timeString=[[NSString alloc]initWithFormat:@"下午 %ld : %@",(long)hour,minute];
        label.text=timeString;
    }
    else if (hour==12)
    {
        NSString *timeString=[[NSString alloc]initWithFormat:@"下午 %ld : %@",(long)hour,minute];
        label.text=timeString;
    }

    else if (hour==0)
    {
        hour=12;
        NSString *timeString=[[NSString alloc]initWithFormat:@"上午 %ld : %@",(long)hour,minute];
        label.text=timeString;
    }

    else
    {
        NSString *timeString=[[NSString alloc]initWithFormat:@"上午 %ld : %@",(long)hour,minute];
        label.text=timeString;

    }
}
-(void)onClickShiftBeginTimeLabel
{
    selectTimeLabel=self.shiftBeginTimeLabel;
    
    [self updateShiftTimeLabelColor:self.shiftBeginTimeLabel withIsSelect:YES];
    [self updateShiftTimeLabelColor:self.shiftEndTimeLabel withIsSelect:NO];
    [self updateRightBarButtonBtnImage:RightBarBtnStatusHiddenTimer];
    [self updateRightBarBtnStatus:RightBarBtnStatusHiddenTimer];
    [timePickerView showTimePickerView:shiftBeginTimeInfo withSetStatus:TimePickerViewSetStatusOn];
    
    
}
-(void)onClickShiftEndTimeLabel
{
    selectTimeLabel=self.shiftEndTimeLabel;
    [self updateShiftTimeLabelColor:self.shiftBeginTimeLabel withIsSelect:NO];
    [self updateShiftTimeLabelColor:self.shiftEndTimeLabel withIsSelect:YES];
    [self updateRightBarButtonBtnImage:RightBarBtnStatusHiddenTimer];
    [self updateRightBarBtnStatus:RightBarBtnStatusHiddenTimer];


    
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
    [timePickerView closeTimePickerView];
    [self updateShiftTimeLabelColor:self.shiftBeginTimeLabel withIsSelect:NO];
    [self updateShiftTimeLabelColor:self.shiftEndTimeLabel withIsSelect:NO];    
}

- (void) selectTimePickerViewTime:(NSMutableDictionary*)timeInfo
{
    if (selectTimeLabel ==self.shiftBeginTimeLabel)
    {
        shiftBeginTimeInfo=timeInfo;
        [self updateShiftTimeLabelText:selectTimeLabel withTimeInfo:shiftBeginTimeInfo];

    }
    else
    {

        shiftEndTimeInfo=timeInfo;
        [self updateShiftTimeLabelText:selectTimeLabel withTimeInfo:shiftEndTimeInfo];
    }
    
}
@end
