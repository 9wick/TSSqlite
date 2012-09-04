//
//  TokoColmunSchema.h
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/13.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
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
