//
//  TokoFetchResultsController.m
//  toko
//
//  Created by 木戸 康平 on 12/04/07.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "TSFetchResultsSectionController.h"
#import "TSSqlite.h"

@implementation TSFetchResultsSectionController
@synthesize sectionName = _sectionName;
@synthesize sectionKey = _sectionKey;

-(id)initWithQuery:(TSQuery *)query{
    if((self =[super init] )){
        _query = [query retain];
        _cachedData = [[NSMutableDictionary alloc] init];
        _limit = 20;
    }
    return self;
}

-(void)dealloc{
    TSRelease(_sectionKey);
    TSRelease(_query);
    TSRelease(_cachedData);
    TSRelease(_sectionName);
    [super dealloc];
}
-(int)count{
    
    _query.offset = 0;
    _query.limit = 0;
    return [_query count];

}

-(void)setCacheIncludeIndex:(int)index{
    int offset = index - (index % _limit);
    _query.offset = offset;
    _query.limit = _limit;
    NSArray *objects = [_query fetchAll];
    int count = MIN( [objects count] , _limit);
    for (int i= 0; i < count; i++) {
        [_cachedData setObject:[objects objectAtIndex:i] forKey:[NSNumber numberWithInt:i+offset]];
    }
    NSAssert([_cachedData objectForKey:[NSNumber numberWithInt:index]], @"cannot load");
}

-(id)objectAtIndex:(int)index{
    id data = [_cachedData objectForKey:[NSNumber numberWithInt:index]];
    if(!data){
        [self setCacheIncludeIndex:index];
        data = [_cachedData objectForKey:[NSNumber numberWithInt:index]];
        NSAssert(data, @"cannot load");
    }
    return data;
}

-(void)removeAllObjects{
    [_cachedData removeAllObjects];
}


@end
