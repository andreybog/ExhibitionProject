//
//  DataLoader.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 9/12/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataLoader <NSObject>


typedef NS_ENUM(NSUInteger, ABEventsOptionFilter) {
    ABEventsOptionFilterAll,
    ABEventsOptionFilterNearMe,
    ABEventsOptionFilterPopular,
    ABEventsOptionFilterLastChance,
    ABEventsOptionFilterOpening,
    ABEventsOptionFilterDefault = ABEventsOptionFilterAll
};



- (void) loadEventsWithOffset:(NSInteger) offset
                        limit:(NSInteger) limit
                       option:(ABEventsOptionFilter)option
                    onSuccess:(void(^)(NSArray *array)) success
                    onFailure:(void(^)(NSError *error)) failure;


@end
