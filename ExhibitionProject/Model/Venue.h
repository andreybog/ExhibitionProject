//
//  Venue.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FavoriteItem.h"

@interface Venue : NSObject <FavoriteItem>

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *address;

@end
