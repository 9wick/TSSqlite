//
//  TokoFetchResultsController.m
//  toko
//
//  Created by 木戸 康平 on 12/04/22.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "TSFetchResultsController.h"
#import "TokoSqlite.h"

@implementation TSFetchResultsController

-(id)initWithQuery:(TSQuery *)query sectionKey:(NSString *)key sectionNameKey:(NSString *)nameKey{
    if((self = [super init])){
        _query = [query retain];
        _sectionKey = [key retain];
        _sectionNameKey = [nameKey retain];
        _sections = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)dealloc{
    TokoRelease(_sections);
    TokoRelease(_sectionKey);
    TokoRelease(_sectionNameKey);
    TokoRelease(_query);
    [super dealloc];
}

-(void)preFetch{
    [_sections removeAllObjects];
    TSQuery *query = [_query copy];
    [query addGroupBy:_sectionKey];
    [query resetSelectKey];
    [query addSelectKey:_sectionKey as:_sectionKey];
    if(_sectionNameKey){
        [query addSelectKey:_sectionNameKey as:_sectionNameKey];
    }
    NSArray *sectionData = [[query fetchAllDictionary] retain];
    [query release];
    
    for (NSDictionary *dic in sectionData) {
        TSQuery *query = [_query copy];
        [query addWhereWithKey:_sectionKey value:[dic objectForKey:_sectionKey]];
        TokoFetchResultsSectionController *sectionController = [[TokoFetchResultsSectionController alloc] initWithQuery:query];
        sectionController.sectionName = [dic objectForKey:_sectionNameKey];
        sectionController.sectionKey = [dic objectForKey:_sectionKey];
        [_sections addObject:sectionController];
        [sectionController release];
        [query release];
    }
    [sectionData release];
    
}

-(int)sectionCount{
    return [_sections count];
}


-(TokoFetchResultsSectionController *)sectionAtIndex:(int)index{
   return [_sections objectAtIndex:index];
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    return [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(NSString *)sectionNameAtIndex:(int)index{
    return [[_sections objectAtIndex:index] sectionName];
}

-(void)removeAllObjects{
    for (TokoFetchResultsSectionController *section in _sections) {
        [section removeAllObjects];
    }    
}

-(void)reload{
    [self preFetch];
}

-(BOOL)isExistAtIndexPath:(NSIndexPath *)indexPath{
    if([_sections count] <= indexPath.section || indexPath.section < 0){
        return NO;
    }
    int rowCount = [[_sections objectAtIndex:indexPath.section] count];
    if (rowCount <= indexPath.row || indexPath.row < 0) {
        return NO;
    }
    return YES;
}


-(int)sectionIndexForSection:(TokoFetchResultsSectionController *)section{
    return [_sections indexOfObject:section];   
}

 
-(TokoFetchResultsSectionController *)sectionForKey:(id)key{
    for (TokoFetchResultsSectionController *section in _sections) {
        if([section.sectionKey isEqual:key ]){
            return section;
        }
    }
    return  nil;
}

@end
