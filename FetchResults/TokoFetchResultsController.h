//
//  TokoFetchResultsController.h
//  toko
//
//  Created by 木戸 康平 on 12/04/22.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TokoQuery;
@class TokoFetchResultsSectionController;

@interface TokoFetchResultsController : NSObject{
    NSMutableArray *_sections;
    NSString *_sectionKey,*_sectionNameKey;
    TokoQuery *_query;
}

-(int)sectionCount;
-(id)initWithQuery:(TokoQuery *)query sectionKey:(NSString *)key sectionNameKey:(NSString *)nameKey;
-(TokoFetchResultsSectionController *)sectionAtIndex:(int)index;
-(void)preFetch;
-(id)objectAtIndexPath:(NSIndexPath *)indexPath;
-(NSString *)sectionNameAtIndex:(int)index;
-(void)removeAllObjects;
-(void)reload;
-(BOOL)isExistAtIndexPath:(NSIndexPath *)indexPath;


-(int)sectionIndexForSection:(TokoFetchResultsSectionController *)section;
-(TokoFetchResultsSectionController *)sectionForKey:(id)key;
@end
