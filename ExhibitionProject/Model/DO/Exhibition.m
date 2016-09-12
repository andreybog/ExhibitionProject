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
        _author = dictionary[@"authorName"];
        _likesCount = [dictionary[@"likesCount"] integerValue];
        _authorDescription = dictionary[@"authorDescription"];
        
        NSArray *works = dictionary[@"works"];
        
        if ( works ) {
            NSMutableArray *masterPieces = [NSMutableArray arrayWithCapacity:works.count];
            
            for ( NSDictionary *masterPieceDict in works ) {
                MasterPiece *masterPiece = [[MasterPiece alloc] initWithDictionary:masterPieceDict];
                [masterPieces addObject:masterPiece];
            }
            
            _masterPieces = [NSArray arrayWithArray:masterPieces];
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"EXHIBITION: %@ GALLERY - %@ WORKS - %lu",
            self.title, self.venue.title, [self.masterPieces count]];
}


/*
 @property (strong, nonatomic) NSString *author;
 @property (strong, nonatomic) NSString *authorDescription;
 @property (assign, nonatomic) NSInteger likesCount;
 @property (strong, nonatomic) NSArray <MasterPiece *> *masterPieces;
 */

@end
