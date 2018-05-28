//
//  Movie.h
//  uicollectionview
//
//  Created by ahme on 5/10/18.
//  Copyright © 2018 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trailer.h"
#import "Review.h"

@interface Movie : NSObject

@property int movieId;


@property NSString *title;


@property NSString *moviePoster;

//fav 0 means not favorite
@property int isFav;

// type 0 means popular movie
@property int type;

@property NSString *overView;


@property NSString *rate;

@property NSString *duration;

@property NSString *releaseDate;

@property NSMutableArray <Trailer *> *trailers;

@property NSMutableArray <Review *> *reviews;


@end
