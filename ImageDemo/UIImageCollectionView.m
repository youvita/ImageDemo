//
//  UIImageCollectionView.m
//  ImageDemo
//
//  Created by Chan Youvita on 8/7/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "UIImageCollectionView.h"

@interface UIImageCollectionView(){
    UIImageView*    imageView;
    UILabel*        page;
    NSMutableArray* contentSizePage;
    NSIndexPath*    indexPage;
    float           currentPage;
    float           mergingW;
    float           mergingX;
    BOOL            pageChanged;
}

@property (nonatomic, strong)UICollectionView* collectionView;
@property (nonatomic, assign)UIView* tagetView;
@property (nonatomic, assign)NSArray* urlImages;
@property (nonatomic, assign)UIColor* backgroundColor;
@property (nonatomic, copy)UIImage* placeholderImage;
@property (nonatomic, assign)BOOL merging;
@property (nonatomic, assign)BOOL pageFooter;
@property (nonatomic, assign)BOOL animate;
@property (nonatomic, strong)void(^scrollHandler)(NSIndexPath*,NSInteger);

@end

@implementation UIImageCollectionView

+ (UIImageCollectionView *)attachToCollectionView:(UICollectionView *)collectionView urlImages:(NSArray *)urlImages tagetView:(UIView *)tagetView backgroundScrollView:(UIColor *)color placeholderImage:(UIImage *)image merging:(BOOL)merging andHidePageFooter:(BOOL)footer withAnimation:(BOOL)animate{
    UIImageCollectionView* imageCollectionControl = [[UIImageCollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, collectionView.frame.size.width, 0.0f)
                                                                          collectionView:collectionView urlImages:urlImages
                                                                           tagetView:tagetView
                                                                backgroundScrollView:color
                                                                placeholderImage:image
                                                                             merging:merging
                                                                   andHidePageFooter:footer
                                                                    withAnimation:animate];
    [collectionView addSubview:imageCollectionControl];
    return imageCollectionControl;
}

-(id)initWithFrame:(CGRect)frame collectionView:(UICollectionView *)collectionView urlImages:(NSArray *)urlImages tagetView:(UIView *)tagetView backgroundScrollView:(UIColor *)color placeholderImage:(UIImage *)image merging:(BOOL)merging andHidePageFooter:(BOOL)footer withAnimation:(BOOL)animate{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView      = collectionView;
        self.tagetView           = tagetView;
        self.urlImages           = urlImages;
        self.backgroundColor     = color;
        self.placeholderImage    = image;
        self.pageFooter          = footer;
        self.animate             = animate;
        [self setUpCollectionView:merging];
    }
    
    return self;
}

-(void)checkMerging:(BOOL)merging{
    if(merging){
        mergingX = 2.0;
        mergingW = 4.0;
    }else{
        mergingX = 0.0;
        mergingW = 0.0;
    }
}

-(void)addFooterPageNumber{
    page = [[UILabel alloc] initWithFrame:CGRectMake(self.collectionView.frame.origin.x + self.collectionView.frame.size.width - 65, self.collectionView.frame.origin.y + self.collectionView.frame.size.height - 25, 100.0, 20.0)];
    page.text       = [NSString stringWithFormat:@"Page:%d/%lu",(indexPage.item + 1),(unsigned long)[self.urlImages count]];
    page.font       = [UIFont fontWithName:@"Helvetica" size:12.0];
    page.textColor  = [UIColor whiteColor];
    [self.tagetView addSubview:page];

}

-(void)setUpCollectionView:(BOOL)merging{
    /* init collection view */
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setBackgroundColor:self.backgroundColor];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setShowsVerticalScrollIndicator:NO];
    [_collectionView setPagingEnabled:YES];
    [self.tagetView addSubview:_collectionView];

    /* init content size of image view */
    contentSizePage     = [[NSMutableArray alloc] init];
    for (int i = 0; i<[self.urlImages count]; i++) {
        [contentSizePage addObject:[NSNumber numberWithFloat:self.collectionView.frame.size.width * i]];
    }
    
    if (!self.pageFooter) {
        /* add page number */
        [self addFooterPageNumber];
        pageChanged = YES;
    }
   
    [self checkMerging:merging];
    isScrolling = YES;
    
    if (self.animate) {
        /* Animation image collection view */
    //////////////////////////////////////////////////////////////////////////
        self.collectionView.alpha = 0.0;
        self.collectionView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        [UIView animateWithDuration:0.5 animations:^{
            self.collectionView.alpha = 1.0;
            self.collectionView.transform = CGAffineTransformIdentity;
        }];
    /////////////////////////////////////////////////////////////////////////
    }
    
}

-(void)checkWithScrollHandler:(void(^)(NSIndexPath*,NSInteger))block{
    self.scrollHandler = block;
}

- (void)updatePageNumber{
    if (!self.pageFooter) {
        page.text = [NSString stringWithFormat:@"Page:%d/%lu",(indexPage.item + 1),(unsigned long)[self.urlImages count]];
    }
}

#pragma mark - UICollectionViewDelegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
  
    /* remove collection view */
    for (int i = 0; i < [cell.contentView.subviews count]; i++) {
        [[cell.contentView.subviews objectAtIndex:i] removeFromSuperview];
    }
    
    /* remove activity indicator view */
    for (UIView* v in self.tagetView.subviews) {
        if ([v isKindOfClass:[UIActivityIndicatorView class]]){
            [v removeFromSuperview];
        }
    }
    
    /* add waiting loading */
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = self.collectionView.center;
    [indicator startAnimating];
    [self.tagetView addSubview:indicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        indexPage = indexPath; // get indexPath for page
        NSURL* url = [NSURL URLWithString:self.urlImages[indexPath.item]];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.collectionView.frame.origin.x - 10 + mergingX, 0.0,self.collectionView.frame.size.width - mergingW, self.collectionView.frame.size.height)];
        [imageView sd_setImageWithURL:url placeholderImage:self.placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [indicator removeFromSuperview];
           
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            if (pageChanged) {
                [self updatePageNumber];
            }
            
            [cell.contentView addSubview:imageView];
        });
    });

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urlImages.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.frame.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPage.item);
    [self.delegate showImageViewCtrl:indexPage.item withImageURL:self.urlImages[indexPage.item]];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   isScrolling = NO;
   pageChanged = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isScrolling) {return;}
    
        if (scrollView.contentOffset.x > currentPage) {
            /* Right */
            if (scrollView.contentOffset.x == (CGFloat)[[contentSizePage objectAtIndex:indexPage.item]floatValue]) {
                if (scrollView.contentOffset.x != currentPage) {
                    currentPage = (CGFloat)[[contentSizePage objectAtIndex:indexPage.item]floatValue];
                    [[ImageSharedManager sharedImage] setIndexPathItem:indexPage.item];
                    self.scrollHandler(indexPage,self.collectionView.tag);
                    [self updatePageNumber];
                }
            }
        }else{
            /* Left */
            if (scrollView.contentOffset.x == (CGFloat)[[contentSizePage objectAtIndex:indexPage.item]floatValue]) {
                if (scrollView.contentOffset.x != currentPage || scrollView.contentOffset.x == currentPage) {
                    currentPage = (CGFloat)[[contentSizePage objectAtIndex:indexPage.item]floatValue];
                    [[ImageSharedManager sharedImage] setIndexPathItem:indexPage.item];
                    self.scrollHandler(indexPage,self.collectionView.tag);
                    [self updatePageNumber];
                }
            }
        }

}

@end
