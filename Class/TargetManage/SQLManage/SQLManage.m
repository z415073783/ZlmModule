//
//  SQLManage.m
//  NetWorkProject
//
//  Created by Zlm on 15-4-15.
//  Copyright (c) 2015年 zlm. All rights reserved.
//

#import "SQLManage.h"

@implementation SQLManage
-(const char *)getDataBaseFileExsitedPath:(NSString*)dataBaseName
{
    //获取数据库名称
    NSString* openSqlDataBase = [NSString stringWithFormat:@"%@.sqlite",dataBaseName];
    
    NSString* temPath = [NSTemporaryDirectory() stringByAppendingPathComponent:openSqlDataBase];
    return [temPath UTF8String];
}
-(BOOL)createNewDataBase:(NSString*)dataBaseName
{
    int result = sqlite3_open([self getDataBaseFileExsitedPath:dataBaseName], &zDataBase);
    if (result == SQLITE_OK) {
        //        创建数据库成功
        return YES;
    }
    return NO;
    
}
-(BOOL)createTableWithTableName:(NSString*)tableName Parameter:(NSString*)parameter
{
    char * error;
    const char * creatTableSql = [[NSString stringWithFormat:@"create table if not exists %@ (%@)",tableName,parameter] UTF8String];
    //    创建表
    int result = sqlite3_exec(zDataBase, creatTableSql, NULL, NULL, &error);
    return  result == SQLITE_OK;
}
-(sqlite3 *)openDataBase:(NSString*)dataBaseName
{
    zDataBaseName = dataBaseName;
    //判断是否存在,不存在则创建数据库
    if (![self createNewDataBase:zDataBaseName]) {
        return nil;
    }
//    [self createTable];
    return zDataBase;
}
-(BOOL)closeOpenedDataBase
{
    //    int result = sqlite3_close(dataBase);
    return sqlite3_close(zDataBase) == SQLITE_OK;
}
-(BOOL)insertWithTableName:(NSString*)table Data:(NSDictionary*)data
{
    NSMutableString* sqlState = [NSMutableString stringWithFormat:@"insert into %@",table];
    NSArray* allKeys = [data allKeys];
    [sqlState appendString:@"("];
    NSMutableString* allValue = [NSMutableString stringWithString:@"("];
    for (int i = 0; i<[allKeys count]; i++)
    {
        id value = [data objectForKey:[allKeys objectAtIndex:i]];
        [allValue appendString:value];
        [sqlState appendFormat:@"%@",[allKeys objectAtIndex:i]];
        if ([allKeys count] > i+1)
        {
            [sqlState appendString:@","];
            [allValue appendString:@","];
        }
    }
    [allValue appendString:@")"];
    [sqlState appendFormat:@")values%@;",allValue];
    char* error = nil;
    int result = sqlite3_exec(zDataBase, [sqlState UTF8String], nil, nil, &error);
    if (result == SQLITE_OK)
    {
        return YES;
    }else
    {
        return NO;
    }
}
-(NSMutableArray*)selectWithTableName:(NSString *)table SqlState:(NSString *)sqlState DataFormat:(NSArray*)dataFormat
{
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(zDataBase, [sqlState UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        NSMutableArray* allData = [[NSMutableArray alloc]init];
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
             NSMutableDictionary* getData = [[NSMutableDictionary alloc]init];
            for (int i = 0; i<[dataFormat count]; i++)
            {
                char* onceData = (char*)sqlite3_column_text(statement, i);
                [getData setValue:[NSString stringWithUTF8String:onceData] forKey:[dataFormat objectAtIndex:i]];
            }
            [allData addObject:getData];
        }
        return allData;
    }
    return nil;
}




@end
