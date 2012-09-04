//
//  TSSqlite.h
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
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




//一括import用
#import "TSColumnSchema.h"
#import "TSDatabaseSchema.h"
#import "TSTableSchema.h"
#import "TSModel.h"
#import "TSModelTable.h"
#import "TSQuery.h"
#import "TSFetchResultsController.h"
#import "TSFetchResultsSectionController.h"


#define TSRelease(obj)  [obj release],obj=nil