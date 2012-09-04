//
//  TSTableSchema.h
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//

#import <Foundation/Foundation.h>
@class TSColumnSchema;
@class TSSqlite;
@interface TSTableSchema : NSObject{
    NSString *_name;
    NSString *_className;
    NSMutableArray *_primaryKeys;
    NSMutableArray *_indexes;
    NSArray *_columns;
    NSMutableDictionary *_colmunDictinary;
    
}

@property(readonly, nonatomic) NSString *name;
@property(readonly, nonatomic) NSString *className;
@property(readonly, nonatomic) NSArray *primaryKeys;
@property(readonly, nonatomic) NSArray *columns;

-(id)initWithName:(NSString *)name data:(NSDictionary *)data;

-(void)createTableOnDb:(TSSqlite *)sqliteCore;
-(void)createIndexOnDb:(TSSqlite *)sqliteCore;
-(void)addMethodToClass;
-(TSColumnSchema *)schemaWithColumnName:(NSString *)columnName;
-(void)migrateOnDb:(TSSqlite *)sqliteCore from:(TSTableSchema *)schema;
@end
