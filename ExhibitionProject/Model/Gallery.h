//
//  Gallery.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "Venue.h"

@interface Gallery : Venue

@property (strong, nonatomic) NSString *logoName;
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;


@end
