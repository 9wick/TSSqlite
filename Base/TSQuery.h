//
//  TSQuery.h
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//

#import <Foundation/Foundation.h>
#import "TSSqlite.h"

@interface TSQuery : NSObject{
    NSString *_alias;
    NSString *_tableName;
    NSMutableArray *_wheres;
    NSMutableArray *_orders;
    NSMutableArray *_selects;
    NSMutableArray *_groups;
    TSSqlite *_sqliteCore;
    
    int _limit,_offset;
    
}

@property(retain,nonatomic) NSString *alias;
@property(retain,nonatomic) NSString *tableName;
@property(retain,nonatomic) TSSqlite  *sqliteCore;
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
