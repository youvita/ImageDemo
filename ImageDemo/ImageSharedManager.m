//
//  ImageSharedManager.m
//  ImageDemo
//
//  Created by Chan Youvita on 8/14/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "ImageSharedManager.h"

@implementation ImageSharedManager

static ImageSharedManager* imgIndexPath = nil;

+ (ImageSharedManager *)sharedImage{
    if (imgIndexPath == nil) {
        imgIndexPath = [[ImageSharedManager alloc] init];
    }
    return imgIndexPath;
}

-(id)init{
    if (self = [super init]) {
        self.arrImages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray*)getSelectedImagesArray:(NSIndexPath*)indexPath withRow:(NSInteger)rowPath{
    for (int i =0; i< [self.arrImages count]; i++) {
        /* Check duplicate row */
        if (rowPath == [[[self.arrImages objectAtIndex:i] objectForKey:@"indexRow"] integerValue]) {
            [self.arrImages removeObjectAtIndex:i]; // remove old row and then add new row
        }
    }

    /* Add object */
    if (self.indexItem != 0) {
        self.dicImages = [[NSMutableDictionary alloc] init];
        [self.dicImages setObject:indexPath forKey:@"indexPage"];
        [self.dicImages setObject:[NSString stringWithFormat:@"%ld",(long)rowPath] forKey:@"indexRow"];
        [self.arrImages addObject:self.dicImages];
    }
    NSLog(@"%@",self.arrImages);
    return self.arrImages;
}

- (void)setIndexPathItem:(int)item{
    self.indexItem = item;
}

@end
