//
//  TokoColmunSchema.m
//  TokoSqliteLib
//
//  Created by 木戸 康平 on 12/02/13.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "TokoColumnSchema.h"
#import "TokoSqliteCore.h"

@interface TokoColumnSchema ()
+(TokoColmunType)colmunTypeFromString:(NSString *)string;
+(NSString *)stringWithColmunType:(TokoColmunType)type;

@end




@implementation TokoColumnSchema

@synthesize name = _name;
@synthesize type = _type;
@synthesize isKey = _isKey;
@synthesize defaultValue = _defaultValue;
@synthesize isAutoincrement = _isAutoIncrement;


+(TokoColmunType)colmunTypeFromString:(NSString *)string{
    if([string isEqualToString:@"int"]
       || [string isEqualToString:@"integer"]){
        return TokoColmunTypeInteger;
        
    }else if([string isEqualToString:@"float"]
             || [string isEqualToString:@"double"]
             || [string isEqualToString:@"real"]){
        return TokoColmunTypeReal;
        
    }else if([string isEqualToString:@"blob"]){
        return TokoColmunTypeBlob;
        
    }
    return TokoColmunTypeText;
}

+(NSString *)stringWithColmunType:(TokoColmunType)type{
    switch (type) {
        case TokoColmunTypeInteger:
            return @"integer";
            break;
        case TokoColmunTypeReal:
            return @"real";
            break;
        case TokoColmunTypeBlob:
            return @"blob";
            break;
        default:
            return @"text";
            break;
    }
}

-(id)initWithName:(NSString *)name data:(NSDictionary *)data{
    if((self = [super init ])){
        _name  = [name retain];
        _type = [[self class] colmunTypeFromString:[data objectForKey:@"type"]];
        _isKey = [[data objectForKey:@"primary"] boolValue];
        _isAutoIncrement = [[data objectForKey:@"autoincrement"] boolValue];
        _defaultValue = [[data objectForKey:@"default"] retain];
    }
    return self;
}

-(void)dealloc{
    TokoRelease(_name);
    TokoRelease(_defaultValue);
    [super dealloc];
}

-(NSString *)typeString{
    return [[self class] stringWithColmunType:_type];
}

-(NSString *)escapedString:(id)value{
    NSString *escapedValue = nil;
    
    if(self.type == TokoColmunTypeInteger){
        escapedValue = [NSString stringWithFormat:@"%d", [value intValue]];
    }else if(self.type == TokoColmunTypeText){
        escapedValue = [NSString stringWithFormat:@"'%@'", [TokoSqliteCore stringByEscapeWithString:value] ];
    }else{
        escapedValue = @"''";
    }

    return escapedValue;
}

-(NSString *)nameWithColumnDefine{
    NSMutableString *columnDef = [NSMutableString string];
    [columnDef appendFormat:@"'%@'",self.name];
    [columnDef appendFormat:@" %@",self.typeString];
    
    if(self.isKey){
        [columnDef appendString:@" primary key "];
    }
    if(self.isAutoincrement){
        [columnDef appendString:@" autoincrement"];
    }
    if(self.defaultValue){
        [columnDef appendFormat:@" default %@",[self escapedString:self.defaultValue]];
    }
    return columnDef;

}
-(NSString *)description{
    return [NSString stringWithFormat:@"name:%@  type:%@  key:%@",
            _name,self.typeString,_isKey?@"YES":@"NO"];
}

-(Class)classType{
    switch (_type) {
        case TokoColmunTypeText:
            return [NSString class];
            break;
        case TokoColmunTypeInteger:
        case TokoColmunTypeReal:
            return [NSNumber class];
            break;
        case TokoColmunTypeBlob:
            return [NSData class];
            break;
            
    }
    abort();
    return nil;
}

@end
