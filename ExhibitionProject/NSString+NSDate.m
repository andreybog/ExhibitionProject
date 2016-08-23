//
//  NSString+NSDate.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 8/23/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "NSString+NSDate.h"

@implementation NSString (NSDate)

- (NSDate *) dateWithFormat:(NSString *) format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    return [formatter dateFromString:self];
}

@end
