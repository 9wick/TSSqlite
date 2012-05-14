//
//  TokoColmunSchema.h
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/13.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TokoColmunType {
    TokoColmunTypeText    = 1,
    TokoColmunTypeInteger = 2,
    TokoColmunTypeReal    = 3,
    TokoColmunTypeBlob    = 4,
};

typedef enum  TokoColmunType TokoColmunType;


@interface TokoColumnSchema : NSObject{
    NSString *_name;
    TokoColmunType _type;
    BOOL _isKey;
    BOOL _isAutoIncrement;
    NSString* _defaultValue;
    
}

@property(readonly,nonatomic) NSString *name;
@property(readonly,nonatomic) TokoColmunType type;
@property(readonly,nonatomic) BOOL isKey; 
@property(readonly,nonatomic) BOOL isAutoincrement;
@property(readonly,nonatomic) NSString *defaultValue;

@property(readonly,nonatomic) NSString *typeString;

-(id)initWithName:(NSString *)name data:(NSDictionary *)data;
-(NSString *)escapedString:(id)value;
-(NSString *)nameWithColumnDefine;
-(Class)classType;

@end
