//
//  DatabaseManger.m
//  friendslistapp
//
//  Created by JETS on 4/30/18.
//  Copyright (c) 2018 JETS. All rights reserved.
//

#import "DatabaseManger.h"

@interface DatabaseManger ()
    




@end

@implementation DatabaseManger

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

-(id)init{
    self =[super init];

    
    return  self;
}

-(void) createDataBase{

    [self createpopularMoviesDataBase];
    [self createtopRatedMoviesDataBase];
    
}

-(void) createpopularMoviesDataBase{

    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        
        char *errMsg;
        const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS POPULARMOVIES (ID INTEGER PRIMARY KEY, TITLE TEXT,POSTER TEXT,FAV INTEGER,MOVTYPE INTEGER,OVERVIEW TEXT,RATE TEXT,DURATION TEXT,RELDATE TEXT)";
        
        if (sqlite3_exec(_moviesDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            _status= @"Failed to create POPULARMOVIES table";
            
        }
        
        sqlite3_close(_moviesDB);
    } else {
        _status= @"Failed to open/create database";

    }
    

}


-(void) createtopRatedMoviesDataBase{
    
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS TOPRATEDMOVIES (ID INTEGER PRIMARY KEY, TITLE TEXT,POSTER TEXT,FAV INTEGER, MOVTYPE INTEGER,OVERVIEW TEXT,RATE TEXT,DURATION TEXT,RELDATE TEXT)";
        
        if (sqlite3_exec(_moviesDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            _status= @"Failed to create TOPRATEDMOVIES table";
            
        }
        sqlite3_close(_moviesDB);
    } else {
        _status= @"Failed to open/create database";
    }
    


}



-(void)savepopularMovieToDatabase:(Movie *)tempMovie{
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];

    sqlite3_stmt    *statement;

    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
          @"INSERT INTO POPULARMOVIES (ID, TITLE,POSTER,FAV,MOVTYPE,OVERVIEW,RATE,DURATION,RELDATE) VALUES (\"%d\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\")",
                              tempMovie.movieId,tempMovie.title,tempMovie.moviePoster,tempMovie.isFav,tempMovie.type,tempMovie.overView,tempMovie.rate,tempMovie.duration,tempMovie.releaseDate];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_moviesDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            _status= @"Movie added";

        } else {
            _status = @"Failed to add Movie";
        }
        sqlite3_finalize(statement);
        sqlite3_close(_moviesDB);
    }
    


}



-(void)savetopRatedMovieToDatabase:(Movie *)tempMovie{
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];
    
    
    sqlite3_stmt    *statement;
    
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO TOPRATEDMOVIES (ID, TITLE,POSTER,FAV,MOVTYPE,OVERVIEW,RATE,DURATION,RELDATE) VALUES (\"%d\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\")",
                               tempMovie.movieId,tempMovie.title,tempMovie.moviePoster,tempMovie.isFav,tempMovie.type,tempMovie.overView,tempMovie.rate,tempMovie.duration,tempMovie.releaseDate];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_moviesDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            _status= @"Movie added";
            
        } else {
            _status = @"Failed to add Movie";
        }
        sqlite3_finalize(statement);
        sqlite3_close(_moviesDB);
    }
  
}

-(NSMutableArray *)getAllPopularMovies{
    
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];
    
    NSMutableArray *moviesArray=[NSMutableArray new];
    
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM POPULARMOVIES "];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_moviesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                Movie *tempMovie= [Movie new];
                
                tempMovie.movieId= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] intValue];
                
                tempMovie.title = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                tempMovie.moviePoster = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                tempMovie.isFav= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)] intValue];
                
                tempMovie.type= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] intValue];
                
                
                tempMovie.overView = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                
                
                tempMovie.rate = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                
                
                tempMovie.duration = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                
                
                tempMovie.releaseDate = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                
                
                [moviesArray addObject:tempMovie];
                
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(_moviesDB);
    }
    
    return moviesArray;
    
    
    
}




-(NSMutableArray *)getAllTopRatedMovies{
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];
    
    
    NSMutableArray *moviesArray=[NSMutableArray new];
    
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM TOPRATEDMOVIES "];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_moviesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                Movie *tempMovie= [Movie new];
                
                tempMovie.movieId= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] intValue];
                
                tempMovie.title = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                tempMovie.moviePoster = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                tempMovie.isFav= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)] intValue];
                
                tempMovie.type= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] intValue];
                
                
                tempMovie.overView = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                
                
                tempMovie.rate = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                
                
                tempMovie.duration = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                
                
                tempMovie.releaseDate = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                
                
                [moviesArray addObject:tempMovie];
                
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(_moviesDB);
    }
    
    return moviesArray;
    
    
    
}

-(NSMutableArray *)getAllFavoriteMovies{
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];
    
    NSMutableArray *moviesArray=[NSMutableArray new];
    
    sqlite3_stmt    *statement;
    
    
    //get torated fav
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM TOPRATEDMOVIES  WHERE FAV=\"%d\"",
                              1];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_moviesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                Movie *tempMovie= [Movie new];
                
                tempMovie.movieId= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] intValue];
                
                tempMovie.title = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                tempMovie.moviePoster = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                tempMovie.isFav= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)] intValue];
                
                tempMovie.type= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] intValue];
                
                
                tempMovie.overView = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                
                
                tempMovie.rate = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                
                
                tempMovie.duration = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                
                
                tempMovie.releaseDate = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                
                
                [moviesArray addObject:tempMovie];
                
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(_moviesDB);
    }
    
    
    //get popular rated
    
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM POPULARMOVIES  WHERE FAV=\"%d\"",
                              1];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_moviesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                Movie *tempMovie= [Movie new];
                
                tempMovie.movieId= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] intValue];
                
                tempMovie.title = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                tempMovie.moviePoster = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                tempMovie.isFav= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)] intValue];
                
                tempMovie.type= [[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)] intValue];
                
                
                tempMovie.overView = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                
                
                tempMovie.rate = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                
                
                tempMovie.duration = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                
                
                tempMovie.releaseDate = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                
                
                [moviesArray addObject:tempMovie];
                
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(_moviesDB);
    }
    
    
    return moviesArray;
}

-(void)removeAllPopularMovies{
    
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];
    
    sqlite3_stmt    *deleteStmt;
    
    
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK){
        
        
        NSString *sql = [NSString stringWithFormat:@"delete * from POPULARMOVIES "];
        
        
        const char *del_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(_moviesDB, del_stmt, -1, & deleteStmt, NULL);
        
        if (sqlite3_step(deleteStmt) == SQLITE_DONE)
        {
            //NSLog(@"Deleted");
        } else {
            //NSLog(@"Not Deleted");
        }
        sqlite3_finalize(deleteStmt);
        sqlite3_close(_moviesDB);
        
        
    }

}


-(void)removeAllTopRatedMovies{
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];
    
    sqlite3_stmt    *deleteStmt;
    
    
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK){
        
        
        NSString *sql = [NSString stringWithFormat:@"delete from TOPRATEDMOVIES "];
        
        
        const char *del_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(_moviesDB, del_stmt, -1, & deleteStmt, NULL);
        
        if (sqlite3_step(deleteStmt) == SQLITE_DONE)
        {
            //NSLog(@"Deleted");
        } else {
            //NSLog(@"Not Deleted");
        }
        sqlite3_finalize(deleteStmt);
        sqlite3_close(_moviesDB);
        
        
    }

    
}





-(void)updateFavoriteMovie:(Movie *)tempMovie{
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    dbpath = [_databasePath UTF8String];
    

    sqlite3_stmt    *updateStmt;
    
    
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK){
        
        NSString *sql;
        
        if(tempMovie.type==0)
        
            sql = [NSString stringWithFormat:@"update POPULARMOVIES Set FAV=\"%d\" Where ID = \"%d\" ",tempMovie.isFav,tempMovie.movieId];
        
        else
            sql = [NSString stringWithFormat:@"update TOPRATEDMOVIES Set FAV=\"%d\" Where ID = \"%d\" ",tempMovie.isFav,tempMovie.movieId];
        
        
        const char *del_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(_moviesDB, del_stmt, -1, & updateStmt, NULL);
        
        if (sqlite3_step(updateStmt) == SQLITE_DONE)
        {
            //NSLog(@"Updated");
        } else {
            //NSLog(@"Not updated");
        }
        sqlite3_finalize(updateStmt);
        sqlite3_close(_moviesDB);
        
        
    }
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+(id)sharedInstance{
    
    static DatabaseManger *databaseManger=nil;
    
    static dispatch_once_t once_Token;
    
    dispatch_once(&once_Token,^{
    
        databaseManger=[[self alloc] init];
        
        
    });
    
    return databaseManger;

}

@end
