//
//  DatabaseManager.m
//  ShareMoney
//
//  Created by Daniel on 2017/3/9.
//  Copyright © 2017年 Daniel. All rights reserved.
//

#import "DatabaseManager.h"
#import <FMDB.h>

#define SQLITE_FILENAME @"ShareMoney.sqlite"

// create table
#define CREATE_EVENT_TABLE_SQL    @"CREATE TABLE IF NOT EXISTS eventlog_table(EventID integer primary key autoincrement,Date text,TotalCost integer,EventTitle text);"
#define CREATE_MEMBER_TABLE_SQL    @"CREATE TABLE IF NOT EXISTS memberlog_table(MemberID integer primary key autoincrement,MemberName text,EventID integer,Money double);"
#define CREATE_COST_TABLE_SQL    @"CREATE TABLE IF NOT EXISTS costlog_table(CostID integer primary key autoincrement,EventID integer,MemberID integer,Cost double,Description text);"

// insert value
#define INSERT_EVENT_LOG_SQL @"INSERT INTO eventlog_table(%@,%@,%@) VALUES(?,?,?);"
#define INSERT_MEMBER_LOG_SQL @"INSERT INTO memberlog_table(%@,%@,%@) VALUES(?,?,?);"
#define INSERT_COST_LOG_SQL @"INSERT INTO costlog_table(%@,%@,%@,%@) VALUES(?,?,?,?);"

// delete
#define DELETE_EVENT_SQL @"DELETE FROM eventlog_table where EventID = %ld"

// get last table ID
#define GET_LAST_ID_SQL @"SELECT * FROM %@ ORDER BY %@ DESC LIMIT 1;"

// select
#define SELECT_EVENT_ALL_SQL  @"SELECT DISTINCT Date from eventlog_table;"
#define SELECT_EVENT_SQL  @"SELECT * from eventlog_table where Date = '%@';"

@implementation DatabaseManager {
    NSString *dbFilePathName;
    FMDatabase *db;
    //    NSMutableArray *messageIDs;
}

- (instancetype) init {
    self = [super init];
    
    //    messageIDs = [NSMutableArray new];
    
    // Prepare dbFilePathName
    NSURL *cachesURL = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *dbFileURL = [cachesURL URLByAppendingPathComponent:SQLITE_FILENAME];
    dbFilePathName = dbFileURL.path;
    
    // Prepare db: maybe open exist one or create a new one.
    db = [FMDatabase databaseWithPath:dbFilePathName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:dbFilePathName]) {
        // Exist already,then load the id into messageIDs
        //        if ([db open]) {
        //            NSString *sql = SELECT_ALL_SQL;
        //            FMResultSet *result = [db executeQuery:sql];
        //
        //            while ([result next]) {
        //                NSInteger messageID = [result intForColumn:MID_KEY];
        //                [messageIDs addObject:@(messageID)];
        //            }
        //
        //            [db close];
        //        }
    } else {
        // First time,create the table.
        if ([db open]) {
            NSString *eventSql = CREATE_EVENT_TABLE_SQL;
            NSString *MemberSql = CREATE_MEMBER_TABLE_SQL;
            NSString *costSql = CREATE_COST_TABLE_SQL;
            BOOL eventSuccess = [db executeUpdate:eventSql];
            BOOL memberSuccess = [db executeUpdate:MemberSql];
            BOOL costSuccess = [db executeUpdate:costSql];
            NSLog(@"Create DB Table: event %@,member %@,cost %@",(eventSuccess?@"OK":@"Fail"),(memberSuccess?@"OK":@"Fail"),(costSuccess?@"OK":@"Fail"));
            [db close];
        }
    }
    
    return self;
}

#pragma MARK - Add Method
- (void) addEvent:(NSDictionary *)eventDic {
    if ([db open]) {
        
        NSString *sql = [NSString stringWithFormat:INSERT_EVENT_LOG_SQL,DATE_KEY,TOTALCOST_KEY,EVENT_TITLE_KEY];
        BOOL success = [db executeUpdate:sql,eventDic[DATE_KEY],eventDic[TOTALCOST_KEY],eventDic[EVENT_TITLE_KEY]];
        [db close];
        
        if (success) {
            //            NSInteger messageID = [self getLastMessageID];
            //            [messageIDs addObject:@(messageID)];
            NSLog(@"Add EVENT success.");
        } else {
            NSLog(@"Add EVENT LOG Fail.");
        }
    }
}

- (void) addMember:(NSDictionary *)memberDic {
    if ([db open]) {
        
        NSString *sql = [NSString stringWithFormat:INSERT_MEMBER_LOG_SQL,MEMBER_NAME_KEY,EVENT_ID_KEY,MEMBER_MONEY_KEY];
        BOOL success = [db executeUpdate:sql,memberDic[MEMBER_NAME_KEY],memberDic[EVENT_ID_KEY],memberDic[MEMBER_MONEY_KEY]];
        [db close];
        
        if (success) {
            //            NSInteger messageID = [self getLastMessageID];
            //            [messageIDs addObject:@(messageID)];
        } else {
            NSLog(@"Add MEMBER LOG Fail.");
        }
    }
}

- (void) addCost:(NSDictionary *)costDic {
    if ([db open]) {
        
        NSString *sql = [NSString stringWithFormat:INSERT_COST_LOG_SQL,EVENT_ID_KEY,MEMBER_ID_KEY,COST_KEY,DESCRIPTION_KEY];
        BOOL success = [db executeUpdate:sql,costDic[EVENT_ID_KEY],costDic[MEMBER_ID_KEY],costDic[COST_KEY],costDic[DESCRIPTION_KEY]];
        [db close];
        
        if (success) {
            //            NSInteger messageID = [self getLastMessageID];
            //            [messageIDs addObject:@(messageID)];
        } else {
            NSLog(@"Add COST LOG Fail.");
        }
    }
}
#pragma MARK - Delete Method
- (void) deleteEventWithID:(NSInteger)eventID {
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:DELETE_EVENT_SQL,eventID];
        BOOL success = [db executeUpdate:sql];
        [db close];
        
        if (success) {
            NSLog(@"Delete Event Success.");
        } else {
            NSLog(@"Delete Event Fail.");
        }
    }
}

#pragma MARK - getLast ID Method
- (NSInteger) getLastIDWithTableName:(dbTableType)tableType {
    
    NSString *tableName,*tableID;
    
    if (tableType == EventType) {
        tableName = EVENT_TABLE_KEY;
        tableID = EVENT_ID_KEY;
    } else if(tableType == MemberType) {
        tableName = MEMBER_TABLE_KEY;
        tableID = MEMBER_ID_KEY;
    } else if (tableType == CostType) {
        tableName = COST_TABLE_KEY;
        tableID = COST_ID_KEY;
    }
    
    NSInteger resultValue;
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:GET_LAST_ID_SQL,tableName,tableID];
        FMResultSet *result = [db executeQuery:sql];
        
        if ([result next]) {
            resultValue = [result intForColumn:tableID];
        }
        [db close];
    }
    return resultValue;
}

#pragma MARK - select table value
- (NSMutableArray*) getValueFromEventTableWithDate:(NSString*) dateString {
    NSDictionary * eventDic = [NSDictionary new];
    NSMutableArray * eventArray = [NSMutableArray new];
    if ([db open]) {
        if (dateString == nil) {
            NSString *sql = [NSString stringWithFormat:SELECT_EVENT_ALL_SQL];
            FMResultSet *result = [db executeQuery:sql];
            while ([result next]) {
//                eventDic = @{DATE_KEY:[result stringForColumn:DATE_KEY]};
                [eventArray addObject:[result stringForColumn:DATE_KEY]];
        }
        } else {
            NSString *sql = [NSString stringWithFormat:SELECT_EVENT_SQL,dateString];
            FMResultSet *result = [db executeQuery:sql];
            while ([result next]) {
                eventDic = @{EVENT_ID_KEY:@([result intForColumn:EVENT_ID_KEY]),EVENT_TITLE_KEY:[result stringForColumn:EVENT_TITLE_KEY],DATE_KEY:[result stringForColumn:DATE_KEY],TOTALCOST_KEY:@([result intForColumn:TOTALCOST_KEY])};
                [eventArray addObject:eventDic];
            }
        }
        [db close];
    }
    return eventArray;
}
@end
