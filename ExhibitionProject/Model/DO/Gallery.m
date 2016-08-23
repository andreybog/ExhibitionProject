//
//  Gallery.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "Gallery.h"

@implementation Gallery

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if ( self = [super initWithDictionary:dictionary] ) {
        NSString *logoPath = [[NSBundle mainBundle] pathForResource:dictionary[@"galleryLogo"] ofType:nil];
        if ( logoPath ) {
            _logoUrl = [NSURL fileURLWithPath:logoPath];
        }
        
        NSString *urlString = dictionary[@"link"];
        if ( urlString ) {
            _linkUrl = [NSURL URLWithString:urlString];
        }
        _phone = dictionary[@"phone"];
        _email = dictionary[@"email"];
        
        double latitude = [dictionary[@"latitude"] doubleValue];
        double longitude = [dictionary[@"longitude"] doubleValue];
        _coordinate = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    }
    return self;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"GALLERY: id: %@ title: %@ address: %@", self.venueId, self.title, self.address];
}

@end
