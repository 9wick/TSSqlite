//
//  TokoModelTable.h
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/16.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TSQuery;

@interface TSModelTable : NSObject

+(id)table;
-(NSString *)tableName;
-(TSQuery *)query;

@end
