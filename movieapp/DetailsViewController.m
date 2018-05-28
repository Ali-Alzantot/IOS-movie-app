//
//  DetailsViewController.m
//  uicollectionview
//
//  Created by ahme on 5/11/18.
//  Copyright © 2018 JETS. All rights reserved.
//

#import "DetailsViewController.h"
#import "ReviewTableViewController.h"

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    databaseManger=[DatabaseManger sharedInstance];
}



-(void)viewWillAppear:(BOOL)animated{
    
    

    [_moviePoster sd_setImageWithURL:[NSURL URLWithString:_movie.moviePoster]
                    placeholderImage:[UIImage imageNamed:@"defaultPoster.jpg"]];
    
    _favImgView.image=[UIImage imageNamed:@"fav.png"];
    
    _movieTitle.text=_movie.title;
    
    _movieTitle.textAlignment=NSTextAlignmentCenter;
    
    _releaseDate.text=_movie.releaseDate;
    
    _movieRating.text=_movie.rate;
    
    _movieOverview.text=_movie.overView;
    
    _movieDuration.text=_movie.duration;
    
    if(_movie.isFav==0){
        _favImgView.image=[UIImage imageNamed:@"fav.png"];
    }
    else{
        _favImgView.image=[UIImage imageNamed:@"fav2.png"];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFavMethod)];
    singleTap.numberOfTapsRequired = 1;
    [_favImgView setUserInteractionEnabled:YES];
    [_favImgView addGestureRecognizer:singleTap];
    

}








- (IBAction)showMovieReviews:(id)sender {
    
    UIAlertView * progreesAlert = [[UIAlertView alloc] initWithTitle:@"\n\nLoading data\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    
    UIActivityIndicatorView *indicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [progreesAlert show];
    
    indicator.center = CGPointMake(progreesAlert.bounds.size.width / 2, progreesAlert.bounds.size.height - 50);
    
    [indicator startAnimating];
    [progreesAlert addSubview:indicator];
    

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr=[NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%d/reviews?api_key=fc3140c227807880f6ba2c7bce9d1cb5",_movie.movieId];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            //NSLog(@"Error: OPPS %@", error);
            
            
        } else {
            //NSLog(@" %@", responseObject);
            
            NSDictionary *dic=responseObject;
            
            NSMutableArray *jsonObj=[[dic objectForKey:@"results"] mutableCopy];
            
            [_movie.reviews removeAllObjects];
            
            for(int i=0;i<jsonObj.count;++i){
                
                Review *tempReview=[Review new];
                NSDictionary *tempDic=[jsonObj objectAtIndex:i];
                tempReview.author=[tempDic objectForKey:@"author"];
                tempReview.content=[tempDic objectForKey:@"content"];
              
                [_movie.reviews addObject:tempReview];
                
            }
            
            [progreesAlert dismissWithClickedButtonIndex:0 animated:YES];
            
            ReviewTableViewController *reviewsView=[self.storyboard instantiateViewControllerWithIdentifier:@"reviewsTableView"];
            
            [reviewsView setSelectedMovie:_movie];
            
            [self.navigationController pushViewController:reviewsView animated:YES];
            
        }
    }];
    
    
    [dataTask resume];
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _movie.trailers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tailersCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
       
    
        UIImageView *imageV=(UIImageView *)[cell viewWithTag:1];
        UILabel *nameLbl=(UILabel *)[cell viewWithTag:2];
    
        imageV.image=[UIImage imageNamed:@"play-icon.png"];
        nameLbl.text=[NSString stringWithFormat:@"Tailer %ld",indexPath.row+1];
    
    
    return cell;
}






-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Trailers";
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [NSURL URLWithString:_movie.trailers[indexPath.row].TrailerUrl];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:url];
}

-(void)selectFavMethod{

    
    if(_movie.isFav==0){
        _favImgView.image=[UIImage imageNamed:@"fav2.png"];
        _movie.isFav=1;
        [databaseManger updateFavoriteMovie:_movie];
    }
    else{
        _favImgView.image=[UIImage imageNamed:@"fav.png"];
        _movie.isFav=0;
        [databaseManger updateFavoriteMovie:_movie];
    }
}



@end
