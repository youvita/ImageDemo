//
//  UIImageCollectionView.h
//  ImageDemo
//
//  Created by Chan Youvita on 8/7/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//
/* Slide image show
 * urlImages is image url that you get from web.
 * tagetView of place that you want add to.
 * backgroundScrollView for background color of collection view.
 * placeholderImage using for emty in collection view.
 * merging is space between images in collection cell.
 * hidePageFooter is number of page image.
 */

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ImageSharedManager.h"

@protocol UIImageCollectionDelegate <NSObject>
@optional
- (void)showImageViewCtrl:(NSInteger)index withImageURL:(NSObject*)url;

@end

@interface UIImageCollectionView : UIView <UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView* _collectionView;
    BOOL isScrolling;
}
@property (nonatomic, weak)id <UIImageCollectionDelegate>delegate;

+ (UIImageCollectionView*)attachToCollectionView:(UICollectionView*)collectionView
                            urlImages:(NSArray*)urlImages
                            tagetView:(UIView*)tagetView
                            backgroundScrollView:(UIColor*)color
                            placeholderImage:(UIImage*)image
                            merging:(BOOL)merging
                            andHidePageFooter:(BOOL)footer
                            withAnimation:(BOOL)animate;

-(void)checkWithScrollHandler:(void(^)(NSIndexPath*,NSInteger))block;

@end
