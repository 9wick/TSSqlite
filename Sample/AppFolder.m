//
//  AppFolder.m
//  novelViewer3
//
//  Created by 木戸 康平 on 12/03/25.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import "AppFolder.h"
#import "AppFolderTable.h"
#import "AppNovelTable.h"
@implementation AppFolder
@dynamic folderId;
@dynamic name;
@dynamic novelCount;
@dynamic folderCount;
@dynamic order;
@dynamic parentFolderId;


-(void)moveToTopInFolder{
    int order = [[AppFolderTable table] maxOrderInFolderId:[self.parentFolderId intValue]];
    [self setOrder:[NSNumber numberWithInt:order+1] ];
}


-(void)delete{
    NSArray *novelIds = [[AppNovelTable table] novelIdsInFolder:self];
    [(AppNovelTable *)[AppNovelTable table] deleteNovelIds:novelIds];
    
    NSArray *folders = [[AppFolderTable table] foldersInFolder:self];
    for (AppFolder *folder in folders) {
        [folder delete];
    }
    
    [super delete];
}

@end
