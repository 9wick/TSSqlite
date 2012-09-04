//
//  TSFetchResultsController.h
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//


#import <Foundation/Foundation.h>
@class TSQuery;
@class TSFetchResultsSectionController;

@interface TSFetchResultsController : NSObject{
    NSMutableArray *_sections;
    NSString *_sectionKey,*_sectionNameKey;
    TSQuery *_query;
}

-(int)sectionCount;
-(id)initWithQuery:(TSQuery *)query sectionKey:(NSString *)key sectionNameKey:(NSString *)nameKey;
-(TSFetchResultsSectionController *)sectionAtIndex:(int)index;
-(void)preFetch;
-(id)objectAtIndexPath:(NSIndexPath *)indexPath;
-(NSString *)sectionNameAtIndex:(int)index;
-(void)removeAllObjects;
-(void)reload;
-(BOOL)isExistAtIndexPath:(NSIndexPath *)indexPath;


-(int)sectionIndexForSection:(TSFetchResultsSectionController *)section;
-(TSFetchResultsSectionController *)sectionForKey:(id)key;
@end
