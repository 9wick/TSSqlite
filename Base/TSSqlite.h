//
//  KKSqlite.h
//  KKFrameworks
//
//  Created by wicket on 11/08/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "TSDatabaseSchema.h"

@interface TSSqlite : NSObject {
	sqlite3 *_database;
    TSDatabaseSchema *_schema;
    NSDictionary *_settingData;
}

@property(retain, nonatomic) TSDatabaseSchema *schema;

+(id)sharedSqlite;
+(NSString *)stringByEscapeWithString:(NSString*)string;

- (BOOL)addSkipBackupAttributeToItem;
-(BOOL)open;
-(int)version;
-(BOOL)needMigrate;
-(void)migrate;
-(void)migrateToVersion:(int)version;
-(id)initWithFileName:(NSString *)fileName;
-(int)lastInsertedId;


-(NSArray *)executeWithSql:(NSString *)sql;
-(NSArray *)executeWithSql:(NSString *)sql forClass:(Class)class_ ;
-(NSArray *)executeWithSql:(NSString *)sql bind:(NSArray *)bind;
-(NSArray *)executeWithSql:(NSString *)sql forClass:(Class)class_ bind:(NSArray *)bind; 
    
-(NSDictionary *)fetchRowWithSql:(NSString *)sql;
-(id)fetchRowWithSql:(NSString *)sql forClass:(Class)class_;
-(id)fetchOneWithSql:(NSString *)sql;



-(BOOL)isExistTable:(NSString *)tableName;
@end
