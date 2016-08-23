//
//  Event.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/23/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteItem.h"
#import "Venue.h"


@interface Event : NSObject <FavoriteItem>

@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *dateStart;
@property (strong, nonatomic) NSDate *dateEnd;
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) Venue *venue;

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;

- (BOOL) isOpenOnDate:(NSDate *)date;
- (NSInteger) daysToOpenFromDate:(NSDate *)date;
- (NSInteger) daysToCloseFromDate:(NSDate *)date;


@end
