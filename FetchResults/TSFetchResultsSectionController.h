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
@interface TSFetchResultsSectionController : NSObject{
    TSQuery *_query;
    NSMutableDictionary *_cachedData;
    int _limit;
    NSString *_sectionName;
    id _sectionKey;
}

@property (retain,nonatomic) NSString *sectionName;
@property (retain,nonatomic) id sectionKey;

-(int)count;
-(id)initWithQuery:(TSQuery *)query;
-(id)objectAtIndex:(int)index;
-(void)removeAllObjects;
@end
