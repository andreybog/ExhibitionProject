//
//  Exhibition.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/23/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "Exhibition.h"

@implementation Exhibition

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if ( self = [super initWithDictionary:dictionary] ) {
        _author = dictionary[@"author"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"EXHIBITION: %@ GALLERY - %@ WORKS - %ld",
            self.title, self.venue.title, [self.masterPieces count]];
}

@end