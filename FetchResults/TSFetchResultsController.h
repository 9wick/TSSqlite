//
//  TokoFetchResultsController.h
//  toko
//
//  Created by 木戸 康平 on 12/04/22.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
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
