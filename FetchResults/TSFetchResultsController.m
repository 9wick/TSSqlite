//
//  TSFetchResultsController.m
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//

#import "TSFetchResultsController.h"
#import "TSSqlite.h"

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
    TSRelease(_sections);
    TSRelease(_sectionKey);
    TSRelease(_sectionNameKey);
    TSRelease(_query);
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
        TSFetchResultsSectionController *sectionController = [[TSFetchResultsSectionController alloc] initWithQuery:query];
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


-(TSFetchResultsSectionController *)sectionAtIndex:(int)index{
   return [_sections objectAtIndex:index];
}

-(id)objectAtIndexPath:(NSIndexPath *)indexPath{
    return [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(NSString *)sectionNameAtIndex:(int)index{
    return [[_sections objectAtIndex:index] sectionName];
}

-(void)removeAllObjects{
    for (TSFetchResultsSectionController *section in _sections) {
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


-(int)sectionIndexForSection:(TSFetchResultsSectionController *)section{
    return [_sections indexOfObject:section];   
}

 
-(TSFetchResultsSectionController *)sectionForKey:(id)key{
    for (TSFetchResultsSectionController *section in _sections) {
        if([section.sectionKey isEqual:key ]){
            return section;
        }
    }
    return  nil;
}

@end
