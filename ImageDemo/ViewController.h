//
//  ViewController.h
//  ImageDemo
//
//  Created by Chan Youvita on 8/7/15.
//  Copyright (c) 2015 Kosign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageCollectionView.h"
#import "ImageDemo-Swift.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic)UICollectionView* collectionView;
@property (weak ,nonatomic)UIImageCollectionView* imageScrollView;
@property (weak ,nonatomic)SlideImage* slideImage;

@end

