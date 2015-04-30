//
//  SQLManage.h
//  NetWorkProject
//
//  Created by Zlm on 15-4-15.
//  Copyright (c) 2015年 zlm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SQLDataManage.h"
@interface SQLManage : NSObject
{
    sqlite3* zDataBase;
    NSString* zDataBaseName;
}
//打开数据库
-(sqlite3*)openDataBase:(NSString*)dataBaseName;

/*
 创建指定表名和字段的表  数据库参数格式统一使用text类型
 parameter格式(参数1 条件1 条件2 ...,参数2 条件1 条件2 ...,...) 例: s_id integer primary key autoincrement unique,s_name text,s_gender text,s_age integer
 */
-(BOOL)createTableWithTableName:(NSString*)tableName Parameter:(NSString*)parameter;

//关闭已经打开的数据库
-(BOOL)closeOpenedDataBase;

//插入数据
-(BOOL)insertWithTableName:(NSString*)table Data:(NSDictionary*)data;


/*
 查询数据:
 table:表名
 sqlState:数据库查询语句
 dataFormat:对应数据字段(按插入数据的顺序排序)
 
 
 */
-(NSMutableArray*)selectWithTableName:(NSString*)table SqlState:(NSString*)sqlState DataFormat:(NSArray*)dataFormat;






@end
