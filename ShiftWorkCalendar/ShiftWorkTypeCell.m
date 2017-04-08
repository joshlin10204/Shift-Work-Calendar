//
//  ShiftWorkTypeCell.m
//  ShiftWorkCalendar
//
//  Created by Josh on 2017/4/8.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import "ShiftWorkTypeCell.h"

@implementation ShiftWorkTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.shortNameLabel.layer.cornerRadius=10;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
