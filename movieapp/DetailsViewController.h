//
//  DetailsViewController.h
//  uicollectionview
//
//  Created by ahme on 5/11/18.
//  Copyright © 2018 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Movie.h"

#import <AFNetworking.h>

#import <SDWebImage/UIImageView+WebCache.h>
#import "Trailer.h"
#import "DatabaseManger.h"

@interface DetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    DatabaseManger *databaseManger;
}

@property Movie *movie;


@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;

@property (weak, nonatomic) IBOutlet UIImageView *favImgView;


@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;

@property (weak, nonatomic) IBOutlet UILabel *movieRating;


@property (weak, nonatomic) IBOutlet UITextView *movieOverview;

@property (weak, nonatomic) IBOutlet UILabel *movieDuration;

@property (weak, nonatomic) IBOutlet UITableView *trailersTable;

@property (weak, nonatomic) IBOutlet UIButton *reviewsButton;

- (IBAction)showMovieReviews:(id)sender;


@end
