//
//  ABImageLoader.m
//  ExhibitionProject
//
//  Created by Andrey Bogushev on 9/12/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABImageLoader.h"

@interface ABImageLoader()

@end

@implementation ABImageLoader

+ (ABImageLoader *) sharedImageLoader {
    static ABImageLoader *imageLoader = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageLoader = [[ABImageLoader alloc] init];
    });
    return imageLoader;
}

- (void) loadImageWithURL:(NSURL *)url onSuccess:(void (^)(UIImage *image))success onFailure:(void(^)(NSError *error))failure {
    
}

@end
