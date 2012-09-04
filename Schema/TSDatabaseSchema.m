//
//  TokoPropetyManager.m
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/13.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "TSDatabaseSchema.h"
#import "TSSqlite.h"

@interface TSDatabaseSchema()
-(void)analyzeSchemaData:(NSDictionary *)data;

@end



@implementation TSDatabaseSchema
@synthesize tableSchemas = _schema;

-(id)initWithSchemaData:(NSDictionary *)schemaData{
    if((self = [super init])){
        if(!schemaData){
            abort();
        }
        
        _schema = [[NSMutableArray alloc] init];
        [self analyzeSchemaData:schemaData];
        
        
    }
    return self;
}

-(id)initWithSchemaPlist:(NSString *)schemaPlistName{
    NSString *path = [[NSBundle mainBundle] pathForResource:schemaPlistName ofType:@"plist"];
    NSDictionary *schemaData = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];

    return [self initWithSchemaData:schemaData];
}

-(id)initWithSchemaJson:(NSString *)schemaJsonName{
    NSString *path = [[NSBundle mainBundle] pathForResource:schemaJsonName ofType:@"json"];
    NSData *data = [[[NSData alloc] initWithContentsOfFile:path] autorelease];
    NSError *error = nil;
    NSDictionary *schemaData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    return [self initWithSchemaData:schemaData];
}

-(void)dealloc{
    TSRelease(_schema);
    [super dealloc];
}





#pragma mark - schema

-(void)analyzeSchemaData:(NSDictionary *)data{
    for (NSString *tableName in data) {
        TSTableSchema *table = [[TSTableSchema alloc] initWithName:tableName data:[data objectForKey:tableName]];
        [_schema addObject:table];
        [table release];
    }

}

-(TSTableSchema *)schemaWithClassName:(NSString *)className{
    for (TSTableSchema *tableSchema in _schema) {
        if([tableSchema.className isEqualToString:className]){
            return tableSchema;
        }
    }
    return nil;
}


-(TSTableSchema *)schemaWithTableName:(NSString *)tableName{
    for (TSTableSchema *tableSchema in _schema) {
        if([tableSchema.name isEqualToString:tableName]){
            return tableSchema;
        }
    }
    return nil;

}


#pragma mark - dynamic method

-(void)addMethodToAllTable{
    for (TSTableSchema *table in _schema) {
        [table addMethodToClass];
    }
}



#pragma mark - migrate

-(void)migrateOnDb:(TSSqlite *)sqliteCore from:(TSDatabaseSchema *)oldSchema{
    
    for (TSTableSchema *table in _schema) {
        [table migrateOnDb:sqliteCore from:[oldSchema schemaWithTableName:table.name]];
    }
    for (TSTableSchema *table in oldSchema.tableSchemas) {
        if(![self schemaWithTableName:table.name]){
            NSLog(@"SQLite cannot drop table");
            abort();
        }
    }
    
}



@end
