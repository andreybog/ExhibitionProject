//
//  Exhibition.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/23/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "Event.h"
#import "MasterPiece.h"

@interface Exhibition : Event

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSArray <MasterPiece *> *masterPieces;

@end
