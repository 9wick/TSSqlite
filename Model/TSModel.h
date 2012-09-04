//
//  TSModel.h
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//


#import <Foundation/Foundation.h>
@class TSSqlite;
@class TSTableSchema;


@interface TSModel : NSObject{
    TSSqlite *_sqliteCore;
    TSTableSchema *_schema;
    NSMutableDictionary *_data;
    NSMutableDictionary *_originalData;
    
}


@property(retain,nonatomic) TSSqlite *sqliteCore;
@property(retain,nonatomic) NSString *name;
@property(readonly,nonatomic) TSTableSchema *schema;

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
