//
//  TokoPropetyManager.h
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/13.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TSSqlite;
@class TSTableSchema;
@interface TSDatabaseSchema : NSObject{
    NSMutableArray *_schema;
}

@property(readonly,nonatomic) NSArray *tableSchemas;

-(id)initWithSchemaData:(NSDictionary *)schemaData;
-(id)initWithSchemaPlist:(NSString *)schemaPlistName;
-(id)initWithSchemaJson:(NSString *)schemaJsonName;
-(void)addMethodToAllTable;


-(TSTableSchema *)schemaWithClassName:(NSString *)className;
-(TSTableSchema *)schemaWithTableName:(NSString *)tableName;

-(void)migrateOnDb:(TSSqlite *)sqliteCore from:(TSDatabaseSchema *)schema;
@end
