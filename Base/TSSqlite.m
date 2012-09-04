//
//  KKSqlite.m
//  KKFrameworks
//
//  Created by wicket on 11/08/22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TSSqlite.h"
#import "TokoSqlite.h"
#include <sys/xattr.h>



TSSqlite *__sharedSqlite = nil;

@implementation TSSqlite

@synthesize schema = _schema;

+(id)sharedSqlite{
    if(__sharedSqlite == nil){
        __sharedSqlite = [[TSSqlite alloc] init];
    }
    return __sharedSqlite;
}

-(id)init{
    return [self initWithFileName:@"database"];
}

-(id)initWithFileName:(NSString*)fileName{
    if((self = [super init])){
//        NSString *settingPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
//        _settingData = [[NSDictionary alloc] initWithContentsOfFile:settingPath];
//        NSString *settingPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"yaml"];
//        _settingData = [[YAMLKit loadFromFile:settingPath] retain];
        NSString *settingPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
        NSData *data = [[[NSData alloc] initWithContentsOfFile:settingPath] autorelease];
        NSError *error = nil;
        _settingData = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error] retain];
        
        if(![self open]){
            return nil;
        }
        
        NSString *schemaFileName = [[_settingData objectForKey:@"schema"] lastObject];
        if(schemaFileName){
            TSDatabaseSchema *schema = [[TSDatabaseSchema alloc] initWithSchemaJson:schemaFileName];
            [self setSchema:schema];
            [schema addMethodToAllTable];
            [schema release];
        }
        //        [self migrate];
        
        
    }
    
    return self;
    
}

- (BOOL)addSkipBackupAttributeToItem{
    NSString *databaseFileName = [_settingData objectForKey:@"filename"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:databaseFileName];
    NSURL *url = [NSURL URLWithString:path];
    const char* filePath = [[url path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";


//    if (&NSURLIsExcludedFromBackupKey == nil) {
        // iOS 5.0.1 and lower
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        
    return result == 0;
//        
//    }
//    else {
//        // First try and remove the extended attribute if it is present
//        int result = getxattr(filePath, attrName, NULL, sizeof(u_int8_t), 0, 0);
//        if (result != -1) {
//            // The attribute exists, we need to remove it
//            int removeResult = removexattr(filePath, attrName, 0);
//            if (removeResult == 0) {
//                NSLog(@"Removed extended attribute on file %@", url);
//            }
//        }
//        
//        // Set the new key
//        NSError *error = nil;
//        [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
//        return error == nil;
//    }
}


-(void)dealloc{
    
    //データベースファイルを閉じる
    sqlite3_close(_database);
    TokoRelease(_schema);
    TokoRelease(_settingData);
    [super dealloc];
}


#pragma mark -
#pragma mark database

-(BOOL)open{
    NSString *databaseFileName = [_settingData objectForKey:@"filename"];
    //	自分の書類ディレクトリを求める。
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:databaseFileName];
    
    //	データベースファイルオープン。
    int result = sqlite3_open([path UTF8String], &_database);
    if (result != SQLITE_OK) {
        //オープンに失敗
        NSString *errorMessage = [[NSString alloc] initWithFormat:@"%s",sqlite3_errmsg(_database)];
        NSLog(@"(Database Open Error)  %@",errorMessage);
        sqlite3_close(_database);
        abort();
        return NO;
    }
    return YES;
}



-(NSArray *)executeWithSql:(NSString *)sql { 
    return [self executeWithSql:sql forClass:[NSMutableDictionary class] bind:nil];
}

-(NSArray *)executeWithSql:(NSString *)sql bind:(NSArray *)bind { 
    return [self executeWithSql:sql forClass:[NSMutableDictionary class] bind:bind];
}

-(NSArray *)executeWithSql:(NSString *)sql forClass:(Class)class { 
    return [self executeWithSql:sql forClass:class bind:nil];
}


-(NSArray *)executeWithSql:(NSString *)sql forClass:(Class)class bind:(NSArray *)bind{ 
    
//    NSLog(@"SQL : %@",sql);
    NSMutableArray *allData = [[[NSMutableArray alloc] init] autorelease]; 
    //ロック
    @synchronized(self) {
        
        //SQLを設定
        sqlite3_stmt *statement;
        sqlite3_prepare_v2(_database, [sql cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL );
        int count = [bind count];
        for (int i = 0; i < count; i++) {
            
            id obj = [bind objectAtIndex:i];
            if([obj isKindOfClass:[NSNumber class]] && [obj intValue] != [obj doubleValue]){
                sqlite3_bind_double(statement, i + 1, [obj doubleValue]);
            }else if([obj isKindOfClass:[NSNumber class]] ){
                sqlite3_bind_int(statement, i + 1, [obj intValue]);
            }else if([obj isKindOfClass:[NSString class]] ){
                sqlite3_bind_text(statement, i + 1, [(NSString *)obj UTF8String] , -1, SQLITE_TRANSIENT);
            }else if([obj isKindOfClass:[NSData class]]){
                sqlite3_bind_blob(statement, i + 1, [(NSData *)obj bytes], -1, SQLITE_TRANSIENT);
            }else if([obj isKindOfClass:[NSNull class]]){
                sqlite3_bind_null(statement, i + 1);
            }
        }
        
        int result;
        while (1) {
            
            //SQLを実行
            result = sqlite3_step(statement);
            
            if(result != SQLITE_ROW && result != SQLITE_DONE){
                //何かしらのエラーが発生した
                NSString *errorMessage = [[NSString alloc] initWithFormat:@"%s  \nwith sql : %@", sqlite3_errmsg(_database),sql];
                NSLog(@"(Database Error)  %@",errorMessage);
                sqlite3_close(_database);                
                abort();
                return nil;
            }
            
            if (result == SQLITE_DONE){ 
                break; 
            }
            if (result == SQLITE_ROW) {
                
                id row = [[class alloc] init];
                
                int colmunNum = sqlite3_column_count(statement);
                
                for(int i = 0;i < colmunNum; i++){
                    NSString *name = [[NSString alloc] initWithCString:sqlite3_column_name(statement, i) encoding:NSUTF8StringEncoding];
                    if([row isKindOfClass:[TokoModel class]]){
                        id value = nil;
                        TokoColmunType type = [[[(TSModel *)row schema] schemaWithColumnName:name] type];
                        
                        
                        if(TokoColmunTypeBlob == type){
                            value = [NSData dataWithBytes:sqlite3_column_blob(statement, i) length:sqlite3_column_bytes(statement, i)];
                        }else{
                            int sqliteType = sqlite3_column_type(statement, i);
                            
                            if(SQLITE_NULL != sqliteType){
                                NSString *str = [[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, i) encoding:NSUTF8StringEncoding] autorelease];
                                if(TokoColmunTypeInteger == type){
                                    value = [NSNumber numberWithInt:[str intValue]];
                                }else if(TokoColmunTypeReal == type){
                                    value = [NSNumber numberWithDouble:[str doubleValue]];
                                }else if(TokoColmunTypeText == type){
                                    value = str;
                                }
                            }
                        }
                        
                        if(value){
                            [row setOriginalValue:value forKey:name];
                        }
                    }else{
                        id value = nil;
                        int type = sqlite3_column_type(statement, i);
                        
                        if(SQLITE_NULL == type){
                            value = nil;
                        }else if(SQLITE_INTEGER == type){
                            value = [NSNumber numberWithInt:sqlite3_column_int(statement, i)];
                        }else if(SQLITE_FLOAT == type){
                            value = [NSNumber numberWithDouble:sqlite3_column_double(statement, i)];
                        }else if(SQLITE_BLOB == type){
                            value = [NSData dataWithBytes:sqlite3_column_blob(statement, i) length:sqlite3_column_bytes(statement, i)];
                        }else if(SQLITE_TEXT == type){
                            value = [[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, i) encoding:NSUTF8StringEncoding] autorelease];
                        }
                        if(value){
                             [row setValue:value forKey:name];
                        }
                    }
                    [name release];
                }                
                [allData addObject:row];
                [row release];
                
            }
        }
        
        sqlite3_finalize(statement);
    }
    if ([allData count] == 0) {
        return nil;
    }
    return allData;
}

-(NSArray *)fetchAllWithSql:(NSString *)sql{
    return [self executeWithSql:sql];
}

-(NSArray *)fetchAllWithSql:(NSString *)sql forClass:(Class)class {
    return [self executeWithSql:sql forClass:class];
}
-(NSDictionary *)fetchRowWithSql:(NSString *)sql{
    NSArray *objects = [self executeWithSql:sql] ;
    if([objects count] == 0){
        return nil;
    }
    return [objects objectAtIndex:0];

}

-(id)fetchRowWithSql:(NSString *)sql forClass:(Class)class {
    NSArray *objects = [self executeWithSql:sql forClass:class] ;
    if([objects count] == 0){
        return nil;
    }
    return [objects objectAtIndex:0];
}

-(id)fetchOneWithSql:(NSString *)sql{
    NSDictionary *row = [self fetchRowWithSql:sql] ;
    if([row count] == 0){
        return nil;
    }
    return [row objectForKey:[[row allKeys] objectAtIndex:0]];
}

#pragma mark - migrate
-(void)createMigrateTable{
    NSString *createSql = @"CREATE TABLE migrate (version integer) ";
    [self executeWithSql:createSql];
    NSString *insertSql = @"INSERT INTO migrate (version) VALUES (0)";
    [self executeWithSql:insertSql];
}

-(int)version{
    if(![self isExistTable:@"migrate"]){
        [self createMigrateTable];
    }
    NSString *versionSql = @"select version from migrate limit 1";
    return [[self fetchOneWithSql:versionSql] intValue];
}

-(BOOL)needMigrate{
    int version = [self version];
    int schemaVersion = [[_settingData objectForKey:@"schema"] count];
    
    return (version != schemaVersion);
}
-(void)migrate{
    [self migrateToVersion:[[_settingData objectForKey:@"schema"] count]];
}

-(void)migrateToVersion:(int)newVersion{
    int version = [self version];
    
    for (int i = version; i < newVersion; i++) {
        //i -> i+1 へのmigrate
        NSLog(@"migrate version %d -> %d",i,i+1);
        
        [self executeWithSql:@"BEGIN TRANSACTION"];
        
        TSDatabaseSchema *oldSchema = nil;
        if(i != 0){
            NSString *oldSchemaFileName = [[_settingData objectForKey:@"schema"] objectAtIndex:i-1];
            oldSchema = [[TSDatabaseSchema alloc] initWithSchemaJson:oldSchemaFileName];
        }
        NSString *newSchemaFileName = [[_settingData objectForKey:@"schema"] objectAtIndex:i];
        TSDatabaseSchema *newSchema = [[TSDatabaseSchema alloc] initWithSchemaJson:newSchemaFileName];
        [newSchema migrateOnDb:self from:oldSchema];
        [newSchema release];
        [oldSchema release];
        
        NSString *updateString = [NSString stringWithFormat:@"UPDATE migrate SET version = %d",i+1];
        [self executeWithSql:updateString];
        [self executeWithSql:@"COMMIT"];
    }
}

#pragma mark -
#pragma mark 定型文
-(int)lastInsertedId{
    return sqlite3_last_insert_rowid(_database);
}

-(BOOL)isExistTable:(NSString *)tableName{
    NSString *sql = [NSString stringWithFormat:@"SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = '%@'" ,tableName];
	return [[self fetchOneWithSql:sql] boolValue];
}

#pragma mark -
#pragma mark Escape

+(NSString *)stringByEscapeWithString:(NSString*)string{
    return [string stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}


@end
