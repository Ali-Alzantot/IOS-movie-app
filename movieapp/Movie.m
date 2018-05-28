//
//  Movie.m
//  uicollectionview
//
//  Created by ahme on 5/10/18.
//  Copyright © 2018 JETS. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)init {
    if (self = [super init]) {
        self.trailers=[NSMutableArray new];
        self.reviews=[NSMutableArray new];
    }
    return self;
}

@end
