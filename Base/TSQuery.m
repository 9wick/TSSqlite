//
//  TokoQuery.m
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/16.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "TSQuery.h"
#import "TSSqlite.h"

@implementation TSQuery
@synthesize alias = _alias;
@synthesize tableName = _tableName;
@synthesize sqliteCore = _sqliteCore;
@synthesize limit = _limit;
@synthesize offset = _offset;


@synthesize wheres = _wheres;
@synthesize orders = _orders;
@synthesize selects = _selects;
@synthesize groups = _groups;

-(id)init{
    if((self = [super init])){
        _wheres = [[NSMutableArray alloc] init];
        _orders = [[NSMutableArray alloc] init];
        _selects = [[NSMutableArray alloc] init];
        _groups = [[NSMutableArray alloc] init];
    }
    return  self;
}
-(void)dealloc{
    TSRelease(_alias);
    TSRelease(_selects);
    TSRelease(_groups);
    TSRelease(_orders);
    TSRelease(_tableName);
    TSRelease(_sqliteCore);
    TSRelease(_wheres);
    [super dealloc];
}

- (id)copy{
    TSQuery* result = [[[self class] alloc] init];
    
    if (result){
        result.alias = [[_alias mutableCopy] autorelease];
        result.tableName = [[_tableName mutableCopy] autorelease];
        result.wheres = [[_wheres mutableCopy] autorelease];
        result.orders = [[_orders mutableCopy] autorelease];
        result.selects = [[_selects mutableCopy] autorelease];
        result.groups = [[_groups mutableCopy] autorelease];
        result.sqliteCore = _sqliteCore;
    }    
    return result;
    
}


-(void)addWhereWithKey:(NSString *)key value:(id)value{
    if([value isKindOfClass:[NSString class]]){
        [_wheres addObject:[NSString stringWithFormat:@"`%@` = '%@'",key  , value]];
    }else{
        [_wheres addObject:[NSString stringWithFormat:@"`%@` = %d",key , [value intValue]]];
    }
}

-(void)addWhereWithKey:(NSString *)key sign:(NSString *)sign value:(id)value{
    if([[sign uppercaseString] isEqualToString:@"IN"] && [value isKindOfClass:[NSArray class]]){
        [_wheres addObject:[NSString stringWithFormat:@"`%@` %@ (%@)",key  , sign, [value componentsJoinedByString:@","]]];    
    }else if([[sign uppercaseString] isEqualToString:@"IN"] ){
        [_wheres addObject:[NSString stringWithFormat:@"`%@` %@ (%@)",key  , sign, value]];    
    }else if([value isKindOfClass:[NSString class]]){
        [_wheres addObject:[NSString stringWithFormat:@"`%@` %@ '%@'",key  , sign, value]];
    }else{
        [_wheres addObject:[NSString stringWithFormat:@"`%@` %@ %d",key , sign, [value intValue]]];
    }
    
}

-(void)resetSelectKey{
    [_selects removeAllObjects];
}


-(void)addSelectKey:(NSString *)key{
    [self addSelectKey:key as:key];
}

-(void)addSelectKey:(NSString *)key as:(NSString *)asName{
    [_selects addObject:[NSString stringWithFormat:@"%@ as %@",key , asName]];
}

-(void)setPage:(int)page perPage:(int)perPage{

}


-(void)addGroupBy:(NSString *)key{
    [_groups addObject:key];
}


-(void)addOrder:(NSString *)key asc:(BOOL)asc{
    [_orders addObject:[NSString stringWithFormat:@"`%@` %@",key , asc ? @"ASC" : @"DESC"]];
}


-(NSString *)sql{
    NSMutableString *sql = [[[NSMutableString alloc] init] autorelease];
    
    [sql appendFormat:@"select "];
    if([_selects count] == 0){
        [sql appendFormat:@"*"];
    }else{
        [sql appendString:[_selects componentsJoinedByString:@","]];
    }
         
    
    
    [sql appendFormat:@" from %@ ",_tableName];
    
    if([_wheres count] > 0){
        [sql appendFormat:@"where %@ ",[_wheres componentsJoinedByString:@" AND "]];
        
    }
    
    if([_groups count] > 0){
        [sql appendFormat:@"group by %@ ",[_groups componentsJoinedByString:@","]];
        
    }
    
    if([_orders count] > 0){
        [sql appendFormat:@"order by %@ ",[_orders componentsJoinedByString:@","]];
        
    }
    
    if(_limit != 0){
        [sql appendFormat:@" limit %d ",_limit];
    }
    if(_offset != 0){
        [sql appendFormat:@" offset %d ",_offset];
    }
    
    return sql;
}

-(NSArray *)fetchAll{
    TSTableSchema * schema = [[_sqliteCore schema] schemaWithTableName:_tableName];
    return [_sqliteCore executeWithSql:[self sql] forClass:NSClassFromString(schema.className) ];
}


-(NSArray *)fetchAllDictionary{
    return [_sqliteCore executeWithSql:[self sql]];
}



-(id)fetchOne{
    TSQuery *query = [self copy];
    query.limit = 1;
    id obj = [[query fetchAll] lastObject];
    [query release];
    return obj;
}


         
-(int)count{
    TSQuery *query = [self copy];
    [query resetSelectKey];
    [query addSelectKey:@"count(1)" as:@"count"];
    NSArray *array = [_sqliteCore executeWithSql:[query sql] ];
    NSNumber *count = [[array lastObject] objectForKey:@"count"];
    [query release];
    return [count intValue];
    
}
        
         
         

@end
