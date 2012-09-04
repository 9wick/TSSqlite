//
//  TokoModelTable.m
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/16.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "TSModelTable.h"


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
    query.sqliteCore = [TSSqlite sharedSqliteCore];
    return query;
}

@end
