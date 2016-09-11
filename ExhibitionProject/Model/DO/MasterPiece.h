//
//  MasterPiece.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/23/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterPiece : NSObject

@property (strong, nonatomic) NSString *masterPieceId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSURL *pictureUrl;
@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) NSInteger year;
@property (strong, nonatomic) NSString *size;

@property (assign, nonatomic) float price;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
