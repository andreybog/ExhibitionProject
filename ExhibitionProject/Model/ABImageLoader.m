//
//  ABImageLoader.m
//  ImageLoaderTest
//
//  Created by Andrey Bogushev on 9/12/16.
//  Copyright © 2016 ABogushev. All rights reserved.
//

#import "ABImageLoader.h"

@interface ABImageViewDownloadTask : NSObject

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation ABImageViewDownloadTask


@end

@interface ABImageLoader()

@property (strong, nonatomic) NSURL *cacheDirUrl;
@property (assign, nonatomic) unsigned long long cacheDirCurrentSize;
@property (strong, nonatomic) NSMutableDictionary *downloadTasks;
@property (strong, nonatomic) NSURLSession *urlSession;

@end

@implementation ABImageLoader

static const unsigned long long kCacheDirMaxSize = 10000000;

+ (ABImageLoader *) sharedImageLoader {
    static ABImageLoader *imageLoader = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageLoader = [[ABImageLoader alloc] init];
    });
    return imageLoader;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheDirUrl = [self getCacheDirUrl];
        [self calculateCacheDirSize];
        self.downloadTasks = [NSMutableDictionary dictionary];
        self.urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void) loadImageWithURL:(NSURL *)url identifier:(NSString *) identifier
                onSuccess:(void(^)(UIImage *image)) success
                onFailure:(void(^)(NSError *error)) failure {
    
    if ( ! url ) {
        if ( failure ) {
            NSError *error = [NSError errorWithDomain:@"ABImageLoader: URL is nil" code:123 userInfo:nil];
            failure(error);
        }
        return;
    }
    
    NSString *imageName = [url.absoluteString stringByReplacingOccurrencesOfString:[url.scheme stringByAppendingString:@"://"] withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    NSURL *localImageUrl = [self.cacheDirUrl URLByAppendingPathComponent:imageName];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ( [fm fileExistsAtPath:localImageUrl.path] && success ) {
        return success([UIImage imageWithContentsOfFile:localImageUrl.path]);
    }
    
    [self cancelTaskWithIdentifier:identifier];
    
    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDownloadTask *dataTask = [self.urlSession downloadTaskWithURL:url
                                                            completionHandler:^(NSURL * _Nullable location,
                                                                                NSURLResponse * _Nullable response,
                                                                                NSError * _Nullable error) {
                                                                if ( error ) {
                                                                    if ( failure ) {
                                                                        failure(error);
                                                                    }
                                                                } else {
                                                                    [weakSelf saveItemAtURL:location toURL:localImageUrl error:nil];
                                                                    
                                                                    UIImage *image = [UIImage imageWithContentsOfFile:localImageUrl.path];
                                                                    
                                                                    if ( success ) {
                                                                        success(image);
                                                                    }
                                                                }
                                                                [weakSelf.downloadTasks removeObjectForKey:identifier];
                                                            }];
    
    [self.downloadTasks setObject:dataTask forKey:identifier];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [dataTask resume];
    });
}

- (void) cancelTaskWithIdentifier:(NSString *)identifier {
    NSURLSessionDownloadTask *task = [self.downloadTasks objectForKey:identifier];
    
    if ( task ) {
        [task cancel];
        NSLog(@"task cancelled - %@", identifier);
    }
}

#pragma mark - Cache

- (void) saveItemAtURL:(NSURL *) sourceURL toURL:(NSURL *) destURL error:(NSError * _Nullable *) error {
    NSNumber *fileSize = nil;
    
    if ( [self shouldClearCacheDirectoryBeforeAddingFileAtURL:sourceURL fileSize:&fileSize] ) {
        [self clearCacheDirectory];
        [self calculateCacheDirSize];
    };
    [[NSFileManager defaultManager] moveItemAtURL:sourceURL toURL:destURL error:error];
    self.cacheDirCurrentSize += [fileSize unsignedLongLongValue];
    
}

- (BOOL) shouldClearCacheDirectoryBeforeAddingFileAtURL:(NSURL *)fileURL fileSize:(out NSNumber * __autoreleasing *) size {
    NSNumber *fileSize = nil;
    
    [fileURL getResourceValue:&fileSize forKey:NSURLTotalFileAllocatedSizeKey error:nil];
    
    if ( fileSize == nil ) {
        [fileURL getResourceValue:&fileSize forKey:NSURLFileAllocatedSizeKey error:nil];
    }
    
    *size = fileSize;
    return self.cacheDirCurrentSize + [fileSize unsignedLongLongValue] > kCacheDirMaxSize;
}

- (void) clearCacheDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *cacheDirUrl = [self cacheDirUrl];
    
    NSArray *prefetchedProperties = @[ NSURLContentModificationDateKey];
    NSArray *allItems = [[fm enumeratorAtURL:cacheDirUrl
                                 includingPropertiesForKeys:prefetchedProperties
                                                    options:NSDirectoryEnumerationSkipsHiddenFiles
                                               errorHandler:nil] allObjects];
    
    allItems = [allItems sortedArrayUsingComparator:^NSComparisonResult(NSURL *url1, NSURL *url2) {
        NSDate *date1 = nil;
        NSDate *date2 = nil;
        [url1 getResourceValue:&date1 forKey:NSURLContentModificationDateKey error:nil];
        [url2 getResourceValue:&date2 forKey:NSURLContentModificationDateKey error:nil];
        
        
        return [[date1 earlierDate:date2] isEqualToDate:date1] ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    NSIndexSet *indexesToRemove = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, allItems.count/2)];
    NSArray *itemsToRemove = [allItems objectsAtIndexes:indexesToRemove];
    
    for ( NSURL *itemURL in itemsToRemove ) {
        [fm removeItemAtURL:itemURL error:nil];
    }
    NSLog(@"clearCacheDirectory");
}

- (void) calculateCacheDirSize {
    unsigned long long directorySize = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *cacheDirUrl = [self cacheDirUrl];
    NSArray *prefetchedProperties = @[ NSURLFileAllocatedSizeKey,
                                NSURLTotalFileAllocatedSizeKey ];
    NSDirectoryEnumerator *enumerator = [fm enumeratorAtURL:cacheDirUrl
         includingPropertiesForKeys:prefetchedProperties
                            options:NSDirectoryEnumerationSkipsHiddenFiles
                        errorHandler:nil];
    
    
    for ( NSURL *itemPath in enumerator ) {
        NSNumber *itemSize = nil;
        
        [itemPath getResourceValue:&itemSize forKey:NSURLTotalFileAllocatedSizeKey error:nil];
        
        if ( itemSize == nil ) {
            [itemPath getResourceValue:&itemSize forKey:NSURLFileAllocatedSizeKey error:nil];
        }
        if ( itemSize != nil ) {
            directorySize += [itemSize unsignedLongLongValue];
        }
    }
    
    self.cacheDirCurrentSize = directorySize;
}

- (NSURL *) getCacheDirUrl {
    if ( ! _cacheDirUrl ) {
        NSArray *URLsArray = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        if ( URLsArray.count ) {
            NSURL *cacheDirectoryURL = URLsArray[0];
            NSString *identifier = [NSBundle mainBundle].bundleIdentifier;
            _cacheDirUrl = [[cacheDirectoryURL URLByAppendingPathComponent:identifier] URLByAppendingPathComponent:@"ImagesCache"];
            
            NSFileManager *fm = [NSFileManager defaultManager];
            
            if ( ! [fm fileExistsAtPath:self.cacheDirUrl.path] ) {
                NSError *error = nil;
                if ( ![fm createDirectoryAtURL:self.cacheDirUrl withIntermediateDirectories:YES attributes:nil error:&error] ) {
                    NSLog(@"creating error: %@", error.localizedDescription);
                }
            }
        }
    }
    return _cacheDirUrl;
}

@end
