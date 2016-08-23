//
//  EventsManager.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/24/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "EventsManager.h"
#import "EventsDataLoader.h"

@interface EventsManager()

@property (strong, nonatomic) id <DataLoader> dataLoader;
@property (strong, nonatomic, readwrite) NSArray <Event *> *events;

@end

@implementation EventsManager

+ (EventsManager *) sharedEventsManager {
    static EventsManager *eventManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventManager = [[EventsManager alloc] init];
    });
    return eventManager;
}

- (instancetype)init {
    if ( self = [super init] ) {
        self.dataLoader = [[EventsDataLoader alloc] init];
    }
    return self;
}

- (void) loadEvents {
    
    __weak EventsManager *weakSelf = self;
    
    [self.dataLoader loadEventsWithCallBack:^(NSArray *array, NSError *error) {
        if ( error ) {
            NSLog(@"ERROR: %@", [error localizedFailureReason]);
            return;
        }
        weakSelf.events = array;
        [weakSelf printEvents];
    }];
}

- (void) printEvents {
    for ( Event *event in self.events ) {
        NSLog(@"%@", event);
    }
    NSLog(@"COUNT: %ld", [self.events count]);
}

@end
