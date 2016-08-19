//
//  Gallery.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "Gallery.h"

@implementation Gallery

- (NSString *)description {
    return [NSString stringWithFormat:@"GALLERY: id: %@ title: %@ address: %@", self._id, self.title, self.address];
}

@end
