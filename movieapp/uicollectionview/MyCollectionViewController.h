//
//  MuCollectionViewController.h
//  uicollectionview
//
//  Created by ahme on 5/5/18.
//  Copyright © 2018 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking.h>
#import "Movie.h"
#import "DetailsViewController.h"
#import "DatabaseManger.h"

@interface MyCollectionViewController : UICollectionViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>
@property IBOutlet UICollectionView * coolView;

@end
