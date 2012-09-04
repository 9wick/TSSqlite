//
//  TSModelTable.m
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//

#import "TSModelTable.h"
#import "TSQuery.h"

@implementation TSModelTable

+(id)table{
    return [[[self alloc] init] autorelease];
}

-(NSString *)tableName{
    abort();
}

-(TSQuery *)query{
    TSQuery *query = [[[TSQuery alloc] init] autorelease];
    query.tableName = [self tableName];
    query.sqliteCore = [TSSqlite sharedSqlite];
    return query;
}

@end
