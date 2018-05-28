//
//  DatabaseManger.h
//  friendslistapp
//
//  Created by JETS on 4/30/18.
//  Copyright (c) 2018 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Movie.h"

@interface DatabaseManger : UIViewController{
    NSString *docsDir;
    NSArray *dirPaths;
    const char *dbpath;
}

@property (strong , nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *moviesDB;

@property Movie *movie;

@property NSString *status;

-(id)init NS_UNAVAILABLE;

+(id)sharedInstance;



-(void) createDataBase;
-(void) createpopularMoviesDataBase;
-(void) createtopRatedMoviesDataBase;


-(void)savepopularMovieToDatabase:(Movie *)tempMovie;
-(void)savetopRatedMovieToDatabase:(Movie *)tempMovie;


-(NSMutableArray *)getAllPopularMovies;
-(NSMutableArray *)getAllTopRatedMovies;
-(NSMutableArray *)getAllFavoriteMovies;

-(void)removeAllPopularMovies;
-(void)removeAllTopRatedMovies;


-(void)updateFavoriteMovie:(Movie *)tempMovie;



@end
