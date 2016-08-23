//
//  NSString+NSDate.h
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/23/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSDate)

- (NSDate *) dateWithFormat:(NSString *) format;

@end
