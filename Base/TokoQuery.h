//
//  TokoQuery.h
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/16.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokoSqliteCore.h"

@interface TokoQuery : NSObject{
    NSString *_alias;
    NSString *_tableName;
    NSMutableArray *_wheres;
    NSMutableArray *_orders;
    NSMutableArray *_selects;
    NSMutableArray *_groups;
    TokoSqliteCore *_sqliteCore;
    
    int _limit,_offset;
    
}

@property(retain,nonatomic) NSString *alias;
@property(retain,nonatomic) NSString *tableName;
@property(retain,nonatomic) TokoSqliteCore  *sqliteCore;
@property(assign,nonatomic) int limit;
@property(assign,nonatomic) int offset;



@property(retain,nonatomic) NSArray *wheres;
@property(retain,nonatomic) NSArray *orders;
@property(retain,nonatomic) NSArray *selects;
@property(retain,nonatomic) NSArray *groups;


-(void)addWhereWithKey:(NSString *)key sign:(NSString *)sign value:(id)value;
-(void)addWhereWithKey:(NSString *)key value:(id)value;
-(void)resetSelectKey;
-(void)addSelectKey:(NSString *)key;
-(void)addSelectKey:(NSString *)key as:(NSString *)asName;
-(void)addGroupBy:(NSString *)key;
-(void)setPage:(int)page perPage:(int)perPage;

-(void)addOrder:(NSString *)key asc:(BOOL)yes;


-(NSString *)sql;

-(NSArray *)fetchAll;
-(NSArray *)fetchAllDictionary;
-(id)fetchOne;
-(int)count;

@end
