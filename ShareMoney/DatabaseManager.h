//
//  DatabaseManager.h
//  ShareMoney
//
//  Created by Daniel on 2017/3/9.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

//  db column name
#define EVENT_ID_KEY @"EventID"
#define DATE_KEY @"Date"
#define EVENT_TITLE_KEY @"EventTitle"
#define TOTALCOST_KEY @"TotalCost"
#define MEMBER_ID_KEY @"MemberID"
#define MEMBER_NAME_KEY @"MemberName"
#define MEMBER_MONEY_KEY @"Money"
#define COST_ID_KEY @"CostID"
#define COST_KEY @"Cost"
#define DESCRIPTION_KEY @"Description"
// db table name
#define EVENT_TABLE_KEY @"eventlog_table"
#define MEMBER_TABLE_KEY @"memberlog_table"
#define COST_TABLE_KEY @"costlog_table"

typedef enum:NSInteger{
    EventType,
    MemberType,
    CostType
} dbTableType;

@interface DatabaseManager : NSObject
- (void) addEvent:(NSDictionary *)eventDic;
- (void) addMember:(NSDictionary *)memberDic;
- (void) addCost:(NSDictionary *)costDic;
- (void) deleteEventWithID:(NSInteger)eventID;
- (NSInteger) getLastIDWithTableName:(dbTableType)tableType;
- (NSMutableArray*) getValueFromEventTableWithDate:(NSString*) dateString;
@end
