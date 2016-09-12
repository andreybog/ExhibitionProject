//
//  EventsManager.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/24/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABEventsNetworkLoader.h"

#import "Event.h"

@interface EventsManager : NSObject

@property (strong, nonatomic, readonly) NSArray <Event *> *events;

+ (EventsManager *) sharedEventsManager;

- (void) loadEventsWithOption:(ABEventsOptionFilter)option
                    onSuccess:(void(^)(NSArray *array)) success
                    onFailure:(void(^)(NSError *)) failure;

@end
