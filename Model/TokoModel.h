//
//  TokoModel.h
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/13.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TokoSqliteCore;
@class TokoTableSchema;


@interface TokoModel : NSObject{
    TokoSqliteCore *_sqliteCore;
    TokoTableSchema *_schema;
    NSMutableDictionary *_data;
    NSMutableDictionary *_originalData;
    
}


@property(retain,nonatomic) TokoSqliteCore *sqliteCore;
@property(retain,nonatomic) NSString *name;
@property(readonly,nonatomic) TokoTableSchema *schema;

-(void)save;
-(void)updateSave;
-(void)insertSave;
-(void)delete;
-(void)refresh;


-(void)setOriginalValue:(id)value forKey:(NSString *)key;
-(void)setValue:(id)value forKey:(NSString *)key;
-(id)valueForKey:(NSString *)key;
-(NSString *)whereString;
-(NSDictionary *)values;
-(void)setValues:(NSDictionary *)values;


@end
