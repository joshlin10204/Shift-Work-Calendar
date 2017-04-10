//
//  ShiftWorkAllTypeView.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/4/8.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftWorkAllTypeView.h"
#import "ShiftWorkTypeCell.h"
#import "CoreDataHandle.h"
#import "ViewController.h"
static ShiftWorkAllTypeView *instance=nil;

@interface ShiftWorkAllTypeView ()
{
    CGFloat cellLineSpacing;
    CGFloat cellInteritemSpacing;
    NSMutableArray *shiftWorkTypeInfosArray;
    ShiftWorkTypeCell * selectShiftTypeCell;
    NSIndexPath *selectIndexPath;
    
    NSUInteger selectShiftTypeCellTag;

}
@property (weak, nonatomic) IBOutlet UIButton *addShiftWorkButton;

@end

@implementation ShiftWorkAllTypeView

+(ShiftWorkAllTypeView*)initShiftWorkAllTypeView:(UIView*)view
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            CGSize basicViewSize;
            basicViewSize.height=view.frame.size.height*15/100;
            basicViewSize.width=view.frame.size.width;
            CGPoint basicViewPoint;
            basicViewPoint.x=0;
            basicViewPoint.y=view.frame.size.height-basicViewSize.height*30/100;
            
            instance=[[ShiftWorkAllTypeView alloc]initWithFrame:CGRectMake(0,
                                                                         basicViewPoint.y,
                                                                         basicViewSize.width,
                                                                         basicViewSize.height)];
            
            
            
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
        [[NSBundle mainBundle]loadNibNamed:@"ShiftWorkAllTypeView" owner:self options:nil];
        self.shiftWorkTypesBasicView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.shiftWorkTypesBasicView];
        
        [self reloadShiftWorkTypeData];

        [self initShiftWorkTypeTableView];
        [self initNotification];
        
        
        
        
    }
    
    return self;
}
#pragma mark -Notification

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateAddShiftWorkBtnColor:)
                                                name:Calendar_SelectDay_Notification
                                              object:nil];
    
}

#pragma mark -Update Calendar Information


-(void)updateAddShiftWorkBtnColor:(NSNotification *)notification
{
    NSMutableDictionary *newInfo=[notification object];
    NSMutableDictionary *typeInfo=[newInfo objectForKey:@"typeInfo"];
    
    if (typeInfo!=nil)
    {
        self.addShiftWorkButton.backgroundColor=[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color];
    }
    else
    {
        self.addShiftWorkButton.backgroundColor=[UIColor colorWithRed:(216/255.0f) green:(216/255.0f) blue:(216/255.0f) alpha:1];

    
    }
    
}


#pragma mark - Shift Work Type Data

-(void)reloadShiftWorkTypeData
{
    shiftWorkTypeInfosArray = [[CoreDataHandle shareCoreDatabase] loadAllShiftWorkType];
    

    [self.shiftWorkTypeTableView reloadData];
    
}
#pragma mark - Show Shift Work View

- (IBAction)onClickAddShiftWorkBtn:(id)sender
{
    
    if (self.addShiftWorkStatus==AddShiftWorkStatusOff)
    {
    
        [self.addShiftWorkButton setTitle:@"X Close" forState:UIControlStateNormal];
        [self showShiftWorkCollectionViewAnimation:AddShiftWorkStatusOn];
        [[NSNotificationCenter defaultCenter]postNotificationName:ShiftWorkType_ShowAddView_Notification object:nil];
        [self onSelectCell];

    }
    else
    {
        [self.addShiftWorkButton setTitle:@"＋ Add Shift Work" forState:UIControlStateNormal];
        [self showShiftWorkCollectionViewAnimation:AddShiftWorkStatusOff];
        [[NSNotificationCenter defaultCenter]postNotificationName:ShiftWorkType_CloseAddView_Notification object:nil];
    }
    



}
-(void)showShiftWorkCollectionViewAnimation:(AddShiftWorkStatus)status;
{
    
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    
    CGRect windowView=self.window.frame;
    CGRect frame=self.frame;
    
    if (status==AddShiftWorkStatusOn)
    {
        self.addShiftWorkStatus=AddShiftWorkStatusOn;
        frame.origin.y =windowView.size.height*86/100;
    }
    else
    {
        self.addShiftWorkStatus=AddShiftWorkStatusOff;
        frame.origin.y =windowView.size.height-frame.size.height*30/100;
        
    }
    self.frame=frame;
    
    [UIView commitAnimations];
}
-(void)onSelectCell
{
    if (shiftWorkTypeInfosArray.count!=0)
    {
        if (selectIndexPath==nil)
        {
            selectIndexPath = [NSIndexPath indexPathForItem: 0 inSection:0];
        }
        
        [self.shiftWorkTypeTableView selectRowAtIndexPath:selectIndexPath
                                                 animated:NO
                                           scrollPosition:(UITableViewScrollPositionTop)];
        
        
        //解決最初 默認第一個cell ，沒反應之問題
        if ([self.shiftWorkTypeTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            [self.shiftWorkTypeTableView.delegate tableView:self.shiftWorkTypeTableView didSelectRowAtIndexPath: selectIndexPath];
        }
    }
    
    
    
}



#pragma mark - Shift Work Type Table View
-(void)initShiftWorkTypeTableView
{

    self.shiftWorkTypeTableView=[[UITableView alloc]init];
    self.shiftWorkTypeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.shiftWorkTypeTableView.backgroundColor=[UIColor colorWithRed:(255/255) green:(255/255) blue:(255/255) alpha:0];
    
    
    self.shiftWorkTypeTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    self.shiftWorkTypeTableView.opaque=NO;
    self.shiftWorkTypeTableView.showsVerticalScrollIndicator=NO;
//    clearsSelectionOnViewWillAppear
    self.shiftWorkTypeTableView.frame=CGRectMake(0,
                                                 self.frame.size.height*30/100,
                                                 self.frame.size.width,
                                                 self.frame.size.height*70/100);
    
    [self addSubview:self.shiftWorkTypeTableView];
    [self.shiftWorkTypeTableView  setDelegate:self];
    [self.shiftWorkTypeTableView setDataSource:self];
    
    [self initShiftWorkCell];

    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressCell:)];
    longPressGr.minimumPressDuration = 0.5;
    [self.shiftWorkTypeTableView addGestureRecognizer:longPressGr];
    
    
}

-(void)initShiftWorkCell
{
    [self.shiftWorkTypeTableView registerNib:[UINib nibWithNibName:@"ShiftWorkTypeCell"
                                                            bundle:nil]
                      forCellReuseIdentifier:@"ShiftWorkTypeCell"];
    
    
    cellLineSpacing=self.frame.size.width/150;
    cellInteritemSpacing=self.frame.size.height/200;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (shiftWorkTypeInfosArray.count==0)
    {
        return 1;
        
    }
    else
    {
        NSInteger rowCount=shiftWorkTypeInfosArray.count+1;
        
        return rowCount;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ShiftWorkTypeCell";
    ShiftWorkTypeCell * shiftCell=[tableView dequeueReusableCellWithIdentifier:cellID ];
    shiftCell.selectionStyle=UITableViewCellSeparatorStyleNone;
    shiftCell.opaque=NO;
    shiftCell.backgroundColor=[UIColor clearColor];
    shiftCell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    shiftCell.backgroundColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:0];
    
    if (shiftWorkTypeInfosArray.count==0||indexPath.row==shiftWorkTypeInfosArray.count)
    {
        [shiftCell setTag:0];
        UIColor *newTextColor=[UIColor colorWithRed:(100/255.0f) green:(100/255.0f) blue:(100/255.0f) alpha:1];
        UIColor *newBgColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:0];
        [self setShiftCellWithLabel:shiftCell.titleNameLabel withTextString:@"New Shift" withTextColor:newTextColor withBgColor:newBgColor];
        [self setShiftCellWithLabel:shiftCell.shortNameLabel withTextString:@"＋" withTextColor:newTextColor withBgColor:newBgColor];
        
    }
    else
    {
        
        NSMutableDictionary* typeInfo=shiftWorkTypeInfosArray[indexPath.row];
        UIColor *shiftColor=[typeInfo objectForKey:CoreData_ShiftTypeInfo_Color];
        UIColor *clenerColor=[UIColor colorWithRed:(255/255.0f) green:(255/255.0f) blue:(255/255.0f) alpha:0];
        NSString*titleString=[typeInfo objectForKey:CoreData_ShiftTypeInfo_TitleName];
        NSString*shortString=[typeInfo objectForKey:CoreData_ShiftTypeInfo_ShortName];
        NSInteger typeID=[[typeInfo objectForKey:CoreData_ShiftTypeInfo_TypeID]integerValue];
        
        [shiftCell setTag:typeID];
        
        
        [self setShiftCellWithLabel:shiftCell.shortNameLabel
                     withTextString:shortString
                      withTextColor:[UIColor whiteColor]
                        withBgColor:[shiftColor colorWithAlphaComponent:0.3]];
        [self setShiftCellWithLabel:shiftCell.titleNameLabel
                     withTextString:titleString
                      withTextColor:[shiftColor colorWithAlphaComponent:0.3]
                        withBgColor:clenerColor];
       
        //避免UITableView更新後，將目前所選的Cell 恢復沒點擊狀況
        if (shiftCell.tag == selectShiftTypeCellTag)
        {
            [self onSelectCellAnimation:selectShiftTypeCell];
        }
        
        
    }

    
    
    return shiftCell;
    
    
}
-(void)setShiftCellWithLabel:(UILabel*)label
              withTextString:(NSString*)textString
               withTextColor:(UIColor*)textColor
                 withBgColor:(UIColor*)bgColor
{
    label.text=textString;
    label.textColor=textColor;
    label.layer.backgroundColor=[bgColor CGColor];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return tableView.frame.size.width*1/4;;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self onCancelSelectCellAnimation:selectShiftTypeCell];
    
    ShiftWorkTypeCell*cell =(ShiftWorkTypeCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *info=[NSMutableDictionary new];
    // Tag=0 New Shift Work Cell
    if (cell.tag==0)
    {
        [self.delegate selectShiftWorkTypeTableViewWithCellType:ShiftWorkCellTypeAddShiftType withShiftTypeInfo:info];
        [self onClickAddShiftWorkBtn:nil];

        
    }
    else
    {
        selectShiftTypeCell=cell;
        selectShiftTypeCellTag=selectShiftTypeCell.tag;
        selectIndexPath=indexPath;
        info=shiftWorkTypeInfosArray[indexPath.row];
        [self onSelectCellAnimation:selectShiftTypeCell];
        [self.delegate selectShiftWorkTypeTableViewWithCellType:ShiftWorkCellTypeSelShiftType withShiftTypeInfo:info];
        
        self.addShiftWorkButton.backgroundColor=[info objectForKey:CoreData_ShiftTypeInfo_Color];
        
    }
    
    
    
    
}



-(void)handleLongPressCell:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:self.shiftWorkTypeTableView];
        
        NSIndexPath *indexPath = [self.shiftWorkTypeTableView indexPathForRowAtPoint:point];
        UITableViewCell *cell =[self.shiftWorkTypeTableView cellForRowAtIndexPath:indexPath];
        NSMutableDictionary *info=[NSMutableDictionary new];
        
        if (cell.tag!=0)
        {
            info=shiftWorkTypeInfosArray[indexPath.row];
            [self.delegate selectShiftWorkTypeTableViewWithCellType:ShiftWorkCellTypeEditShiftType withShiftTypeInfo:info];
            [self onClickAddShiftWorkBtn:nil];

        }
    }
    else
    {
        return;
        
    }
    
}
-(void)onSelectCellAnimation:(ShiftWorkTypeCell*)cell
{
    cell.shortNameLabel.layer.backgroundColor=[[cell.titleNameLabel.textColor colorWithAlphaComponent:1]CGColor];
    cell.titleNameLabel.textColor=[cell.titleNameLabel.textColor colorWithAlphaComponent:1];
    
    CABasicAnimation* openAnim = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    openAnim.fromValue = [NSNumber numberWithFloat:1];
    openAnim.toValue = [NSNumber numberWithFloat:1.1];
    openAnim.duration = 0.3;
    openAnim.repeatCount = 0;
    openAnim.autoreverses = NO;
    openAnim.removedOnCompletion = NO;
    openAnim.fillMode = kCAFillModeForwards;
    [cell.shortNameLabel.layer addAnimation:openAnim forKey:@"scale-layer"];
}
-(void)onCancelSelectCellAnimation:(ShiftWorkTypeCell*)cell
{
    cell.shortNameLabel.layer.backgroundColor=[[cell.titleNameLabel.textColor colorWithAlphaComponent:0.3]CGColor];
    cell.titleNameLabel.textColor=[cell.titleNameLabel.textColor colorWithAlphaComponent:0.3];
    
    
    CABasicAnimation* openAnim = [CABasicAnimation animationWithKeyPath: @"transform.scale"];
    openAnim.fromValue = [NSNumber numberWithFloat:1.1];
    openAnim.toValue = [NSNumber numberWithFloat:1.0];
    openAnim.duration = 0.3;
    openAnim.repeatCount = 0;
    openAnim.autoreverses = NO;
    openAnim.removedOnCompletion = NO;
    openAnim.fillMode = kCAFillModeForwards;
    [cell.shortNameLabel.layer addAnimation:openAnim forKey:@"scale-layer"];
}


@end
