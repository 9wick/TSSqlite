//
//  AppFolder.h
//  novelViewer3
//
//  Created by 木戸 康平 on 12/03/25.
//  Copyright (c) 2012 tokotoko soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokoModel.h"

@interface AppFolder : TokoModel

@property (retain,nonatomic) NSNumber *folderId;
@property (retain,nonatomic) NSString *name;
@property (retain,nonatomic) NSNumber *novelCount;
@property (retain,nonatomic) NSNumber *folderCount;
@property (retain,nonatomic) NSNumber *order;
@property (retain,nonatomic) NSNumber *parentFolderId;



-(void)moveToTopInFolder;

@end
