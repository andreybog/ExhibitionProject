//
//  NSDate+NSString.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 9/4/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "NSDate+NSString.h"

@implementation NSDate (NSString)

- (NSString *) stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:self];
}

@end
