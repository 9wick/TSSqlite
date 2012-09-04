//
//  TSDatabaseSchema.h
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
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
