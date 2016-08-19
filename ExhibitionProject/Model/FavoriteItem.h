//
//  FavoriteItem.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FavoriteItem <NSObject>

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *title;

@end
