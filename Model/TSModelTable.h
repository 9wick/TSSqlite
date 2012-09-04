//
//  TSModelTable.h
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//

#import <Foundation/Foundation.h>
@class TSQuery;

@interface TSModelTable : NSObject

+(id)table;
-(NSString *)tableName;
-(TSQuery *)query;

@end
