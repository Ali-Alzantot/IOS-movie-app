//
//  ReviewTableViewController.m
//  moviapp
//
//  Created by ahme on 5/16/18.
//  Copyright © 2018 JETS. All rights reserved.
//

#import "ReviewTableViewController.h"


@implementation ReviewTableViewController

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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _selectedMovie.reviews.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"reviewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *nameLbl=(UILabel *)[cell viewWithTag:1];
    UITextView *contentTextView=(UITextView *)[cell viewWithTag:2];
    nameLbl.text=_selectedMovie.reviews[indexPath.row].author;
    nameLbl.textAlignment=NSTextAlignmentCenter;
    contentTextView.text=_selectedMovie.reviews[indexPath.row].content;
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str=@"REVIEWS";

    return str;
}



@end
