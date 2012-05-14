//
//  TokoQueryResultsController.h
//  toko
//
//  Created by 木戸 康平 on 12/03/15.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokoQuery.h"

@class TokoQueryResultsController;

@protocol TokoQueryResultsControllerDelegate<NSObject>
@optional

@end


@interface TokoQueryResultsController : NSObject{
    int _defaultLimit, _defaultOffset;
    NSMutableDictionary *_objects;
    NSMutableArray *_idMap;
    TokoQuery *_query;
    int _countPerOnce;
    int _sectionCount;
    NSString *_sectionKey;
}

@property(assign,nonatomic) int countPerOnce;
-(id)initWithQuery:(TokoQuery *)query sectionKey:(NSString *)key;
-(void)makeIdMap;

@end
