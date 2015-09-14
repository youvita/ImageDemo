//
//  ImageSharedManager.h
//  ImageDemo
//
//  Created by Chan Youvita on 8/14/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSharedManager : NSObject
@property (nonatomic, strong)NSMutableArray* arrImages;
@property (nonatomic, strong)NSMutableDictionary* dicImages;
@property (nonatomic, assign)int indexItem;

+ (ImageSharedManager *)sharedImage;
- (NSMutableArray*)getSelectedImagesArray:(NSIndexPath*)indexPath withRow:(NSInteger)rowPath;
- (void)setIndexPathItem:(int)item;

@end
