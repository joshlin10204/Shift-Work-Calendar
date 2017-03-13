//
//  CalendarData.h
//  TestCalendar
//
//  Created by Josh on 2017/3/12.
//  Copyright © 2017年 Josh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarData : NSObject


-(NSMutableDictionary*)getCurrentDateInfo;
-(NSMutableDictionary*)getNextDateInfo:(NSMutableDictionary*)curDateInfo;
-(NSMutableDictionary*)getPrevDateInfo:(NSMutableDictionary*)curDateInfo;


@end
