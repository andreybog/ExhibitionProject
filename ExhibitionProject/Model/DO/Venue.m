//
//  Venue.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "Venue.h"


@implementation Venue

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if ( self = [super init] ) {
        _venueId = dictionary[@"_id"];
        _title = dictionary[@"name"];
        _address = dictionary[@"address"];
        _about = dictionary[@"galleryDescription"];
    }
    return self;
}

@end
