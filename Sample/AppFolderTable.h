//
//  AppFolderTable.h
//  novelViewer3
//
//  Created by 木戸 康平 on 12/05/06.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokoSqlite.h"

@class AppFolder;
@interface AppFolderTable : TokoModelTable

-(TokoQuery *)queryToFindAllByFolderId:(int)folderId;
-(AppFolder*)findById:(int)folderId;
-(int)maxOrderInFolderId:(int)folderId;
-(void)changeOrderFrom:(AppFolder *)fromFolder to:(AppFolder *)toFolder;
-(NSArray *)foldersInFolder:(AppFolder *)folder;
-(NSArray *)folderIdsInFolderId:(int)folderId;
@end
