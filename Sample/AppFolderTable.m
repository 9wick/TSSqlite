//
//  AppFolderTable.m
//  novelViewer3
//
//  Created by 木戸 康平 on 12/05/06.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "AppFolderTable.h"
#import "AppFolder.h"
#import "AppNovel.h"

@implementation AppFolderTable

-(NSString *)tableName{
    return @"folder";
}

-(TokoQuery *)queryToFindAllByFolderId:(int)folderId{
    TokoQuery *query = [self query];
    [query addWhereWithKey:@"parentFolderId" value:[NSNumber numberWithInt:folderId]];
    [query addOrder:@"order" asc:NO];
    return query;
}



-(AppFolder*)findById:(int)folderId{
    TokoQuery *query = [self query];
    [query addWhereWithKey:@"folderId" value:[NSNumber numberWithInt:folderId]];
    AppFolder *folder =  [query fetchOne];
    
    if(folder  == nil && folderId == 0){
        folder = [[[AppFolder alloc] init] autorelease];
        folder.folderId = [NSNumber numberWithInt:0];
        folder.parentFolderId = [NSNumber numberWithInt:-1];
        folder.name = @"書庫";
        [folder save];
    }
    return folder;
}

-(int)maxOrderInFolderId:(int)folderId{
    TokoQuery *query = [self query];
    [query addWhereWithKey:@"parentFolderId" value:[NSNumber numberWithInt:folderId]];
    [query addOrder:@"order" asc:NO];
    [query addSelectKey:@"`order`"];
    [query setLimit:1];
    NSDictionary *dic = [[query fetchAllDictionary] lastObject];
    return [[dic objectForKey:@"order"] intValue];
}

-(NSArray *)foldersInFolder:(AppFolder *)folder{
    TokoQuery *query = [self query];
    [query addWhereWithKey:@"parentFolderId" value:folder.folderId];
    [query addOrder:@"order" asc:NO];
    return [query fetchAll];
}


-(NSArray *)folderIdsInFolderId:(int)folderId{
    TokoQuery *query = [self query];
    [query addWhereWithKey:@"parentFolderId" value:[NSNumber numberWithInt:folderId]];
    [query addOrder:@"order" asc:NO];
    [query addSelectKey:@"folderId"];
    NSArray *results = [query fetchAllDictionary];
    return [results valueForKeyPath:@"folderId"];
}


-(void)changeOrderFrom:(AppFolder *)fromFolder to:(AppFolder *)toFolder{
    if(![fromFolder.parentFolderId isEqualToNumber:toFolder.parentFolderId]){
        return;
    }
    
    int fromIndex = [fromFolder.order intValue];  
    int toIndex = [toFolder.order intValue];
    
    
    NSUInteger start, end;
    int delta;
    
    if (fromIndex < toIndex) {
        delta = -1;
        start = fromIndex + 1;
        end = toIndex;
    } else { // fromIndex > toIndex
        delta = 1;
        start = toIndex;
        end = fromIndex - 1;
    }
    NSString *sql = [NSString stringWithFormat:@"UPDATE folder SET `order` = `order` %+d WHERE parentFolderId = %d AND  %d <= `order` AND `order` <= %d ",
                     delta,[fromFolder.parentFolderId intValue],start,end];
    [[TokoSqliteCore sharedSqliteCore] executeWithSql:sql];
    
    fromFolder.order = toFolder.order;
    [fromFolder save];
}


@end
