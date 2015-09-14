//
//  ViewController.m
//  ImageDemo
//
//  Created by Chan Youvita on 8/7/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"


@interface ViewController ()<UIImageCollectionDelegate>
{
    NSArray *itemsUrl;
    NSArray *itemsData;
    NSMutableArray *imagesTemp;
    BOOL isReload;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemsUrl = @[@"http://www.planwallpaper.com/static/images/background-wallpapers-32.jpg",
                 @"http://www.planwallpaper.com/static/images/824183-green-wallpaper.jpg",
                 @"http://www.keenthemes.com/preview/metronic/theme/assets/global/plugins/jcrop/demos/demo_files/image2.jpg",
                 @"http://www.planwallpaper.com/static/images/fresh-green-background.jpg",
                 @"http://www.planwallpaper.com/static/images/recycled_texture_background_by_sandeep_m-d6aeau9_PZ9chud.jpg"
                ];
    
    itemsData = @[@"love cambodian",@"beautiful image",@"backgroud love",@"like the images",@"a lot of place",@"good memory",@"free dom",@"love love"];
    imagesTemp = [[NSMutableArray alloc] init];
    
    /* add footer view */
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    self.tableView.tableFooterView = footer;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 10, 10, self.view.frame.size.width - 20, 150) collectionViewLayout:layout];
        self.collectionView.tag = indexPath.row;
        self.imageScrollView = [UIImageCollectionView attachToCollectionView:self.collectionView
                                                                   urlImages:itemsUrl
                                                                   tagetView:cell.contentView
                                                        backgroundScrollView:[UIColor grayColor]
                                                            placeholderImage:[UIImage imageNamed:@"none_photo.png"]
                                                                     merging:YES
                                                           andHidePageFooter:NO
                                                               withAnimation:NO];
        self.imageScrollView.delegate = self;
        
        UILabel* content = [[UILabel alloc] initWithFrame:CGRectMake(10, self.collectionView.frame.size.height + 10, 300, 25)];
        content.tag = 1000;
        [cell.contentView addSubview:content];

    }else{

        /* Remove old object */
        for (UIView* v in cell.contentView.subviews) {
            if ([v isKindOfClass:[UICollectionView class]]){
                [v removeFromSuperview];
            }
        }

        /* Reuse cell init new object */
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 10, 10, self.view.frame.size.width - 20, 150) collectionViewLayout:layout];
        self.collectionView.tag = indexPath.row;
        self.imageScrollView = [UIImageCollectionView attachToCollectionView:self.collectionView
                                                               urlImages:itemsUrl
                                                               tagetView:cell.contentView
                                                    backgroundScrollView:[UIColor grayColor]
                                                        placeholderImage:[UIImage imageNamed:@"none_photo.png"]
                                                                 merging:YES
                                                       andHidePageFooter:NO
                                                           withAnimation:YES];

    }
    
    /* Slide Image Event */
    /////////////////////////////////////////////////////////////////////////////////////////////////
    /* Block code */
    [self.imageScrollView checkWithScrollHandler:^(NSIndexPath* index,NSInteger row) {
        if (row == indexPath.row) {
            imagesTemp = [[ImageSharedManager sharedImage] getSelectedImagesArray:index withRow:row];
        }
    }];
    
    /////////////////////////////////////////////////////////////////////////
    /* Move image set to positon */
    if ([imagesTemp count] != 0) {
        for (int i = 0; i < imagesTemp.count; i++) {
            if (indexPath.row == [[[imagesTemp objectAtIndex:i] objectForKey:@"indexRow"] integerValue]) {
                [self.collectionView scrollToItemAtIndexPath:[[imagesTemp objectAtIndex:i] objectForKey:@"indexPage"] atScrollPosition:NO animated:NO];
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    UILabel* content = (UILabel*)[cell.contentView viewWithTag:1000];
    content.text = itemsData[indexPath.row];

    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [itemsData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}

- (void)showImageViewCtrl:(NSInteger)index withImageURL:(NSObject *)url{
    NSLog(@"index-->%d with url-->%@",index,url);
}

@end
