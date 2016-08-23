//
//  DataLoader.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataLoader <NSObject>;

- (void) loadEventsWithCallBack:(void(^)(NSArray *array, NSError *error)) callBack;

@end

@interface EventsDataLoader : NSObject <DataLoader>


@end


