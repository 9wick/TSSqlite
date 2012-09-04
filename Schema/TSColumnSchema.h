//
//  TSColmunSchema.h
//  TSSqlite
//
//  Created by Kouhei Kido on 12/09/5.
//  Copyright 2012 Kouhei Kido.
//  MIT License http://www.opensource.org/licenses/mit-license.php
//

#import <Foundation/Foundation.h>

enum TSColmunType {
    TSColmunTypeText    = 1,
    TSColmunTypeInteger = 2,
    TSColmunTypeReal    = 3,
    TSColmunTypeBlob    = 4,
};

typedef enum  TSColmunType TSColmunType;


@interface TSColumnSchema : NSObject{
    NSString *_name;
    TSColmunType _type;
    BOOL _isKey;
    BOOL _isAutoIncrement;
    NSString* _defaultValue;
    
}

@property(readonly,nonatomic) NSString *name;
@property(readonly,nonatomic) TSColmunType type;
@property(readonly,nonatomic) BOOL isKey; 
@property(readonly,nonatomic) BOOL isAutoincrement;
@property(readonly,nonatomic) NSString *defaultValue;

@property(readonly,nonatomic) NSString *typeString;

-(id)initWithName:(NSString *)name data:(NSDictionary *)data;
-(NSString *)escapedString:(id)value;
-(NSString *)nameWithColumnDefine;
-(Class)classType;

@end
