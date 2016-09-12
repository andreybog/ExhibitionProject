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
        NSString *logoURLString = [dictionary valueForKeyPath:@"galleryLogo.url"];
        
        if ( logoURLString ) {
            _logoUrl = [NSURL URLWithString:logoURLString];
        }
        
        NSString *urlString = dictionary[@"link"];
        if ( urlString ) {
            _linkUrl = [NSURL URLWithString:urlString];
        }
        _phone = dictionary[@"phone"];
        _email = dictionary[@"email"];
        _city = dictionary[@"city"];
        _facebook = dictionary[@"facebook"];
        
        double latitude = [dictionary[@"latitude"] doubleValue];
        double longitude = [dictionary[@"longitude"] doubleValue];
        _coordinate = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        _schedule = dictionary[@"schedule"];
    }
    return self;
}

/*
 @property (strong, nonatomic) NSURL *logoUrl;
 @property (strong, nonatomic) NSURL *linkUrl;
 @property (strong, nonatomic) NSString *phone;
 @property (strong, nonatomic) NSString *email;
 @property (strong, nonatomic) CLLocation *coordinate;
 @property (strong, nonatomic) NSArray *schedule;
 @property (strong, nonatomic) NSString *facebook;
 @property (strong, nonatomic) NSString *city;
 */

- (NSString *)description {
    
    return [NSString stringWithFormat:@"GALLERY: id: %@ title: %@ address: %@", self.venueId, self.title, self.address];
}

@end
