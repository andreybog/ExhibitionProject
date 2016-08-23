//
//  MasterPiece.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/23/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "MasterPiece.h"

@implementation MasterPiece

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if ( self = [super init] ) {
        _masterPieceId = dictionary[@"_id"];
        _title = dictionary[@"title"];
        _about = dictionary[@"about"];
        _author = dictionary[@"author"];
        
        NSString *picturePath = [[NSBundle mainBundle] pathForResource:dictionary[@"imgPicture"] ofType:nil];
        
        if ( picturePath ) {
            _pictureUrl = [NSURL fileURLWithPath:picturePath];
        }
        _type = dictionary[@"type"];
        
        id year = dictionary[@"year"];
        if ( year != [NSNull null]  ) {
            _year = [year integerValue];
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"MASTERPIECE: %@ id: %@ author: %@", self.title, self.masterPieceId, self.author];
}
@end
