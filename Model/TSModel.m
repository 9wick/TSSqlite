//
//  TSModel.m
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//


#import "TSModel.h"
#import "TSSqlite.h"

@interface TSModel()
-(void)updateSave;
-(void)insertSave;
@end

@implementation TSModel
@synthesize sqliteCore = _sqliteCore;
@dynamic name;
@synthesize schema = _schema;

-(id)init{
    if((self = [super init])){
        _data = [[NSMutableDictionary alloc] init];
        _originalData = [[NSMutableDictionary alloc] init];
        _sqliteCore = [[TSSqlite sharedSqlite] retain];
        _schema = [[[_sqliteCore schema] schemaWithClassName:NSStringFromClass([self class])] retain];
    }
    return self;
}



-(void)dealloc{
    TSRelease(_data);
    TSRelease(_sqliteCore);
    TSRelease(_schema);
    TSRelease(_originalData);
    
    [super dealloc];
}


-(void)save{
    if([_originalData count]){
        [self updateSave];
    }else{
        [self insertSave];
    }
}

-(void)updateSave{
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (TSColumnSchema *column in _schema.columns) {
        id obj = [_data objectForKey:column.name];
        if(obj == nil){
            continue;
        }
        [keys addObject:[NSString stringWithFormat:@"`%@` = ?", column.name ]];
        [values addObject:obj];
    }
    if([keys count] != 0){
        NSMutableString *sql = [[NSMutableString alloc] init];
        
        [sql appendFormat:@"update %@ set",_schema.name];
        [sql appendFormat:@" %@ ",[keys componentsJoinedByString:@","]];
        [sql appendFormat:@" where %@",[self whereString]];
        
        [_sqliteCore executeWithSql:sql bind:values];
        [sql release];

    }
    [keys release];
    [values release];
}

-(void)insertSave{
   
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (TSColumnSchema *column in _schema.columns) {
        id obj = [_data objectForKey:column.name];
        if(obj == nil){
            continue;
        }
        [keys addObject:[NSString stringWithFormat:@"`%@`",column.name]];
        [values addObject:obj];
        
    }
    if([keys count] == 0){
        TSColumnSchema *column  = [_schema.primaryKeys lastObject];
        [keys addObject:[NSString stringWithFormat:@"`%@`",column.name]];
        [values addObject:[NSNull null]];
        
    }
    NSMutableString *sql = [[NSMutableString alloc] init];
    
    [sql appendFormat:@"insert into %@ ", _schema.name];
    [sql appendFormat:@"( %@ ) ",[keys componentsJoinedByString:@","]];
    [sql appendString:@"values ( "];
    int count = [values count];
    for (int i=0; i < count; i++) {
        [sql appendString:@"?"];
        if(i < count -1 ){
            [sql appendString:@","];
        }
    }
    [sql appendString:@")"];
    
    [_sqliteCore executeWithSql:sql bind:values];

    [sql release];
    [values release];
    [keys release];
    
    [_originalData setValuesForKeysWithDictionary:_data];
    [_data removeAllObjects];
    
    if([_schema.primaryKeys count]){
        TSColumnSchema *colmun  = [_schema.primaryKeys lastObject];
        if (colmun.isAutoincrement) {
            [_originalData setValue:[NSNumber numberWithInt:[_sqliteCore lastInsertedId]] forKey:colmun.name ];
        }
    }
}

-(void)delete{
    if([_originalData count] == 0){
        return;
    }
    NSMutableString *sql = [[NSMutableString alloc] init];
    
    [sql appendFormat:@"delete from %@ ",_schema.name];
    [sql appendFormat:@" where %@",[self whereString]];
    [_sqliteCore executeWithSql:sql];
    [sql release];

}

-(void)refresh{
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"select * from %@ ", _schema.name];
    [sql appendFormat:@" where %@ limit 1",[self whereString]];
    NSDictionary *data = [[_sqliteCore executeWithSql:sql] lastObject];
    
    TSRelease(_originalData);
    _originalData = [data mutableCopy];
    [_data removeAllObjects];
    
}



-(NSString *)whereString{
    NSMutableArray *where = [[[NSMutableArray alloc] init] autorelease];
    for (TSColumnSchema *column in _schema.primaryKeys) {
        NSString *value = [column escapedString:[_originalData objectForKey: column.name]];
        [where addObject:[NSString stringWithFormat:@"`%@` = %@", column.name, value]];
    }    
    return [where componentsJoinedByString:@" AND "];
    
}

-(NSString *)description{
    NSMutableString *description = [NSMutableString string];
    
    [description appendFormat:@"[%@] (db : %@){\n",NSStringFromClass([self class]), _schema.name];
    for (TSColumnSchema *colmun in _schema.columns) {
        id value = [_data objectForKey:colmun.name];
        if(value == nil){
            value = [_originalData objectForKey:colmun.name];
        }
        [description appendFormat:@"%@ : %@\n",colmun.name, value];
    }
    [description appendString:@"}\n"];
    return description;
}


-(void)setOriginalValue:(id)value forKey:(NSString *)key{
    if(!value || !key){
        return;
    }
    TSColumnSchema *col = [_schema schemaWithColumnName:key];
    Class class = [col classType];
    if(![value isKindOfClass: class ]){
        NSLog(@"TokoModel class different Error");
    }
    [_originalData setValue:value forKey:key];
}


-(void)setValue:(id)value forKey:(NSString *)key{
    if(!value || !key){
        return;
    }
    if(![value isKindOfClass: [[_schema schemaWithColumnName:key] classType] ]){
        NSLog(@"Error");
    }
    [_data setValue:value forKey:key];
}


-(id)valueForKey:(NSString *)key{
    if(!key){
        return nil;
    }
    id data = [_data valueForKey:key];
    if(data == nil){
        data = [_originalData valueForKey:key ];
    }
    return data;
}


-(NSDictionary *)values{
    NSMutableDictionary *values = [[[NSMutableDictionary alloc] init] autorelease];
    [values setValuesForKeysWithDictionary:_originalData];
    [values setValuesForKeysWithDictionary:_data];
    return values;
}

-(void)setValues:(NSDictionary *)values{
    [_data setValuesForKeysWithDictionary:values];
}
@end
