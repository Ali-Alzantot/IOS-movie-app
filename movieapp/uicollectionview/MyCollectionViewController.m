//
//  MuCollectionViewController.m
//  uicollectionview
//
//  Created by ahme on 5/5/18.
//  Copyright © 2018 JETS. All rights reserved.
//

#import "MyCollectionViewController.h"


@interface MyCollectionViewController (){

    NSString *imageBaseURl;
    
    NSMutableArray <Movie *> *moviesArray;
    
    UIAlertView *progreesAlert;
    UIActivityIndicatorView *indicator;
    
    __weak IBOutlet UISegmentedControl *selectViewSegmentedControl;
    
    DatabaseManger *databaseManger;
    NSUserDefaults *defaults;
}
- (IBAction)selectViewMethod:(id)sender;

@end

@implementation MyCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageBaseURl=@"http://image.tmdb.org/t/p/w185/";
    
    moviesArray=[NSMutableArray new];
    
    databaseManger=[DatabaseManger sharedInstance];
    
    defaults=[NSUserDefaults standardUserDefaults];
    
    [databaseManger createDataBase];
    
    progreesAlert = [[UIAlertView alloc] initWithTitle:@"\n\nLoading data\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    
    indicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [progreesAlert show];
    
    indicator.center = CGPointMake(progreesAlert.bounds.size.width / 2, progreesAlert.bounds.size.height - 50);
    
    [indicator startAnimating];
    [progreesAlert addSubview:indicator];
    
    [self downLoadDataWithAFN:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return moviesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    UIImageView *imgv=[cell viewWithTag:1];
    
    
    Movie *tempmovie=moviesArray[indexPath.item];
    
    
    [imgv sd_setImageWithURL:[NSURL URLWithString:tempmovie.moviePoster]
               placeholderImage:[UIImage imageNamed:@"defaultPoster.jpg"]];
    
    
    return cell;
}


-(void)viewWillAppear:(BOOL)animated{
    

}


-(void)downLoadDataWithAFN:(int) sortFlage{
    int userDefaultFlage;
    if(sortFlage==1)
        userDefaultFlage=[defaults integerForKey:@"userDefaultFlagePopularity"];
    else
        userDefaultFlage=[defaults integerForKey:@"userDefaultFlageTopRated"];
    
    if(userDefaultFlage == 1){
        
        [moviesArray removeAllObjects];
        
        if(sortFlage ==1){
            
            moviesArray=[databaseManger getAllPopularMovies];
            
            
        }
        else{
            moviesArray=[databaseManger getAllTopRatedMovies];
            
        }
        
        [self.collectionView reloadData];
        
        [progreesAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    else{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL;
    if(sortFlage == 1){
        URL = [NSURL URLWithString:@"http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=fc3140c227807880f6ba2c7bce9d1cb5"];
    }
    else{
        URL= [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/top_rated?api_key=fc3140c227807880f6ba2c7bce9d1cb5"];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
           //NSLog(@"Error: OPPS %@", error);
        } else {
            //NSLog(@" %@", responseObject);
            
            NSDictionary *dic=responseObject;
            
            NSMutableArray *jsonObj=[[dic objectForKey:@"results"] mutableCopy];
            
            [moviesArray removeAllObjects];
            
            for(int i=0;i<jsonObj.count;++i){
                
                Movie *tempmovie=[Movie new];
                NSDictionary *tempDic=[jsonObj objectAtIndex:i];
                tempmovie.movieId=[[tempDic valueForKey:@"id"] intValue];
                tempmovie.title=[tempDic objectForKey:@"title"];
                tempmovie.releaseDate=[tempDic objectForKey:@"release_date"];
                tempmovie.overView=[tempDic objectForKey:@"overview"];
                NSString *posterPath=[tempDic objectForKey:@"poster_path"];
                tempmovie.moviePoster=[NSString stringWithFormat:@"%@%@",imageBaseURl,posterPath];
                
                NSNumber *mynumber=[tempDic objectForKey:@"vote_average"];
                float movieRate=[mynumber floatValue];
                tempmovie.rate=[NSString stringWithFormat:@"%.01f%@",movieRate,@"/10"];
                
                tempmovie.isFav=0;
                
                
                if(sortFlage == 1)
                    tempmovie.type=0;
                else
                    tempmovie.type=1;
                
                [moviesArray addObject:tempmovie];

            }
            
            
            [self.collectionView reloadData];
            
            [progreesAlert dismissWithClickedButtonIndex:0 animated:YES];
            
            
            if(sortFlage ==1){
                
                for(int i =0 ; i < moviesArray.count;++i){
                    [databaseManger savepopularMovieToDatabase:moviesArray[i]];
                }
            }
            else{
                
                for(int i =0 ; i < moviesArray.count;++i){
                    [databaseManger savetopRatedMovieToDatabase:moviesArray[i]];
                }
            }
            
            if(sortFlage ==1){
                [defaults setInteger:1 forKey:@"userDefaultFlagePopularity"];
                [defaults synchronize];
            }
            else{
                [defaults setInteger:1 forKey:@"userDefaultFlageTopRated"];
                [defaults synchronize];
            }

        
        }
    }];
    
    
    [dataTask resume];
        
    }

}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [progreesAlert show];
    [progreesAlert addSubview:indicator];
    [self downLoadMovieDataWithAFN:indexPath.item];

}



-(void)downLoadMovieDataWithAFN:(long) movieindex{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *urlStr=[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%d?api_key=fc3140c227807880f6ba2c7bce9d1cb5",moviesArray[movieindex].movieId];

    NSURL *URL = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            //NSLog(@"Error: OPPS %@", error);
            [self downLoadMovieTrailersWithAFN:movieindex];
            
            
        } else {
            //NSLog(@" %@", responseObject);
            
            NSDictionary *dic=responseObject;
            
            int movieDuartion=[[dic valueForKey:@"runtime"] intValue];
            
            moviesArray[movieindex].duration=[NSString stringWithFormat:@"%d%@",movieDuartion,@"Min"];

            [self downLoadMovieTrailersWithAFN:movieindex];
            
        }
    }];
    
    
    [dataTask resume];
    
}



-(void)downLoadMovieTrailersWithAFN:(long) movieindex{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr=[NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%d/videos?api_key=fc3140c227807880f6ba2c7bce9d1cb5",moviesArray[movieindex].movieId];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            //NSLog(@"Error: OPPS %@", error);

            [self showMoviedetails:movieindex];
            
        } else {
            //NSLog(@" %@", responseObject);
            
            NSDictionary *dic=responseObject;
            
            NSMutableArray *jsonObj=[[dic objectForKey:@"results"] mutableCopy];
            
            NSString *youtubeBaseUrl=@"https://www.youtube.com/watch?v=";
            
            [moviesArray[movieindex].trailers removeAllObjects];
            
            for(int i=0;i<jsonObj.count;++i){
                
                Trailer *tempTrailer=[Trailer new];
                NSDictionary *tempDic=[jsonObj objectAtIndex:i];
                tempTrailer.trailerId=[tempDic objectForKey:@"id"];
                NSString *movieTrailerKey=[tempDic objectForKey:@"key"];
                tempTrailer.TrailerUrl=[NSString stringWithFormat:@"%@%@",youtubeBaseUrl,movieTrailerKey];
                [moviesArray[movieindex].trailers addObject:tempTrailer];
               
            }
            
            [self showMoviedetails:movieindex];
        }
    }];
    
    
    [dataTask resume];
    
}



-(void) showMoviedetails:(long) movieindex{

    [progreesAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    DetailsViewController *detailsView=[self.storyboard instantiateViewControllerWithIdentifier:@"detailsView"];
    
    [detailsView setMovie:moviesArray[movieindex]];
    
    [self.navigationController pushViewController:detailsView animated:YES];
    
}



- (IBAction)selectViewMethod:(id)sender {
    
    
    if(selectViewSegmentedControl.selectedSegmentIndex==0){
        
        [progreesAlert show];
        [progreesAlert addSubview:indicator];
        [self downLoadDataWithAFN:1];
    }
    else if(selectViewSegmentedControl.selectedSegmentIndex==1){
        
        [progreesAlert show];
        [progreesAlert addSubview:indicator];
        [self downLoadDataWithAFN:2];
    }
    else if(selectViewSegmentedControl.selectedSegmentIndex==2){
        
        
        [moviesArray removeAllObjects];

        moviesArray=[databaseManger getAllFavoriteMovies];

        [self.collectionView reloadData];
        
    }
    
}
@end
