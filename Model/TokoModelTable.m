//
//  TokoModelTable.m
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/16.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "TokoModelTable.h"


@implementation TokoModelTable

+(id)table{
    return [[[self alloc] init] autorelease];
}

-(NSString *)tableName{
    abort();
}

-(TokoQuery *)query{
    TokoQuery *query = [[[TokoQuery alloc] init] autorelease];
    query.tableName = [self tableName];
    query.sqliteCore = [TokoSqliteCore sharedSqliteCore];
    return query;
}

@end
