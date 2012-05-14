//
//  TokoQueryResultsController.m
//  toko
//
//  Created by 木戸 康平 on 12/03/15.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "TokoQueryResultsController.h"
#import "TokoTableSchema.h"


@implementation TokoQueryResultsController
@synthesize countPerOnce = _countPerOnce;


-(id)initWithQuery:(TokoQuery *)query sectionKey:(NSString *)key{
    if((self = [super init])){
        _countPerOnce = 20;
        _objects = [[NSMutableDictionary alloc] init];
        _sectionKey = key;
    }
    return self;
}

-(void)dealloc{
    TokoRelease(_objects);
    TokoRelease(_idMap);
    TokoRelease(_query);
    [super dealloc];
}


-(void)makeIdMap{
    TokoRelease(_idMap);
    _idMap = [[NSMutableArray alloc] init];
    //todo
    
//    TokoTableSchema * schema = [[_sqliteCore schema] schemaWithTableName:_tableName];
//    NSString *primaryKeyName =[[schema.primaryKeys lastObject] name];
//    
//    [_query resetSelectKey];
//    [_query addSelectKey:primaryKeyName];
//    if(_sectionKey){
//        [_query addSelectKey:_sectionKey];
//    }
//    NSArray *objects = [_query fetchAllDictionary];
//    for (NSDictionary *dic in obj) {
//        id primaryValue = [dic objectForKey:primaryKeyName];
//        if( )
//    }
}



@end
