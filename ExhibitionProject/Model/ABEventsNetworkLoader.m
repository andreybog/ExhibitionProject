//
//  ABEventsNetworkLoader.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 9/12/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//


/*
 Все ниже перечисленные методы работую с помощь метода GET
 опциональные параметры: skip (default: 0), limit (default: 10).
 skip - количество объектов которые нужно пропустить
 limit - количество объектов которми будет лимитирована выдача
 Получить список всех выставок:
 https://gallery-guru-prod.herokuapp.com/exhibitions
 Получить список самых популярных выставок:
 https://gallery-guru-prod.herokuapp.com/exhibitions/popular
 Получить список выставок которые скоро откроются:
 https://gallery-guru-prod.herokuapp.com/exhibitions/opening
 Получить список выставок которые скоро закроются:
 https://gallery-guru-prod.herokuapp.com/exhibitions/lastchance
 Получить полную информацию о выставке со списком работ
 https://gallery-guru-prod.herokuapp.com/exhibitions/:id
 где id = objectId выбранной выставки, например:
 https://gallery-guru-prod.herokuapp.com/exhibitions/MAC2hKzbeG
 выдача выставок которые находятся рядом пока недоступна
 */

#import "ABEventsNetworkLoader.h"
#import "AFNetworking.h"
#import "AFURLResponseSerialization.h"
#import "Exhibition.h"

@interface ABEventsNetworkLoader()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) AFHTTPSessionManager *exhibitionsSessionManager;

@end

@implementation ABEventsNetworkLoader

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *baseURL = [NSURL URLWithString:@"https://gallery-guru-prod.herokuapp.com/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        
        NSMutableSet *contentTypes = [NSMutableSet setWithSet:[self.sessionManager.responseSerializer acceptableContentTypes]];
        
        [contentTypes addObject:@"text/html"];
        [self.sessionManager.responseSerializer setAcceptableContentTypes:contentTypes];
        
        NSURL *exhibitionsBaseURL = [NSURL URLWithString:@"https://gallery-guru-prod.herokuapp.com/exhibitions/"];
        self.exhibitionsSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:exhibitionsBaseURL];
        [self.exhibitionsSessionManager.responseSerializer setAcceptableContentTypes:contentTypes];
    }
    return self;
}

#pragma mark - DataLoader

- (void) loadEventsWithOffset:(NSInteger) offset
                        limit:(NSInteger) limit
                       option:(ABEventsOptionFilter)option
                    onSuccess:(void(^)(NSArray *array)) success
                    onFailure:(void(^)(NSError *)) failure {
    
    __weak typeof(self) weakSelf = self;
    NSString *methodString = [self methodString:@"exhibitions" withFilter:option];
    NSDictionary *params = @{
                             @"skip"    : @(offset),
                             @"limit"   : @(limit)
                             };
    
    [self.sessionManager GET:methodString
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSArray *exhibitionsResponse) {
                         
                         __block NSMutableArray *eventsArray = [NSMutableArray arrayWithCapacity:exhibitionsResponse.count];
                         
                         for ( NSDictionary *dict in exhibitionsResponse ) {
                             __block NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                             NSString *exhibitionId = dict[@"objectId"];
                             
                             //obtain masterPieces dictionaries
                             [weakSelf.exhibitionsSessionManager GET:exhibitionId
                                                          parameters:nil
                                                            progress:nil
                                                             success:
                              ^(NSURLSessionDataTask * _Nonnull task, NSDictionary *exhibitionResponse) {
                                  NSArray *works = exhibitionResponse[@"works"];
                                  if ( works ) {
                                      eventDict[@"works"] = works;
                                  }
                                  
                                  Exhibition *exhibition = [[Exhibition alloc] initWithDictionary:eventDict];
                                  [eventsArray addObject:exhibition];
                                  
                                  if ( eventsArray.count == exhibitionsResponse.count && success ) {
                                      success([NSArray arrayWithArray:eventsArray]);
                                  }
                                  
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  if ( failure ) {
                                      NSLog(@"func: exhibitions request ERROR: %@", error.localizedDescription);
                                      return failure(error);
                                  }
                              }];
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if ( failure ) {
                             failure(error);
                         }
                     }];
    
}

- (NSString *) methodString:(NSString *)methodString withFilter:(ABEventsOptionFilter) filter {
    NSString *filterString = nil;
    
    switch ( filter ) {
        case ABEventsOptionFilterPopular:
            filterString = @"popular";
            break;
        case ABEventsOptionFilterOpening:
            filterString = @"opening";
            break;
        case ABEventsOptionFilterLastChance:
            filterString = @"lastchance";
            break;
        default:
            break;
    }
    
    return [methodString stringByAppendingPathComponent:filterString];
}

@end
