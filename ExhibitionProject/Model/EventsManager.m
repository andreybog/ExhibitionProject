//
//  EventsManager.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/24/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "EventsManager.h"
#import "ABEventsNetworkLoader.h"


@interface EventsManager()

@property (strong, nonatomic) id <DataLoader> dataLoader;
@property (strong, nonatomic, readwrite) NSArray <Event *> *events;

@end

@implementation EventsManager

static NSInteger kEventsInRequest = 10;

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
//        self.dataLoader = [[EventsDataLoader alloc] init];
        self.dataLoader = [[ABEventsNetworkLoader alloc] init];
    }
    return self;
}

- (void) loadEventsWithOption:(ABEventsOptionFilter)option
                    onSuccess:(void(^)(NSArray *array)) success
                    onFailure:(void(^)(NSError *)) failure {
    
    __weak typeof(self) weakSelf = self;
    
    [self.dataLoader loadEventsWithOffset:self.events.count
                                    limit:kEventsInRequest
                                   option:option
                                onSuccess:^(NSArray *array) {
                                    NSMutableArray *events = [NSMutableArray arrayWithArray:weakSelf.events];
                                    
                                    [events addObjectsFromArray:array];
                                    
                                    weakSelf.events = events;
                                    
                                    if ( success ) {
                                        success(array);
                                    }
                                } onFailure:failure];
}


@end
