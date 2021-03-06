//
//  TSTableSchema.m
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//


#import "TSTableSchema.h"
#import "TSSqlite.h"
#import <objc/runtime.h>

void setPropertyMethod(id self, SEL _cmd, id object);
id getPropertyMethod(id self, SEL _cmd);






void setPropertyMethod(id self, SEL _cmd, id object){
    NSString *selectorString = NSStringFromSelector(_cmd);
    NSRange startRange = NSMakeRange(3, 1);
    NSRange lengthRange = NSMakeRange(4, [selectorString length] - 5);
    NSString *lowerStaring = [[selectorString substringWithRange:startRange] lowercaseString];
    NSString *afterString = [selectorString substringWithRange:lengthRange];
    NSString *propertyName = [NSString stringWithFormat:@"%@%@",lowerStaring,afterString];
	[self setValue:object forKey:propertyName];
}

id getPropertyMethod(id self, SEL _cmd){
    return [self valueForKey:NSStringFromSelector(_cmd)];
}







@implementation TSTableSchema

@synthesize name = _name;
@synthesize className = _className;
@synthesize primaryKeys = _primaryKeys;
@synthesize columns = _columns;

-(id)initWithName:(NSString *)name data:(NSDictionary *)data{
    if((self = [super init])){
        _name = [name retain];
        _primaryKeys = [[NSMutableArray alloc] init];
        _indexes = [[NSMutableArray alloc] init];
        
        NSMutableArray *tmpColumns = [NSMutableArray array];
        NSDictionary *columns  = [data objectForKey:@"columns"];
        _colmunDictinary = [[NSMutableDictionary alloc] init];
        for (NSString *columnName in columns) {
            TSColumnSchema *schema = [[TSColumnSchema alloc] initWithName:columnName data:[columns objectForKey:columnName]];
            [tmpColumns addObject:schema];
            [_colmunDictinary setObject:schema forKey:schema.name];
            if(schema.isKey){
                [_primaryKeys addObject:schema];
            }
            [schema release];
        }
        _columns = [tmpColumns retain];
        
        NSArray *primaryKeys  = [data objectForKey:@"primary"];
        if([_primaryKeys count] == 0 && [primaryKeys count] > 0){
            for (NSString *columnName in primaryKeys) {
                [_primaryKeys addObject:[self schemaWithColumnName:columnName]];
            }
        }
        
        NSArray *indexes  = [data objectForKey:@"indexes"];
        for (NSArray *index in indexes) {
            NSMutableArray *array = [NSMutableArray array];
            for (id column in index) {
                if([column isKindOfClass:[NSString class]]){
                    TSColumnSchema *data = [self schemaWithColumnName:column];
                    NSString *order = @"ASC";
                    [array addObject: [NSArray arrayWithObjects:data, order, nil]];
                }else if([column isKindOfClass:[NSArray class]]){
                    TSColumnSchema *data = [self schemaWithColumnName:[column objectAtIndex:0]];
                    NSString *order = [column objectAtIndex:1];
                    [array addObject: [NSArray arrayWithObjects:data, order, nil]];

                }
            }
            [_indexes addObject:array];
        }
        
        
        
        _className = [[data objectForKey:@"class"] retain];
        if(!_className){
            _className = [@"TokoModel" retain];
        }
        
        
    }
    return self;
}

-(void)dealloc{
    TSRelease(_indexes);
    TSRelease(_colmunDictinary);
    TSRelease(_name);
    TSRelease(_columns);
    TSRelease(_primaryKeys);
    TSRelease(_className);
    [super dealloc];
}


-(TSColumnSchema *)schemaWithColumnName:(NSString *)columnName{
    return [_colmunDictinary objectForKey:columnName];
}

-(NSString *)description{
    
    return [NSString stringWithFormat:@"name:%@  columns:%@  keys:%@",
            _name,[_columns description],_primaryKeys];
}

-(void)createTableOnDb:(TSSqlite *)sqliteCore{
    NSMutableArray *columnSqlArray = [[NSMutableArray alloc] init];
    for (TSColumnSchema *colmun in self.columns) {
        [columnSqlArray addObject:[colmun nameWithColumnDefine]];
    }
    if([_primaryKeys count] > 0){
        if([_primaryKeys count] != 1 || ![[_primaryKeys objectAtIndex:0] isKey]){
            NSMutableArray *colArray = [NSMutableArray array];
            for (TSColumnSchema *schema in _primaryKeys) {
                [colArray addObject:schema.name];
            }
            NSString *primarySql = [NSString stringWithFormat:@"PRIMARY KEY(%@)", [colArray componentsJoinedByString:@","]];
            [columnSqlArray addObject:primarySql];
        }
    }
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendFormat:@"create table %@ (" , self.name];
    [sql appendString:[columnSqlArray componentsJoinedByString:@","]];
    [sql appendString:@")"];
    
    [sqliteCore executeWithSql:sql];
    
    [sql release];
    [columnSqlArray release];
    
    [self createIndexOnDb:sqliteCore];
}

-(void)createIndexOnDb:(TSSqlite *)sqliteCore{
    
    for (NSArray *index in _indexes) {
        NSMutableString  *name = [[NSMutableString alloc] init];
        NSMutableArray *columns = [[NSMutableArray alloc] init];
        [name appendString:@"index"];
        for (NSArray *column in index) {
            [name appendFormat:@"_%@",[[column objectAtIndex:0] name]];
            NSString *str = [NSString stringWithFormat:@"`%@` %@",[[column objectAtIndex:0] name],[column objectAtIndex:1]];
            [columns addObject:str];
        } 
        [name appendFormat:@"_in_%@",self.name];
        NSMutableString *sql = [[NSMutableString alloc] init];
        [sql appendFormat:@"CREATE INDEX %@ ON %@ (%@)",
            name,self.name,[columns componentsJoinedByString:@","]];
        [sqliteCore executeWithSql:sql];
        [sql release];
        [columns release];
        [name release];
    }
}

-(void)addMethodToClass{
    if(!self.className || [self.className isEqualToString:@"TokoModel"]){return;}
    Class c = NSClassFromString(self.className);
    
    for (TSColumnSchema *colmun  in self.columns) {
        NSMutableString *setSelector = [[NSMutableString alloc] initWithFormat:@"set%@%@:",[[colmun.name substringToIndex:1] uppercaseString],[colmun.name substringFromIndex:1]];
        
        class_addMethod(c, NSSelectorFromString(setSelector), (IMP)setPropertyMethod, "v@:@");
        class_addMethod(c, NSSelectorFromString(colmun.name),  (IMP)getPropertyMethod, "v@:");
        [setSelector release];
    }
	
}

-(void)migrateOnDb:(TSSqlite *)sqliteCore from:(TSTableSchema *)schema{
    if(!schema){
        [self createTableOnDb:sqliteCore];
        return;
    }
    for (TSColumnSchema *column  in self.columns) {
        if (![schema schemaWithColumnName:column.name]) {
            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@",self.name,[column nameWithColumnDefine]];
            [sqliteCore executeWithSql:sql];
        }
    }
    for (TSColumnSchema *column  in schema.columns) {
        if (![self schemaWithColumnName:column.name]) {
            NSLog(@"SQLite cannot drop column");
            abort();
        }
    }  
    
}

@end
