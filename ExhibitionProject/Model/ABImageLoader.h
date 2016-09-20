//
//  ABImageLoader.h
//  ImageLoaderTest
//
//  Created by Andrey Bogushev on 9/12/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ABImageLoader : NSObject

+ (ABImageLoader *) sharedImageLoader;
- (void) loadImageWithURL:(NSURL *)url identifier:(NSString *) identifier onSuccess:(void(^)(UIImage *image)) success onFailure:(void(^)(NSError *error)) failure;

@end
