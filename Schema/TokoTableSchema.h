//
//  TokoTableSchema.h
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/13.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TokoColumnSchema;
@class TokoSqliteCore;
@interface TokoTableSchema : NSObject{
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

-(void)createTableOnDb:(TokoSqliteCore *)sqliteCore;
-(void)createIndexOnDb:(TokoSqliteCore *)sqliteCore;
-(void)addMethodToClass;
-(TokoColumnSchema *)schemaWithColumnName:(NSString *)columnName;
-(void)migrateOnDb:(TokoSqliteCore *)sqliteCore from:(TokoTableSchema *)schema;
@end
