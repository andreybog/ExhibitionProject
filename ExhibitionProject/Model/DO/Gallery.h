//
//  Gallery.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//


#import <CoreLocation/CLLocation.h>
#import "Venue.h"


@interface Gallery : Venue

@property (strong, nonatomic) NSURL *logoUrl;
@property (strong, nonatomic) NSURL *linkUrl;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) CLLocation *coordinate;
@property (strong, nonatomic) NSArray *schedule;
@property (strong, nonatomic) NSString *facebook;
@property (strong, nonatomic) NSString *city;


@end
