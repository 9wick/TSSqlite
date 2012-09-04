//
//  TokoFetchResultsController.h
//  toko
//
//  Created by 木戸 康平 on 12/04/07.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
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
