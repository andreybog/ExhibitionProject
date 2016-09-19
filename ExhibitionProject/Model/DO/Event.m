//
//  Event.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/23/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "Event.h"
#import "Venue.h"
#import "Gallery.h"
#import "NSString+NSDate.h"

static NSString *dateFormat = @"yyyy-MM-dd'T'hh:mm:ss.000'Z'";

@implementation Event

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _eventId = dictionary[@"objectId"];
        _title = dictionary[@"name"];
        
//        id dateStart = dictionary[@"dateStart"];
        id dateStart = [dictionary valueForKeyPath:@"dateStart.iso"];
        if ( [dateStart isKindOfClass:[NSString class]] ) {
            _dateStart = [dateStart dateWithFormat:dateFormat];
        }
        
        id dateEnd = [dictionary valueForKeyPath:@"dateEnd.iso"];
        if ( [dateEnd isKindOfClass:[NSString class]] ) {
            _dateEnd = [dateEnd dateWithFormat:dateFormat];
        }
        _about = dictionary[@"about"];
        _venue = [[Gallery alloc] initWithDictionary:dictionary[@"gallery"]];
        
    }
    return self;
}

- (BOOL) isOpenOnDate:(NSDate *)date {
    
    return YES;
}
- (NSInteger) daysToOpenFromDate:(NSDate *)date {
    return 0;
}
- (NSInteger) daysToCloseFromDate:(NSDate *)date {
    
    return 0;
}



@end
