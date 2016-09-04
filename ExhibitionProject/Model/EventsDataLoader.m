 //
//  DataLoader.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/19/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "EventsDataLoader.h"
#import "Gallery.h"
#import "Exhibition.h"


@implementation EventsDataLoader

#pragma mark - DataLoader

- (void) loadEventsWithCallBack:(void(^)(NSArray *array, NSError *error)) callBack {
    NSError *error = nil;
    NSDictionary *galleries = nil;
    NSDictionary *masterPieces = nil;
    NSMutableArray <Exhibition *> *exhibitions;
    
    galleries = [self loadGalleriesWithError:error];
    
    if ( error ) {
        return callBack(nil, error);
    }
    
    masterPieces = [self loadMasterPiecesWithError:error];
  
    if ( error ) {
        return callBack(nil, error);
    }
    
    NSArray *JSONArray = [self loadJSONArrayFromLocalResource:@"exhibitions" type:@"json" error:&error];
    
    if ( error ) {
        return callBack(nil, error);
    }
    
    exhibitions = [NSMutableArray arrayWithCapacity:[JSONArray count]];
    
    for ( NSDictionary *exhibitionDict in JSONArray ) {
        Exhibition *exhibition = [[Exhibition alloc] initWithDictionary:exhibitionDict];
        NSString *venueId = [[exhibitionDict[@"_p_gallery"] componentsSeparatedByString:@"$"] lastObject];
        
        exhibition.venue = galleries[venueId];
        
        NSArray *works = exhibitionDict[@"works"];
        
        if ( [works count] ) {
            NSMutableArray *exhibitionMasterPieces = [NSMutableArray arrayWithCapacity:[works count]];
            
            for ( NSDictionary *masterPieceDict in works ) {
                NSString *masterPieceId = masterPieceDict[@"objectId"];
                MasterPiece *masterPiece = masterPieces[masterPieceId];
                [exhibitionMasterPieces addObject:masterPiece];
            }
            exhibition.masterPieces = [NSArray arrayWithArray:exhibitionMasterPieces];
        }
        [exhibitions addObject:exhibition];
    }
    callBack([NSArray arrayWithArray:exhibitions], nil);
}

- (NSDictionary *) loadGalleriesWithError:(NSError *) error {
    NSMutableDictionary *galleriesDictionary;
    NSArray *JSONArray = [self loadJSONArrayFromLocalResource:@"galleries" type:@"json" error:&error];
    
    if ( error ) {
        return nil;
    }
    
    galleriesDictionary = [NSMutableDictionary dictionaryWithCapacity: [JSONArray count]];
    
    for ( NSDictionary *galleryDict in JSONArray ) {
        Gallery *gallery = [[Gallery alloc] initWithDictionary:galleryDict];
        
        [galleriesDictionary setObject:gallery forKey:gallery.venueId];
    }
    return [NSDictionary dictionaryWithDictionary: galleriesDictionary];
}

- (NSDictionary *) loadMasterPiecesWithError:(NSError *) error {
    NSMutableDictionary *masterPiecesDictionary;
    NSArray *JSONArray = [self loadJSONArrayFromLocalResource:@"works" type:@"json" error:&error];
    
    if ( error ) {
        return nil;
    }
    
    masterPiecesDictionary = [NSMutableDictionary dictionaryWithCapacity: [JSONArray count]];
    
    for ( NSDictionary *masterPieceDict in JSONArray ) {
        MasterPiece *masterPiece = [[MasterPiece alloc] initWithDictionary:masterPieceDict];
        
        [masterPiecesDictionary setObject:masterPiece forKey:masterPiece.masterPieceId];
    }
    return [NSDictionary dictionaryWithDictionary: masterPiecesDictionary];
}

- (NSArray *) loadJSONArrayFromLocalResource:(NSString *)resource type:(NSString *)type error:(NSError **)error {
    NSURL *resourceURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:resource ofType:type]];
    NSData *resourceData = [NSData dataWithContentsOfURL:resourceURL];
    NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:resourceData
                                                         options:NSJSONReadingAllowFragments
                                                           error:error];
    
    if ( *error ) {
        return nil;
    }
    return JSONArray;
}

@end
