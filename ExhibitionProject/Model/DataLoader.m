 //
//  DataLoader.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "DataLoader.h"
#import "Gallery.h"

@interface DataLoader()

@end

@implementation DataLoader

- (NSDictionary *) loadGalleries {
    NSMutableDictionary *galleriesDictionary;
    NSURL *galleriesURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"galleries" ofType:@"json"]];
    NSData *galleriesData = [NSData dataWithContentsOfURL:galleriesURL];
    NSError *error = nil;
    NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:galleriesData
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    
    if ( error ) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    
    galleriesDictionary = [NSMutableDictionary dictionaryWithCapacity:[JSONArray count]];
    
    for ( NSDictionary *galleryDict in JSONArray ) {
        Gallery *gallery = [[Gallery alloc] init];
        
        gallery._id = galleryDict[@"_id"];
        gallery.title = galleryDict[@"name"];
        gallery.address = galleryDict[@"address"];
        gallery.logoName = galleryDict[@"galleryLogo"];
        gallery.about = galleryDict[@"galleryDescription"];
        gallery.link = galleryDict[@"link"];
        gallery.phone = galleryDict[@"phone"];
        gallery.email = galleryDict[@"email"];
        
        galleriesDictionary[gallery._id] = gallery;
    }
    
    return [NSDictionary dictionaryWithDictionary: galleriesDictionary];
}

@end
